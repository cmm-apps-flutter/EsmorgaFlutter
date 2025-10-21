import 'package:esmorga_flutter/data/event/event_datasource.dart';
import 'package:esmorga_flutter/data/event/model/event_data_model.dart';
import 'package:esmorga_flutter/datasource_local/event/event_local_model.dart';
import 'package:esmorga_flutter/datasource_local/event/mapper/event_local_mapper.dart';
import 'package:hive_ce/hive.dart';

class EventLocalDatasourceImpl implements EventDatasource {
  static const String eventsBoxName = 'events';
  final Box<EventLocalModel> eventsBox;

  EventLocalDatasourceImpl(this.eventsBox);

  @override
  Future<List<EventDataModel>> getEvents() async {
    final events = eventsBox.values.toList();
    return events.toEventDataModelList();
  }

  @override
  Future<EventDataModel> getEventById(String eventId) async {
    final event = eventsBox.get(eventId);
    if (event == null) {
      throw Exception('Event not found with id: $eventId');
    }
    return event.toEventDataModel();
  }

  @override
  Future<List<EventDataModel>> getMyEvents() async {
    final events = eventsBox.values.where((event) => event.localUserJoined).toList();
    return events.toEventDataModelList();
  }

  @override
  Future<void> joinEvent(EventDataModel event) async {
    final localEvent = event.copyWith(dataUserJoined: true).toEventLocalModel();
    await eventsBox.put(event.dataId, localEvent);
  }

  @override
  Future<void> leaveEvent(EventDataModel event) async {
    final localEvent = event.copyWith(dataUserJoined: false).toEventLocalModel();
    await eventsBox.put(event.dataId, localEvent);
  }

  @override
  Future<void> cacheEvents(List<EventDataModel> events) async {
    await eventsBox.clear();
    final localEvents = events.toEventLocalModelList();
    final eventMap = {for (var e in localEvents) e.localId: e};
    await eventsBox.putAll(eventMap);
  }

  @override
  Future<void> deleteCacheEvents() async {
    await eventsBox.clear();
  }
}

