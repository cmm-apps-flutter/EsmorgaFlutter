import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esmorga_flutter/view/events/event_create/model/event_type.dart';

part 'create_event_state.dart';

sealed class CreateEventEffect {}

class CreateEventEffectNavigateToNextStep extends CreateEventEffect {
  final String eventName;
  final String description;
  CreateEventEffectNavigateToNextStep(this.eventName, this.description);
}

class CreateEventEffectNavigateToTypeStep extends CreateEventEffect {
  final String eventName;
  final String description;
  final EventType eventType;
  CreateEventEffectNavigateToTypeStep(this.eventName, this.description, this.eventType);
}

class CreateEventCubit extends Cubit<CreateEventState> {
  final AppLocalizations l10n;

  final _effectController = StreamController<CreateEventEffect>.broadcast();
  Stream<CreateEventEffect> get effects => _effectController.stream;

  CreateEventCubit({required this.l10n}) : super(const CreateEventState());

  void updateEventName(String name) {
    String? error;
    if (name.isEmpty) {
      error = l10n.inlineErrorEmptyField;
    } else if (name.length < 3 || name.length > 100) {
      error = l10n.inlineErrorInvalidLengthName;
    }

    emit(state.copyWith(
      eventName: name,
      eventNameError: error,
    ));
  }

  void updateDescription(String desc) {
    String? error;
    if (desc.isEmpty) {
      error = l10n.inlineErrorEmptyField;
    } else if (desc.length < 4 || desc.length > 5000) {
      error = l10n.inlineErrorInvalidLengthDescription;
    }

    emit(state.copyWith(
      description: desc,
      descriptionError: error,
    ));
  }

  void updateEventType(EventType type) {
    emit(state.copyWith(eventType: type));
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

  bool get isFormValid =>
      state.eventName.isNotEmpty &&
      state.eventNameError == null &&
      state.description.isNotEmpty &&
      state.descriptionError == null &&
      state.eventType != null;

  void submit() {
    _effectController.add(CreateEventEffectNavigateToNextStep(state.eventName, state.description));
  }

  @override
  Future<void> close() {
    _effectController.close();
    return super.close();
  }
}
