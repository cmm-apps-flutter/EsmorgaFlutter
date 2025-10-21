import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/view/events/event_list/mapper/event_list_ui_mapper.dart';
import 'package:esmorga_flutter/view/events/event_list/model/event_list_ui_model.dart';

part 'event_list_state.dart';

class EventListCubit extends Cubit<EventListState> {
  final EventRepository eventRepository;

  List<EventListUiModel> _cachedEvents = [];

  EventListCubit({required this.eventRepository}) : super(const EventListState());

  Future<void> loadEvents() async => _load();
  Future<void> retry() async => _load();

  Future<void> _load() async {
    emit(state.copyWith(loading: true, error: null, showNoNetworkPrompt: false));
    try {
      final events = await eventRepository.getEvents();
      _cachedEvents = events.toEventUiList();
      if (_cachedEvents.isEmpty) {
        emit(state.copyWith(loading: false, eventList: const [], error: null, showNoNetworkPrompt: false));
      } else {
        emit(state.copyWith(loading: false, eventList: _cachedEvents, error: null, showNoNetworkPrompt: false));
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
}
