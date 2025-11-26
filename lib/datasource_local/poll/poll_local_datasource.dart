import 'package:esmorga_flutter/data/poll/poll_datasource.dart';
import 'package:esmorga_flutter/data/poll/model/poll_data_model.dart';
import 'package:esmorga_flutter/datasource_local/poll/poll_local_model.dart';
import 'package:esmorga_flutter/datasource_local/poll/mapper/poll_local_mapper.dart';
import 'package:hive_ce/hive.dart';

class PollLocalDatasourceImpl implements PollDatasource {
  static const String pollsBoxName = 'polls';
  final Box<PollLocalModel> pollsBox;

  PollLocalDatasourceImpl(this.pollsBox);

  @override
  Future<List<PollDataModel>> getPolls() async {
    final polls = pollsBox.values.toList();
    return polls.toPollDataModelList();
  }

  @override
  Future<void> cachePolls(List<PollDataModel> polls) async {
    await pollsBox.clear();
    final localPolls = polls.toPollLocalModelList();
    final pollMap = {for (var p in localPolls) p.localId: p};
    await pollsBox.putAll(pollMap);
  }

  @override
  Future<PollDataModel> votePoll(String pollId, List<String> selectedOptions) async {
    throw UnimplementedError();
  }

  @override
  Future<void> savePoll(PollDataModel poll) async {
    final localPoll = poll.toPollLocalModel();
    await pollsBox.put(localPoll.localId, localPoll);
  }
}
