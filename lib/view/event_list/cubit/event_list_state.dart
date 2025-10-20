part of 'event_list_cubit.dart';

sealed class EventListState extends Equatable {
  const EventListState();
  @override
  List<Object?> get props => [];
}

class EventListInitial extends EventListState {
  const EventListInitial();
}

class EventListLoading extends EventListState {
  const EventListLoading();
}

class EventListEmpty extends EventListState {
  const EventListEmpty();
}

class EventListShowNoNetwork extends EventListState {
  const EventListShowNoNetwork();
}

class EventListLoadFailure extends EventListState {
  final String message;
  const EventListLoadFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class EventListLoadSuccess extends EventListState {
  final List<EventListUiModel> events;
  const EventListLoadSuccess(this.events);
  @override
  List<Object?> get props => [events];
}
