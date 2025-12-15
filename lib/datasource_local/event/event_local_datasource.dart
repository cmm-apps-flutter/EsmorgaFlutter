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
    final existingLocalModel = eventsBox.get(event.dataId);
    
    final newLocalModel = event.toEventLocalModel();
    
    if (existingLocalModel != null) {
      newLocalModel.attendees = existingLocalModel.attendees;
    }
    
    await eventsBox.put(event.dataId, newLocalModel);
  }

  @override
  Future<void> leaveEvent(EventDataModel event) async {
    final existingLocalModel = eventsBox.get(event.dataId);
    
    final newLocalModel = event.toEventLocalModel();
    
    if (existingLocalModel != null) {
      newLocalModel.attendees = existingLocalModel.attendees;
    }

    await eventsBox.put(event.dataId, newLocalModel);
  }

  @override
  Future<void> cacheEvents(List<EventDataModel> events) async {
    final eventMap = <String, EventLocalModel>{};

    for (final eventDataModel in events) {
      
      final existingLocalModel = eventsBox.get(eventDataModel.dataId);
      
      final newLocalModel = eventDataModel.toEventLocalModel(); 
      
      if (existingLocalModel != null) {
        newLocalModel.attendees = existingLocalModel.attendees;
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
  Future<void> savePaidStatus(String eventId, EventAttendeeLocalModel attendee) async {
    final event = eventsBox.get(eventId);
    if (event == null) return;

    final attendeesList = event.attendees ?? []; 
    final existingAttendeeIndex = attendeesList.indexWhere((a) => a.userName == attendee.userName); 

    if (existingAttendeeIndex >= 0) {
      event.attendees[existingAttendeeIndex] = attendee;
    } else {
      event.attendees.add(attendee); 
    }
    await event.save(); 
}

  @override
  Future<Map<String, bool>> getPaidStatuses(String eventId) async {
    final event = eventsBox.get(eventId);

    if (event == null) {
      return {}; 
    }

    final attendees = event.attendees ?? [];
    
    final paidStatusMap = <String, bool>{};

    for (final attendee in attendees) {
      if (attendee.isPaid) {
        paidStatusMap[attendee.userName] = true; 
      }
    }
    return paidStatusMap;
  }
}