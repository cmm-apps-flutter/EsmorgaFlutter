// view/change_password/cubit/change_password_cubit.dart

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

    final validated = s.copyWith(
      currentTouched: true,
      newTouched: true,
      repeatTouched: true,
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

  void onCurrentChanged(String v) => _emitEditing((s) => s.copyWith(
        currentPassword: v,
        currentErrorKey: s.currentTouched ? _validateCurrent(v) : s.currentErrorKey,
      ));

  void onNewChanged(String v) {
    _emitEditing((s) {
      final newError = s.newTouched ? _validateNew(v, s.currentPassword) : null;
      final repeatError = s.repeatTouched ? _validateRepeat(s.repeatPassword, v) : s.repeatErrorKey;
      return s.copyWith(
        newPassword: v,
        newErrorKey: newError,
        repeatErrorKey: repeatError,
      );
    });
  }

  void onRepeatChanged(String v) => _emitEditing((s) => s.copyWith(
        repeatPassword: v,
        repeatErrorKey: s.repeatTouched ? _validateRepeat(v, s.newPassword) : null,
      ));

  void onCurrentUnfocused() => _touchValidate((s) => s.copyWith(
        currentTouched: true,
        currentErrorKey: _validateCurrent(s.currentPassword),
      ));

  void onNewUnfocused() => _touchValidate((s) => s.copyWith(
        newTouched: true,
        newErrorKey: _validateNew(s.newPassword, s.currentPassword),
      ));

  void onRepeatUnfocused() => _touchValidate((s) => s.copyWith(
        repeatTouched: true,
        repeatErrorKey: _validateRepeat(s.repeatPassword, s.newPassword),
      ));

  void _emitEditing(ChangePasswordEditing Function(ChangePasswordEditing) fn) {
    final s = state is ChangePasswordEditing ? state as ChangePasswordEditing : const ChangePasswordEditing();
    emit(fn(s));
  }

  void _touchValidate(ChangePasswordEditing Function(ChangePasswordEditing) fn) {
    final s = state is ChangePasswordEditing ? state as ChangePasswordEditing : const ChangePasswordEditing();
    emit(fn(s));
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
