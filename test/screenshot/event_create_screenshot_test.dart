import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/events/event_create/cubit/create_event_cubit.dart';
import 'package:esmorga_flutter/view/events/event_create/view/create_event_screen.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'screenshot_helper.dart';

class MockCreateEventCubit extends MockCubit<CreateEventState> implements CreateEventCubit {}

class MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  late MockCreateEventCubit cubit;
  late MockLocalizationService localizationService;

  setUp(() {
    cubit = MockCreateEventCubit();
    localizationService = MockLocalizationService();
    getIt.registerFactory<CreateEventCubit>(() => cubit);
    getIt.registerSingleton<LocalizationService>(localizationService);
    when(() => localizationService.current).thenReturn(AppLocalizationsEn());
    when(() => cubit.state).thenReturn(const CreateEventState());
    when(() => cubit.isFormValid).thenReturn(false);
    when(() => cubit.effects).thenAnswer((_) => const Stream.empty());
    cubit.emit(const CreateEventState());
  });

  tearDown(() {
    getIt.reset();
  });

  final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
  );

  Widget buildScreen() {
    return const CreateEventScreen();
  }

  screenshotGolden(
    'step1_initial',
    theme: lightTheme,
    screenshotPath: 'event_create',
    buildHome: () => buildScreen(),
  );

  screenshotGolden(
    'step1_filled',
    theme: lightTheme,
    screenshotPath: 'event_create',
    buildHome: () => buildScreen(),
    afterBuild: (tester) async {
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), 'Amazing event');
      await tester.enterText(find.byType(TextField).at(1), 'This is amazing Event in Prague');
      await tester.pumpAndSettle();
    },
  );
}
