import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/domain/poll/model/poll.dart';

class PollDetailState extends Equatable {
  final Poll poll;
  final List<String> currentSelection;
  final bool isButtonLoading;
  final String buttonText;
  final bool isButtonEnabled;
  final String? error;
  final bool showSuccessMessage;

  const PollDetailState({
    required this.poll,
    this.currentSelection = const [],
    this.isButtonLoading = false,
    this.buttonText = '',
    this.isButtonEnabled = false,
    this.error,
    this.showSuccessMessage = false,
  });

  PollDetailState copyWith({
    Poll? poll,
    List<String>? currentSelection,
    bool? isButtonLoading,
    String? buttonText,
    bool? isButtonEnabled,
    String? error,
    bool? showSuccessMessage,
  }) {
    return PollDetailState(
      poll: poll ?? this.poll,
      currentSelection: currentSelection ?? this.currentSelection,
      isButtonLoading: isButtonLoading ?? this.isButtonLoading,
      buttonText: buttonText ?? this.buttonText,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      error: error,
      showSuccessMessage: showSuccessMessage ?? this.showSuccessMessage,
    );
  }

  // Custom copyWith to allow clearing error
  PollDetailState copyWithClearError({
    Poll? poll,
    List<String>? currentSelection,
    bool? isButtonLoading,
    String? buttonText,
    bool? isButtonEnabled,
    bool? showSuccessMessage,
  }) {
    return PollDetailState(
      poll: poll ?? this.poll,
      currentSelection: currentSelection ?? this.currentSelection,
      isButtonLoading: isButtonLoading ?? this.isButtonLoading,
      buttonText: buttonText ?? this.buttonText,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      error: null,
      showSuccessMessage: showSuccessMessage ?? this.showSuccessMessage,
    );
  }

  @override
  List<Object?> get props => [poll, currentSelection, isButtonLoading, error, showSuccessMessage];
}
