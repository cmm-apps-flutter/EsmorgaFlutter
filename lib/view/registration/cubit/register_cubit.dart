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
    emit(
      state
          .clearErrors(failureMessage: true, successEmail: true)
          .copyWith(name: name)
          .withValidationResult(
            nameError: nameError,
            lastNameError: state.lastNameError,
            emailError: state.emailError,
            passwordError: state.passwordError,
            repeatPasswordError: state.repeatPasswordError,
          ),
    );
  }

  void onLastNameChanged(String lastName) {
    final error = _shouldValidateLastName ? validator.validateLastName(lastName, acceptsEmpty: !state.attemptedSubmit) : null;
    emit(
      state
          .clearErrors(failureMessage: true, successEmail: true)
          .copyWith(lastName: lastName)
          .withValidationResult(
            nameError: state.nameError,
            lastNameError: error,
            emailError: state.emailError,
            passwordError: state.passwordError,
            repeatPasswordError: state.repeatPasswordError,
          ),
    );
  }

  void onEmailChanged(String email) {
    final error = _shouldValidateEmail ? validator.validateEmail(email, acceptsEmpty: !state.attemptedSubmit) : null;
    emit(
      state
          .clearErrors(failureMessage: true, successEmail: true)
          .copyWith(email: email)
          .withValidationResult(
            nameError: state.nameError,
            lastNameError: state.lastNameError,
            emailError: error,
            passwordError: state.passwordError,
            repeatPasswordError: state.repeatPasswordError,
          ),
    );
  }

  void onPasswordChanged(String password) {
    final passError = _shouldValidatePassword ? validator.validatePassword(password, acceptsEmpty: !state.attemptedSubmit) : null;
    final repeatError = _shouldValidateRepeatPassword ? validator.validateRepeatPassword(state.repeatPassword, password, acceptsEmpty: !state.attemptedSubmit) : state.repeatPasswordError;
    emit(
      state
          .clearErrors(failureMessage: true, successEmail: true)
          .copyWith(password: password)
          .withValidationResult(
            nameError: state.nameError,
            lastNameError: state.lastNameError,
            emailError: state.emailError,
            passwordError: passError,
            repeatPasswordError: repeatError,
          ),
    );
  }

  void onRepeatPasswordChanged(String repeatPassword) {
    final repeatError = _shouldValidateRepeatPassword ? validator.validateRepeatPassword(repeatPassword, state.password, acceptsEmpty: !state.attemptedSubmit) : state.repeatPasswordError;
    emit(
      state
          .clearErrors(failureMessage: true, successEmail: true)
          .copyWith(repeatPassword: repeatPassword)
          .withValidationResult(
            nameError: state.nameError,
            lastNameError: state.lastNameError,
            emailError: state.emailError,
            passwordError: state.passwordError,
            repeatPasswordError: repeatError,
          ),
    );
  }

  void onNameUnfocused() {
    final err = validator.validateName(state.name, acceptsEmpty: false);
    emit(
      state.copyWith(nameBlurred: true).withValidationResult(
        nameError: err,
        lastNameError: state.lastNameError,
        emailError: state.emailError,
        passwordError: state.passwordError,
        repeatPasswordError: state.repeatPasswordError,
      ),
    );
  }

  void onLastNameUnfocused() {
    final err = validator.validateLastName(state.lastName, acceptsEmpty: false);
    emit(
      state.copyWith(lastNameBlurred: true).withValidationResult(
        nameError: state.nameError,
        lastNameError: err,
        emailError: state.emailError,
        passwordError: state.passwordError,
        repeatPasswordError: state.repeatPasswordError,
      ),
    );
  }

  void onEmailUnfocused() {
    final err = validator.validateEmail(state.email, acceptsEmpty: false);
    emit(
      state.copyWith(emailBlurred: true).withValidationResult(
        nameError: state.nameError,
        lastNameError: state.lastNameError,
        emailError: err,
        passwordError: state.passwordError,
        repeatPasswordError: state.repeatPasswordError,
      ),
    );
  }

  void onPasswordUnfocused() {
    final err = validator.validatePassword(state.password, acceptsEmpty: false);
    final repeatErr = state.repeatPasswordBlurred ? validator.validateRepeatPassword(state.repeatPassword, state.password, acceptsEmpty: false) : state.repeatPasswordError;
    emit(
      state.copyWith(passwordBlurred: true).withValidationResult(
        nameError: state.nameError,
        lastNameError: state.lastNameError,
        emailError: state.emailError,
        passwordError: err,
        repeatPasswordError: repeatErr,
      ),
    );
  }

  void onRepeatPasswordUnfocused() {
    final err = validator.validateRepeatPassword(state.repeatPassword, state.password, acceptsEmpty: false);
    emit(
      state.copyWith(repeatPasswordBlurred: true).withValidationResult(
        nameError: state.nameError,
        lastNameError: state.lastNameError,
        emailError: state.emailError,
        passwordError: state.passwordError,
        repeatPasswordError: err,
      ),
    );
  }
  
  void togglePasswordVisibility() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void toggleRepeatPasswordVisibility() {
    emit(state.copyWith(showRepeatPassword: !state.showRepeatPassword));
  }

  Future<void> submit() async {
    final nameError = validator.validateName(state.name, acceptsEmpty: false);
    final lastNameError = validator.validateLastName(state.lastName, acceptsEmpty: false);
    final emailError = validator.validateEmail(state.email, acceptsEmpty: false);
    final passwordError = validator.validatePassword(state.password, acceptsEmpty: false);
    final repeatPasswordError = validator.validateRepeatPassword(state.repeatPassword, state.password, acceptsEmpty: false);

    final withValidation = state
        .clearErrors(failureMessage: true, successEmail: true)
        .copyWith(
          attemptedSubmit: true,
          nameBlurred: true,
          lastNameBlurred: true,
          emailBlurred: true,
          passwordBlurred: true,
          repeatPasswordBlurred: true,
        )
        .withValidationResult(
          nameError: nameError,
          lastNameError: lastNameError,
          emailError: emailError,
          passwordError: passwordError,
          repeatPasswordError: repeatPasswordError,
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