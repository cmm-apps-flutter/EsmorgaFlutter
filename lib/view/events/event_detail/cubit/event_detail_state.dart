import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/view/events/event_detail/model/event_detail_ui_model.dart';

class EventDetailState extends Equatable {
  final EventDetailUiModel event;
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
    EventDetailUiModel? event,
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
