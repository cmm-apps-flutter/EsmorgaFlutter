part of 'create_event_cubit.dart';

class CreateEventState extends Equatable {
  final String eventName;
  final String description;
  final EventType? eventType;
  final String? eventNameError;
  final String? descriptionError;
  final DateTime? eventDate;
  final TimeOfDay? eventTime;
  final String? eventDateError;
  final String? formattedEventDate;
  final bool joinDeadlineEnabled;
  final DateTime? joinDeadlineDate;
  final TimeOfDay? joinDeadlineTime;
  final String? joinDeadlineError;
  final String? formattedJoinDeadline;
  final String location;
  final String coordinates;
  final String maxCapacity;
  final String? locationError;
  final String? coordinatesError;
  final double? parsedLatitude;
  final double? parsedLongitude;
  final String? maxCapacityError;
  final String eventImageUrl;
  final String? eventImageUrlError;
  final bool submitting;

  const CreateEventState({
    this.eventName = '',
    this.description = '',
    this.eventType = EventType.party,
    this.eventNameError,
    this.descriptionError,
    this.eventDate,
    this.eventTime,
    this.eventDateError,
    this.formattedEventDate,
    this.joinDeadlineEnabled = false,
    this.joinDeadlineDate,
    this.joinDeadlineTime,
    this.joinDeadlineError,
    this.formattedJoinDeadline,
    this.location = '',
    this.coordinates = '',
    this.maxCapacity = '',
    this.locationError,
    this.coordinatesError,
    this.parsedLatitude,
    this.parsedLongitude,
    this.maxCapacityError,
    this.eventImageUrl = '',
    this.eventImageUrlError,
    this.submitting = false,
  });

  CreateEventState copyWith({
    String? eventName,
    String? description,
    EventType? eventType,
    String? eventNameError,
    String? descriptionError,
    DateTime? eventDate,
    TimeOfDay? eventTime,
    String? eventDateError,
    String? formattedEventDate,
    bool? joinDeadlineEnabled,
    DateTime? joinDeadlineDate,
    TimeOfDay? joinDeadlineTime,
    String? joinDeadlineError,
    String? formattedJoinDeadline,
    String? location,
    String? coordinates,
    String? maxCapacity,
    String? locationError,
    String? coordinatesError,
    double? parsedLatitude,
    double? parsedLongitude,
    String? maxCapacityError,
    String? eventImageUrl,
    String? eventImageUrlError,
    bool? submitting,
    bool clearDate = false,
    bool clearTime = false,
    bool clearNameError = false,
    bool clearDescriptionError = false,
    bool clearDateError = false,
    bool clearLocationError = false,
    bool clearCoordinatesError = false,
    bool clearParsedCoordinates = false,
    bool clearMaxCapacityError = false,
    bool clearEventImageUrlError = false,
    bool clearJoinDeadline = false,
    bool clearJoinDeadlineError = false,
  }) {
    return CreateEventState(
      eventName: eventName ?? this.eventName,
      description: description ?? this.description,
      eventType: eventType ?? this.eventType,
      eventNameError: clearNameError ? null : (eventNameError ?? this.eventNameError),
      descriptionError: clearDescriptionError ? null : (descriptionError ?? this.descriptionError),
      eventDate: clearDate ? null : (eventDate ?? this.eventDate),
      eventTime: clearTime ? null : (eventTime ?? this.eventTime),
      eventDateError: clearDateError ? null : (eventDateError ?? this.eventDateError),
      formattedEventDate: formattedEventDate ?? this.formattedEventDate,
      joinDeadlineEnabled: joinDeadlineEnabled ?? this.joinDeadlineEnabled,
      joinDeadlineDate: clearJoinDeadline ? null : (joinDeadlineDate ?? this.joinDeadlineDate),
      joinDeadlineTime: clearJoinDeadline ? null : (joinDeadlineTime ?? this.joinDeadlineTime),
      joinDeadlineError: clearJoinDeadlineError ? null : (joinDeadlineError ?? this.joinDeadlineError),
      formattedJoinDeadline: clearJoinDeadline ? null : (formattedJoinDeadline ?? this.formattedJoinDeadline),
      location: location ?? this.location,
      coordinates: coordinates ?? this.coordinates,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      locationError: clearLocationError ? null : (locationError ?? this.locationError),
      coordinatesError: clearCoordinatesError ? null : (coordinatesError ?? this.coordinatesError),
      parsedLatitude: clearParsedCoordinates ? null : (parsedLatitude ?? this.parsedLatitude),
      parsedLongitude: clearParsedCoordinates ? null : (parsedLongitude ?? this.parsedLongitude),
      maxCapacityError: clearMaxCapacityError ? null : (maxCapacityError ?? this.maxCapacityError),
      eventImageUrl: eventImageUrl ?? this.eventImageUrl,
      eventImageUrlError: clearEventImageUrlError ? null : (eventImageUrlError ?? this.eventImageUrlError),
      submitting: submitting ?? this.submitting,
    );
  }

  @override
  List<Object?> get props => [eventName, description, eventType, eventNameError, descriptionError, eventDate, eventTime, eventDateError, formattedEventDate, joinDeadlineEnabled, joinDeadlineDate, joinDeadlineTime, joinDeadlineError, formattedJoinDeadline, location, coordinates, maxCapacity, locationError, coordinatesError, parsedLatitude, parsedLongitude, maxCapacityError, eventImageUrl, eventImageUrlError, submitting];
}
