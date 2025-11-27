import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/domain/poll/model/poll.dart';

class PollDetailState extends Equatable {
  final Poll poll;
  final List<String> currentSelection;
  final bool isLoading;
  final String? error;
  final bool showSuccessMessage;

  const PollDetailState({
    required this.poll,
    this.currentSelection = const [],
    this.isLoading = false,
    this.error,
    this.showSuccessMessage = false,
  });

  PollDetailState copyWith({
    Poll? poll,
    List<String>? currentSelection,
    bool? isLoading,
    String? error,
    bool? showSuccessMessage,
  }) {
    return PollDetailState(
      poll: poll ?? this.poll,
      currentSelection: currentSelection ?? this.currentSelection,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      showSuccessMessage: showSuccessMessage ?? this.showSuccessMessage,
    );
  }

  // Custom copyWith to allow clearing error
  PollDetailState copyWithClearError({
    Poll? poll,
    List<String>? currentSelection,
    bool? isLoading,
    bool? showSuccessMessage,
  }) {
    return PollDetailState(
      poll: poll ?? this.poll,
      currentSelection: currentSelection ?? this.currentSelection,
      isLoading: isLoading ?? this.isLoading,
      error: null,
      showSuccessMessage: showSuccessMessage ?? this.showSuccessMessage,
    );
  }

  @override
  List<Object?> get props => [poll, currentSelection, isLoading, error, showSuccessMessage];
}
