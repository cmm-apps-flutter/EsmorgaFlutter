import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/registration/cubit/register_cubit.dart';
import 'package:esmorga_flutter/view/registration/view/register_screen.dart';
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
    buildHome: () => buildScreen(),
    afterBuild: (tester) async {
      await tester.pumpAndSettle();
      
      await tester.enterText(find.byKey(const Key('registration_name_input')), 'John');
      await tester.enterText(find.byKey(const Key('registration_last_name_input')), 'Doe');
      await tester.enterText(find.byKey(const Key('registration_email_input')), 'john.doe@example.com');

      final passFinder = find.byKey(const Key('registration_password_input'));
      final repeatPassFinder = find.byKey(const Key('registration_repeat_password_input'));

      await tester.ensureVisible(passFinder);
      await tester.pumpAndSettle();
      await tester.enterText(passFinder, 'Password123!');
      
      await tester.ensureVisible(repeatPassFinder);
      await tester.pumpAndSettle();
      await tester.enterText(repeatPassFinder, 'Password123!');

      final eye1 = find.descendant(of: passFinder, matching: find.byType(IconButton));
      final eye2 = find.descendant(of: repeatPassFinder, matching: find.byType(IconButton));

      await tester.tap(eye1);
      await tester.tap(eye2);
      
      await tester.pumpAndSettle();
    },
  );
}
