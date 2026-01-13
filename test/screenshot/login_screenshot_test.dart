import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/login/cubit/login_cubit.dart';
import 'package:esmorga_flutter/view/login/view/login_screen.dart';
import 'package:esmorga_flutter/view/validation/form_validator.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'screenshot_helper.dart';

class MockUserRepository extends Mock implements UserRepository {}

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

    getIt.registerFactoryParam<LoginCubit, BuildContext, String?>((context, message) {
      return LoginCubit(
        userRepository: userRepository,
        validator: formValidator,
        initialMessage: message,
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
    return LoginScreen(
      onRegisterClicked: () {},
      onForgotPasswordClicked: () {},
      onLoginSuccess: () {},
      onLoginError: () {},
      onBackClicked: () {},
    );
  }

  screenshotGolden(
    'login_initial',
    theme: lightTheme,
    screenshotPath: 'login',
    buildHome: () {
      return buildScreen();
    },
  );

  screenshotGolden(
    'login_filled',
    theme: lightTheme,
    screenshotPath: 'login',
    buildHome: () {
      return buildScreen();
    },
    afterBuild: (tester) async {
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('login_email_input')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('login_password_input')), 'password123');
      await tester.pumpAndSettle();
    },
  );

  screenshotGolden(
    'login_error',
    theme: lightTheme,
    screenshotPath: 'login',
    buildHome: () {
      when(() => userRepository.login(any(), any())).thenThrow(Exception('Auth failed'));
      return buildScreen();
    },
    afterBuild: (tester) async {
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('login_email_input')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('login_password_input')), 'wrongpass');
      await tester.tap(find.byKey(const Key('login_login_button')));
      await tester.pumpAndSettle();
    },
  );

  screenshotGolden(
    'login_password_visible',
    theme: lightTheme,
    screenshotPath: 'login',
    buildHome: () {
      return buildScreen();
    },
    afterBuild: (tester) async {
      await tester.pumpAndSettle();
      
      final passwordFieldFinder = find.byKey(const Key('login_password_input'));
      
      await tester.ensureVisible(passwordFieldFinder);
      await tester.pumpAndSettle();

      await tester.enterText(passwordFieldFinder, 'password123');
      await tester.pumpAndSettle();

      final visibilityButton = find.descendant(
        of: passwordFieldFinder,
        matching: find.byType(IconButton),
      );

      await tester.tap(visibilityButton);
      
      await tester.pumpAndSettle();
    },
  );
}
