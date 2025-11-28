import 'package:esmorga_flutter/domain/event/model/event_attendees.dart';

class EventAttendeesUiModel {
  final List<String> users;
  final bool hasAttendees;

  EventAttendeesUiModel({
    required this.users,
  }) : hasAttendees = users.isNotEmpty;
}
class EventAttendeesUiMapper {
  static EventAttendeesUiModel map(EventAttendees attendees) {
    return EventAttendeesUiModel(
      users: attendees.users.map((e) => e.name).toList(),
    );
  }
}