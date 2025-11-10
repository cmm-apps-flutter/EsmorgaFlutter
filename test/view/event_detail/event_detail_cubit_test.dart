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
  String formatEventDate(int epochMillis) => 'date';

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

  group('EventDetailCubit', () {
    blocTest<EventDetailCubit, EventDetailState>(
      'loads event and sets isAuthenticated true when getUser succeeds',
      build: () {
        when(() => userRepository.getUser()).thenAnswer((_) async => testUser);
        return EventDetailCubit(eventRepository: eventRepository, userRepository: userRepository, event: baseEvent);
      },
      act: (c) => c.start(),
      expect: () => [
        isA<EventDetailState>().having((s) => s.loading, 'loading', true),
        isA<EventDetailState>().having((s) => s.loading, 'loading', false),
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
        isA<EventDetailState>().having((s) => s.uiModel.userJoined, 'joined', false),
        isA<EventDetailState>().having((s) => s.joinLeaving, 'joinLeaving', true),
        isA<EventDetailState>()
            .having((s) => s.joinLeaving, 'joinLeaving', false)
            .having((s) => s.uiModel.userJoined, 'joined', true),
      ],
    );;

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

    final fullEvent = baseEvent.copyWith(
      currentAttendeeCount: 10,
      maxCapacity: 10,
    );

    blocTest<EventDetailCubit, EventDetailState>(
      'when the event is full, the uiModel reflects full capacity',
      build: () {
        when(() => userRepository.getUser()).thenAnswer((_) async => testUser);
        return EventDetailCubit(
          eventRepository: eventRepository,
          userRepository: userRepository,
          event: fullEvent,
        );
      },
      act: (cubit) => cubit.start(),
      expect: () => [
        isA<EventDetailState>().having((s) => s.loading, 'loading', true),
        isA<EventDetailState>()
            .having((s) => s.loading, 'loading', false)
            .having(
              (s) => s.uiModel.currentAttendeeCount >= (s.uiModel.maxCapacity!),
              'isFull',
              true,
            ),
      ],
    );
  });
}
