
import 'package:equatable/equatable.dart';

enum RecoverPasswordStatus { idle, submitting, success, failure }

class RecoverPasswordState extends Equatable {
  final String email;
  final String? emailError;
  final bool emailBlurred;
  final bool attemptedSubmit;
  final RecoverPasswordStatus status;
  final bool networkFailure;

  const RecoverPasswordState({
    this.email = '',
    this.emailError,
    this.emailBlurred = false,
    this.attemptedSubmit = false,
    this.status = RecoverPasswordStatus.idle,
    this.networkFailure = false,
  });

  bool get isSubmitting => status == RecoverPasswordStatus.submitting;
  bool get isSuccess => status == RecoverPasswordStatus.success;

  RecoverPasswordState copyWith({
    String? email,
    String? emailError = _sentinel,
    bool? emailBlurred,
    bool? attemptedSubmit,
    RecoverPasswordStatus? status,
    bool? networkFailure,
  }) => RecoverPasswordState(
    email: email ?? this.email,
    emailError: emailError == _sentinel ? this.emailError : emailError,
    emailBlurred: emailBlurred ?? this.emailBlurred,
    attemptedSubmit: attemptedSubmit ?? this.attemptedSubmit,
    status: status ?? this.status,
    networkFailure: networkFailure ?? this.networkFailure,
  );

  @override
  List<Object?> get props => [email, emailError, emailBlurred, attemptedSubmit, status, networkFailure];
}

const _sentinel = '__S';

