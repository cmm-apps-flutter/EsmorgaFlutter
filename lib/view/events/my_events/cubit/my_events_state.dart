part of 'my_events_cubit.dart';

enum MyEventsEffectType { notLoggedIn, emptyList, unknown }

class MyEventsState extends Equatable {
  final bool loading;
  final bool isAdmin;
  final List<HomeTabUiModel> eventList;
  final MyEventsEffectType? error;
  const MyEventsState({this.loading = false, this.isAdmin =false, this.eventList = const [], this.error});
  @override
  List<Object?> get props => [loading, isAdmin, eventList, error];
}
