import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/event/model/event_location.dart';
import 'package:esmorga_flutter/domain/event/model/event_type.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/event_list/cubit/event_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventRepository extends Mock implements EventRepository {}

class FakeFormatter implements EsmorgaDateTimeFormatter {
  @override
  String formatEventDate(int epochMillis) => 'formattedDate';
  @override
  String formatIsoDateTime(DateTime date, String time) => 'iso';
  @override
  String formatTimeWithMillisUtcSuffix(int hour, int minute) => 'timeZ';
}

final event = Event(
  id: '1',
  name: 'Event 1',
  date: DateTime(2025, 1, 1).millisecondsSinceEpoch,
  description: 'desc',
  type: EventType.party,
  imageUrl: 'https://image',
  location: const EventLocation(name: 'Location'),
  tags: const [],
  userJoined: false,
);

void main() {
  late MockEventRepository repository;

  setUp(() {
    repository = MockEventRepository();
    if (!getIt.isRegistered<EsmorgaDateTimeFormatter>()) {
      getIt.registerSingleton<EsmorgaDateTimeFormatter>(FakeFormatter());
    }
  });

  tearDown(() async {
    // reset mocks
    reset(repository);
  });

  blocTest<EventListCubit, EventListState>(
    'emits [Loading, Success] when repository returns non-empty list',
    build: () {
      when(() => repository.getEvents()).thenAnswer((_) async => [event]);
      return EventListCubit(eventRepository: repository);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<EventListLoading>(),
      isA<EventListLoadSuccess>().having(
          (s) => (s as EventListLoadSuccess).events.length, 'event count', 1),
    ],
  );

  blocTest<EventListCubit, EventListState>(
    'emits [Loading, Empty] when repository returns empty list',
    build: () {
      when(() => repository.getEvents()).thenAnswer((_) async => []);
      return EventListCubit(eventRepository: repository);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<EventListLoading>(),
      isA<EventListEmpty>(),
    ],
  );

  blocTest<EventListCubit, EventListState>(
    'emits [Loading, ShowNoNetwork, Failure] when repository throws network error',
    build: () {
      when(() => repository.getEvents()).thenThrow(Exception('network error'));
      return EventListCubit(eventRepository: repository);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<EventListLoading>(),
      isA<EventListShowNoNetwork>(),
      isA<EventListLoadFailure>().having(
          (s) => (s as EventListLoadFailure).message,
          'message',
          contains('network error')),
    ],
  );

  blocTest<EventListCubit, EventListState>(
    'emits [Loading, Failure] when repository throws generic error',
    build: () {
      when(() => repository.getEvents()).thenThrow(Exception('boom'));
      return EventListCubit(eventRepository: repository);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<EventListLoading>(),
      isA<EventListLoadFailure>().having(
          (s) => (s as EventListLoadFailure).message,
          'message',
          contains('boom')),
    ],
  );
}
