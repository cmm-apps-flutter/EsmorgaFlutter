import 'package:esmorga_flutter/data/event/model/event_data_model.dart';
import 'package:esmorga_flutter/datasource_local/event/event_local_model.dart';

extension EventLocalModelMapper on EventLocalModel {
  EventDataModel toEventDataModel() {
    return EventDataModel(
      dataId: localId,
      dataName: localName,
      dataDate: localDate,
      dataDescription: localDescription,
      dataImageUrl: localImageUrl,
      dataLocation: EventLocationDataModel(
        name: localLocation.name,
        lat: localLocation.lat,
        long: localLocation.long,
      ),
      dataTags: localTags,
      dataCreationTime: localCreationTime,
      dataUserJoined: localUserJoined,
      dataCurrentAttendeeCount: localCurrentAttendeeCount,
      dataMaxCapacity: localMaxCapacity,
      dataJoinDeadLine: localJoinDeadline,
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
      localImageUrl: dataImageUrl,
      localLocation: EventLocationLocalModel(
        name: dataLocation.name,
        lat: dataLocation.lat,
        long: dataLocation.long,
      ),
      localTags: dataTags,
      localCreationTime: dataCreationTime,
      localUserJoined: dataUserJoined,
      localCurrentAttendeeCount: dataCurrentAttendeeCount,
      localMaxCapacity: dataMaxCapacity,
      localJoinDeadline: dataJoinDeadLine,
      attendees: [],
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

