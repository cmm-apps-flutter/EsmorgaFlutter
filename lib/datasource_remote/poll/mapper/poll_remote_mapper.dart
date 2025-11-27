import 'package:esmorga_flutter/data/poll/model/poll_data_model.dart';
import 'package:esmorga_flutter/datasource_remote/poll/poll_remote_model.dart';

extension PollRemoteModelMapper on List<PollRemoteModel> {
  List<PollDataModel> toPollDataModelList() {
    return map((remote) => PollDataModel.fromRemoteModel(remote)).toList();
  }
}
