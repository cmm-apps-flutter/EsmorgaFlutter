import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/view/events/event_list/cubit/event_cubit.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/event/model/event_location.dart';
import 'package:esmorga_flutter/domain/event/model/event_type.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/view/events/event_list/cubit/event_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockEventRepository extends Mock implements EventRepository {}

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
  late EventCubit cubit;

  final testEvent = Event(
    id: '1',
    name: 'Name',
    date: 0,
    description: 'desc',
    type: EventType.party,
    imageUrl: 'https://image',
    location: const EventLocation(name: 'Loc'),
    tags: const [],
    userJoined: false,
  );

  setUp(() {
    eventRepository = _MockEventRepository();
    if (!getIt.isRegistered<EsmorgaDateTimeFormatter>()) {
      getIt.registerSingleton<EsmorgaDateTimeFormatter>(_FakeFormatter());
    }
    cubit = EventCubit(eventRepository: eventRepository);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('EventCubit (view/events)', () {
    blocTest<EventCubit, EventState>(
      'loads events successfully',
      build: () {
        when(() => eventRepository.getEvents())
            .thenAnswer((_) async => [testEvent]);
        return cubit;
      },
      act: (c) => c.loadEvents(),
      expect: () => [
        const EventState(loading: true),
        isA<EventState>().having((s) => s.eventList.length, 'count', 1)
      ],
      verify: (_) => verify(() => eventRepository.getEvents()).called(1),
    );
  });
}
