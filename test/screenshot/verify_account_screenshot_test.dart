import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/registration/verify_account/cubit/verify_account_cubit.dart';
import 'package:esmorga_flutter/view/registration/verify_account/cubit/verify_account_state.dart';
import 'package:esmorga_flutter/view/registration/verify_account/view/verify_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'screenshot_helper.dart';

class MockVerifyAccountCubit extends MockCubit<VerifyAccountState> implements VerifyAccountCubit {}

class MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  late MockVerifyAccountCubit cubit;
  late MockLocalizationService localizationService;

  setUp(() {
    cubit = MockVerifyAccountCubit();
    localizationService = MockLocalizationService();
    // VerifyAccountScreen uses context.read<VerifyAccountCubit>(), but it is NOT created via GetIt inside the screen.
    // Wait, let's check the screen:
    // class VerifyAccountScreen extends StatefulWidget { ... createState ... }
    // class _VerifyAccountScreenState ... initState { _cubit = context.read<VerifyAccountCubit>(); ... }
    // It assumes the cubit is provided by a parent.
    // Ah, wait. In VerifyAccountScreen source code:
    // It DOES NOT create the cubit. It expects it to be provided.
    // So my test helper buildHome needs to provide it.

    getIt.registerSingleton<LocalizationService>(localizationService);
    when(() => localizationService.current).thenReturn(AppLocalizationsEn());
    when(() => cubit.verifyAccount()).thenAnswer((_) async {});
    when(() => cubit.effectStream).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    getIt.reset();
  });

  final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
  );

  Widget buildScreen() {
    // Provide the mocked cubit
    return BlocProvider<VerifyAccountCubit>(
      create: (_) => cubit,
      child: VerifyAccountScreen(onAccountVerified: () {}),
    );
  }

  screenshotGolden(
    'verify_account_initial',
    theme: lightTheme,
    screenshotPath: 'verify_account',
    buildHome: () {
      when(() => cubit.state).thenReturn(VerifyAccountInitial());
      return buildScreen();
    },
  );

  screenshotGolden(
    'verify_account_loading',
    theme: lightTheme,
    screenshotPath: 'verify_account',
    buildHome: () {
      when(() => cubit.state).thenReturn(VerifyAccountLoading());
      return buildScreen();
    },
  );
}
