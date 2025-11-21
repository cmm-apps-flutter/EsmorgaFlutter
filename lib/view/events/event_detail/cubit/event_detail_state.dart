import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/view/events/event_detail/model/event_detail_ui_model.dart';

class EventDetailState extends Equatable {
  final EventDetailUiModel uiModel;
  final bool loading;
  final bool isAuthenticated;
  final bool joinLeaving;
  final String? error;

  const EventDetailState({
    required this.uiModel,
    this.loading = false,
    this.isAuthenticated = false,
    this.joinLeaving = false,
    this.error,
  });

  bool get isJoinEnabled {
  final now = DateTime.now();

  if (uiModel.eventDate.isBefore(now)) {
    return false;
  }

  if (uiModel.joinDeadLine != null) {
    final deadline = DateTime.tryParse(uiModel.joinDeadLine!);
    if (deadline != null) {
      return now.isBefore(deadline) || now.isAtSameMomentAs(deadline);
    }
  }

  return true;
}

  EventDetailState copyWith({
    bool? loading,
    EventDetailUiModel? uiModel,
    bool? isAuthenticated,
    bool? joinLeaving,
    String? error,
  }) => EventDetailState(
    loading: loading ?? this.loading,
    uiModel: uiModel ?? this.uiModel,
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    joinLeaving: joinLeaving ?? this.joinLeaving,
    error: error ?? this.error,
  );

  @override
  List<Object?> get props => [uiModel, loading, isAuthenticated, joinLeaving, error];
}
