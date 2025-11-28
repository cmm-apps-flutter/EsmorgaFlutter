import 'package:esmorga_flutter/datasource_remote/event/event_attendees_remote_model.dart';

class EventAttendees {
  final int totalUsers;
  final List<EventAttendeeRemoteModel> users;

  EventAttendees({required this.totalUsers, required this.users});

  factory EventAttendees.fromJson(Map<String, dynamic> json) {
    final attendeesJson = (json['users'] as List<dynamic>?) ?? [];
    final attendees = attendeesJson
        .map((e) => EventAttendeeRemoteModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return EventAttendees(
      totalUsers: attendees.length,
      users: attendees,
    );
  }
}