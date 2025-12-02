import 'package:esmorga_flutter/view/events/event_attendees/mapper/event_attendees_ui_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'event_attendees_state.dart';

class EventAttendeesCubit extends Cubit<EventAttendeesState> {
  final EventRepository repository;

  EventAttendeesCubit(this.repository) : super(const EventAttendeesState());

  Future<void> loadAttendees(String eventId) async {
    emit(EventAttendeesState.loading());
    try {
      final attendees = await repository.getEventAttendees(eventId);

      if (attendees.totalUsers > 0) {
        final uiModel = EventAttendeesUiMapper.map(attendees);
        emit(EventAttendeesState.success(uiModel));
      } else {
        emit(EventAttendeesState.empty());
      }
    } catch (e) {
      emit(EventAttendeesState.error(e.toString()));
    }
  }
}