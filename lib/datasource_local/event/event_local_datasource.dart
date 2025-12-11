import 'package:esmorga_flutter/data/event/event_datasource.dart';
import 'package:esmorga_flutter/data/event/model/event_attendees_data_model.dart';
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
    final localEvent = event.toEventLocalModel();
    await eventsBox.put(event.dataId, localEvent);
  }

  @override
  Future<void> leaveEvent(EventDataModel event) async {
    final localEvent = event.toEventLocalModel();
    await eventsBox.put(event.dataId, localEvent);
  }

  @override
  Future<void> cacheEvents(List<EventDataModel> events) async {
    final eventMap = <String, EventLocalModel>{};

    for (final eventDataModel in events) {
      
      final existingLocalModel = eventsBox.get(eventDataModel.dataId);
      
      final newLocalModel = eventDataModel.toEventLocalModel(); 
      
      if (existingLocalModel != null) {
        newLocalModel.paidUsers = existingLocalModel.paidUsers;
      }

      eventMap[newLocalModel.localId] = newLocalModel;
    }
    
    await eventsBox.putAll(eventMap);
  }

  @override
  Future<void> deleteCacheEvents() async {
    await eventsBox.clear();
  }

  @override
  Future<EventAttendeesDataModel> getEventAttendees(String eventId) async {
    return EventAttendeesDataModel(totalUsers: 0, users: []);
  }

  @override
  Future<void> savePaidStatus(String eventId, String userName, bool isPaid) async {
    final event = eventsBox.get(eventId);
    if (event == null) return;

    event.paidUsers = event.paidUsers ?? [];

    if (isPaid) {
      if (!event.paidUsers.contains(userName)) {
        event.paidUsers.add(userName);
      }
    } else {
      event.paidUsers.remove(userName);
    }

    await event.save(); 
    final savedEvent = eventsBox.get(eventId);
  }

  @override
  Future<Map<String, bool>> getPaidStatuses(String eventId) async {
    final event = eventsBox.get(eventId);

    if (event == null) {
      return {}; 
    }

    final paidUsers = event.paidUsers ?? [];
    final paidStatusMap = <String, bool>{};

    for (final userName in paidUsers) {
      paidStatusMap[userName] = true; 
    }
    return paidStatusMap;
  }
}