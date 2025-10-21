import 'package:bloc/bloc.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/password/reset_password_state.dart';
import 'package:esmorga_flutter/view/validation/form_validator.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final UserRepository userRepository;
  final FormValidator validator;
  final String? code;

  ResetPasswordCubit({required this.userRepository, required this.validator, required this.code}) : super(const ResetPasswordState());

  bool get _validateNew => state.newBlurred || state.attemptedSubmit;

  bool get _validateRepeat => state.repeatBlurred || state.attemptedSubmit;
  final l10n = getIt<LocalizationService>().current;

  void onNewChanged(String value) {
    final err = _validateNew ? _validateNewPassword(value) : null;
    final repeatErr = state.repeatPassword.isEmpty ? state.repeatError : _validateRepeatPassword(state.repeatPassword, value);
    emit(state.copyWith(newPassword: value, newError: err, repeatError: repeatErr));
  }

  void onRepeatChanged(String value) {
    final err = _validateRepeat ? _validateRepeatPassword(value, state.newPassword) : null;
    emit(state.copyWith(repeatPassword: value, repeatError: err));
  }

  void onNewUnfocused() {
    final err = _validateNewPassword(state.newPassword);
    emit(state.copyWith(newBlurred: true, newError: err));
  }

  void onRepeatUnfocused() {
    final err = _validateRepeatPassword(state.repeatPassword, state.newPassword);
    emit(state.copyWith(repeatBlurred: true, repeatError: err));
  }

  Future<void> submit() async {
    final newErr = _validateNewPassword(state.newPassword);
    final repeatErr = _validateRepeatPassword(state.repeatPassword, state.newPassword);
    var newState = state.copyWith(
      attemptedSubmit: true,
      newBlurred: true,
      repeatBlurred: true,
      newError: newErr,
      repeatError: repeatErr,
    );
    if (!newState.isFormValid || code == null || code!.isEmpty) {
      emit(newState.copyWith(codeInvalid: code == null || code!.isEmpty));
      return;
    }
    emit(newState.copyWith(status: ResetPasswordStatus.submitting));
    try {
      await userRepository.resetPassword(code!, state.newPassword);
      emit(newState.copyWith(status: ResetPasswordStatus.success));
    } catch (err) {
      final msg = err.toString().toLowerCase();
      final isNetwork = msg.contains('network') || msg.contains('connection');
      emit(newState.copyWith(status: ResetPasswordStatus.failure, networkFailure: isNetwork));
    }
  }

  String? _validateNewPassword(String v) {
    if (v.isEmpty) return l10n.inlineErrorEmptyField;
    return validator.validatePassword(v, acceptsEmpty: false);
  }

  String? _validateRepeatPassword(String v, String newP) {
    if (v.isEmpty) return l10n.inlineErrorEmptyField;
    if (v != newP) {
      return l10n.inlineErrorPasswordMismatch;
    }
    return null;
  }
}
