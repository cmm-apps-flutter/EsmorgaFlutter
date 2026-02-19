import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/events/event_create/cubit/create_event_cubit.dart';
import 'package:esmorga_flutter/view/events/event_create/model/event_type.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/util/esmorga_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalizationService extends Mock implements LocalizationService {}

class _MockDateTimeFormatter extends Mock implements EsmorgaDateTimeFormatter {}

class _MockClock extends Mock implements EsmorgaClock {}

void main() {
  late CreateEventCubit cubit;
  late _MockLocalizationService mockL10nService;
  late _MockDateTimeFormatter mockFormatter;
  late _MockClock mockClock;
  final l10n = AppLocalizationsEn();

  setUp(() {
    mockL10nService = _MockLocalizationService();
    mockFormatter = _MockDateTimeFormatter();
    mockClock = _MockClock();
    getIt.registerSingleton<LocalizationService>(mockL10nService);
    when(() => mockL10nService.current).thenReturn(l10n);
    when(() => mockClock.now()).thenReturn(DateTime(2026, 2, 19));
    cubit = CreateEventCubit(l10n: l10n, dateTimeFormatter: mockFormatter, clock: mockClock);
  });

  tearDown(() {
    cubit.close();
    getIt.reset();
  });

  group('CreateEventCubit', () {
    test('initial state has default values', () {
      expect(cubit.state.eventName, '');
      expect(cubit.state.description, '');
      expect(cubit.state.eventType, EventType.text_party);
      expect(cubit.state.eventDate, isNull);
      expect(cubit.state.eventTime, isNull);
      expect(cubit.state.eventDateError, isNull);
    });

    blocTest<CreateEventCubit, CreateEventState>(
      'updateEventDate with future date sets date without error',
      build: () => cubit,
      act: (cubit) => cubit.updateEventDate(DateTime(2030, 6, 15)),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.eventDate, 'eventDate', DateTime(2030, 6, 15))
            .having((s) => s.eventDateError, 'eventDateError', isNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateEventDate with past date sets date with error',
      build: () => cubit,
      act: (cubit) => cubit.updateEventDate(DateTime(2020, 1, 1)),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.eventDate, 'eventDate', DateTime(2020, 1, 1))
            .having((s) => s.eventDateError, 'eventDateError', isNotNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateEventTime sets time correctly',
      build: () => cubit,
      act: (cubit) => cubit.updateEventTime(const TimeOfDay(hour: 18, minute: 30)),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.eventTime, 'eventTime', const TimeOfDay(hour: 18, minute: 30)),
      ],
    );

    test('formattedEventTime returns null when no time set', () {
      expect(cubit.formattedEventTime, isNull);
    });

    test('formattedEventTime returns locale formatted string when time is set', () {
      cubit.updateEventTime(const TimeOfDay(hour: 14, minute: 30));
      expect(cubit.formattedEventTime, isNotNull);
      expect(cubit.formattedEventTime, contains('14:30'));
    });

    test('getFormattedEventDate returns null when date or time missing', () {
      expect(cubit.getFormattedEventDate(), isNull);
      cubit.updateEventDate(DateTime(2030, 6, 15));
      expect(cubit.getFormattedEventDate(), isNull);
    });

    test('getFormattedEventDate uses EsmorgaDateTimeFormatter', () {
      when(() => mockFormatter.formatTimeWithMillisUtcSuffix(18, 30))
          .thenReturn('18:30:00.000Z');
      when(() => mockFormatter.formatIsoDateTime(any(), any()))
          .thenReturn('2030-06-15T18:30:00.000Z');

      cubit.updateEventDate(DateTime(2030, 6, 15));
      cubit.updateEventTime(const TimeOfDay(hour: 18, minute: 30));
      final result = cubit.getFormattedEventDate();

      expect(result, '2030-06-15T18:30:00.000Z');
      verify(() => mockFormatter.formatTimeWithMillisUtcSuffix(18, 30)).called(1);
      verify(() => mockFormatter.formatIsoDateTime(DateTime(2030, 6, 15), '18:30:00.000Z')).called(1);
    });

    test('canProceedFromScreen3 requires date, time, and no date error', () {
      expect(cubit.canProceedFromScreen3(), isFalse);

      cubit.updateEventDate(DateTime(2030, 6, 15));
      expect(cubit.canProceedFromScreen3(), isFalse);

      cubit.updateEventTime(const TimeOfDay(hour: 18, minute: 30));
      expect(cubit.canProceedFromScreen3(), isTrue);
    });

    test('canProceedFromScreen3 is false with past date error', () {
      cubit.updateEventDate(DateTime(2020, 1, 1));
      cubit.updateEventTime(const TimeOfDay(hour: 18, minute: 30));
      expect(cubit.canProceedFromScreen3(), isFalse);
    });

    test('submitDateStep emits CreateEventDateConfirmedEffect', () async {
      when(() => mockFormatter.formatTimeWithMillisUtcSuffix(18, 30))
          .thenReturn('18:30:00.000Z');
      when(() => mockFormatter.formatIsoDateTime(any(), any()))
          .thenReturn('2030-06-15T18:30:00.000Z');

      cubit.updateEventName('Test Event');
      cubit.updateDescription('A valid test description text');
      cubit.updateEventType(EventType.text_party);
      cubit.updateEventDate(DateTime(2030, 6, 15));
      cubit.updateEventTime(const TimeOfDay(hour: 18, minute: 30));

      final effectFuture = expectLater(
        cubit.effects,
        emits(isA<CreateEventDateConfirmedEffect>()
            .having((e) => e.eventData.eventName, 'eventName', 'Test Event')
            .having((e) => e.eventData.description, 'description', 'A valid test description text')
            .having((e) => e.eventData.eventType, 'eventType', EventType.text_party)
            .having((e) => e.eventData.formattedEventDate, 'formattedEventDate', '2030-06-15T18:30:00.000Z')),
      );

      cubit.submitDateStep();
      await effectFuture;
    });

    test('submitDateStep does nothing when date is incomplete', () async {
      cubit.updateEventName('Test Event');
      cubit.updateDescription('A valid test description text');
      cubit.updateEventType(EventType.text_party);
      cubit.updateEventDate(DateTime(2030, 6, 15));

      final emittedEffects = <CreateEventEffect>[];
      final subscription = cubit.effects.listen(emittedEffects.add);

      cubit.submitDateStep();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(emittedEffects, isEmpty);
      await subscription.cancel();
    });

    test('submit emits CreateEventNavigateToEventTypeEffect', () async {
      cubit.updateEventName('Test Event');
      cubit.updateDescription('A valid test description text');

      final effectFuture = expectLater(
        cubit.effects,
        emits(isA<CreateEventNavigateToEventTypeEffect>()
            .having((e) => e.eventData.eventName, 'eventName', 'Test Event')
            .having((e) => e.eventData.description, 'description', 'A valid test description text')),
      );

      cubit.submit();
      await effectFuture;
    });

    blocTest<CreateEventCubit, CreateEventState>(
      'clearDateAndTime resets date and time to null',
      build: () => cubit,
      seed: () => CreateEventState(
        eventDate: DateTime(2030, 6, 15),
        eventTime: const TimeOfDay(hour: 18, minute: 30),
      ),
      act: (cubit) => cubit.clearDateAndTime(),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.eventDate, 'eventDate', isNull)
            .having((s) => s.eventTime, 'eventTime', isNull),
      ],
    );
  });
}
