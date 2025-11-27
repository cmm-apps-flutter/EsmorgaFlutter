import 'package:esmorga_flutter/data/poll/model/poll_data_model.dart';

abstract class PollDatasource {
  Future<List<PollDataModel>> getPolls();
  Future<void> cachePolls(List<PollDataModel> polls);
  Future<PollDataModel> votePoll(String pollId, List<String> selectedOptions);
  Future<void> savePoll(PollDataModel poll);
}
