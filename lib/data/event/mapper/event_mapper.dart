import 'package:esmorga_flutter/data/event/model/event_data_model.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/event/model/event_location.dart';

extension EventDataModelMapper on EventDataModel {
  Event toEvent() {
    return Event(
      id: dataId,
      name: dataName,
      date: dataDate,
      description: dataDescription,
      imageUrl: dataImageUrl,
      location: EventLocation(
        name: dataLocation.name,
        lat: dataLocation.lat,
        long: dataLocation.long,
      ),
      tags: dataTags,
      userJoined: dataUserJoined,
      currentAttendeeCount: dataCurrentAttendeeCount,
      maxCapacity: dataMaxCapacity,
      joinDeadline: dataJoinDeadLine,
    );
  }
}

extension EventDataModelListMapper on List<EventDataModel> {
  List<Event> toEventList() {
    return map((dataModel) => dataModel.toEvent()).toList();
  }
}

extension EventMapper on Event {
  EventDataModel toEventDataModel() {
    return EventDataModel(
      dataId: id,
      dataName: name,
      dataDate: date,
      dataDescription: description,
      dataImageUrl: imageUrl != null ? Uri.encodeComponent(imageUrl!) : null,
      dataLocation: EventLocationDataModel(
        name: location.name,
        lat: location.lat,
        long: location.long,
      ),
      dataTags: tags,
      dataCreationTime: DateTime.now().millisecondsSinceEpoch,
      dataUserJoined: userJoined,
      dataCurrentAttendeeCount: currentAttendeeCount,
      dataMaxCapacity: maxCapacity,
      dataJoinDeadLine: joinDeadline,
    );
  }
}
