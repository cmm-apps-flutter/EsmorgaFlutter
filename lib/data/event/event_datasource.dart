import 'package:esmorga_flutter/data/event/model/event_attendees_data_model.dart';
import 'package:esmorga_flutter/data/event/model/event_data_model.dart';

abstract class EventDatasource {
  Future<List<EventDataModel>> getEvents();
  Future<List<EventDataModel>> getMyEvents();
  Future<void> joinEvent(EventDataModel event);
  Future<void> leaveEvent(EventDataModel event);

  Future<EventDataModel> getEventById(String eventId) async {
    throw UnimplementedError('getEventById is not supported by this datasource');
  }

  Future<void> cacheEvents(List<EventDataModel> events) async {
    throw UnimplementedError('getEventById is not supported by this datasource');
  }

  Future<void> deleteCacheEvents() async {
    throw UnimplementedError('getEventById is not supported by this datasource');
  }

  Future<EventAttendeesDataModel> getEventAttendees(String eventId) async {
    throw UnimplementedError('getEventAttendees is not supported by this datasource');
  }
}