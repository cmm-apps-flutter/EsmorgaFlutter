import 'package:esmorga_flutter/domain/event/model/event_attendee_domain_model.dart';
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
  static EventAttendeesUiModel map(
    List<EventAttendeeDomainModel> combinedAttendees,
    bool isAdmin
  ) { 
    return EventAttendeesUiModel(
      users: combinedAttendees.map((domainModel) => EventAttendeeUiModel(
        name: domainModel.name,
        isPaid: domainModel.isPaid, 
      )).toList(),
      isAdmin: isAdmin, 
    );
  }
}