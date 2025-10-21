import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';

enum EventDetailEffectType { navigateBack, navigateToLogin, showJoinSuccess, showLeaveSuccess, showNoNetwork, showGenericError, openMaps }

class EventDetailState extends Equatable {
  final String eventId;
  final bool loading;
  final Event? event;
  final bool isAuthenticated;
  final bool joinLeaving;
  final String? error;
  final EventDetailEffectType? effectType;
  final int effectId;
  final double? effectLat;
  final double? effectLng;
  final String? effectName;

  const EventDetailState({
    required this.eventId,
    this.loading = false,
    this.event,
    this.isAuthenticated = false,
    this.joinLeaving = false,
    this.error,
    this.effectType,
    this.effectId = 0,
    this.effectLat,
    this.effectLng,
    this.effectName,
  });

  EventDetailState copyWith({
    bool? loading,
    Event? event,
    bool? isAuthenticated,
    bool? joinLeaving,
    String? error,
    EventDetailEffectType? effectType,
    int? effectId,
    double? effectLat,
    double? effectLng,
    String? effectName,
  }) => EventDetailState(
    eventId: eventId,
    loading: loading ?? this.loading,
    event: event ?? this.event,
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    joinLeaving: joinLeaving ?? this.joinLeaving,
    error: error,
    effectType: effectType,
    effectId: effectId ?? this.effectId,
    effectLat: effectLat,
    effectLng: effectLng,
    effectName: effectName,
  );

  @override
  List<Object?> get props => [eventId, loading, event, isAuthenticated, joinLeaving, error, effectType, effectId, effectLat, effectLng, effectName];
}
