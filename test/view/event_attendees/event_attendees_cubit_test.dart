import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/datasource_remote/event/event_attendees_remote_model.dart';
import 'package:esmorga_flutter/view/events/event_attendees/cubbit/event_attendees_cubit.dart';
import 'package:esmorga_flutter/view/events/event_attendees/cubbit/event_attendees_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event_attendees.dart';

class _MockEventRepository extends Mock implements EventRepository {}

void main() {
  late _MockEventRepository repository;
  const testEventId = 'test_1';

  final attendees5 = EventAttendees(
    totalUsers: 5,
    users: [
      EventAttendeeRemoteModel(name: "Pepe"),
      EventAttendeeRemoteModel(name: "Ana"),
      EventAttendeeRemoteModel(name: "Luis"),
      EventAttendeeRemoteModel(name: "Sara"),
      EventAttendeeRemoteModel(name: "Juan"),
],

  );

  final attendees0 = EventAttendees(
    totalUsers: 0,
    users: const [],
  );

  setUp(() {
    repository = _MockEventRepository();
  });


  blocTest<EventAttendeesCubit, EventAttendeesState>(
    'Emits [loading, success] when there are attendants',
    build: () {
      when(() => repository.getEventAttendees(testEventId))
          .thenAnswer((_) async => attendees5);
      return EventAttendeesCubit(repository);
    },
    act: (cubit) => cubit.loadAttendees(testEventId),
    expect: () => [
      predicate<EventAttendeesState>((s) =>
          s.loading == true &&
          s.attendees == null &&
          s.error == null),

      predicate<EventAttendeesState>((s) =>
          s.loading == false &&
          s.attendees!.users.length == 5 &&
          s.error == null),
    ],
  );


  blocTest<EventAttendeesCubit, EventAttendeesState>(
    'Emits [loading, empty] when there are not attendants',
    build: () {
      when(() => repository.getEventAttendees(testEventId))
          .thenAnswer((_) async => attendees0);
      return EventAttendeesCubit(repository);
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
      when(() => repository.getEventAttendees(testEventId))
          .thenThrow(Exception('Network error'));
      return EventAttendeesCubit(repository);
    },
    act: (cubit) => cubit.loadAttendees(testEventId),
    expect: () => [
      predicate<EventAttendeesState>((s) => s.loading == true),
      predicate<EventAttendeesState>((s) =>
          s.loading == false &&
          s.error!.contains('Network error')),
    ],
    verify: (_) {
      verify(() => repository.getEventAttendees(testEventId)).called(1);
    },
  );
}