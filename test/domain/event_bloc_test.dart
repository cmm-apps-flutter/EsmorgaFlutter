import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/datasource_remote/event/event_remote_model.dart';
import 'package:esmorga_flutter/domain/event/event_bloc.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventRepository extends Mock implements EventRepository {}

void main() {
  late EventRepository eventRepository;
  late EventBloc eventBloc;
  const event = EventRemoteModel(
    remoteId: "1",
    remoteName: "name",
    remoteDescription: "description",
    remoteDate: "date",
    remoteLocation: EventLocationRemoteModel(remoteLocationName: "name"),
    remoteImageUrl: "image",
  );
  setUp(() {
    eventRepository = MockEventRepository();
    eventBloc = EventBloc(eventRepository: eventRepository);
  });

  tearDown(() {
    eventBloc.close();
  });

  blocTest<EventBloc, EventState>(
    'emits [EventLoadingState, EventLoadSuccessState] when EventLoadEvent is added and getEvents succeeds',
    build: () {
      when(() => eventRepository.getEvents()).thenAnswer((_) async => [event]);
      return eventBloc;
    },
    act: (bloc) => bloc.add(EventLoadEvent()),
    expect: () => [
      isA<EventLoadingState>(),
      const EventLoadSuccessState([event]),
    ],
  );

  blocTest<EventBloc, EventState>(
    'emits [EventLoadingState, EventLoadFailureState] when EventLoadEvent is added and getEvents fails',
    build: () {
      when(() => eventRepository.getEvents()).thenThrow(Exception('error'));
      return eventBloc;
    },
    act: (bloc) => bloc.add(EventLoadEvent()),
    expect: () => [
      isA<EventLoadingState>(),
      const EventLoadFailureState('Exception: error'),
    ],
  );

  blocTest<EventBloc, EventState>(
    'emits [EventLoadingState, EventLoadFailureState] when EventLoadEvent is added and getEvents fails',
    build: () {
      when(() => eventRepository.getEvents()).thenThrow(Exception('error'));
      return eventBloc;
    },
    act: (bloc) => bloc.add(EventLoadEvent()),
    expect: () => [
      isA<EventLoadingState>(),
      isA<EventLoadFailureState>(),
    ],
  );
}
