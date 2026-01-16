part of 'my_events_cubit.dart';

enum MyEventsEffectType { notLoggedIn, emptyList, unknown }

class MyEventsState extends Equatable {
  final bool loading;
  final bool showCreateButton;
  final List<HomeTabUiModel> eventList;
  final MyEventsEffectType? error;
  const MyEventsState({this.loading = false, this.showCreateButton =false, this.eventList = const [], this.error});
  @override
  List<Object?> get props => [loading, showCreateButton, eventList, error];
}
