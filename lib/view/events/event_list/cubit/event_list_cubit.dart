import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/view/events/event_list/cubit/event_list_effect.dart';
import 'package:esmorga_flutter/view/events/event_list/mapper/event_list_ui_mapper.dart';
import 'package:esmorga_flutter/view/events/event_list/model/event_list_ui_model.dart';

part 'event_list_state.dart';

class EventListCubit extends Cubit<EventListState> {
  final EventRepository eventRepository;

  final _effectController = StreamController<EventListEffect>.broadcast();
  Stream<EventListEffect> get effects => _effectController.stream;

  List<Event> _events = [];

  EventListCubit({required this.eventRepository}) : super(const EventListState());

  Future<void> loadEvents() async => _load();
  Future<void> retry() async => _load();

  Future<void> _load() async {
    emit(state.copyWith(loading: true, error: null, showNoNetworkPrompt: false));
    try {
      final events = await eventRepository.getEvents();
      _events = events;
      if (_events.isEmpty) {
        emit(state.copyWith(loading: false, eventList: const [], error: null, showNoNetworkPrompt: false));
      } else {
        emit(state.copyWith(loading: false, eventList: _events.toEventUiList(), error: null, showNoNetworkPrompt: false));
      }
    } catch (e) {
      final msg = e.toString();
      final isNetwork = msg.contains('network') || msg.contains('connection');
      emit(state.copyWith(loading: false, eventList: const [], error: msg, showNoNetworkPrompt: isNetwork));
    }
  }

  void clearNoNetworkPrompt() {
    if (state.showNoNetworkPrompt) {
      emit(state.copyWith(showNoNetworkPrompt: false));
    }
  }

  void onEventClicked(String id) {
    final events = _events.where((e) => e.id == id);
    if (events.isEmpty) return;
    _emitEffect(NavigateToEventDetailsEffect(event: events.first));
  }

  void _emitEffect(EventListEffect effect) => _effectController.add(effect);

  @override
  Future<void> close() {
    _effectController.close();
    return super.close();
  }
}
