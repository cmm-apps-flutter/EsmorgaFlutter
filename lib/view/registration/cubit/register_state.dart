import 'package:equatable/equatable.dart';

enum RegisterStatus { idle, submitting, success, failure }

const _notProvided = Object();

class RegisterState extends Equatable {
  final String name;
  final String lastName;
  final String email;
  final String password;
  final String repeatPassword;
  final String? nameError;
  final String? lastNameError;
  final String? emailError;
  final String? passwordError;
  final String? repeatPasswordError;
  final RegisterStatus status;
  final bool attemptedSubmit;
  final String? failureMessage;
  final String? successEmail;
  final bool nameBlurred;
  final bool lastNameBlurred;
  final bool emailBlurred;
  final bool passwordBlurred;
  final bool repeatPasswordBlurred;
  final bool showPassword;
  final bool showRepeatPassword;

  const RegisterState({
    this.name = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.repeatPassword = '',
    this.nameError,
    this.lastNameError,
    this.emailError,
    this.passwordError,
    this.repeatPasswordError,
    this.status = RegisterStatus.idle,
    this.attemptedSubmit = false,
    this.failureMessage,
    this.successEmail,
    this.nameBlurred = false,
    this.lastNameBlurred = false,
    this.emailBlurred = false,
    this.passwordBlurred = false,
    this.repeatPasswordBlurred = false,
    this.showPassword = false,
    this.showRepeatPassword = false,
  });

  bool get isSubmitting => status == RegisterStatus.submitting;

  bool get isSuccess => status == RegisterStatus.success;

  bool get isFailure => status == RegisterStatus.failure;

  bool get isValid =>
      nameError == null &&
      lastNameError == null &&
      emailError == null &&
      passwordError == null &&
      repeatPasswordError == null &&
      name.trim().isNotEmpty &&
      lastName.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      password.isNotEmpty &&
      repeatPassword.isNotEmpty;

  RegisterState copyWith({
    String? name,
    String? lastName,
    String? email,
    String? password,
    String? repeatPassword,
    Object? nameError = _notProvided,
    Object? lastNameError = _notProvided,
    Object? emailError = _notProvided,
    Object? passwordError = _notProvided,
    Object? repeatPasswordError = _notProvided,
    RegisterStatus? status,
    bool? attemptedSubmit,
    Object? failureMessage = _notProvided,
    Object? successEmail = _notProvided,
    bool? nameBlurred,
    bool? lastNameBlurred,
    bool? emailBlurred,
    bool? passwordBlurred,
    bool? repeatPasswordBlurred,
    bool? showPassword,
    bool? showRepeatPassword,
  }) {
    return RegisterState(
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      repeatPassword: repeatPassword ?? this.repeatPassword,

      nameError: identical(nameError, _notProvided)
          ? this.nameError
          : nameError as String?,
      lastNameError: identical(lastNameError, _notProvided)
          ? this.lastNameError
          : lastNameError as String?,
      emailError: identical(emailError, _notProvided)
          ? this.emailError
          : emailError as String?,
      passwordError: identical(passwordError, _notProvided)
          ? this.passwordError
          : passwordError as String?,
      repeatPasswordError: identical(
        repeatPasswordError,
        _notProvided,
      )
          ? this.repeatPasswordError
          : repeatPasswordError as String?,

      status: status ?? this.status,
      attemptedSubmit: attemptedSubmit ?? this.attemptedSubmit,
      failureMessage: identical(failureMessage, _notProvided)
          ? this.failureMessage
          : failureMessage as String?,
      successEmail: identical(successEmail, _notProvided)
          ? this.successEmail
          : successEmail as String?,

      nameBlurred: nameBlurred ?? this.nameBlurred,
      lastNameBlurred: lastNameBlurred ?? this.lastNameBlurred,
      emailBlurred: emailBlurred ?? this.emailBlurred,
      passwordBlurred: passwordBlurred ?? this.passwordBlurred,
      repeatPasswordBlurred:
          repeatPasswordBlurred ?? this.repeatPasswordBlurred,
      showPassword: showPassword ?? this.showPassword,
      showRepeatPassword:
          showRepeatPassword ?? this.showRepeatPassword,
    );
  }

  @override
  List<Object?> get props => [
        name,
        lastName,
        email,
        password,
        repeatPassword,
        nameError,
        lastNameError,
        emailError,
        passwordError,
        repeatPasswordError,
        status,
        attemptedSubmit,
        failureMessage,
        successEmail,
        nameBlurred,
        lastNameBlurred,
        emailBlurred,
        passwordBlurred,
        repeatPasswordBlurred,
        showPassword,
        showRepeatPassword
      ];
}