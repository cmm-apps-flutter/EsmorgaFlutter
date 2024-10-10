
part of 'event_bloc.dart';

sealed class EventState {}

class EventInitialState extends EventState {}

class EventLoadingState extends EventState {}

class EventLoadSuccessState extends EventState {
  final List<EventRemoteModel> events;

  EventLoadSuccessState(this.events);
}

class EventLoadFailureState extends EventState {
  final String error;

  EventLoadFailureState(this.error);
}