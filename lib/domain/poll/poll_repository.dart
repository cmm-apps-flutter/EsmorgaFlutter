import 'package:esmorga_flutter/domain/poll/model/poll.dart';

abstract class PollRepository {
  Future<List<Poll>> getPolls({bool forceRefresh = false, bool forceLocal = false});
}
