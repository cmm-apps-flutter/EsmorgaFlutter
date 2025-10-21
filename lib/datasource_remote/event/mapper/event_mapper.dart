import 'package:esmorga_flutter/data/event/model/event_data_model.dart';
import 'package:esmorga_flutter/datasource_remote/event/event_remote_model.dart';

extension EventRemoteModelMapper on List<EventRemoteModel> {
  List<EventDataModel> toEventDataModelList() {
    return map((remote) => EventDataModel.fromRemoteModel(remote)).toList();
  }
}

