import 'package:esmorga_flutter/domain/event/model/event_attendee_domain_model.dart';

class EventAttendees {
  final int totalUsers;
  final List<EventAttendeeDomainModel> users; 

  EventAttendees({required this.totalUsers, required this.users});
  
  EventAttendees copyWith({
    int? totalUsers,
    List<EventAttendeeDomainModel>? users, 
  }) {
    return EventAttendees(
      totalUsers: totalUsers ?? this.totalUsers, 
      users: users ?? this.users, 
    );
  }
}