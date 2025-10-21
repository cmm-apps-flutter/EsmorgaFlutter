import 'package:bloc/bloc.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_state.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  final EventRepository eventRepository;
  final UserRepository userRepository;

  EventDetailCubit(
      {required this.eventRepository,
      required this.userRepository,
      required String eventId})
      : super(EventDetailState(eventId: eventId));

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
      final evt = await eventRepository.getEventDetails(state.eventId);
      emit(state.copyWith(loading: false, event: evt, isAuthenticated: isAuth));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> primaryPressed() async {
    final current = state.event;
    if (current == null) return;
    if (!state.isAuthenticated) {
      _emitEffect(EventDetailEffectType.navigateToLogin);
      return;
    }
    emit(state.copyWith(joinLeaving: true));
    try {
      if (current.userJoined) {
        await eventRepository.leaveEvent(current);
        final updated = current.copyWith(userJoined: false);
        emit(state.copyWith(event: updated, joinLeaving: false));
        _emitEffect(EventDetailEffectType.showLeaveSuccess);
      } else {
        await eventRepository.joinEvent(current);
        final updated = current.copyWith(userJoined: true);
        emit(state.copyWith(event: updated, joinLeaving: false));
        _emitEffect(EventDetailEffectType.showJoinSuccess);
      }
    } catch (e) {
      final msg = e.toString().toLowerCase();
      _emitEffect(msg.contains('network') || msg.contains('connection')
          ? EventDetailEffectType.showNoNetwork
          : EventDetailEffectType.showGenericError);
      emit(state.copyWith(joinLeaving: false));
    }
  }

  void navigatePressed() {
    final evt = state.event;
    if (evt?.location.lat != null && evt?.location.long != null) {
      _emitEffect(EventDetailEffectType.openMaps,
          lat: evt!.location.lat!,
          lng: evt.location.long!,
          name: evt.location.name);
    }
  }

  void backPressed() => _emitEffect(EventDetailEffectType.navigateBack);

  void _emitEffect(EventDetailEffectType type,
      {double? lat, double? lng, String? name}) {
    emit(state.copyWith(
      effectType: type,
      effectLat: lat,
      effectLng: lng,
      effectName: name,
      effectId: state.effectId + 1,
    ));
  }
}
