part of 'create_event_cubit.dart';

class CreateEventState extends Equatable {
  final String eventName;
  final String description;
  final String? eventNameError;
  final String? descriptionError;

  const CreateEventState({
    this.eventName = '',
    this.description = '',
    this.eventNameError,
    this.descriptionError,
  });

  CreateEventState copyWith({
    String? eventName,
    String? description,
    String? eventNameError,
    String? descriptionError,
  }) {
    return CreateEventState(
      eventName: eventName ?? this.eventName,
      description: description ?? this.description,
      eventNameError: eventNameError,
      descriptionError: descriptionError,
    );
  }

  @override
  List<Object?> get props => [eventName, description, eventNameError, descriptionError];
}
