import 'package:esmorga_flutter/data/poll/poll_datasource.dart';
import 'package:esmorga_flutter/data/poll/model/poll_data_model.dart';
import 'package:esmorga_flutter/datasource_remote/api/esmorga_api.dart';
import 'package:esmorga_flutter/datasource_remote/poll/mapper/poll_remote_mapper.dart';

class PollRemoteDatasourceImpl implements PollDatasource {
  final EsmorgaApi _api;

  PollRemoteDatasourceImpl(this._api);

  @override
  Future<List<PollDataModel>> getPolls() async {
    final remotePolls = await _api.getPolls();
    return remotePolls.toPollDataModelList();
  }

  @override
  Future<void> cachePolls(List<PollDataModel> polls) async {
    // Remote datasource doesn't cache locally
    throw UnimplementedError();
  }
}
