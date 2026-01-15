import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/registration/cubit/register_state.dart';
import 'package:esmorga_flutter/view/validation/form_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final UserRepository userRepository;
  final FormValidator validator;

  RegisterCubit({
    required this.userRepository,
    required this.validator,
  }) : super(const RegisterState());

  bool get _shouldValidateName => state.attemptedSubmit || state.nameBlurred;
  bool get _shouldValidateLastName => state.attemptedSubmit || state.lastNameBlurred;
  bool get _shouldValidateEmail => state.attemptedSubmit || state.emailBlurred;
  bool get _shouldValidatePassword => state.attemptedSubmit || state.passwordBlurred;
  bool get _shouldValidateRepeatPassword => state.attemptedSubmit || state.repeatPasswordBlurred;

  void onNameChanged(String name) {
    final nameError = _shouldValidateName ? validator.validateName(name, acceptsEmpty: !state.attemptedSubmit) : null;
    emit(state.copyWith(name: name, nameError: nameError, failureMessage: null, successEmail: null));
  }

  void onLastNameChanged(String lastName) {
    final error = _shouldValidateLastName ? validator.validateLastName(lastName, acceptsEmpty: !state.attemptedSubmit) : null;
    emit(state.copyWith(lastName: lastName, lastNameError: error, failureMessage: null, successEmail: null));
  }

  void onEmailChanged(String email) {
    final error = _shouldValidateEmail ? validator.validateEmail(email, acceptsEmpty: !state.attemptedSubmit) : null;
    emit(state.copyWith(email: email, emailError: error, failureMessage: null, successEmail: null));
  }

  void onPasswordChanged(String password) {
    final passError = _shouldValidatePassword ? validator.validatePassword(password, acceptsEmpty: !state.attemptedSubmit) : null;
    final repeatError = _shouldValidateRepeatPassword ? validator.validateRepeatPassword(state.repeatPassword, password, acceptsEmpty: !state.attemptedSubmit) : null;
    emit(state.copyWith(password: password, passwordError: passError, repeatPasswordError: repeatError, failureMessage: null, successEmail: null));
  }

  void onRepeatPasswordChanged(String repeatPassword) {
    final repeatError = _shouldValidateRepeatPassword ? validator.validateRepeatPassword(repeatPassword, state.password, acceptsEmpty: !state.attemptedSubmit) : null;
    emit(state.copyWith(repeatPassword: repeatPassword, repeatPasswordError: repeatError, failureMessage: null, successEmail: null));
  }

  void onNameUnfocused() {
    final err = validator.validateName(state.name, acceptsEmpty: false);
    emit(state.copyWith(nameBlurred: true, nameError: err));
  }
  void onLastNameUnfocused() {
    final err = validator.validateLastName(state.lastName, acceptsEmpty: false);
    emit(state.copyWith(lastNameBlurred: true, lastNameError: err));
  }
  void onEmailUnfocused() {
    final err = validator.validateEmail(state.email, acceptsEmpty: false);
    emit(state.copyWith(emailBlurred: true, emailError: err));
  }
  void onPasswordUnfocused() {
    final err = validator.validatePassword(state.password, acceptsEmpty: false);
    final repeatErr = state.repeatPasswordBlurred ? validator.validateRepeatPassword(state.repeatPassword, state.password, acceptsEmpty: false) : state.repeatPasswordError;
    emit(state.copyWith(passwordBlurred: true, passwordError: err, repeatPasswordError: repeatErr));
  }
  void onRepeatPasswordUnfocused() {
    final err = validator.validateRepeatPassword(state.repeatPassword, state.password, acceptsEmpty: false);
    emit(state.copyWith(repeatPasswordBlurred: true, repeatPasswordError: err));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  Future<void> submit() async {
    final nameError = validator.validateName(state.name, acceptsEmpty: false);
    final lastNameError = validator.validateLastName(state.lastName, acceptsEmpty: false);
    final emailError = validator.validateEmail(state.email, acceptsEmpty: false);
    final passwordError = validator.validatePassword(state.password, acceptsEmpty: false);
    final repeatPasswordError = validator.validateRepeatPassword(state.repeatPassword, state.password, acceptsEmpty: false);

    final withValidation = state.copyWith(
      attemptedSubmit: true,
      nameError: nameError,
      lastNameError: lastNameError,
      emailError: emailError,
      passwordError: passwordError,
      repeatPasswordError: repeatPasswordError,
      nameBlurred: true,
      lastNameBlurred: true,
      emailBlurred: true,
      passwordBlurred: true,
      repeatPasswordBlurred: true,
      failureMessage: null,
      successEmail: null,
    );

    if (!withValidation.isValid) {
      emit(withValidation);
      return;
    }

    emit(withValidation.copyWith(status: RegisterStatus.submitting));
    try {
      await userRepository.register(
        state.name.trim(),
        state.lastName.trim(),
        state.email.trim(),
        state.password,
      );
      emit(withValidation.copyWith(status: RegisterStatus.success, successEmail: state.email.trim()));
    } catch (e) {
      emit(withValidation.copyWith(status: RegisterStatus.failure, failureMessage: e.toString()));
    }
  }
}
