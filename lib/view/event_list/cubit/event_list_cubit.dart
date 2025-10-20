import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/view/events/event_list/mapper/event_list_ui_mapper.dart';
import 'package:esmorga_flutter/view/events/event_list/model/event_list_ui_model.dart';

// Removed events part as we now use imperative API
// part 'event_list_event.dart';
part 'event_list_state.dart';

class EventListCubit extends Cubit<EventListState> {
  final EventRepository eventRepository;
  EventListCubit({required this.eventRepository}) : super(const EventListInitial());

  Future<void> load() async => _load();
  Future<void> retry() async => _load();

  Future<void> _load() async {
    emit(const EventListLoading());
    try {
      final events = await eventRepository.getEvents();
      if (events.isEmpty) {
        emit(const EventListEmpty());
      } else {
        emit(EventListLoadSuccess(events.toEventUiList()));
      }
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('network') || msg.contains('connection')) {
        emit(const EventListShowNoNetwork());
      }
      emit(EventListLoadFailure(msg));
    }
  }
}
