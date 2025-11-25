import 'dart:io';

import 'package:esmorga_flutter/data/event/event_repository_impl.dart';
import 'package:esmorga_flutter/datasource_remote/config/environment_config.dart';
import 'package:http/io_client.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:intl/intl.dart';
import 'package:esmorga_flutter/data/user/datasource/auth_datasource.dart';
import 'package:esmorga_flutter/data/user/datasource/shared_preferences_auth_datasource.dart';
import 'package:esmorga_flutter/data/user/datasource/user_local_datasource_impl.dart';
import 'package:esmorga_flutter/data/user/datasource/user_remote_datasource_impl.dart';
import 'package:esmorga_flutter/data/user/repository/user_repository_impl.dart';
import 'package:esmorga_flutter/datasource_local/event/event_local_datasource.dart';
import 'package:esmorga_flutter/datasource_local/event/event_local_model.dart';
import 'package:esmorga_flutter/datasource_remote/api/authenticated_http_client.dart';
import 'package:esmorga_flutter/datasource_remote/api/esmorga_api.dart';
import 'package:esmorga_flutter/datasource_remote/api/esmorga_auth_api.dart';
import 'package:esmorga_flutter/datasource_remote/api/esmorga_guest_api.dart';
import 'package:esmorga_flutter/datasource_remote/api/logging_http_client.dart';
import 'package:esmorga_flutter/datasource_remote/event/event_remote_datasource.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/change_password/cubit/change_password_cubit.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/deeplink/deep_link_service.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_cubit.dart';
import 'package:esmorga_flutter/view/events/event_list/cubit/event_list_cubit.dart';
import 'package:esmorga_flutter/view/events/my_events/cubit/my_events_cubit.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/login/cubit/login_cubit.dart';
import 'package:esmorga_flutter/view/navigation/app_routes.dart';
import 'package:esmorga_flutter/view/password/recover_password_cubit.dart';
import 'package:esmorga_flutter/view/password/reset_password_cubit.dart';
import 'package:esmorga_flutter/view/profile/cubit/profile_cubit.dart';
import 'package:esmorga_flutter/view/registration/cubit/register_cubit.dart';
import 'package:esmorga_flutter/view/registration/cubit/registration_confirmation_cubit.dart';
import 'package:esmorga_flutter/view/registration/verify_account/cubit/verify_account_cubit.dart';
import 'package:esmorga_flutter/view/splash/cubit/splash_cubit.dart';
import 'package:esmorga_flutter/view/validation/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDi(Locale locale) async {
  Intl.defaultLocale = locale.toString();
  // -----------------------------
  // ROUTER
  // -----------------------------
  if (!getIt.isRegistered<GoRouter>()) {
    getIt.registerSingleton<GoRouter>(AppRoutes.createRouter());
  }
  final router = getIt<GoRouter>();
  final deepLinkService = DeepLinkService(router);
  getIt.registerSingleton<DeepLinkService>(deepLinkService);

  final locService = LocalizationService();
  await locService.load(locale);
  getIt.registerSingleton<LocalizationService>(locService);
  getIt.registerSingleton<AppLocalizations>(locService.current);
  getIt.registerSingleton<FormValidator>(FormValidator());
  // -----------------------------
  // STORAGE
  // -----------------------------
  await Hive.initFlutter();
  Hive.registerAdapter(EventLocalModelAdapter());
  Hive.registerAdapter(EventLocationLocalModelAdapter());

  final eventsBox = await Hive.openBox<EventLocalModel>('events');
  getIt.registerSingleton<Box<EventLocalModel>>(eventsBox);

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // -----------------------------
  // NETWORK
  // -----------------------------
  http.Client client;
  if (EnvironmentConfig.isQA) {
    final httpProxy = await HttpProxy.createHttpProxy();
    if (httpProxy.host != null && httpProxy.host!.isNotEmpty) {
      HttpOverrides.global = httpProxy;
      final httpClient = HttpClient();
      httpClient.findProxy = (uri) {
        return "PROXY ${httpProxy.host}:${httpProxy.port}";
      };
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
      client = IOClient(httpClient);
    } else {
      client = http.Client();
    }
  } else {
    client = http.Client();
  }

  getIt.registerSingleton<http.Client>(
    LoggingHttpClient(client),
    instanceName: 'base',
  );

  getIt.registerSingleton<EsmorgaDateTimeFormatter>(DateFormatterImpl());

  getIt.registerSingleton<EsmorgaAuthApi>(
    EsmorgaAuthApi(getIt<http.Client>(instanceName: 'base')),
  );

  getIt.registerSingleton<AuthDatasource>(
    SharedPreferencesAuthDatasource(
      getIt<SharedPreferences>(),
      getIt<EsmorgaAuthApi>(),
    ),
  );

  getIt.registerSingleton<http.Client>(
    AuthenticatedHttpClient(
      getIt<http.Client>(instanceName: 'base'),
      getIt<AuthDatasource>(),
    ),
    instanceName: 'authenticated',
  );

  getIt.registerSingleton<EsmorgaGuestApi>(
    EsmorgaGuestApi(getIt<http.Client>(instanceName: 'base')),
  );

  getIt.registerSingleton<EsmorgaApi>(
    EsmorgaApi(getIt<http.Client>(instanceName: 'authenticated')),
  );

  // -----------------------------
  // DATASOURCES
  // -----------------------------
  getIt.registerFactory(() => UserLocalDatasourceImpl(getIt<SharedPreferences>()));

  getIt.registerFactory(() => UserRemoteDatasourceImpl(
        getIt<EsmorgaAuthApi>(),
        getIt<EsmorgaApi>(),
        getIt<AuthDatasource>(),
      ));

  getIt.registerFactory(() => EventLocalDatasourceImpl(getIt<Box<EventLocalModel>>()));

  getIt.registerFactory(() => EventRemoteDatasourceImpl(
        getIt<EsmorgaApi>(),
        getIt<EsmorgaGuestApi>(),
      ));

  // -----------------------------
  // REPOSITORIES
  // -----------------------------
  getIt.registerFactory<UserRepository>(() => UserRepositoryImpl(
        getIt<UserLocalDatasourceImpl>(),
        getIt<UserRemoteDatasourceImpl>(),
        getIt<EventLocalDatasourceImpl>(),
        getIt<AuthDatasource>(),
      ));

  getIt.registerFactory<EventRepository>(() => EventRepositoryImpl(
        getIt<UserLocalDatasourceImpl>(),
        getIt<EventLocalDatasourceImpl>(),
        getIt<EventRemoteDatasourceImpl>(),
      ));

  // -----------------------------
  // CUBITS
  // -----------------------------
  getIt.registerFactory(() => SplashCubit());
  getIt.registerFactory(() => MyEventsCubit(eventRepository: getIt(), userRepository: getIt()));
  getIt.registerFactory(() => EventListCubit(eventRepository: getIt()));
  getIt.registerFactory(() => ProfileCubit(userRepository: getIt()));
  getIt.registerFactory(() => LoginCubit(userRepository: getIt(), validator: getIt()));
  getIt.registerFactory(() => RegisterCubit(userRepository: getIt(), validator: getIt()));
  getIt.registerFactory(() => ChangePasswordCubit(userRepository: getIt(), validator: getIt()));
  getIt.registerFactory(() => RegistrationConfirmationCubit(userRepository: getIt()));
  getIt.registerFactory(() => RecoverPasswordCubit(userRepository: getIt(), validator: getIt()));
  getIt.registerFactoryParam<ResetPasswordCubit, BuildContext, String?>((context, code) => ResetPasswordCubit(
        userRepository: getIt(),
        validator: getIt(),
        code: code,
      ));

  getIt.registerFactoryParam<EventDetailCubit, BuildContext, Event>((context, event) => EventDetailCubit(
        eventRepository: getIt(),
        userRepository: getIt(),
        event: event,
        l10n: getIt<LocalizationService>(),
      ));

  getIt
      .registerFactoryParam<VerifyAccountCubit, BuildContext, String>((context, verificationCode) => VerifyAccountCubit(
            userRepository: getIt(),
            verificationCode: verificationCode,
          ));
}
