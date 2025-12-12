import 'package:esmorga_flutter/domain/event/attendees/usecase/get_event_attendees_use_case.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/events/event_attendees/mapper/event_attendees_ui_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'event_attendees_state.dart';

class EventAttendeesCubit extends Cubit<EventAttendeesState> {
  final EventRepository eventRepository;
  final UserRepository userRepository;
  final GetEventAttendeesUseCase _getEventAttendeesUseCase;

  EventAttendeesCubit({required GetEventAttendeesUseCase getEventAttendeesUseCase,
    required this.eventRepository,
    required this.userRepository,
  })  : _getEventAttendeesUseCase = getEventAttendeesUseCase,
        super(EventAttendeesState());
      
  Future<void> loadAttendees(String eventId) async {
    emit(EventAttendeesState.loading());
    try {
      final (combinedAttendees, isAdmin) = 
          await _getEventAttendeesUseCase.execute(eventId);

      if (combinedAttendees.isNotEmpty) {
        
        final uiModel = EventAttendeesUiMapper.map(combinedAttendees, isAdmin);
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
        
        final isPaidStatus = updatedUsers.firstWhere((u) => u.name == name).isPaid;
        await eventRepository.updatePaidStatus(eventId, name, isPaidStatus);
    }
  }
}