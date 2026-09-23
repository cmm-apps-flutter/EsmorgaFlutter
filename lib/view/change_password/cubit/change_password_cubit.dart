
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/change_password/cubit/change_password_effect.dart';
import 'package:esmorga_flutter/view/change_password/cubit/change_password_state.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/validation/form_validator.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final UserRepository userRepository;
  final FormValidator validator;

  ChangePasswordCubit({
    required this.userRepository,
    required this.validator,
  }) : super(const ChangePasswordInitial());

  final l10n = getIt<LocalizationService>().current;

  final _effectController = StreamController<ChangePasswordEffect>.broadcast();
  Stream<ChangePasswordEffect> get effects => _effectController.stream;

  void emitEffect(ChangePasswordEffect effect) => _effectController.add(effect);

  Future<void> submit() async {
    final s = state;
    if (s is! ChangePasswordEditing) return;

    final validated = s
        .copyWith(currentTouched: true, newTouched: true, repeatTouched: true)
        .withValidationResult(
          currentErrorKey: _validateCurrent(s.currentPassword),
          newErrorKey: _validateNew(s.newPassword, s.currentPassword),
          repeatErrorKey: _validateRepeat(s.repeatPassword, s.newPassword),
        );
    emit(validated);
    if (!validated.isValid) return;

    emit(validated.copyWith(isSubmitting: true));
    try {
      await userRepository.changePassword(
        s.currentPassword,
        s.newPassword,
      );
      emitEffect(ShowSnackbarEffect(l10n.passwordSetSnackbar, success: true));
    } catch (e) {
      final failure = _mapFailure(e);
      emitEffect(ShowSnackbarEffect(failure));
      emit(validated.copyWith(isSubmitting: false));
    }
  }

  void onCurrentChanged(String v) => _emitEditing((s) {
        final currentErrorKey = s.currentTouched ? _validateCurrent(v) : s.currentErrorKey;
        return s.copyWith(currentPassword: v).withValidationResult(
          currentErrorKey: currentErrorKey,
          newErrorKey: s.newErrorKey,
          repeatErrorKey: s.repeatErrorKey,
        );
      });

  void onNewChanged(String v) {
    _emitEditing((s) {
      final newErrorKey = s.newTouched ? _validateNew(v, s.currentPassword) : s.newErrorKey;
      final repeatErrorKey = s.repeatTouched ? _validateRepeat(s.repeatPassword, v) : s.repeatErrorKey;
      return s.copyWith(newPassword: v).withValidationResult(
        currentErrorKey: s.currentErrorKey,
        newErrorKey: newErrorKey,
        repeatErrorKey: repeatErrorKey,
      );
    });
  }

  void onRepeatChanged(String v) => _emitEditing((s) {
        final repeatErrorKey = s.repeatTouched ? _validateRepeat(v, s.newPassword) : s.repeatErrorKey;
        return s.copyWith(repeatPassword: v).withValidationResult(
          currentErrorKey: s.currentErrorKey,
          newErrorKey: s.newErrorKey,
          repeatErrorKey: repeatErrorKey,
        );
      });

  void onCurrentUnfocused() => _touchValidate((s) {
        final err = _validateCurrent(s.currentPassword);
        return s.copyWith(currentTouched: true).withValidationResult(
          currentErrorKey: err,
          newErrorKey: s.newErrorKey,
          repeatErrorKey: s.repeatErrorKey,
        );
      });

  void onNewUnfocused() => _touchValidate((s) {
        final err = _validateNew(s.newPassword, s.currentPassword);
        return s.copyWith(newTouched: true).withValidationResult(
          currentErrorKey: s.currentErrorKey,
          newErrorKey: err,
          repeatErrorKey: s.repeatErrorKey,
        );
      });

  void onRepeatUnfocused() => _touchValidate((s) {
        final err = _validateRepeat(s.repeatPassword, s.newPassword);
        return s.copyWith(repeatTouched: true).withValidationResult(
          currentErrorKey: s.currentErrorKey,
          newErrorKey: s.newErrorKey,
          repeatErrorKey: err,
        );
      });

  void _emitEditing(ChangePasswordEditing Function(ChangePasswordEditing) fn) {
    final s = state is ChangePasswordEditing ? state as ChangePasswordEditing : const ChangePasswordEditing();
    emit(fn(s));
  }

  void _touchValidate(ChangePasswordEditing Function(ChangePasswordEditing) fn) {
    final s = state is ChangePasswordEditing ? state as ChangePasswordEditing : const ChangePasswordEditing();
    emit(fn(s));
  }

  void toggleCurrentPassword() {
    if (state is ChangePasswordEditing) {
      final s = state as ChangePasswordEditing;
      emit(s.copyWith(showCurrentPassword: !s.showCurrentPassword));
    }
  }

  void toggleNewPassword() {
    if (state is ChangePasswordEditing) {
      final s = state as ChangePasswordEditing;
      emit(s.copyWith(showNewPassword: !s.showNewPassword));
    }
  }

  void toggleRepeatPassword() {
    if (state is ChangePasswordEditing) {
      final s = state as ChangePasswordEditing;
      emit(s.copyWith(showRepeatPassword: !s.showRepeatPassword));
    }
  }

  String? _validateCurrent(String v) {
    if (v.isEmpty) return l10n.inlineErrorEmptyField;
    return validator.validatePassword(v, acceptsEmpty: false);
  }

  String? _validateNew(String v, String current) {
    if (v == current) return l10n.registrationReusedPasswordError;
    return validator.validatePassword(v, acceptsEmpty: false);
  }

  String? _validateRepeat(String v, String newP) {
    return validator.validateRepeatPassword(v, newP, acceptsEmpty: false);
  }

  String _mapFailure(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('network')) return l10n.snackbarNoInternet;
    if (msg.contains('401') || msg.contains('unauthorized')) {
      return l10n.unauthenticatedErrorMessage;
    }
    return l10n.defaultErrorTitle;
  }
}
