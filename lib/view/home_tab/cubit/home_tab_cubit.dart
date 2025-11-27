import 'dart:async';

import 'package:esmorga_flutter/domain/event/event_repository.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/view/home_tab/cubit/home_tab_effect.dart';
import 'package:esmorga_flutter/view/home_tab/cubit/home_tab_state.dart';
import 'package:esmorga_flutter/view/home_tab/mapper/home_tab_ui_mapper.dart';
import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/domain/poll/usecase/get_polls_use_case.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/home_tab/mapper/poll_ui_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTabCubit extends Cubit<HomeTabState> {
  final EventRepository eventRepository;
  final GetPollsUseCase getPollsUseCase;
  final UserRepository userRepository;

  final _effectController = StreamController<HomeTabEffect>.broadcast();
  Stream<HomeTabEffect> get effects => _effectController.stream;

  List<Event> _events = [];
  List<Poll> _polls = [];

  HomeTabCubit({
    required this.eventRepository,
    required this.getPollsUseCase,
    required this.userRepository,
  }) : super(const HomeTabState());

  Future<void> loadEvents() async => _load();
  Future<void> retry() async => _load();

  Future<void> _load() async {
    emit(state.copyWith(loading: true, error: null, showNoNetworkPrompt: false));
    try {
      final eventsFuture = eventRepository.getEvents();

      bool isAuthenticated = false;
      try {
        await userRepository.getUser();
        isAuthenticated = true;
      } catch (_) {
        isAuthenticated = false;
      }

      Future<List<Poll>> pollsFuture;
      if (isAuthenticated) {
        pollsFuture = getPollsUseCase();
      } else {
        pollsFuture = Future.value([]);
      }

      final results = await Future.wait([eventsFuture, pollsFuture]);
      _events = results[0] as List<Event>;
      _polls = results[1] as List<Poll>;

      emit(state.copyWith(
        loading: false,
        eventList: _events.toHomeTabUiList(),
        pollList: _polls.toPollUiList(),
        error: null,
        showNoNetworkPrompt: false,
      ));
    } catch (e) {
      final msg = e.toString();
      final isNetwork = msg.contains('network') || msg.contains('connection');
      emit(state.copyWith(
          loading: false, eventList: const [], pollList: const [], error: msg, showNoNetworkPrompt: isNetwork));
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

  void onPollClicked(String id) {
    final polls = _polls.where((p) => p.id == id);
    if (polls.isEmpty) return;
    _emitEffect(NavigateToPollDetailsEffect(poll: polls.first));
  }

  void _emitEffect(HomeTabEffect effect) => _effectController.add(effect);

  @override
  Future<void> close() {
    _effectController.close();
    return super.close();
  }
}
