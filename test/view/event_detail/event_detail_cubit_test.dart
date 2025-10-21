import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/event/model/event_location.dart';
import 'package:esmorga_flutter/domain/event/model/event_type.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_cubit.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:esmorga_flutter/domain/user/model/user.dart';
import 'package:esmorga_flutter/domain/user/model/role_type.dart';

class _MockEventRepository extends Mock implements EventRepository {}

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  late _MockEventRepository eventRepository;
  late _MockUserRepository userRepository;

  const testUser = User(
      name: 'John',
      lastName: 'Doe',
      email: 'john@doe.com',
      role: RoleType.user);

  final baseEvent = Event(
    id: 'e1',
    name: 'Event',
    date: 0,
    description: 'A description',
    type: EventType.party,
    location: const EventLocation(name: 'Loc', lat: 10.0, long: 20.0),
    userJoined: false,
    imageUrl: null,
    tags: const [],
  );

  setUpAll(() {
    // Needed for any<Event>() usage in mocktail stubs (joinEvent/leaveEvent)
    registerFallbackValue(baseEvent);
  });

  setUp(() {
    eventRepository = _MockEventRepository();
    userRepository = _MockUserRepository();
  });

  group('EventDetailCubit', () {
    blocTest<EventDetailCubit, EventDetailState>(
      'loads event and sets isAuthenticated true when getUser succeeds',
      build: () {
        when(() => userRepository.getUser()).thenAnswer((_) async => testUser);
        when(() => eventRepository.getEventDetails(any()))
            .thenAnswer((_) async => baseEvent);
        return EventDetailCubit(
            eventRepository: eventRepository,
            userRepository: userRepository,
            eventId: 'e1');
      },
      act: (c) => c.start(),
      expect: () => [
        isA<EventDetailState>().having((s) => s.loading, 'loading', true),
        isA<EventDetailState>()
            .having((s) => s.loading, 'loading', false)
            .having((s) => s.event, 'event', baseEvent)
            .having((s) => s.isAuthenticated, 'auth', true),
      ],
    );

    blocTest<EventDetailCubit, EventDetailState>(
      'join flow emits submitting, updated event userJoined true and success effect',
      build: () {
        when(() => userRepository.getUser()).thenAnswer((_) async => testUser);
        when(() => eventRepository.getEventDetails(any()))
            .thenAnswer((_) async => baseEvent);
        when(() => eventRepository.joinEvent(any())).thenAnswer((_) async {});
        return EventDetailCubit(
            eventRepository: eventRepository,
            userRepository: userRepository,
            eventId: 'e1');
      },
      act: (c) async {
        c.start();
        await Future<void>.delayed(const Duration(milliseconds: 5));
        c.primaryPressed();
      },
      skip: 0,
      expect: () => [
        // 1) initial loading
        isA<EventDetailState>().having((s) => s.loading, 'loading', true),
        // 2) loaded event (pre-join)
        isA<EventDetailState>()
            .having((s) => s.event?.userJoined, 'joined', false),
        // 3) join request in progress
        isA<EventDetailState>()
            .having((s) => s.joinLeaving, 'joinLeaving', true),
        // 4) joinLeaving finished, event updated, effect not yet emitted
        isA<EventDetailState>()
            .having((s) => s.joinLeaving, 'joinLeaving', false)
            .having((s) => s.event?.userJoined, 'joined', true)
            .having((s) => s.effectType, 'effectType', isNull),
        // 5) effect state emitted separately
        isA<EventDetailState>()
            .having((s) => s.joinLeaving, 'joinLeaving', false)
            .having((s) => s.event?.userJoined, 'joined', true)
            .having((s) => s.effectType, 'effectType',
                EventDetailEffectType.showJoinSuccess)
            .having((s) => s.effectId, 'effectId incremented', greaterThan(0)),
      ],
    );

    blocTest<EventDetailCubit, EventDetailState>(
      'navigate pressed emits openMaps effect when coords present',
      build: () {
        when(() => userRepository.getUser()).thenAnswer((_) async => testUser);
        when(() => eventRepository.getEventDetails(any()))
            .thenAnswer((_) async => baseEvent);
        return EventDetailCubit(
            eventRepository: eventRepository,
            userRepository: userRepository,
            eventId: 'e1');
      },
      act: (c) async {
        c.start();
        await Future<void>.delayed(const Duration(milliseconds: 5));
        c.navigatePressed();
      },
      expect: () => [
        isA<EventDetailState>().having((s) => s.loading, 'loading', true),
        isA<EventDetailState>()
            .having((s) => s.effectType, 'effectType', isNull),
        isA<EventDetailState>().having(
            (s) => s.effectType, 'effectType', EventDetailEffectType.openMaps),
      ],
    );
  });
}
