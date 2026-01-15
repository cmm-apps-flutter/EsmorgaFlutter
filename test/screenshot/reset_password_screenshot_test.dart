import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/password/reset_password_cubit.dart';
import 'package:esmorga_flutter/view/password/reset_password_state.dart';
import 'package:esmorga_flutter/view/password/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'screenshot_helper.dart';

class MockResetPasswordCubit extends MockCubit<ResetPasswordState> implements ResetPasswordCubit {}

class MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  late MockResetPasswordCubit cubit;
  late MockLocalizationService localizationService;

  setUp(() {
    cubit = MockResetPasswordCubit();
    localizationService = MockLocalizationService();
    getIt.registerFactoryParam<ResetPasswordCubit, BuildContext, String?>((context, code) => cubit);
    getIt.registerSingleton<LocalizationService>(localizationService);
    when(() => localizationService.current).thenReturn(AppLocalizationsEn());
  });

  tearDown(() {
    getIt.reset();
  });

  final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
  );

  Widget buildScreen() {
    return const ResetPasswordScreen(code: '123456');
  }

  screenshotGolden(
    'reset_password_initial',
    theme: lightTheme,
    screenshotPath: 'reset_password',
    buildHome: () {
      when(() => cubit.state).thenReturn(const ResetPasswordState());
      return buildScreen();
    },
  );

  screenshotGolden(
    'reset_password_filled',
    theme: lightTheme,
    screenshotPath: 'reset_password',
    buildHome: () {
      when(() => cubit.state).thenReturn(const ResetPasswordState(
        newPassword: 'newPassword123!',
        repeatPassword: 'newPassword123!',
      ));
      return buildScreen();
    },
    afterBuild: (tester) async {
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('reset_password_new_input')), 'newPassword123!');
      await tester.enterText(find.byKey(const Key('reset_password_repeat_input')), 'newPassword123!');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
    },
  );

  screenshotGolden(
    'reset_password_error',
    theme: lightTheme,
    screenshotPath: 'reset_password',
    buildHome: () {
      when(() => cubit.state).thenReturn(const ResetPasswordState(
        newPassword: 'newPassword123!',
        repeatPassword: 'mismatch',
        newError: null,
        repeatError: 'Passwords do not match',
        repeatBlurred: true,
      ));
      return buildScreen();
    },
    afterBuild: (tester) async {
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('reset_password_new_input')), 'newPassword123!');
      await tester.enterText(find.byKey(const Key('reset_password_repeat_input')), 'mismatch');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
    },
  );

  screenshotGolden(
    'reset_password_invalid_code',
    theme: lightTheme,
    screenshotPath: 'reset_password',
    buildHome: () {
      when(() => cubit.state).thenReturn(const ResetPasswordState(
        codeInvalid: true,
      ));
      return buildScreen();
    },
  );

  screenshotGolden(
    'reset_password_visible',
    theme: lightTheme,
    screenshotPath: 'reset_password',
    buildHome: () {
      final stateVisible = const ResetPasswordState(
        newPassword: 'newPassword123!',
        repeatPassword: 'newPassword123!',
        showNewPassword: true,
        showRepeatPassword: true,
      );
      
      when(() => cubit.state).thenReturn(stateVisible);
      when(() => cubit.stream).thenAnswer((_) => Stream.value(stateVisible));
      
      return buildScreen();
    },
    afterBuild: (tester) async {
      await tester.pumpAndSettle();
      
      await tester.enterText(find.byKey(const Key('reset_password_new_input')), 'newPassword123!');
      await tester.enterText(find.byKey(const Key('reset_password_repeat_input')), 'newPassword123!');
      
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
    },
  );
}