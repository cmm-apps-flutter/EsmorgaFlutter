
import 'package:esmorga_flutter/datasource_remote/event/event_remote_model.dart';

abstract class EventRepository {
  Future<List<EventRemoteModel>> getEvents();
}