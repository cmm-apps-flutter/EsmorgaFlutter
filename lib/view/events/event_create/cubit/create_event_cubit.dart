import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/domain/error/exceptions.dart';
import 'package:esmorga_flutter/domain/event/model/create_event_params.dart';
import 'package:esmorga_flutter/domain/event/model/event_type.dart';
import 'package:esmorga_flutter/domain/event/usecase/create_event_use_case.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:esmorga_flutter/view/util/esmorga_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_event_state.dart';

sealed class CreateEventEffect {}

const minimumDescriptionLength = 20;
const maximumDescriptionLength = 5000;
const maximumEventNameLength = 100;
const minimumEventNameLength = 3;
const maximumLocationLength = 100;
const minimumMaxCapacity = 1;
const maximumMaxCapacity = 5000;

class EventCreationData {
  final String eventName;
  final String description;
  final EventType? eventType;
  final String? formattedEventDate;
  final String? location;
  final String? coordinates;
  final int? maxCapacity;
  final String? eventImageUrl;

  const EventCreationData({
    required this.eventName,
    required this.description,
    this.eventType,
    this.formattedEventDate,
    this.location,
    this.coordinates,
    this.maxCapacity,
    this.eventImageUrl,
  });

  factory EventCreationData.fromState(
    CreateEventState state, {
    String? formattedEventDate,
  }) {
    final parsedMaxCapacity = int.tryParse(state.maxCapacity);
    return EventCreationData(
      eventName: state.eventName,
      description: state.description,
      eventType: state.eventType,
      formattedEventDate: formattedEventDate ?? state.formattedEventDate,
      location: state.location.isEmpty ? null : state.location,
      coordinates: state.coordinates.isEmpty ? null : state.coordinates,
      maxCapacity: parsedMaxCapacity,
      eventImageUrl: state.eventImageUrl.isEmpty ? null : state.eventImageUrl,
    );
  }
}

class CreateEventNavigateToEventTypeEffect extends CreateEventEffect {
  final EventCreationData eventData;

  CreateEventNavigateToEventTypeEffect({
    required this.eventData,
  });
}

class CreateEventDateConfirmedEffect extends CreateEventEffect {
  final EventCreationData eventData;

  CreateEventDateConfirmedEffect({
    required this.eventData,
  });
}

class CreateEventLocationConfirmedEffect extends CreateEventEffect {
  final EventCreationData eventData;

  CreateEventLocationConfirmedEffect({
    required this.eventData,
  });
}

class CreateEventSuccessEffect extends CreateEventEffect {}

class CreateEventGenericErrorEffect extends CreateEventEffect {}

class CreateEventNoInternetEffect extends CreateEventEffect {}

class CreateEventCubit extends Cubit<CreateEventState> {
  final AppLocalizations l10n;
  final EsmorgaDateTimeFormatter dateTimeFormatter;
  final EsmorgaClock clock;
  final Future<bool> Function(String url) imageLoader;
  final CreateEventUseCase createEventUseCase;

  final _effectController = StreamController<CreateEventEffect>.broadcast();
  Stream<CreateEventEffect> get effects => _effectController.stream;

  CreateEventCubit({
    required this.l10n,
    required this.dateTimeFormatter,
    required this.clock,
    required this.imageLoader,
    required this.createEventUseCase,
  }) : super(const CreateEventState());

  void initFromEventData(EventCreationData eventData) {
    emit(state.copyWith(
      eventName: eventData.eventName,
      description: eventData.description,
      eventType: eventData.eventType,
      formattedEventDate: eventData.formattedEventDate,
      location: eventData.location ?? '',
      coordinates: eventData.coordinates ?? '',
      maxCapacity: eventData.maxCapacity?.toString() ?? '',
      eventImageUrl: eventData.eventImageUrl ?? '',
    ));
  }

  DateTime get currentDate => clock.now();

  void initializeEventDate() {
    final today = currentDate;
    updateEventDate(DateTime(today.year, today.month, today.day));
  }

  void updateEventName(String name) {
    String? error;
    if (name.isEmpty) {
      error = l10n.inlineErrorEmptyField;
    } else if (name.length < minimumEventNameLength || name.length > maximumEventNameLength) {
      error = l10n.inlineErrorInvalidLengthName;
    }

    emit(state.copyWith(
      eventName: name,
      eventNameError: error,
      clearNameError: error == null,
    ));
  }

