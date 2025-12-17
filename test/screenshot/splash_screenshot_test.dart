import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/splash/cubit/splash_cubit.dart';
import 'package:esmorga_flutter/view/splash/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'screenshot_helper.dart';

class MockSplashCubit extends MockCubit<SplashState> implements SplashCubit {}

void main() {
  late MockSplashCubit cubit;

  setUp(() {
    cubit = MockSplashCubit();
    // No GetIt needed for SplashCubit if provided via BlocProvider in test wrapper
    // But verify if SplashScreen uses GetIt anywhere. It seems to use context.read().
    when(() => cubit.start()).thenAnswer((_) async {});
  });

  tearDown(() {
    // getIt.reset(); // Not used
  });

  final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
  );

  Widget buildScreen() {
    return BlocProvider<SplashCubit>(
      create: (_) => cubit,
      child: SplashScreen(
        onFinished: () {},
      ),
    );
  }

  screenshotGolden(
    'splash_initial',
    theme: lightTheme,
    screenshotPath: 'splash',
    buildHome: () {
      when(() => cubit.state).thenReturn(const SplashState.initial());
      return buildScreen();
    },
  );
}
