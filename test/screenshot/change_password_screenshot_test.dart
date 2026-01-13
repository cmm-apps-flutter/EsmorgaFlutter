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
  );

  screenshotGolden(
    'change_password_visible',
    theme: lightTheme,
    screenshotPath: 'change_password',
    buildHome: () {
      when(() => cubit.state).thenReturn(const ChangePasswordEditing(
        currentPassword: 'Password123...',
        newPassword: 'Password123.',
        repeatPassword: 'Password123.',
        isSubmitting: false,
      ));
      return buildScreen();
    },
    afterBuild: (tester) async {
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      
      await tester.ensureVisible(fields.at(0));
      await tester.tap(find.descendant(
        of: fields.at(0), 
        matching: find.byType(IconButton),
      ));

      await tester.ensureVisible(fields.at(1));
      await tester.tap(find.descendant(
        of: fields.at(1), 
        matching: find.byType(IconButton),
      ));

      await tester.ensureVisible(fields.at(2));
      await tester.tap(find.descendant(
        of: fields.at(2), 
        matching: find.byType(IconButton),
      ));
      
      await tester.pumpAndSettle();
    },
  );
}
