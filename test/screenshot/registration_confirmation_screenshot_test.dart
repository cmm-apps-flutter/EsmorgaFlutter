import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/registration/cubit/registration_confirmation_cubit.dart';
import 'package:esmorga_flutter/view/registration/cubit/registration_confirmation_state.dart';
import 'package:esmorga_flutter/view/registration/view/registration_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'screenshot_helper.dart';

class MockRegistrationConfirmationCubit extends MockCubit<RegistrationConfirmationState>
    implements RegistrationConfirmationCubit {}

class MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  late MockRegistrationConfirmationCubit cubit;
  late MockLocalizationService localizationService;

  setUp(() {
    cubit = MockRegistrationConfirmationCubit();
    localizationService = MockLocalizationService();
    // RegistrationConfirmationScreen DOES create the cubit using GetIt:
    // create: (_) => getIt<RegistrationConfirmationCubit>(),

    getIt.registerFactory<RegistrationConfirmationCubit>(() => cubit);
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
    return RegistrationConfirmationScreen(
      email: 'john.doe@example.com',
      onBackClicked: () {},
    );
  }

  screenshotGolden(
    'registration_confirmation_initial',
    theme: lightTheme,
    screenshotPath: 'registration_confirmation',
    buildHome: () {
      when(() => cubit.state).thenReturn(RegistrationConfirmationInitial());
      return buildScreen();
    },
  );

  screenshotGolden(
    'registration_confirmation_resending',
    theme: lightTheme,
    screenshotPath: 'registration_confirmation',
    buildHome: () {
      when(() => cubit.state).thenReturn(RegistrationConfirmationResending());
      return buildScreen();
    },
  );
}
