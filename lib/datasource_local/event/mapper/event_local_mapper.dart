import 'package:esmorga_flutter/data/event/model/event_data_model.dart';
import 'package:esmorga_flutter/datasource_local/event/event_local_model.dart';
import 'package:esmorga_flutter/domain/event/model/event_type.dart';

extension EventLocalModelMapper on EventLocalModel {
  EventDataModel toEventDataModel() {
    return EventDataModel(
      dataId: localId,
      dataName: localName,
      dataDate: localDate,
      dataDescription: localDescription,
      dataType: EventTypeExtension.fromString(localType),
      dataImageUrl: localImageUrl,
      dataLocation: EventLocationDataModel(
        name: localLocation.name,
        lat: localLocation.lat,
        long: localLocation.long,
      ),
      dataTags: localTags,
      dataCreationTime: localCreationTime,
      dataUserJoined: localUserJoined,
    );
  }
}

extension EventDataModelToLocalMapper on EventDataModel {
  EventLocalModel toEventLocalModel() {
    return EventLocalModel(
      localId: dataId,
      localName: dataName,
      localDate: dataDate,
      localDescription: dataDescription,
      localType: dataType.name,
      localImageUrl: dataImageUrl,
      localLocation: EventLocationLocalModel(
        name: dataLocation.name,
        lat: dataLocation.lat,
        long: dataLocation.long,
      ),
      localTags: dataTags,
      localCreationTime: dataCreationTime,
      localUserJoined: dataUserJoined,
    );
  }
}

extension EventLocalModelListMapper on List<EventLocalModel> {
  List<EventDataModel> toEventDataModelList() {
    return map((local) => local.toEventDataModel()).toList();
  }
}

extension EventDataModelListToLocalMapper on List<EventDataModel> {
  List<EventLocalModel> toEventLocalModelList() {
    return map((data) => data.toEventLocalModel()).toList();
  }
}

