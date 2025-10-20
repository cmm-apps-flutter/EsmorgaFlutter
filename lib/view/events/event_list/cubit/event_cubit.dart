import 'dart:async';

import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/view/events/event_list/cubit/event_state.dart';
import 'package:esmorga_flutter/view/events/event_list/mapper/event_list_ui_mapper.dart';
import 'package:esmorga_flutter/view/events/event_list/model/event_list_ui_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class EventCubit extends Cubit<EventState> {
  final EventRepository eventRepository;
  List<Event> _events = [];
  final _effectController = StreamController<EventListEffect>.broadcast();
  Stream<EventListEffect> get effects => _effectController.stream;

  EventCubit({required this.eventRepository}) : super(const EventState());

  Future<void> loadEvents() async {
    emit(const EventState(loading: true));
    try {
      final events = await eventRepository.getEvents();
      _events = events;
      emit(EventState(loading: false, eventList: events.toEventUiList()));
    } catch (e) {
      if (e.toString().contains('network') ||
          e.toString().contains('connection')) {
        _effectController.add(ShowNoNetworkPrompt());
      }
      emit(EventState(loading: false, error: e.toString()));
    }
  }

  void onEventClick(String eventId) {
    final eventFound = _events.firstWhereOrNull((e) => e.id == eventId);
    if (eventFound != null) {
      final eventEncoded = eventFound.copyWith(
          description: Uri.encodeComponent(eventFound.description));
      _effectController.add(NavigateToEventDetail(eventEncoded));
    }
  }

  @override
  Future<void> close() {
    _effectController.close();
    return super.close();
  }
}
