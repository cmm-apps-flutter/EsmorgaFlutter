import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_effect.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_state.dart';
import 'package:esmorga_flutter/view/events/event_detail/model/event_detail_ui_model.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  final EventRepository eventRepository;
  final UserRepository userRepository;
  final Event event;

  final _effectController = StreamController<EventDetailEffect>.broadcast();
  Stream<EventDetailEffect> get effects => _effectController.stream;

  EventDetailCubit({required this.eventRepository, required this.userRepository, required this.event}) : super(EventDetailState(event: event.toEventDetailUiModel()));

  Future<void> start() async {
    emit(state.copyWith(loading: true, error: null));
    bool isAuth = false;
    try {
      try {
        await userRepository.getUser();
        isAuth = true;
      } catch (_) {
        isAuth = false;
      }
      emit(state.copyWith(loading: false, event: event.toEventDetailUiModel(), isAuthenticated: isAuth));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> primaryPressed() async {
  final current = state.event;
  if (current == null) return;

  if (!state.isAuthenticated) {
    _emitEffect(NavigateToLoginEffect());
    return;
  }

  emit(state.copyWith(joinLeaving: true));

  try {
    if (current.userJoined) {
      await eventRepository.leaveEvent(event);
      final updated = event.copyWith(
        userJoined: false,
        currentAttendeeCount: (event.currentAttendeeCount - 1).clamp(0, event.maxCapacity ?? 9999),
      );
      emit(state.copyWith(event: updated.toEventDetailUiModel(), joinLeaving: false));
      _emitEffect(ShowLeaveSuccessEffect());
    } else {
      await eventRepository.joinEvent(event);
      final updated = event.copyWith(
        userJoined: true,
        currentAttendeeCount: (event.currentAttendeeCount + 1),
      );
      emit(state.copyWith(event: updated.toEventDetailUiModel(), joinLeaving: false));
      _emitEffect(ShowJoinSuccessEffect());
    }
  } catch (e) {
    final msg = e.toString();
    if (msg.contains('422')) {
      _emitEffect(ShowEventFullSnackbarEffect());
    } else if (msg.contains('network') || msg.contains('connection')) {
      _emitEffect(ShowNoNetworkEffect());
    } else {
      _emitEffect(ShowGenericErrorEffect());
    }
    emit(state.copyWith(joinLeaving: false));
  }
}


  void navigatePressed() {
    if (event.location.lat != null && event.location.long != null) {
      _emitEffect(OpenMapsEffect(lat: event.location.lat!, lng: event.location.long!, name: event.location.name));
    }
  }

  void backPressed() => _emitEffect(NavigateBackEffect());

  void _emitEffect(EventDetailEffect effect) => _effectController.add(effect);

  @override
  Future<void> close() {
    _effectController.close();
    return super.close();
  }
}
