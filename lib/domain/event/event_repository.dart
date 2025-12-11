import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/event/model/event_attendees.dart';

abstract class EventRepository {
  Future<List<Event>> getEvents({bool forceRefresh = false, bool forceLocal = false});
  Future<void> joinEvent(Event event);
  Future<void> leaveEvent(Event event);
  Future<EventAttendees> getEventAttendees(String eventId);
  Future<void> updatePaidStatus(String eventId, String userName, bool isPaid);
  Future<Map<String, bool>> getLocallyStoredPaidStatus(String eventId);
}