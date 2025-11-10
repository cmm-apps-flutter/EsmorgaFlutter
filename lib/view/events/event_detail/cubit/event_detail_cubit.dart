import 'dart:async';

import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_effect.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_state.dart';
import 'package:esmorga_flutter/view/events/event_detail/model/event_detail_ui_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  final EventRepository eventRepository;
  final UserRepository userRepository;

  final _effectController = StreamController<EventDetailEffect>.broadcast();
  Stream<EventDetailEffect> get effects => _effectController.stream;

  EventDetailCubit({required this.eventRepository, required this.userRepository, required Event event}) : super(
    EventDetailState(
      event: event,
      uiModel: event.toEventDetailUiModel(),
    ),
  );

  Future<void> start() async {
  emit(state.copyWith(loading: true, error: null));

  bool isAuth = false;
  try {
    await userRepository.getUser();
    isAuth = true;
  } catch (_) {
    isAuth = false;
  }

  emit(state.copyWith(
    loading: false,
    isAuthenticated: isAuth,
  ));
  }

  Future<void> primaryPressed() async {
    final currentEvent = state.uiModel.toDomain();

    if (!state.isAuthenticated) {
      _emitEffect(NavigateToLoginEffect());
      return;
    }

    emit(state.copyWith(joinLeaving: true));

    try {
      if (currentEvent.userJoined) {
        await eventRepository.leaveEvent(currentEvent);
        final updated = currentEvent.copyWith(
          userJoined: false,
          currentAttendeeCount: (currentEvent.currentAttendeeCount - 1).clamp(0, currentEvent.maxCapacity ?? 9999),
        );
        emit(state.copyWith(
          event: updated,
          uiModel: updated.toEventDetailUiModel(),
          joinLeaving: false,
        ));
        _emitEffect(ShowLeaveSuccessEffect());
      } else {
        await eventRepository.joinEvent(currentEvent);
        final updated = currentEvent.copyWith(
          userJoined: true,
          currentAttendeeCount: currentEvent.currentAttendeeCount + 1,
        );
        emit(state.copyWith(
          event: updated,
          uiModel: updated.toEventDetailUiModel(),
          joinLeaving: false,
        ));
        _emitEffect(ShowJoinSuccessEffect());
      }
    } catch (e) {
      final msg = e.toString().toLowerCase();
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
    final loc = state.event.location;
    if (loc.lat != null && loc.long != null) {
      _emitEffect(OpenMapsEffect(
        lat: loc.lat!,
        lng: loc.long!,
        name: loc.name,
      ));
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
