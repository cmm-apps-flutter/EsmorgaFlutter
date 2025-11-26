import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/domain/poll/usecase/vote_poll_use_case.dart';
import 'package:esmorga_flutter/view/poll_detail/cubit/poll_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PollDetailCubit extends Cubit<PollDetailState> {
  final VotePollUseCase _votePollUseCase;

  PollDetailCubit({
    required Poll poll,
    required VotePollUseCase votePollUseCase,
  })  : _votePollUseCase = votePollUseCase,
        super(PollDetailState(
          poll: poll,
          currentSelection: List.from(poll.userSelectedOptionIds),
        ));

  void toggleOption(String optionId) {
    final current = List<String>.from(state.currentSelection);
    if (state.poll.isMultipleChoice) {
      if (current.contains(optionId)) {
        current.remove(optionId);
      } else {
        current.add(optionId);
      }
    } else {
      current.clear();
      current.add(optionId);
    }
    emit(state.copyWith(currentSelection: current, showSuccessMessage: false));
  }

  Future<void> vote() async {
    if (state.currentSelection.isEmpty) return;

    emit(state.copyWithClearError(isLoading: true, showSuccessMessage: false));

    try {
      final updatedPoll = await _votePollUseCase(state.poll.id, state.currentSelection);
      emit(state.copyWith(
        poll: updatedPoll,
        currentSelection: updatedPoll.userSelectedOptionIds,
        isLoading: false,
        showSuccessMessage: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
        showSuccessMessage: false,
      ));
    }
  }

  void clearSuccessMessage() {
    emit(state.copyWith(showSuccessMessage: false));
  }
}
