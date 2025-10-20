part of 'my_events_cubit.dart';

enum MyEventsEffectType { notLoggedIn, emptyList, unknown }

class MyEventsState extends Equatable {
  final bool loading;
  final List<EventListUiModel> eventList;
  final MyEventsEffectType? error;
  const MyEventsState({ this.loading = false, this.eventList = const [], this.error });
  @override
  List<Object?> get props => [loading, eventList, error];
}

