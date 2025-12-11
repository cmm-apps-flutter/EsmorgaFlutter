import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/datasource_remote/event/event_attendees_remote_model.dart';
import 'package:esmorga_flutter/domain/user/model/role_type.dart';
import 'package:esmorga_flutter/domain/user/model/user.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/events/event_attendees/cubbit/event_attendees_cubit.dart';
import 'package:esmorga_flutter/view/events/event_attendees/cubbit/event_attendees_state.dart';
import 'package:esmorga_flutter/view/events/event_attendees/mapper/event_attendees_ui_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event_attendees.dart';

class _MockEventRepository extends Mock implements EventRepository {}
class _MockUserRepository extends Mock implements UserRepository {}

const testEventId = 'test_1';
final adminUser = User(name: "admin", lastName: "admin", email: "admin@admin.com", role: RoleType.admin);
final normalUser = User(name: "user",lastName: "user", email: "user@user.com", role: RoleType.user);

final attendeeListBase = [
  EventAttendeeRemoteModel(name: "Pepe", isPaid: false),
  EventAttendeeRemoteModel(name: "Ana", isPaid: false),
  EventAttendeeRemoteModel(name: "Luis", isPaid: true), 
];

final attendees3 = EventAttendees(
  totalUsers: 3,
  users: attendeeListBase,
);

final attendees5 = EventAttendees(
  totalUsers: 5,
  users: [
    EventAttendeeRemoteModel(name: "Pepe", isPaid: false),
    EventAttendeeRemoteModel(name: "Ana", isPaid: false),
    EventAttendeeRemoteModel(name: "Luis", isPaid: true),
    EventAttendeeRemoteModel(name: "Sara", isPaid: false),
    EventAttendeeRemoteModel(name: "Juan", isPaid: true),
  ],
);

final attendees0 = EventAttendees(
  totalUsers: 0,
  users: const [],
);

void main() {
  late _MockEventRepository eventRepository;
  late _MockUserRepository userRepository;

  setUp(() {
    eventRepository = _MockEventRepository();
    userRepository = _MockUserRepository();
    
    when(() => userRepository.getUser()).thenAnswer((_) async => normalUser);
    when(() => eventRepository.getLocallyStoredPaidStatus(any())).thenAnswer((_) async => {});
    when(() => eventRepository.updatePaidStatus(any(), any(), any())).thenAnswer((_) async => Future.value());
  });

  EventAttendeesCubit buildCubit() {
  return EventAttendeesCubit(
    eventRepository: eventRepository,
    userRepository: userRepository,   
  );
}

  group('loadAttendees', () {
    
    blocTest<EventAttendeesCubit, EventAttendeesState>(
      'Emits [loading, success] when there are attendants',
      build: () {
        when(() => eventRepository.getEventAttendees(testEventId))
            .thenAnswer((_) async => attendees5);
        
        return buildCubit();
      },
      act: (cubit) => cubit.loadAttendees(testEventId),
      expect: () => [
        predicate<EventAttendeesState>((s) => s.loading == true),
        predicate<EventAttendeesState>((s) =>
            s.loading == false &&
            s.attendees!.users.length == 5 &&
            s.error == null),
      ],
    );

    blocTest<EventAttendeesCubit, EventAttendeesState>(
      'Emits [loading, empty] when there are not attendants',
      build: () {
        when(() => eventRepository.getEventAttendees(testEventId))
            .thenAnswer((_) async => attendees0);
        
        return buildCubit();
      },
      act: (cubit) => cubit.loadAttendees(testEventId),
      expect: () => [
        predicate<EventAttendeesState>((s) => s.loading == true),
        predicate<EventAttendeesState>((s) =>
            s.loading == false &&
            s.attendees == null &&
            s.error == null),
      ],
    );

    blocTest<EventAttendeesCubit, EventAttendeesState>(
      'Emits [loading, error] when the repo fails',
      build: () {
        when(() => eventRepository.getEventAttendees(testEventId))
            .thenThrow(Exception('Network error'));
            
        return buildCubit();
      },
      act: (cubit) => cubit.loadAttendees(testEventId),
      expect: () => [
        predicate<EventAttendeesState>((s) => s.loading == true),
        predicate<EventAttendeesState>((s) =>
            s.loading == false &&
            s.error!.contains('Network error')),
      ],
      verify: (_) {
        verify(() => eventRepository.getEventAttendees(testEventId)).called(1);
      },
    );
    
    test('Combines remote and local paid statuses correctly', () async {
      when(() => userRepository.getUser()).thenAnswer((_) async => adminUser);
      when(() => eventRepository.getEventAttendees(testEventId)).thenAnswer((_) async => attendees3);

      when(() => eventRepository.getLocallyStoredPaidStatus(testEventId))
          .thenAnswer((_) async => {'Ana': true, 'Pepe': false});
      
      final cubit = buildCubit();
      await cubit.loadAttendees(testEventId);

      final resultUsers = cubit.state.attendees!.users;
      
      expect(resultUsers.firstWhere((u) => u.name == 'Luis').isPaid, isTrue, reason: 'Remote paid status should be preserved');
      expect(resultUsers.firstWhere((u) => u.name == 'Ana').isPaid, isTrue, reason: 'Local paid status should be merged');
      expect(resultUsers.firstWhere((u) => u.name == 'Pepe').isPaid, isFalse, reason: 'Default status should be false');
    });
  });

  group('togglePaidStatus', () {
    final initialUiModel = EventAttendeesUiMapper.map(attendees3, true); 
    
    blocTest<EventAttendeesCubit, EventAttendeesState>(
      'Admin: Toggles status from FALSE to TRUE and persists the change',
      build: buildCubit,
      seed: () => EventAttendeesState.success(initialUiModel),
      act: (cubit) => cubit.togglePaidStatus('Pepe', testEventId),
      expect: () => [
        predicate<EventAttendeesState>((s) =>
            s.attendees!.users.firstWhere((u) => u.name == 'Pepe').isPaid == true),
      ],
      verify: (_) {
        verify(() => eventRepository.updatePaidStatus(testEventId, 'Pepe', true)).called(1);
      },
    );

    blocTest<EventAttendeesCubit, EventAttendeesState>(
      'Normal User: Does NOT toggle status',
      build: buildCubit,
      seed: () {
        final userUiModel = EventAttendeesUiMapper.map(attendees3, false); 
        return EventAttendeesState.success(userUiModel);
      },
      act: (cubit) => cubit.togglePaidStatus('Pepe', testEventId),
      expect: () => [], 
      verify: (_) {
        verifyNever(() => eventRepository.updatePaidStatus(any(), any(), any()));
      },
    );
  });
}