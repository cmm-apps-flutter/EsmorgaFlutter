import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/ds/esmorga_theme.dart';
import 'package:esmorga_flutter/view/events/event_attendees/cubbit/event_attendees_cubit.dart';
import 'package:esmorga_flutter/view/events/event_attendees/cubbit/event_attendees_state.dart';
import 'package:esmorga_flutter/view/events/event_attendees/mapper/event_attendee_ui_model.dart';
import 'package:esmorga_flutter/view/events/event_attendees/mapper/event_attendees_ui_mapper.dart';
import 'package:esmorga_flutter/view/events/event_attendees/view/event_attendees_screen.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'screenshot_helper.dart';

class MockEventAttendeesCubit extends MockCubit<EventAttendeesState> implements EventAttendeesCubit {}

class MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  late MockEventAttendeesCubit cubit;
  late MockLocalizationService localizationService;

  setUp(() {
    cubit = MockEventAttendeesCubit();
    localizationService = MockLocalizationService();
    getIt.registerSingleton<LocalizationService>(localizationService);
    when(() => localizationService.current).thenReturn(AppLocalizationsEn());
    when(() => cubit.loadAttendees(any())).thenAnswer((_) async {});
  });

  tearDown(() {
    getIt.reset();
  });

  final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
  );

  Widget buildScreen() {
    return BlocProvider<EventAttendeesCubit>(
      create: (_) => cubit,
      child: const EventAttendeesScreen(eventId: '1'),
    );
  }

  final attendees = [
    EventAttendeeUiModel(name: 'Alice', isPaid: true),
    EventAttendeeUiModel(name: 'Bob', isPaid: false),
  ];

  screenshotGolden(
    'event_attendees_user',
    theme: lightTheme,
    screenshotPath: 'event_attendees',
    buildHome: () {
      when(() => cubit.state).thenReturn(EventAttendeesState.success(
        EventAttendeesUiModel(users: attendees, isAdmin: false),
      ));
      return buildScreen();
    },
  );

  screenshotGolden(
    'event_attendees_admin',
    theme: lightTheme,
    screenshotPath: 'event_attendees',
    buildHome: () {
      when(() => cubit.state).thenReturn(EventAttendeesState.success(
        EventAttendeesUiModel(users: attendees, isAdmin: true),
      ));
      return buildScreen();
    },
  );
}
