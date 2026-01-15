import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/change_password/cubit/change_password_cubit.dart';
import 'package:esmorga_flutter/view/change_password/cubit/change_password_state.dart';
import 'package:esmorga_flutter/view/change_password/view/change_password_screen.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'screenshot_helper.dart';

class MockChangePasswordCubit extends MockCubit<ChangePasswordState> implements ChangePasswordCubit {}

class MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  late MockChangePasswordCubit cubit;
  late MockLocalizationService localizationService;

  setUp(() {
    cubit = MockChangePasswordCubit();
    localizationService = MockLocalizationService();
    getIt.registerFactoryParam<ChangePasswordCubit, BuildContext, void>((context, _) => cubit);
    getIt.registerSingleton<LocalizationService>(localizationService);
    when(() => localizationService.current).thenReturn(AppLocalizationsEn());
    when(() => cubit.effects).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    getIt.reset();
  });

  final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
  );

  Widget buildScreen() {
    return const ChangePasswordScreen();
  }

  screenshotGolden(
    'change_password_initial',
    theme: lightTheme,
    screenshotPath: 'change_password',
    buildHome: () {
      when(() => cubit.state).thenReturn(const ChangePasswordInitial());
      return buildScreen();
    },
  );

  screenshotGolden(
    'change_password_filled',
    theme: lightTheme,
    screenshotPath: 'change_password',
    buildHome: () {
      when(() => cubit.state).thenReturn(const ChangePasswordEditing(
        currentPassword: 'password',
        newPassword: 'newPassword123!',
        repeatPassword: 'newPassword123!',
        isSubmitting: false,
      ));
      return buildScreen();
    },
    afterBuild: (tester) async {
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('current_password_input')), 'password');
      await tester.enterText(find.byKey(const Key('new_password_input')), 'newPassword123!');
      await tester.enterText(find.byKey(const Key('repeat_password_input')), 'newPassword123!');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
    },
  );

  screenshotGolden(
    'change_password_visible',
    theme: lightTheme,
    screenshotPath: 'change_password',
    buildHome: () {
      final stateVisible = const ChangePasswordEditing(
        currentPassword: 'Password123...',
        newPassword: 'Password123.',
        repeatPassword: 'Password123.',
        isSubmitting: false,
        showPassword: true,
      );

      when(() => cubit.state).thenReturn(stateVisible);
      when(() => cubit.stream).thenAnswer((_) => Stream.value(stateVisible));

      return buildScreen();
    },
    afterBuild: (tester) async {
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('current_password_input')), 'Password123...');
      await tester.enterText(find.byKey(const Key('new_password_input')), 'Password123.');
      await tester.enterText(find.byKey(const Key('repeat_password_input')), 'Password123.');
      
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
    },
  );
}