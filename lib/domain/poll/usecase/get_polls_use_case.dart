import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/domain/poll/poll_repository.dart';

class GetPollsUseCase {
  final PollRepository _repository;

  GetPollsUseCase(this._repository);

  Future<List<Poll>> call() async {
    final polls = await _repository.getPolls();
    polls.sort((a, b) => a.voteDeadline.compareTo(b.voteDeadline));
    return polls;
  }
}
