import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';

class EventDetailState extends Equatable {
  final Event event;
  final bool loading;
  final bool isAuthenticated;
  final bool joinLeaving;
  final String? error;

  const EventDetailState({
    required this.event,
    this.loading = false,
    this.isAuthenticated = false,
    this.joinLeaving = false,
    this.error,
  });

  EventDetailState copyWith({
    bool? loading,
    Event? event,
    bool? isAuthenticated,
    bool? joinLeaving,
    String? error,
  }) => EventDetailState(
    loading: loading ?? this.loading,
    event: event ?? this.event,
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    joinLeaving: joinLeaving ?? this.joinLeaving,
    error: error,
  );

  @override
  List<Object?> get props => [loading, event, isAuthenticated, joinLeaving, error];
}
