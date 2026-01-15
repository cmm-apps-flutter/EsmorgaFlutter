import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/login/cubit/login_state.dart';
import 'package:esmorga_flutter/view/validation/form_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserRepository userRepository;
  final FormValidator validator;

  LoginCubit({
    required this.userRepository,
    required this.validator,
    String? initialMessage,
  }) : super(LoginState(initMessage: initialMessage));

final l10n = getIt<LocalizationService>().current;
  bool get _validateEmail => state.attemptedSubmit || state.emailBlurred;
  bool get _validatePassword => state.attemptedSubmit || state.passwordBlurred;

  void changeEmail(String email) {
    final emailError = _validateEmail
        ? validator.validateEmail(email, acceptsEmpty: !state.attemptedSubmit)
        : null;
    emit(state.copyWith(email: email, emailError: emailError));
  }

  void changePassword(String password) {
    final passwordError = _validatePassword
        ? validator.validatePassword(password, acceptsEmpty: !state.attemptedSubmit)
        : null;
    emit(state.copyWith(password: password, passwordError: passwordError));
  }

  void blurEmail() {
    final error = validator.validateEmail(state.email, acceptsEmpty: false);
    emit(state.copyWith(emailBlurred: true, emailError: error));
  }

  void blurPassword() {
    final error = validator.validatePassword(state.password, acceptsEmpty: false);
    emit(state.copyWith(passwordBlurred: true, passwordError: error));
  }

  void consumeInitMessage() {
    emit(state.copyWith(initMessage: null));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  Future<void> submit() async {
    final emailError = validator.validateEmail(state.email, acceptsEmpty: false);
    final passwordError = validator.validatePassword(state.password, acceptsEmpty: false);
    final validated = state.copyWith(
      attemptedSubmit: true,
      emailBlurred: true,
      passwordBlurred: true,
      emailError: emailError,
      passwordError: passwordError,
    );
    if (!validated.isFormValid) {
      emit(validated);
      return;
    }
    emit(validated.copyWith(status: LoginStatus.submitting));
    try {
      await userRepository.login(state.email.trim(), state.password);
      emit(validated.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(validated.copyWith(status: LoginStatus.failure, failureMessage: l10n.loginError));
    }
  }
}

