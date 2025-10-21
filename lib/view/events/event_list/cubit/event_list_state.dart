part of 'event_list_cubit.dart';

class EventListState extends Equatable {
  final bool loading;
  final List<EventListUiModel> eventList;
  final String? error;
  final bool showNoNetworkPrompt;

  const EventListState({this.loading = false, this.eventList = const [], this.error, this.showNoNetworkPrompt = false});

  static const _noChange = Object();

  EventListState copyWith({bool? loading, List<EventListUiModel>? eventList, Object? error = _noChange, bool? showNoNetworkPrompt}) {
    return EventListState(
      loading: loading ?? this.loading,
      eventList: eventList ?? this.eventList,
      error: identical(error, _noChange) ? this.error : (error as String?),
      showNoNetworkPrompt: showNoNetworkPrompt ?? this.showNoNetworkPrompt,
    );
  }

  @override
  List<Object?> get props => [loading, eventList, error, showNoNetworkPrompt];
}
