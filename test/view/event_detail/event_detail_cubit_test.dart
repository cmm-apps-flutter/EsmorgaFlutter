import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/event/model/event_location.dart';
import 'package:esmorga_flutter/domain/user/model/role_type.dart';
import 'package:esmorga_flutter/domain/user/model/user.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_cubit.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_effect.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockEventRepository extends Mock implements EventRepository {}

class _MockUserRepository extends Mock implements UserRepository {}

class _FakeFormatter implements EsmorgaDateTimeFormatter {
  @override
  String formatEventDate(int epochMillis) {
    return DateTime.fromMillisecondsSinceEpoch(epochMillis).toIso8601String();
  }

  @override
  String formatIsoDateTime(DateTime date, String time) => 'iso';

  @override
  String formatTimeWithMillisUtcSuffix(int hour, int minute) => 'timeZ';
}

void main() {
  late _MockEventRepository eventRepository;
  late _MockUserRepository userRepository;

  const testUser = User(name: 'John', lastName: 'Doe', email: 'john@doe.com', role: RoleType.user);

  final baseEvent = Event(
    id: 'e1',
    name: 'Event',
    date: 0,
    description: 'A description',
    location: const EventLocation(name: 'Loc', lat: 10.0, long: 20.0),
    userJoined: false,
    imageUrl: null,
    tags: const [],
    currentAttendeeCount: 2,
    maxCapacity: 10,
    joinDeadline: DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch, 
  );
  
  final deadlinePassedEvent = baseEvent.copyWith(
    joinDeadline: DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
    currentAttendeeCount: 2,
    userJoined: false,
  );

  final fullEvent = baseEvent.copyWith(
    currentAttendeeCount: 10,
    maxCapacity: 10,
    joinDeadline: DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch,
    userJoined: false,
  );

  final fullJoinedEvent = fullEvent.copyWith(
    userJoined: true,
  );

  final deadlineFutureEvent = baseEvent.copyWith(
    joinDeadline: DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch,
    currentAttendeeCount: 2,
    userJoined: false,
  );


  setUpAll(() {
    registerFallbackValue(baseEvent);
  });

  setUp(() {
    eventRepository = _MockEventRepository();
    userRepository = _MockUserRepository();
    getIt.registerSingleton<EsmorgaDateTimeFormatter>(_FakeFormatter());
  });

  tearDown(() async {
    getIt.reset();
  });

    blocTest<EventDetailCubit, EventDetailState>(
      'loads event and sets isAuthenticated true when getUser succeeds',
      build: () {
        when(() => userRepository.getUser()).thenAnswer((_) async => testUser);
        return EventDetailCubit(eventRepository: eventRepository, userRepository: userRepository, event: baseEvent);
      },
      act: (c) => c.start(),
      expect: () => [
        isA<EventDetailState>().having((s) => s.loading, 'loading', true),
        isA<EventDetailState>()
            .having((s) => s.loading, 'loading', false)
            .having((s) => s.isAuthenticated, 'isAuthenticated', true),
      ],
    );

    blocTest<EventDetailCubit, EventDetailState>(
      'join flow emits submitting, updated event userJoined true and success effect',
      build: () {
        when(() => userRepository.getUser()).thenAnswer((_) async => testUser);
        when(() => eventRepository.joinEvent(any())).thenAnswer((_) async {});
        return EventDetailCubit(eventRepository: eventRepository, userRepository: userRepository, event: baseEvent);
      },
      act: (c) async {
        final effectFuture = c.effects.firstWhere((e) => e is ShowJoinSuccessEffect);
        await c.start();
        await c.primaryPressed();
        await effectFuture;
      },
      expect: () => [
        isA<EventDetailState>().having((s) => s.loading, 'loading', true),
        isA<EventDetailState>().having((s) => s.loading, 'loading', false).having((s) => s.isAuthenticated, 'isAuthenticated', true),
        isA<EventDetailState>().having((s) => s.joinLeaving, 'joinLeaving', true),
        isA<EventDetailState>()
            .having((s) => s.joinLeaving, 'joinLeaving', false)
            .having((s) => s.uiModel.userJoined, 'joined', true),
      ],
    );

    blocTest<EventDetailCubit, EventDetailState>(
      'navigate pressed emits openMaps effect when coords present',
      build: () {
        when(() => userRepository.getUser()).thenAnswer((_) async => testUser);
        return EventDetailCubit(eventRepository: eventRepository, userRepository: userRepository, event: baseEvent);
      },
      act: (c) async {
        final effectFuture = c.effects.firstWhere((e) => e is OpenMapsEffect);
        c.start();
        await Future<void>.delayed(const Duration(milliseconds: 5));
        c.navigatePressed();
        await effectFuture;
      },
      expect: () => [
        isA<EventDetailState>().having((s) => s.loading, 'loading', true),
        isA<EventDetailState>(),
      ],
    );

    blocTest<EventDetailCubit, EventDetailState>(
      'uiModel has the correct capacity values',
      build: () {
        when(() => userRepository.getUser()).thenAnswer((_) async => testUser);
        return EventDetailCubit(
          eventRepository: eventRepository,
          userRepository: userRepository,
          event: baseEvent,
        );
      },
      act: (cubit) => cubit.start(),
      expect: () => [
        isA<EventDetailState>().having((s) => s.loading, 'loading', true),
        isA<EventDetailState>()
            .having((s) => s.loading, 'loading', false)
            .having((s) => s.uiModel.currentAttendeeCount, 'currentAttendeeCount', 2)
            .having((s) => s.uiModel.maxCapacity, 'maxCapacity', 10),
      ],
    );  

  blocTest<EventDetailCubit, EventDetailState>(
    'isJoinEnabled is false when joinDeadline is in the past',
    build: () {
      return EventDetailCubit(
        eventRepository: eventRepository,
        userRepository: userRepository,
        event: deadlinePassedEvent,
      );
    },
    act: (c) => c.start(),
    expect: () => [
      isA<EventDetailState>().having((s) => s.loading, 'loading', true),
      isA<EventDetailState>()
          .having((s) => s.loading, 'loading', false)
          .having((s) => s.isJoinEnabled, 'isJoinEnabled', false), 
    ],
  );

  blocTest<EventDetailCubit, EventDetailState>(
    'isJoinEnabled is true when joinDeadline is in the future',
    build: () {
      return EventDetailCubit(
        eventRepository: eventRepository,
        userRepository: userRepository,
        event: deadlineFutureEvent,
      );
    },
    act: (c) => c.start(),
    expect: () => [
      isA<EventDetailState>().having((s) => s.loading, 'loading', true),
      isA<EventDetailState>()
          .having((s) => s.loading, 'loading', false)
          .having((s) => s.isJoinEnabled, 'isJoinEnabled', true),
    ],
  );

  blocTest<EventDetailCubit, EventDetailState>(
    'primaryPressed emits ShowJoinClosedEffect when deadline is passed',
    build: () {
      when(() => userRepository.getUser()).thenAnswer((_) async => testUser);
      return EventDetailCubit(
        eventRepository: eventRepository,
        userRepository: userRepository,
        event: deadlinePassedEvent,
      );
    },
    act: (c) async {
      final effectFuture = c.effects.firstWhere((e) => e is ShowJoinClosedEffect);
      await c.start();
      c.primaryPressed();
      await effectFuture;
    },
    verify: (c) {
      verifyNever(() => eventRepository.joinEvent(any()));
    },
  );

  blocTest<EventDetailCubit, EventDetailState>(
    'isJoinEnabled is true when event is full but deadline is in the future (Cubit logic)',
    build: () {
      return EventDetailCubit(
        eventRepository: eventRepository,
        userRepository: userRepository,
        event: fullEvent,
      );
    },
    act: (c) => c.start(),
    expect: () => [
      isA<EventDetailState>().having((s) => s.loading, 'loading', true),
      isA<EventDetailState>()
          .having((s) => s.loading, 'loading', false)
          .having((s) => s.isJoinEnabled, 'isJoinEnabled', true),
    ],
  );

  blocTest<EventDetailCubit, EventDetailState>(
    'leave event flow still works when event is full and user has joined (Capacity logic)',
    build: () {
      when(() => userRepository.getUser()).thenAnswer((_) async => testUser);
      when(() => eventRepository.leaveEvent(any())).thenAnswer((_) async {});
      return EventDetailCubit(
        eventRepository: eventRepository,
        userRepository: userRepository,
        event: fullJoinedEvent,
      );
    },
    act: (c) async {
      final effectFuture = c.effects.firstWhere((e) => e is ShowLeaveSuccessEffect);
      await c.start();
      await c.primaryPressed();
      await effectFuture;
    },
    expect: () => [
      isA<EventDetailState>().having((s) => s.loading, 'loading', true),
      isA<EventDetailState>().having((s) => s.loading, 'loading', false).having((s) => s.isAuthenticated, 'isAuthenticated', true),
      isA<EventDetailState>().having((s) => s.joinLeaving, 'joinLeaving', true),
      isA<EventDetailState>()
          .having((s) => s.joinLeaving, 'joinLeaving', false)
          .having((s) => s.uiModel.userJoined, 'joined', false)
          .having((s) => s.uiModel.currentAttendeeCount, 'currentAttendeeCount', 9),
    ],
    verify: (c) {
      verify(() => eventRepository.leaveEvent(any())).called(1);
    },
  );
}