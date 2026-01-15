import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/registration/cubit/register_cubit.dart';
import 'package:esmorga_flutter/view/registration/cubit/register_state.dart';
import 'package:esmorga_flutter/view/registration/view/register_screen.dart';
import 'package:esmorga_flutter/view/validation/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'screenshot_helper.dart';

class MockUserRepository extends Mock implements UserRepository {}
class MockRegisterCubit extends MockCubit<RegisterState> implements RegisterCubit {}
class MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  late MockUserRepository userRepository;
  late MockLocalizationService localizationService;
  late FormValidator formValidator;

  setUp(() {
    userRepository = MockUserRepository();
    localizationService = MockLocalizationService();
    getIt.registerSingleton<LocalizationService>(localizationService);
    when(() => localizationService.current).thenReturn(AppLocalizationsEn());

    formValidator = FormValidator();

    // Registro por defecto (Cubit real)
    getIt.registerFactoryParam<RegisterCubit, BuildContext, Object?>((context, _) {
      return RegisterCubit(
        userRepository: userRepository,
        validator: formValidator,
      );
    });
  });

  tearDown(() {
    getIt.reset();
  });

  final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
  );

  Widget buildScreen() {
    return const RegisterScreen();
  }

  screenshotGolden(
    'register_initial',
    theme: lightTheme,
    screenshotPath: 'register',
    buildHome: () => buildScreen(),
  );

  screenshotGolden(
    'register_filled',
    theme: lightTheme,
    screenshotPath: 'register',
    buildHome: () => buildScreen(),
    afterBuild: (tester) async {
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('registration_name_input')), 'John');
      await tester.enterText(find.byKey(const Key('registration_last_name_input')), 'Doe');
      await tester.enterText(find.byKey(const Key('registration_email_input')), 'john.doe@example.com');
      await tester.enterText(find.byKey(const Key('registration_password_input')), 'Password123!');
      await tester.enterText(find.byKey(const Key('registration_repeat_password_input')), 'Password123!');
      
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
    },
  );

  screenshotGolden(
    'register_error',
    theme: lightTheme,
    screenshotPath: 'register',
    buildHome: () {
      when(() => userRepository.register(any(), any(), any(), any())).thenThrow(Exception('Registration failed'));
      return buildScreen();
    },
    afterBuild: (tester) async {
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('registration_name_input')), 'John');
      await tester.enterText(find.byKey(const Key('registration_last_name_input')), 'Doe');
      await tester.enterText(find.byKey(const Key('registration_email_input')), 'john.doe@example.com');
      await tester.enterText(find.byKey(const Key('registration_password_input')), 'Password123!');
      await tester.enterText(find.byKey(const Key('registration_repeat_password_input')), 'Password123!');
      await tester.tap(find.byKey(const Key('registration_register_button')));
      await tester.pumpAndSettle();
    },
  );

  screenshotGolden(
    'register_passwords_visible',
    theme: lightTheme,
    screenshotPath: 'register',
    buildHome: () {
      const stateVisible = RegisterState(
        name: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        password: 'Password123!',
        repeatPassword: 'Password123!',
        showPassword: true, 
      );

      final mockCubit = MockRegisterCubit();
      when(() => mockCubit.state).thenReturn(stateVisible);
      when(() => mockCubit.stream).thenAnswer((_) => Stream.value(stateVisible));

      getIt.unregister<RegisterCubit>();
      getIt.registerFactoryParam<RegisterCubit, BuildContext, Object?>((_, __) => mockCubit);

      return buildScreen();
    },
    afterBuild: (tester) async {
      await tester.pumpAndSettle();
      
      await tester.enterText(find.byKey(const Key('registration_name_input')), 'John');
      await tester.enterText(find.byKey(const Key('registration_last_name_input')), 'Doe');
      await tester.enterText(find.byKey(const Key('registration_email_input')), 'john.doe@example.com');
      await tester.enterText(find.byKey(const Key('registration_password_input')), 'Password123!');
      await tester.enterText(find.byKey(const Key('registration_repeat_password_input')), 'Password123!');

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
    },
  );
}