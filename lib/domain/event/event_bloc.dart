import 'package:esmorga_flutter/datasource_remote/event/event_remote_model.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;

  EventBloc({required this.eventRepository}) : super(EventInitialState()) {
    on<EventLoadEvent>((event, emit) async {
      emit(EventLoadingState());
      try {
        final events = await eventRepository.getEvents();
        emit(EventLoadSuccessState(events));
      } catch (e) {
        emit(EventLoadFailureState(e.toString()));
      }
    });
  }
}