  void updateDescription(String desc) {
    String? error;
    if (desc.isEmpty) {
      error = l10n.inlineErrorEmptyField;
    } else if (desc.length < minimumDescriptionLength || desc.length > maximumDescriptionLength) {
      error = l10n.inlineErrorInvalidLengthDescription;
    }

    emit(state.copyWith(
      description: desc,
      descriptionError: error,
      clearDescriptionError: error == null,
    ));
  }

  void updateEventType(EventType type) {
    emit(state.copyWith(eventType: type));
  }

  void updateEventDate(DateTime date) {
    final dateTimeError = _validateDateTimeInPast(date, state.eventTime);
    emit(state.copyWith(
      eventDate: date,
      eventDateError: dateTimeError,
      clearDateError: dateTimeError == null,
    ));
  }

  void updateEventTime(TimeOfDay time) {
    final timeError = _validateDateTimeInPast(state.eventDate, time);
    emit(state.copyWith(
      eventTime: time,
      eventDateError: timeError,
      clearDateError: timeError == null,
    ));
  }

  String? _validateDateTimeInPast(DateTime? date, TimeOfDay? time) {
    if (date == null) return null;
    final now = clock.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    if (date.isBefore(startOfToday)) {
      return l10n.inlineErrorEventDatePast;
    }
    if (time == null) return null;
    final isToday = date.year == startOfToday.year &&
        date.month == startOfToday.month &&
        date.day == startOfToday.day;
    if (!isToday) return null;
    final selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    if (selectedDateTime.isBefore(now)) {
      return l10n.inlineErrorEventTimePast;
    }
    return null;
  }

  void clearDateAndTime() {
    emit(state.copyWith(clearDate: true, clearTime: true));
  }

  String? get formattedEventTime {
    if (state.eventTime == null) return null;
    final time = state.eventTime!;
    final hourString = time.hour.toString().padLeft(2, '0');
    final minuteString = time.minute.toString().padLeft(2, '0');
    return '$hourString:$minuteString';
  }

  String? getFormattedEventDate() {
    if (state.eventDate == null || state.eventTime == null) return null;
    final time = dateTimeFormatter.formatTimeWithMillisUtcSuffix(
      state.eventTime!.hour,
      state.eventTime!.minute,
    );
    return dateTimeFormatter.formatIsoDateTime(state.eventDate!, time);
  }

  bool canProceedFromScreen1() {
    return state.eventName.isNotEmpty &&
        state.eventNameError == null &&
        state.description.isNotEmpty &&
        state.descriptionError == null;
  }

  bool canProceedFromScreen2() {
    return state.eventType != null;
  }

  bool canProceedFromScreen3() {
    return state.eventDate != null &&
        state.eventTime != null &&
        state.eventDateError == null;
  }

  bool canProceedFromScreen4() {
    return state.location.isNotEmpty &&
        state.locationError == null &&
        state.coordinatesError == null &&
        state.maxCapacityError == null;
  }

  bool get isFormValid =>
      state.eventName.isNotEmpty &&
      state.eventNameError == null &&
      state.description.isNotEmpty &&
      state.descriptionError == null &&
      state.eventType != null &&
      state.eventDate != null &&
      state.eventTime != null &&
      state.eventDateError == null &&
      state.location.isNotEmpty &&
      state.locationError == null &&
      state.coordinatesError == null &&
      state.maxCapacityError == null;

  void submit() {
    _effectController.add(CreateEventNavigateToEventTypeEffect(
      eventData: EventCreationData.fromState(state),
    ));
  }

  void submitDateStep() {
    final formattedDate = getFormattedEventDate();
    if (formattedDate == null) return;
    emit(state.copyWith(formattedEventDate: formattedDate));
    _effectController.add(CreateEventDateConfirmedEffect(
      eventData: EventCreationData.fromState(
        state,
        formattedEventDate: formattedDate,
      ),
    ));
  }

  static final _coordinatesRegExp = RegExp(r'^\s*-?\d+\.?\d*\s*,\s*-?\d+\.?\d*\s*$');
  static final _locationCharsRegExp = RegExp(r"^[\p{L}\p{N}\s.,\-'\/#ºª°]+$", unicode: true);

  void updateLocation(String value) {
    final trimmedValue = value.trim();
    String? error;
    if (trimmedValue.isEmpty) {
      error = l10n.inlineErrorLocationRequired;
    } else if (!_locationCharsRegExp.hasMatch(trimmedValue)) {
      error = l10n.inlineErrorLocationInvalidChars;
    }
    emit(state.copyWith(
      location: trimmedValue,
      locationError: error,
      clearLocationError: error == null,
    ));
  }

