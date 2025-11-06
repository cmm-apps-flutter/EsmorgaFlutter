import 'package:esmorga_flutter/domain/event/model/event.dart';

abstract class EventRepository {
  Future<List<Event>> getEvents({bool forceRefresh = false, bool forceLocal = false});
  Future<void> joinEvent(Event event);
  Future<void> leaveEvent(Event event);
  Future<Event> getEventDetails(String eventId);
}

