import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/view/events/event_detail/model/event_detail_ui_model.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';

class EventDetailState extends Equatable {
  final Event event;
  final EventDetailUiModel uiModel;
  final bool loading;
  final bool isAuthenticated;
  final bool joinLeaving;
  final String? error;

  const EventDetailState({
    required this.event,
    required this.uiModel,
    this.loading = false,
    this.isAuthenticated = false,
    this.joinLeaving = false,
    this.error,
  });

  EventDetailState copyWith({
    Event? event,
    bool? loading,
    EventDetailUiModel? uiModel,
    bool? isAuthenticated,
    bool? joinLeaving,
    String? error,
  }) => EventDetailState(
    event: event ?? this.event,
    loading: loading ?? this.loading,
    uiModel: uiModel ?? this.uiModel,
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    joinLeaving: joinLeaving ?? this.joinLeaving,
    error: error ?? this.error,
  );

  @override
  List<Object?> get props => [loading, event, isAuthenticated, joinLeaving, error];
}
