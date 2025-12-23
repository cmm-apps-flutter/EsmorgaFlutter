import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/domain/poll/usecase/vote_poll_use_case.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/poll_detail/cubit/poll_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PollDetailCubit extends Cubit<PollDetailState> {
  final VotePollUseCase _votePollUseCase;
  final LocalizationService l10n;

  PollDetailCubit({
    required Poll poll,
    required VotePollUseCase votePollUseCase,
    required this.l10n,
  })  : _votePollUseCase = votePollUseCase,
        super(PollDetailState(
          poll: poll,
          currentSelection: List.from(poll.userSelectedOptionIds),
          buttonText: _getButtonText(poll, l10n),
          isButtonEnabled: _getButtonEnabled(poll, List.from(poll.userSelectedOptionIds), l10n),
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
    emit(state.copyWith(
        currentSelection: current,
        buttonText: _getButtonText(state.poll, l10n),
        isButtonEnabled: _getButtonEnabled(state.poll, current, l10n),
        showSuccessMessage: false));
  }

  Future<void> vote() async {
    if (state.currentSelection.isEmpty) return;

    emit(state.copyWithClearError(isButtonLoading: true, showSuccessMessage: false));

    try {
      final updatedPoll = await _votePollUseCase(state.poll.id, state.currentSelection);
      emit(state.copyWith(
        poll: updatedPoll,
        currentSelection: updatedPoll.userSelectedOptionIds,
        buttonText: _getButtonText(updatedPoll, l10n),
        isButtonEnabled: _getButtonEnabled(updatedPoll, updatedPoll.userSelectedOptionIds, l10n),
        isButtonLoading: false,
        showSuccessMessage: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isButtonLoading: false,
        error: e.toString(),
        showSuccessMessage: false,
      ));
    }
  }

  void clearSuccessMessage() {
    emit(state.copyWith(showSuccessMessage: false));
  }

  static String _getButtonText(Poll poll, LocalizationService l10n) {
    final isDeadlinePassed = DateTime.now().isAfter(poll.voteDeadline);
    final hasVoted = poll.userSelectedOptionIds.isNotEmpty;
    return isDeadlinePassed
        ? l10n.current.buttonDeadlinePassed
        : (hasVoted ? l10n.current.buttonPollChangeVote : l10n.current.buttonPollVote);
  }

  static bool _getButtonEnabled(Poll poll, List<String> currentSelection, LocalizationService l10n) {
    final isDeadlinePassed = DateTime.now().isAfter(poll.voteDeadline);
    final hasVoteChanged = (poll.userSelectedOptionIds.length != currentSelection.length) ||
        poll.userSelectedOptionIds.indexWhere(currentSelection.contains) == -1;
    return !isDeadlinePassed && currentSelection.isNotEmpty && hasVoteChanged;
  }
}
