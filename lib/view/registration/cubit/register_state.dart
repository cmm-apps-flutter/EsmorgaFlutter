import 'package:equatable/equatable.dart';

enum RegisterStatus { idle, submitting, success, failure }

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

  bool get isValid => [
        nameError,
        lastNameError,
        emailError,
        passwordError,
        repeatPasswordError,
      ].every((e) => e == null) &&
      name.isNotEmpty &&
      lastName.isNotEmpty &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      repeatPassword.isNotEmpty;

  RegisterState copyWith({
    String? name,
    String? lastName,
    String? email,
    String? password,
    String? repeatPassword,
    String? nameError,
    String? lastNameError,
    String? emailError,
    String? passwordError,
    String? repeatPasswordError,
    RegisterStatus? status,
    bool? attemptedSubmit,
    String? failureMessage,
    String? successEmail,
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
      nameError: nameError ?? this.nameError,
      lastNameError: lastNameError ?? this.lastNameError,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      repeatPasswordError: repeatPasswordError ?? this.repeatPasswordError,
      status: status ?? this.status,
      attemptedSubmit: attemptedSubmit ?? this.attemptedSubmit,
      failureMessage: failureMessage ?? this.failureMessage,
      successEmail: successEmail ?? this.successEmail,
      nameBlurred: nameBlurred ?? this.nameBlurred,
      lastNameBlurred: lastNameBlurred ?? this.lastNameBlurred,
      emailBlurred: emailBlurred ?? this.emailBlurred,
      passwordBlurred: passwordBlurred ?? this.passwordBlurred,
      repeatPasswordBlurred: repeatPasswordBlurred ?? this.repeatPasswordBlurred,
      showPassword: showPassword ?? this.showPassword,
      showRepeatPassword: showRepeatPassword ?? this.showRepeatPassword,
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
        showRepeatPassword,
      ];
}