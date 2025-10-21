import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/event/model/event_location.dart';
import 'package:esmorga_flutter/domain/event/model/event_type.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/events/event_list/cubit/event_list_cubit.dart';
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
    'emits [loading true, then success with one item] when repository returns non-empty list',
    build: () {
      when(() => repository.getEvents()).thenAnswer((_) async => [event]);
      return EventListCubit(eventRepository: repository);
    },
    act: (cubit) => cubit.loadEvents(),
    expect: () => [
      isA<EventListState>().having((s) => s.loading, 'loading', true),
      isA<EventListState>().having((s) => s.loading, 'loading', false).having((s) => s.eventList.length, 'event count', 1).having((s) => s.error, 'error', null),
    ],
  );

  blocTest<EventListCubit, EventListState>(
    'emits [loading true, then empty list] when repository returns empty list',
    build: () {
      when(() => repository.getEvents()).thenAnswer((_) async => []);
      return EventListCubit(eventRepository: repository);
    },
    act: (cubit) => cubit.loadEvents(),
    expect: () => [
      isA<EventListState>().having((s) => s.loading, 'loading', true),
      isA<EventListState>().having((s) => s.loading, 'loading', false).having((s) => s.eventList.length, 'event count', 0).having((s) => s.error, 'error', null),
    ],
  );

  blocTest<EventListCubit, EventListState>(
    'emits [loading true, then error + showNoNetworkPrompt] when repository throws network error',
    build: () {
      when(() => repository.getEvents()).thenThrow(Exception('network error'));
      return EventListCubit(eventRepository: repository);
    },
    act: (cubit) => cubit.loadEvents(),
    expect: () => [
      isA<EventListState>().having((s) => s.loading, 'loading', true),
      isA<EventListState>().having((s) => s.loading, 'loading', false).having((s) => s.error, 'error', contains('network error')).having((s) => s.showNoNetworkPrompt, 'showNoNetworkPrompt', true),
    ],
  );

  blocTest<EventListCubit, EventListState>(
    'emits [loading true, then error] when repository throws generic error',
    build: () {
      when(() => repository.getEvents()).thenThrow(Exception('boom'));
      return EventListCubit(eventRepository: repository);
    },
    act: (cubit) => cubit.loadEvents(),
    expect: () => [
      isA<EventListState>().having((s) => s.loading, 'loading', true),
      isA<EventListState>().having((s) => s.loading, 'loading', false).having((s) => s.error, 'error', contains('boom')),
    ],
  );
}
