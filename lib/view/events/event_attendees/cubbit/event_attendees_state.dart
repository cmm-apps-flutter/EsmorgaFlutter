import 'package:esmorga_flutter/view/events/event_attendees/mapper/event_attendees_ui_mapper.dart';

class EventAttendeesState {
  final bool loading;
  final EventAttendeesUiModel? attendees;
  final String? error;

  const EventAttendeesState({
    this.loading = false,
    this.attendees,
    this.error,
  });

  factory EventAttendeesState.loading() => const EventAttendeesState(loading: true);

  factory EventAttendeesState.success(EventAttendeesUiModel attendees) =>
      EventAttendeesState(attendees: attendees);

  factory EventAttendeesState.empty() =>
      const EventAttendeesState(attendees: null);

  factory EventAttendeesState.error(String message) =>
      EventAttendeesState(error: message);
}
