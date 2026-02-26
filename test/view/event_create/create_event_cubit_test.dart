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
      'initFromEventData hydrates state in a single emission',
      build: () => cubit,
      act: (cubit) => cubit.initFromEventData(const EventCreationData(
        eventName: 'My Event',
        description: 'A long enough description',
        eventType: EventType.text_party,
        formattedEventDate: '2030-06-15T18:30:00.000Z',
      )),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.eventName, 'eventName', 'My Event')
            .having((s) => s.description, 'description', 'A long enough description')
            .having((s) => s.eventType, 'eventType', EventType.text_party)
            .having((s) => s.formattedEventDate, 'formattedEventDate', '2030-06-15T18:30:00.000Z')
            .having((s) => s.eventNameError, 'eventNameError', isNull)
            .having((s) => s.descriptionError, 'descriptionError', isNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'initializeEventDate sets today date from EsmorgaClock',
      build: () => cubit,
      act: (cubit) => cubit.initializeEventDate(),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.eventDate, 'eventDate', DateTime(2026, 2, 19))
            .having((s) => s.eventDateError, 'eventDateError', isNull),
      ],
    );

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

    blocTest<CreateEventCubit, CreateEventState>(
      'updateLocation with empty string sets locationError',
      build: () => cubit,
      act: (cubit) => cubit.updateLocation(''),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.location, 'location', '')
            .having((s) => s.locationError, 'locationError', isNotNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateLocation with valid string clears locationError',
      build: () => cubit,
      act: (cubit) => cubit.updateLocation('Barcelona'),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.location, 'location', 'Barcelona')
            .having((s) => s.locationError, 'locationError', isNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateLocation with emoji sets error',
      build: () => cubit,
      act: (cubit) => cubit.updateLocation('Barcelona 🎉'),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.location, 'location', 'Barcelona 🎉')
            .having((s) => s.locationError, 'locationError', isNotNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateLocation with special symbols sets error',
      build: () => cubit,
      act: (cubit) => cubit.updateLocation('Loc@tion!'),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.location, 'location', 'Loc@tion!')
            .having((s) => s.locationError, 'locationError', isNotNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateLocation with allowed special chars succeeds',
      build: () => cubit,
      act: (cubit) => cubit.updateLocation("Calle d'en Robador, 1ª/2º"),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.location, 'location', "Calle d'en Robador, 1ª/2º")
            .having((s) => s.locationError, 'locationError', isNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateLocation with whitespace-only string sets locationError',
      build: () => cubit,
      act: (cubit) => cubit.updateLocation(' '),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.location, 'location', '')
            .having((s) => s.locationError, 'locationError', l10n.inlineErrorLocationRequired),
      ],
    );

    test('canProceedFromScreen4 returns false for whitespace-only location', () {
      cubit.updateLocation('   ');
      expect(cubit.state.location, '');
      expect(cubit.canProceedFromScreen4(), isFalse);
    });

    blocTest<CreateEventCubit, CreateEventState>(
      'updateCoordinates with empty string clears error',
      build: () => cubit,
      act: (cubit) => cubit.updateCoordinates(''),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.coordinates, 'coordinates', '')
            .having((s) => s.coordinatesError, 'coordinatesError', isNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateCoordinates with valid pair clears error',
      build: () => cubit,
      act: (cubit) => cubit.updateCoordinates('41.3879, 2.16992'),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.coordinates, 'coordinates', '41.3879, 2.16992')
            .having((s) => s.coordinatesError, 'coordinatesError', isNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateCoordinates with invalid string sets error',
      build: () => cubit,
      act: (cubit) => cubit.updateCoordinates('invalid'),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.coordinates, 'coordinates', 'invalid')
            .having((s) => s.coordinatesError, 'coordinatesError', isNotNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateCoordinates with latitude out of bounds sets error',
      build: () => cubit,
      act: (cubit) => cubit.updateCoordinates('95.0, 2.16992'),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.coordinates, 'coordinates', '95.0, 2.16992')
            .having((s) => s.coordinatesError, 'coordinatesError', isNotNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateCoordinates with longitude out of bounds sets error',
      build: () => cubit,
      act: (cubit) => cubit.updateCoordinates('41.3879, -190.0'),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.coordinates, 'coordinates', '41.3879, -190.0')
            .having((s) => s.coordinatesError, 'coordinatesError', isNotNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateCoordinates with exact max boundary values succeeds',
      build: () => cubit,
      act: (cubit) => cubit.updateCoordinates('90, 180'),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.coordinates, 'coordinates', '90, 180')
            .having((s) => s.coordinatesError, 'coordinatesError', isNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateCoordinates with exact min boundary values succeeds',
      build: () => cubit,
      act: (cubit) => cubit.updateCoordinates('-90, -180'),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.coordinates, 'coordinates', '-90, -180')
            .having((s) => s.coordinatesError, 'coordinatesError', isNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateCoordinates with just over latitude boundary sets error',
      build: () => cubit,
      act: (cubit) => cubit.updateCoordinates('90.0001, 0'),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.coordinatesError, 'coordinatesError', isNotNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateCoordinates with just over longitude boundary sets error',
      build: () => cubit,
      act: (cubit) => cubit.updateCoordinates('0, 180.0001'),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.coordinatesError, 'coordinatesError', isNotNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateMaxCapacity with empty string clears error',
      build: () => cubit,
      act: (cubit) => cubit.updateMaxCapacity(''),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.maxCapacity, 'maxCapacity', '')
            .having((s) => s.maxCapacityError, 'maxCapacityError', isNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateMaxCapacity with valid value clears error',
      build: () => cubit,
      act: (cubit) => cubit.updateMaxCapacity('100'),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.maxCapacity, 'maxCapacity', '100')
            .having((s) => s.maxCapacityError, 'maxCapacityError', isNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateMaxCapacity with 0 sets error',
      build: () => cubit,
      act: (cubit) => cubit.updateMaxCapacity('0'),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.maxCapacity, 'maxCapacity', '0')
            .having((s) => s.maxCapacityError, 'maxCapacityError', isNotNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateMaxCapacity with 5001 sets error',
      build: () => cubit,
      act: (cubit) => cubit.updateMaxCapacity('5001'),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.maxCapacity, 'maxCapacity', '5001')
            .having((s) => s.maxCapacityError, 'maxCapacityError', isNotNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateMaxCapacity with minimum value 1 clears error',
      build: () => cubit,
      act: (cubit) => cubit.updateMaxCapacity('1'),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.maxCapacity, 'maxCapacity', '1')
            .having((s) => s.maxCapacityError, 'maxCapacityError', isNull),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateMaxCapacity with maximum value 5000 clears error',
      build: () => cubit,
      act: (cubit) => cubit.updateMaxCapacity('5000'),
      expect: () => [
        isA<CreateEventState>()
            .having((s) => s.maxCapacity, 'maxCapacity', '5000')
            .having((s) => s.maxCapacityError, 'maxCapacityError', isNull),
      ],
    );

    test('canProceedFromScreen4 requires non-empty location and no errors', () {
      expect(cubit.canProceedFromScreen4(), isFalse);

      cubit.updateLocation('Barcelona');
      expect(cubit.canProceedFromScreen4(), isTrue);

      cubit.updateCoordinates('invalid');
      expect(cubit.canProceedFromScreen4(), isFalse);

      cubit.updateCoordinates('41.3879, 2.16992');
      expect(cubit.canProceedFromScreen4(), isTrue);

      cubit.updateMaxCapacity('0');
      expect(cubit.canProceedFromScreen4(), isFalse);

      cubit.updateMaxCapacity('100');
      expect(cubit.canProceedFromScreen4(), isTrue);
    });

    test('submitLocationStep emits CreateEventLocationConfirmedEffect', () async {
      when(() => mockFormatter.formatTimeWithMillisUtcSuffix(18, 30))
          .thenReturn('18:30:00.000Z');
      when(() => mockFormatter.formatIsoDateTime(any(), any()))
          .thenReturn('2030-06-15T18:30:00.000Z');

      cubit.updateEventName('Test Event');
      cubit.updateDescription('A valid test description text');
      cubit.updateEventType(EventType.text_party);
      cubit.updateEventDate(DateTime(2030, 6, 15));
      cubit.updateEventTime(const TimeOfDay(hour: 18, minute: 30));
      cubit.updateLocation('Barcelona');
      cubit.updateCoordinates('41.3879, 2.16992');
      cubit.updateMaxCapacity('200');

      final effectFuture = expectLater(
        cubit.effects,
        emits(isA<CreateEventLocationConfirmedEffect>()
            .having((e) => e.eventData.eventName, 'eventName', 'Test Event')
            .having((e) => e.eventData.formattedEventDate, 'formattedEventDate', '2030-06-15T18:30:00.000Z')
            .having((e) => e.eventData.location, 'location', 'Barcelona')
            .having((e) => e.eventData.coordinates, 'coordinates', '41.3879, 2.16992')
            .having((e) => e.eventData.maxCapacity, 'maxCapacity', 200)),
      );

      cubit.submitLocationStep();
      await effectFuture;
    });

    test('submitLocationStep does nothing when date is incomplete', () async {
      cubit.updateEventName('Test Event');
      cubit.updateDescription('A valid test description text');
      cubit.updateEventType(EventType.text_party);
      cubit.updateLocation('Barcelona');

      final emittedEffects = <CreateEventEffect>[];
      final subscription = cubit.effects.listen(emittedEffects.add);

      cubit.submitLocationStep();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(emittedEffects, isEmpty);
      await subscription.cancel();
    });
  });
}
