import 'package:esmorga_flutter/data/cache_helper.dart';
import 'package:esmorga_flutter/data/event/event_datasource.dart';
import 'package:esmorga_flutter/data/event/mapper/event_mapper.dart';
import 'package:esmorga_flutter/data/user/datasource/user_datasource.dart';
import 'package:esmorga_flutter/data/event/model/event_data_model.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';

class EventRepositoryImpl implements EventRepository {
  final UserDatasource localUserDatasource;
  final EventDatasource localEventDatasource;
  final EventDatasource remoteEventDatasource;

  EventRepositoryImpl(
    this.localUserDatasource,
    this.localEventDatasource,
    this.remoteEventDatasource,
  );

  @override
  Future<List<Event>> getEvents({bool forceRefresh = false, bool forceLocal = false}) async {
    final localList = await localEventDatasource.getEvents();

    if (forceLocal ||
        (!forceRefresh &&
         localList.isNotEmpty &&
         CacheHelper.shouldReturnCache(localList[0].dataCreationTime))) {
      return localList.toEventList();
    }

    return (await _getEventsFromRemote()).toEventList();
  }

  @override
  Future<Event> getEventDetails(String eventId) async {
    return (await localEventDatasource.getEventById(eventId)).toEvent();
  }

  @override
  Future<void> joinEvent(Event event) async {
    final updatedEvent = event.copyWith(userJoined: true);
    await remoteEventDatasource.joinEvent(updatedEvent.toEventDataModel());
    await localEventDatasource.joinEvent(updatedEvent.toEventDataModel());
  }

  @override
  Future<void> leaveEvent(Event event) async {
    final updatedEvent = event.copyWith(userJoined: false);
    await remoteEventDatasource.leaveEvent(updatedEvent.toEventDataModel());
    await localEventDatasource.leaveEvent(updatedEvent.toEventDataModel());
  }

  Future<List<EventDataModel>> _getEventsFromRemote() async {
    final combinedList = <EventDataModel>[];
    final remoteEventList = await remoteEventDatasource.getEvents();

    try {
      final myEvents = await remoteEventDatasource.getMyEvents();

      combinedList.addAll(
        remoteEventList.map((event) {
          final isJoined = myEvents.any((me) => event.dataId == me.dataId);
          return event.copyWith(dataUserJoined: isJoined);
        }),
      );
    } catch (e) {
      combinedList.addAll(remoteEventList);
    }

    await localEventDatasource.cacheEvents(combinedList);
    return combinedList;
  }
}

