import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/events/event_create/cubit/create_event_cubit.dart';
import 'package:esmorga_flutter/view/events/event_create/view/create_eventType_screen.dart';
import 'package:esmorga_flutter/view/events/event_create/view/create_event_screen.dart';
import 'package:esmorga_flutter/view/events/event_create/view/create_event_date_screen.dart';
import 'package:esmorga_flutter/view/events/event_create/model/event_type.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screenshot_helper.dart';

class MockCreateEventCubit extends MockCubit<CreateEventState> implements CreateEventCubit {}

class MockLocalizationService extends Mock implements LocalizationService {}

class MockDateTimeFormatter extends Mock implements EsmorgaDateTimeFormatter {}

void main() {
  late MockCreateEventCubit cubit;
  late MockLocalizationService localizationService;
  late MockDateTimeFormatter dateTimeFormatter;

  setUp(() {
    cubit = MockCreateEventCubit();
    localizationService = MockLocalizationService();
    dateTimeFormatter = MockDateTimeFormatter();
    getIt.registerFactory<CreateEventCubit>(() => cubit);
    getIt.registerSingleton<LocalizationService>(localizationService);
    getIt.registerSingleton<EsmorgaDateTimeFormatter>(dateTimeFormatter);
    when(() => localizationService.current).thenReturn(AppLocalizationsEn());
    when(() => cubit.state).thenReturn(const CreateEventState());
    when(() => cubit.isFormValid).thenReturn(false);
    when(() => cubit.canProceedFromScreen1()).thenReturn(false);
    when(() => cubit.canProceedFromScreen3()).thenReturn(false);
    when(() => cubit.formattedEventTime).thenReturn(null);
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
    return CreateEventScreen(
      onNavigateToNextStep: (_, __) {},
      onBackClicked: () {},
    );
  }

  Widget buildEventTypeScreen() {
    return BlocProvider<CreateEventCubit>(
      create: (_) => cubit,
      child: CreateEventTypeScreen(onNavigateToNextStep: (_, __, ___) {}),
    );
  }

  Widget buildEventDateScreen({DateTime? mockCurrentDate}) {
    return BlocProvider<CreateEventCubit>(
      create: (_) => cubit,
      child: CreateEventDateScreen(
        mockCurrentDate: mockCurrentDate,
        onNavigateToNextStep: (_, __, ___, ____) {},
        onBackClicked: () {},
      ),
    );
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

  screenshotGolden(
    'step2_initial',
    theme: lightTheme,
    screenshotPath: 'event_create',
    buildHome: () => buildEventTypeScreen(),
  );

  screenshotGolden(
    'step3_initial',
    theme: lightTheme,
    screenshotPath: 'event_create',
    buildHome: () => buildEventDateScreen(
      mockCurrentDate: DateTime(2026, 2, 16),
    ),
  );

  screenshotGolden(
    'step3_date_selected',
    theme: lightTheme,
    screenshotPath: 'event_create',
    buildHome: () => buildEventDateScreen(
      mockCurrentDate: DateTime(2026, 2, 10),
    ),
    beforeScreenshot: (tester) async {
      when(() => cubit.state).thenReturn(CreateEventState(
        eventName: 'Test Event',
        description: 'Test Description',
        eventType: EventType.text_party,
        eventDate: DateTime(2030, 3, 15),
      ));
      when(() => cubit.canProceedFromScreen3()).thenReturn(false);
    },
  );

  screenshotGolden(
    'step3_complete',
    theme: lightTheme,
    screenshotPath: 'event_create',
    buildHome: () => buildEventDateScreen(
      mockCurrentDate: DateTime(2026, 2, 10),
    ),
    beforeScreenshot: (tester) async {
      when(() => cubit.state).thenReturn(CreateEventState(
        eventName: 'Test Event',
        description: 'Test Description',
        eventType: EventType.text_party,
        eventDate: DateTime(2030, 3, 15),
        eventTime: const TimeOfDay(hour: 18, minute: 30),
      ));
      when(() => cubit.canProceedFromScreen3()).thenReturn(true);
      when(() => cubit.formattedEventTime).thenReturn('18:30');
    },
  );
}
