import 'package:esmorga_flutter/datasource_remote/config/environment_config.dart';
import 'package:esmorga_flutter/view/deeplink/deep_link_service.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/view/events/event_list/cubit/event_cubit.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:esmorga_flutter/view/navigation/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvironmentConfig.initFromDartDefine();
  await setupDi();
  final router = getIt<GoRouter>();
  final deepLinkService = DeepLinkService(router);
  await deepLinkService.init();
  runApp(const EsmorgaApp());
}

class EsmorgaApp extends StatelessWidget {
  const EsmorgaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<GoRouter>();
    return MaterialApp.router(
      title: 'Esmorga',
      theme: getThemeData(context),
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
      ],
    );
  }
}
