import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/view/home_tab/model/home_tab_ui_model.dart';
import 'package:esmorga_flutter/view/home_tab/model/poll_ui_model.dart';

class HomeTabState extends Equatable {
  final bool loading;
  final List<HomeTabUiModel> eventList;
  final List<PollUiModel> pollList;
  final String? error;
  final bool showNoNetworkPrompt;

  const HomeTabState({
    this.loading = false,
    this.eventList = const [],
    this.pollList = const [],
    this.error,
    this.showNoNetworkPrompt = false,
  });

  static const _noChange = Object();

  HomeTabState copyWith({
    bool? loading,
    List<HomeTabUiModel>? eventList,
    List<PollUiModel>? pollList,
    Object? error = _noChange,
    bool? showNoNetworkPrompt,
  }) {
    return HomeTabState(
      loading: loading ?? this.loading,
      eventList: eventList ?? this.eventList,
      pollList: pollList ?? this.pollList,
      error: identical(error, _noChange) ? this.error : (error as String?),
      showNoNetworkPrompt: showNoNetworkPrompt ?? this.showNoNetworkPrompt,
    );
  }

  @override
  List<Object?> get props => [loading, eventList, pollList, error, showNoNetworkPrompt];
}