  void updateCoordinates(String value) {
    String? error;
    if (value.isNotEmpty) {
      if (!_coordinatesRegExp.hasMatch(value)) {
        error = l10n.inlineErrorCoordinatesInvalid;
      } else {
        final parsed = _parseCoordinates(value);
        if (parsed == null) {
          error = l10n.inlineErrorCoordinatesOutOfBounds;
        }
      }
    }
    emit(state.copyWith(
      coordinates: value,
      coordinatesError: error,
      clearCoordinatesError: error == null,
    ));
  }

  void updateMaxCapacity(String value) {
    String? error;
    if (value.isNotEmpty) {
      final parsed = int.tryParse(value);
      if (parsed == null || parsed < minimumMaxCapacity || parsed > maximumMaxCapacity) {
        error = l10n.inlineErrorMaxCapacityInvalid;
      }
    }
    emit(state.copyWith(
      maxCapacity: value,
      maxCapacityError: error,
      clearMaxCapacityError: error == null,
    ));
  }

  void updateFormattedEventDate(String date) {
    emit(state.copyWith(formattedEventDate: date));
  }

  void submitLocationStep() {
    final formattedDate = state.formattedEventDate ?? getFormattedEventDate();
    if (formattedDate == null) return;
    _effectController.add(CreateEventLocationConfirmedEffect(
      eventData: EventCreationData.fromState(
        state,
        formattedEventDate: formattedDate,
      ),
    ));
  }

  static final _imageUrlRegExp = RegExp(
    r'^https://.+\.(jpg|jpeg|png|webp)(\?.*)?$',
    caseSensitive: false,
  );

  Future<void> validateAndPreviewImageUrl(String url) async {
    final trimmedUrl = url.trim();
    if (trimmedUrl.isEmpty) {
      emit(state.copyWith(eventImageUrlError: l10n.inlineErrorImageUrlRequired));
      return;
    }
    if (!_imageUrlRegExp.hasMatch(trimmedUrl)) {
      emit(state.copyWith(eventImageUrlError: l10n.inlineErrorImageUrlRequired));
      return;
    }
    final bool imageLoaded;
    try {
      imageLoaded = await imageLoader(trimmedUrl);
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(eventImageUrlError: l10n.inlineErrorImageUrlRequired));
      return;
    }
    if (isClosed) return;
    if (!imageLoaded) {
      emit(state.copyWith(eventImageUrlError: l10n.inlineErrorImageUrlRequired));
      return;
    }
    emit(state.copyWith(
      eventImageUrl: trimmedUrl,
      clearEventImageUrlError: true,
    ));
  }

  void clearEventImageUrl() {
    emit(state.copyWith(
      eventImageUrl: '',
      clearEventImageUrlError: true,
    ));
  }

  ({double lat, double lng})? _parseCoordinates(String raw) {
    if (raw.isEmpty) return null;
    if (!_coordinatesRegExp.hasMatch(raw)) return null;
    final parts = raw.split(',');
    if (parts.length < 2) return null;
    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    if (lat == null || lng == null) return null;
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return null;
    return (lat: lat, lng: lng);
  }

  Future<void> submitImageStep() async {
    if (state.submitting) return;

    final eventDate = state.formattedEventDate;
    if (eventDate == null) return;

    if (state.eventType == null) return;

    emit(state.copyWith(submitting: true));

    final parsedCoordinates = _parseCoordinates(state.coordinates);
    final eventParams = CreateEventParams(
      eventName: state.eventName.trim(),
      eventDate: eventDate,
      description: state.description.trim(),
      eventType: state.eventType!,
      imageUrl: state.eventImageUrl.isNotEmpty ? state.eventImageUrl : null,
      locationName: state.location.trim(),
      locationLat: parsedCoordinates?.lat,
      locationLong: parsedCoordinates?.lng,
      maxCapacity: int.tryParse(state.maxCapacity),
    );

    try {
      await createEventUseCase.execute(eventParams);
      if (isClosed) return;
      emit(state.copyWith(submitting: false));
      _effectController.add(CreateEventSuccessEffect());
    } on NetworkException {
      if (isClosed) return;
      emit(state.copyWith(submitting: false));
      _effectController.add(CreateEventNoInternetEffect());
    } on EsmorgaException {
      if (isClosed) return;
      emit(state.copyWith(submitting: false));
      _effectController.add(CreateEventGenericErrorEffect());
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(submitting: false));
      _effectController.add(CreateEventGenericErrorEffect());
    }
  }

  @override
  Future<void> close() {
    _effectController.close();
    return super.close();
  }
}
