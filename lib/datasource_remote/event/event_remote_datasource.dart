import 'package:esmorga_flutter/data/event/event_datasource.dart';
import 'package:esmorga_flutter/data/event/model/event_data_model.dart';
import 'package:esmorga_flutter/datasource_remote/api/esmorga_api.dart';
import 'package:esmorga_flutter/datasource_remote/api/esmorga_guest_api.dart';
import 'package:esmorga_flutter/datasource_remote/event/mapper/event_mapper.dart';

class EventRemoteDatasourceImpl implements EventDatasource {
  final EsmorgaApi eventApi;
  final EsmorgaGuestApi guestApi;

  EventRemoteDatasourceImpl(this.eventApi, this.guestApi);

  @override
  Future<List<EventDataModel>> getEvents() async {
    try {
      final eventList = await guestApi.getEvents();
      return eventList.toEventDataModelList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<EventDataModel>> getMyEvents() async {
    try {
      final myEventList = await eventApi.getMyEvents();
      return myEventList.toEventDataModelList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> joinEvent(EventDataModel event) async {
    try {
      await eventApi.joinEvent(event.dataId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> leaveEvent(EventDataModel event) async {
    try {
      await eventApi.leaveEvent(event.dataId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> cacheEvents(List<EventDataModel> events) {
    // TODO: implement cacheEvents
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCacheEvents() {
    // TODO: implement deleteCacheEvents
    throw UnimplementedError();
  }

  @override
  Future<EventDataModel> getEventById(String eventId) {
    // TODO: implement getEventById
    throw UnimplementedError();
  }
}
