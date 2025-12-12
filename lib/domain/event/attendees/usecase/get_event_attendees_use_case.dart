import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event_attendees.dart';
import 'package:esmorga_flutter/domain/user/model/role_type.dart';
import 'package:esmorga_flutter/domain/user/model/user.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event_attendee_domain_model.dart'; 

class GetEventAttendeesUseCase {
  final EventRepository _eventRepository;
  final UserRepository _userRepository;

  GetEventAttendeesUseCase(this._eventRepository, this._userRepository);

  Future<(List<EventAttendeeDomainModel>, bool)> execute(String eventId) async {
    final results = await Future.wait([
      _userRepository.getUser(), 
      _eventRepository.getEventAttendees(eventId), 
      _eventRepository.getPaidStatus(eventId), 
    ]);
    
    final user = results[0] as User; 
    final attendees = results[1] as EventAttendees; 
    final localPaidStatuses = results[2] as Map<String, bool>;
    
    final bool isAdmin = user.role == RoleType.admin;

    if (attendees.totalUsers == 0) {
      return (<EventAttendeeDomainModel>[], isAdmin);
    }
    
    final List<EventAttendeeDomainModel> attendeesToCombine = attendees.users.map((remoteModel) {
        return EventAttendeeDomainModel(
            name: remoteModel.name,
            isPaid: false,
        );
    }).toList();

    final List<EventAttendeeDomainModel> combinedAttendees = attendeesToCombine.map((domainModel) {
        final isPaidLocally = localPaidStatuses[domainModel.name] ?? domainModel.isPaid; 
        
        return domainModel.copyWith(isPaid: isPaidLocally);
    }).toList();

    return (combinedAttendees, isAdmin);
  }
}