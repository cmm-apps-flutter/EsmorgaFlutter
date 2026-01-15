import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/domain/user/model/role_type.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/home_tab/mapper/home_tab_ui_mapper.dart';
import 'package:esmorga_flutter/view/home_tab/model/home_tab_ui_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Removed event part
// part 'my_events_event.dart';
part 'my_events_state.dart';

sealed class MyEventsEffect {}

class MyEventsEffectShowNoNetworkPrompt extends MyEventsEffect {}

class MyEventsEffectNavigateToEventDetail extends MyEventsEffect {
  final Event event;
  MyEventsEffectNavigateToEventDetail(this.event);
}

class MyEventsEffectNavigateToSignIn extends MyEventsEffect {}

class MyEventsCubit extends Cubit<MyEventsState> {
  final EventRepository eventRepository;
  final UserRepository userRepository;

  List<Event> _myEvents = [];
  bool _showCreateButton = false;
  final _effectController = StreamController<MyEventsEffect>.broadcast();
  Stream<MyEventsEffect> get effects => _effectController.stream;

  MyEventsCubit({required this.eventRepository, required this.userRepository}) : super(const MyEventsState());

  Future<void> load({bool forceRefresh = false}) async {
    emit(const MyEventsState(loading: true));
    try {
      final userData = await userRepository.getUser();
      _showCreateButton = userData.role == RoleType.admin;
    } catch (_) {
      emit(MyEventsState(loading: false, showCreateButton: _showCreateButton, error: MyEventsEffectType.notLoggedIn));
      return;
    }
    try {
      final events = await eventRepository.getEvents(forceRefresh: forceRefresh); 
      _myEvents = events.where((e) => e.userJoined).toList();
      if (_myEvents.isEmpty) {
        emit(MyEventsState(loading: false, showCreateButton: _showCreateButton, error: MyEventsEffectType.emptyList));
      } else {
        emit(MyEventsState(loading: false, showCreateButton: _showCreateButton, eventList: _myEvents.toHomeTabUiList()));
      }
    } catch (e) {
      if (e.toString().contains('network') || e.toString().contains('connection')) {
        _effectController.add(MyEventsEffectShowNoNetworkPrompt());
      }
      emit(MyEventsState(loading: false, showCreateButton: _showCreateButton, error: MyEventsEffectType.unknown));
    }
  }

  void onEventClick(String eventId) {
    final eventFound = _myEvents.where((e) => e.id == eventId).firstOrNull;
    if (eventFound != null) {
      final eventEncoded = eventFound.copyWith(description: Uri.encodeComponent(eventFound.description));
      _effectController.add(MyEventsEffectNavigateToEventDetail(eventEncoded));
    }
  }

  void signIn() {
    _effectController.add(MyEventsEffectNavigateToSignIn());
  }

  @override
  Future<void> close() {
    _effectController.close();
    return super.close();
  }
}
