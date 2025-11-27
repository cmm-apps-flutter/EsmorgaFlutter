import 'package:esmorga_flutter/domain/event/model/event_attendees.dart';

class EventAttendeesUiModel {
  final int totalUsers;
  final List<String> users;
  final bool hasAttendees;

  EventAttendeesUiModel({
    required this.totalUsers,
    required this.users,
  }) : hasAttendees = totalUsers > 0;
}
class EventAttendeesUiMapper {
  static EventAttendeesUiModel map(EventAttendees attendees) {
    return EventAttendeesUiModel(
      totalUsers: attendees.totalUsers,
      users: attendees.users,
    );
  }
}