import 'package:equatable/equatable.dart';

enum LoginStatus { idle, submitting, success, failure }

class LoginState extends Equatable {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool attemptedSubmit;
  final bool emailBlurred;
  final bool passwordBlurred;
  final LoginStatus status;
  final String? failureMessage;
  final String? initMessage;
  final bool showPassword;

  const LoginState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.attemptedSubmit = false,
    this.emailBlurred = false,
    this.passwordBlurred = false,
    this.status = LoginStatus.idle,
    this.failureMessage,
    this.initMessage,
    this.showPassword = false,
  });

  bool get isSubmitting => status == LoginStatus.submitting;
  bool get isSuccess => status == LoginStatus.success;
  bool get isFailure => status == LoginStatus.failure;
  bool get isFormValid => emailError == null && passwordError == null && email.isNotEmpty && password.isNotEmpty;

  LoginState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? attemptedSubmit,
    bool? emailBlurred,
    bool? passwordBlurred,
    LoginStatus? status,
    String? failureMessage,
    String? initMessage,
    bool? showPassword,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      attemptedSubmit: attemptedSubmit ?? this.attemptedSubmit,
      emailBlurred: emailBlurred ?? this.emailBlurred,
      passwordBlurred: passwordBlurred ?? this.passwordBlurred,
      status: status ?? this.status,
      failureMessage: failureMessage ?? this.failureMessage,
      initMessage: initMessage ?? this.initMessage,
      showPassword: showPassword ?? this.showPassword,
    );
  }

  LoginState clearInitMessage() => LoginState(
        email: email,
        password: password,
        emailError: emailError,
        passwordError: passwordError,
        attemptedSubmit: attemptedSubmit,
        emailBlurred: emailBlurred,
        passwordBlurred: passwordBlurred,
        status: status,
        failureMessage: failureMessage,
        initMessage: null,
        showPassword: showPassword,
      );

  LoginState withValidationResult({
    required String? emailError,
    required String? passwordError,
  }) => LoginState(
        email: email,
        password: password,
        emailError: emailError,
        passwordError: passwordError,
        attemptedSubmit: attemptedSubmit,
        emailBlurred: emailBlurred,
        passwordBlurred: passwordBlurred,
        status: status,
        failureMessage: failureMessage,
        initMessage: initMessage,
        showPassword: showPassword,
      );

  @override
  List<Object?> get props => [
        email,
        password,
        emailError,
        passwordError,
        attemptedSubmit,
        emailBlurred,
        passwordBlurred,
        status,
        failureMessage,
        initMessage,
        showPassword,
      ];
}