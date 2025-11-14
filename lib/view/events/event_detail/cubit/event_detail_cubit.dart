import 'dart:async';

import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_effect.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_state.dart';
import 'package:esmorga_flutter/view/events/event_detail/mapper/event_detail_ui_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  final EventRepository eventRepository;
  final UserRepository userRepository;
  Event _event;

  final _effectController = StreamController<EventDetailEffect>.broadcast();
  Stream<EventDetailEffect> get effects => _effectController.stream;

  EventDetailCubit({required this.eventRepository, required this.userRepository, required Event event}) : _event = event, super(
    EventDetailState(
      uiModel: EventDetailUiMapper.map(
        event,
        isAuthenticated: false,
        isJoinEnabled: true,
      ),
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

    try {
      final localEvents = await eventRepository.getEvents(forceLocal: true);
      final updatedEvent = localEvents.firstWhere(
        (e) => e.id == _event.id,
        orElse: () => _event,
      );
      _event = updatedEvent;
    } catch (_) {}

    final newUiModel = EventDetailUiMapper.map(
      _event,
      isAuthenticated: isAuth,
      isJoinEnabled: state.isJoinEnabled,
    );

    emit(state.copyWith(
      loading: false,
      isAuthenticated: isAuth,
      uiModel: newUiModel,
    ));
  }


  Future<void> primaryPressed() async {
    if (!state.isAuthenticated) {
      _emitEffect(NavigateToLoginEffect());
      return;
    }

    if (!state.isJoinEnabled) {
      _emitEffect(ShowJoinClosedEffect());
      return;
    }

    emit(state.copyWith(joinLeaving: true));

    try {
      Event updated;
      if (_event.userJoined) {
        await eventRepository.leaveEvent(_event);
        updated = _event.copyWith(
          userJoined: false,
          currentAttendeeCount: (_event.currentAttendeeCount - 1).clamp(0, _event.maxCapacity ?? _event.currentAttendeeCount),
        );
        _emitEffect(ShowLeaveSuccessEffect());
      } else {
        await eventRepository.joinEvent(_event);
        updated = _event.copyWith(
          userJoined: true,
          currentAttendeeCount: _event.currentAttendeeCount + 1,
        );
        _emitEffect(ShowJoinSuccessEffect());
      }

      _event = updated;
      emit(state.copyWith(
        uiModel: EventDetailUiMapper.map(
          updated,
          isAuthenticated: state.isAuthenticated,
          isJoinEnabled: state.isJoinEnabled,
        ),
        joinLeaving: false,
      ));
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
    final loc = _event.location;
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