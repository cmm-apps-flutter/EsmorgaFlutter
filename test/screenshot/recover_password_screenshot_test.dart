import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/password/recover_password_cubit.dart';
import 'package:esmorga_flutter/view/password/recover_password_state.dart';
import 'package:esmorga_flutter/view/password/recover_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'screenshot_helper.dart';

class MockRecoverPasswordCubit extends MockCubit<RecoverPasswordState> implements RecoverPasswordCubit {}

class MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  late MockRecoverPasswordCubit cubit;
  late MockLocalizationService localizationService;

  setUp(() {
    cubit = MockRecoverPasswordCubit();
    localizationService = MockLocalizationService();
    getIt.registerFactoryParam<RecoverPasswordCubit, BuildContext, void>((context, _) => cubit);
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
    return const RecoverPasswordScreen();
  }

  screenshotGolden(
    'recover_password_initial',
    theme: lightTheme,
    screenshotPath: 'recover_password',
    buildHome: () {
      when(() => cubit.state).thenReturn(const RecoverPasswordState());
      return buildScreen();
    },
  );

  screenshotGolden(
    'recover_password_filled',
    theme: lightTheme,
    screenshotPath: 'recover_password',
    buildHome: () {
      when(() => cubit.state).thenReturn(const RecoverPasswordState(
        email: 'john.doe@example.com',
      ));
      return buildScreen();
    },
  );

  screenshotGolden(
    'recover_password_error',
    theme: lightTheme,
    screenshotPath: 'recover_password',
    buildHome: () {
      when(() => cubit.state).thenReturn(const RecoverPasswordState(
        email: 'invalid-email',
        emailError: 'Invalid email',
        emailBlurred: true,
      ));
      return buildScreen();
    },
  );
}
