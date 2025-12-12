import 'package:bloc_test/bloc_test.dart';
// ❌ ELIMINAR: Ya no es el modelo que fluye
// import 'package:esmorga_flutter/datasource_remote/event/event_attendees_remote_model.dart'; 
// ❌ ELIMINAR: Ya no es el modelo que fluye
// import 'package:esmorga_flutter/domain/event/model/event_attendees.dart'; 
import 'package:esmorga_flutter/domain/event/attendees/usecase/get_event_attendees_use_case.dart'; // ✅ AÑADIR
import 'package:esmorga_flutter/domain/event/model/event_attendee_domain_model.dart'; // ✅ AÑADIR
import 'package:esmorga_flutter/domain/user/model/role_type.dart';
import 'package:esmorga_flutter/domain/user/model/user.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/events/event_attendees/cubbit/event_attendees_cubit.dart';
import 'package:esmorga_flutter/view/events/event_attendees/cubbit/event_attendees_state.dart';
import 'package:esmorga_flutter/view/events/event_attendees/mapper/event_attendees_ui_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';

class _MockEventRepository extends Mock implements EventRepository {}
class _MockUserRepository extends Mock implements UserRepository {}
class _MockGetEventAttendeesUseCase extends Mock implements GetEventAttendeesUseCase {}

const testEventId = 'test_1';
final adminUser = User(name: "admin", lastName: "admin", email: "admin@admin.com", role: RoleType.admin);
final normalUser = User(name: "user",lastName: "user", email: "user@user.com", role: RoleType.user);

final attendeeListBase = [
  EventAttendeeDomainModel(name: "Pepe", isPaid: false),
  EventAttendeeDomainModel(name: "Ana", isPaid: false),
  EventAttendeeDomainModel(name: "Luis", isPaid: true), 
];

final attendees5Domain = [
    EventAttendeeDomainModel(name: "Pepe", isPaid: false),
    EventAttendeeDomainModel(name: "Ana", isPaid: false),
    EventAttendeeDomainModel(name: "Luis", isPaid: true),
    EventAttendeeDomainModel(name: "Sara", isPaid: false),
    EventAttendeeDomainModel(name: "Juan", isPaid: true),
  ];

void main() {
  late _MockEventRepository eventRepository;
  late _MockUserRepository userRepository;
  late _MockGetEventAttendeesUseCase getEventAttendeesUseCase;

  setUp(() {
    eventRepository = _MockEventRepository();
    userRepository = _MockUserRepository();
    getEventAttendeesUseCase = _MockGetEventAttendeesUseCase();
    
    when(() => userRepository.getUser()).thenAnswer((_) async => normalUser);
    
    when(() => eventRepository.getPaidStatus(any())).thenAnswer((_) async => {});
    when(() => eventRepository.updatePaidStatus(any(), any(), any())).thenAnswer((_) async => Future.value());
  });

  EventAttendeesCubit buildCubit() {
    return EventAttendeesCubit(
      getEventAttendeesUseCase: getEventAttendeesUseCase,
      eventRepository: eventRepository,
      userRepository: userRepository,   
    );
  }

  group('loadAttendees', () {
    
    blocTest<EventAttendeesCubit, EventAttendeesState>(
      'Emits [loading, success] when there are attendants',
      build: () {
        when(() => getEventAttendeesUseCase.execute(testEventId))
            .thenAnswer((_) async => (attendees5Domain, false));
        
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
        when(() => getEventAttendeesUseCase.execute(testEventId))
          .thenAnswer((_) async => (<EventAttendeeDomainModel>[], false));        
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
        when(() => getEventAttendeesUseCase.execute(testEventId))
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
        verify(() => getEventAttendeesUseCase.execute(testEventId)).called(1);
      },
    );
  });

  group('togglePaidStatus', () {
    final initialUiModel = EventAttendeesUiMapper.map(attendeeListBase, true); 
    
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
        final userUiModel = EventAttendeesUiMapper.map(attendeeListBase, false); 
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