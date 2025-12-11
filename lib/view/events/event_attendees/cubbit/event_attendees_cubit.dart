import 'package:esmorga_flutter/domain/event/model/event_attendees.dart';
import 'package:esmorga_flutter/domain/user/model/role_type.dart';
import 'package:esmorga_flutter/domain/user/model/user.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/events/event_attendees/mapper/event_attendees_ui_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'event_attendees_state.dart';

class EventAttendeesCubit extends Cubit<EventAttendeesState> {
  final EventRepository eventRepository;
  final UserRepository userRepository;

  EventAttendeesCubit( {
    required this.eventRepository,
    required this.userRepository
  }) : super(const EventAttendeesState());

  Future<void> loadAttendees(String eventId) async { 
    emit(EventAttendeesState.loading());
    try {
      final results = await Future.wait([
        userRepository.getUser(), 
        eventRepository.getEventAttendees(eventId), 
        eventRepository.getLocallyStoredPaidStatus(eventId), 
      ]);
      
      final user = results[0] as User; 
      final attendees = results[1] as EventAttendees; 
      final localPaidStatuses = results[2] as Map<String, bool>;

      final bool isAdmin = user.role == RoleType.admin;
      if (attendees.totalUsers > 0) {
        
        final updatedUsers = attendees.users.map((user) {
            final isPaidLocally = localPaidStatuses[user.name] ?? user.isPaid; 
            return user.copyWith(isPaid: isPaidLocally);
        }).toList();

        final updatedAttendees = attendees.copyWith(users: updatedUsers); 

        final uiModel = EventAttendeesUiMapper.map(updatedAttendees, isAdmin); 
        emit(EventAttendeesState.success(uiModel));
        
      } else {
        emit(EventAttendeesState.empty());
      }
    } catch (e) {
      emit(EventAttendeesState.error(e.toString()));
    }
  }
  
  void togglePaidStatus(String name, String eventId) async {
      final currentAttendees = state.attendees;
      if (currentAttendees != null && currentAttendees.isAdmin) {
        final updatedUsers = currentAttendees.users.map((user) {
        if (user.name == name) {
          return user.copyWith(isPaid: !user.isPaid);
        }
        return user;
        }).toList();

        final updatedUiModel = currentAttendees.copyWith(users: updatedUsers);
        emit(EventAttendeesState.success(updatedUiModel));
        
        final newPaid = updatedUsers.firstWhere((u) => u.name == name).isPaid;
        await eventRepository.updatePaidStatus(eventId, name, newPaid);
    }
  }
}