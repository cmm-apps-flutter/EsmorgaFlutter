import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/domain/poll/poll_repository.dart';

class VotePollUseCase {
  final PollRepository _repository;

  VotePollUseCase(this._repository);

  Future<Poll> call(String pollId, List<String> selectedOptions) {
    return _repository.votePoll(pollId, selectedOptions);
  }
}
