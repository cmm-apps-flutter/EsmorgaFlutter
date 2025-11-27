import 'package:esmorga_flutter/domain/poll/model/poll.dart';

abstract class PollRepository {
  Future<List<Poll>> getPolls({bool forceRefresh = false, bool forceLocal = false});
  Future<Poll> votePoll(String pollId, List<String> selectedOptions);
}
