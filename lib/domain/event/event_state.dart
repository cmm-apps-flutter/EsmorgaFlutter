
part of 'event_bloc.dart';

sealed class EventState {}

class EventInitialState implements EventState {}

class EventLoadingState implements EventState {}

class EventLoadSuccessState extends Equatable implements EventState  {
  final List<EventRemoteModel> events;

  const EventLoadSuccessState(this.events);

  @override
  List<Object?> get props => events;
}

class EventLoadFailureState extends Equatable implements EventState {
  final String error;

  const EventLoadFailureState(this.error);

  @override
  List<Object?> get props => [error];
}
