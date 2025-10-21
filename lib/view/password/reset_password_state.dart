import 'package:equatable/equatable.dart';

enum ResetPasswordStatus { idle, submitting, success, failure }

class ResetPasswordState extends Equatable {
  final String newPassword;
  final String repeatPassword;
  final String? newError;
  final String? repeatError;
  final bool newBlurred;
  final bool repeatBlurred;
  final bool attemptedSubmit;
  final bool codeInvalid;
  final ResetPasswordStatus status;
  final bool networkFailure;

  const ResetPasswordState({
    this.newPassword = '',
    this.repeatPassword = '',
    this.newError,
    this.repeatError,
    this.newBlurred = false,
    this.repeatBlurred = false,
    this.attemptedSubmit = false,
    this.codeInvalid = false,
    this.status = ResetPasswordStatus.idle,
    this.networkFailure = false,
  });

  bool get isSubmitting => status == ResetPasswordStatus.submitting;
  bool get isSuccess => status == ResetPasswordStatus.success;
  bool get isFormValid =>
      newError == null &&
      repeatError == null &&
      newPassword.isNotEmpty &&
      repeatPassword.isNotEmpty &&
      newPassword == repeatPassword;

  ResetPasswordState copyWith({
    String? newPassword,
    String? repeatPassword,
    String? newError = _sentinel,
    String? repeatError = _sentinel,
    bool? newBlurred,
    bool? repeatBlurred,
    bool? attemptedSubmit,
    bool? codeInvalid,
    ResetPasswordStatus? status,
    bool? networkFailure,
  }) =>
      ResetPasswordState(
        newPassword: newPassword ?? this.newPassword,
        repeatPassword: repeatPassword ?? this.repeatPassword,
        newError: newError == _sentinel ? this.newError : newError,
        repeatError: repeatError == _sentinel ? this.repeatError : repeatError,
        newBlurred: newBlurred ?? this.newBlurred,
        repeatBlurred: repeatBlurred ?? this.repeatBlurred,
        attemptedSubmit: attemptedSubmit ?? this.attemptedSubmit,
        codeInvalid: codeInvalid ?? this.codeInvalid,
        status: status ?? this.status,
        networkFailure: networkFailure ?? this.networkFailure,
      );

  @override
  List<Object?> get props => [
        newPassword,
        repeatPassword,
        newError,
        repeatError,
        newBlurred,
        repeatBlurred,
        attemptedSubmit,
        codeInvalid,
        status,
        networkFailure
      ];
}

const _sentinel = '__S';
