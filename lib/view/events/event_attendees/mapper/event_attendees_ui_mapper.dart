import 'package:esmorga_flutter/domain/event/model/event_attendees.dart';
import 'package:esmorga_flutter/view/events/event_attendees/mapper/event_attendee_ui_model.dart';

class EventAttendeesUiModel {
  final List<EventAttendeeUiModel> users; 
  final bool hasAttendees;
  final bool isAdmin; 

  EventAttendeesUiModel({
    required this.users,
    this.isAdmin = false
    })
      : hasAttendees = users.isNotEmpty;

  EventAttendeesUiModel copyWith({
    List<EventAttendeeUiModel>? users,
    bool? isAdmin,
  }) {
    return EventAttendeesUiModel(
      users: users ?? this.users,
      isAdmin: isAdmin ?? this.isAdmin, 
    );
  }
}
class EventAttendeesUiMapper {
  static EventAttendeesUiModel map(EventAttendees attendees, bool isAdmin) { 
    return EventAttendeesUiModel(
      users: attendees.users.map((e) => EventAttendeeUiModel(
        name: e.name,
        isPaid: e.isPaid,
      )).toList(),
      isAdmin: isAdmin, 
    );
  }
}