import 'package:esmorga_flutter/datasource_remote/event/event_attendees_remote_model.dart';

class EventAttendees {
  final int totalUsers;
  final List<EventAttendeeRemoteModel> users;

  EventAttendees({required this.totalUsers, required this.users});
}