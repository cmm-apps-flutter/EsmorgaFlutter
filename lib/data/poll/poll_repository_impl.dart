import 'package:esmorga_flutter/data/cache_helper.dart';
import 'package:esmorga_flutter/data/poll/mapper/poll_mapper.dart';
import 'package:esmorga_flutter/data/poll/model/poll_data_model.dart';
import 'package:esmorga_flutter/data/poll/poll_datasource.dart';
import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/domain/poll/poll_repository.dart';

class PollRepositoryImpl implements PollRepository {
  final PollDatasource localPollDatasource;
  final PollDatasource remotePollDatasource;

  PollRepositoryImpl(
    this.localPollDatasource,
    this.remotePollDatasource,
  );

  @override
  Future<List<Poll>> getPolls({bool forceRefresh = false, bool forceLocal = false}) async {
    final localList = await localPollDatasource.getPolls();

    if (forceLocal ||
        (!forceRefresh && localList.isNotEmpty && CacheHelper.shouldReturnCache(localList[0].dataCreationTime))) {
      return localList.toDomainList();
    }

    return (await _getPollsFromRemote()).toDomainList();
  }

  Future<List<PollDataModel>> _getPollsFromRemote() async {
    final remotePolls = await remotePollDatasource.getPolls();
    await localPollDatasource.cachePolls(remotePolls);
    return remotePolls;
  }
}
