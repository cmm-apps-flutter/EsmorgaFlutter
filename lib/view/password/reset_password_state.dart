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
  final bool showNewPassword;
  final bool showRepeatPassword;

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
    this.showNewPassword = false,
    this.showRepeatPassword = false,
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
    String? newError,
    String? repeatError,
    bool? newBlurred,
    bool? repeatBlurred,
    bool? attemptedSubmit,
    bool? codeInvalid,
    ResetPasswordStatus? status,
    bool? networkFailure,
    bool? showNewPassword,
    bool? showRepeatPassword,
  }) =>
      ResetPasswordState(
        newPassword: newPassword ?? this.newPassword,
        repeatPassword: repeatPassword ?? this.repeatPassword,
        newError: newError ?? this.newError,
        repeatError: repeatError ?? this.repeatError,
        newBlurred: newBlurred ?? this.newBlurred,
        repeatBlurred: repeatBlurred ?? this.repeatBlurred,
        attemptedSubmit: attemptedSubmit ?? this.attemptedSubmit,
        codeInvalid: codeInvalid ?? this.codeInvalid,
        status: status ?? this.status,
        networkFailure: networkFailure ?? this.networkFailure,
        showNewPassword: showNewPassword ?? this.showNewPassword,
        showRepeatPassword: showRepeatPassword ?? this.showRepeatPassword,
      );

  ResetPasswordState withValidationResult({
    required String? newError,
    required String? repeatError,
  }) =>
      ResetPasswordState(
        newPassword: newPassword,
        repeatPassword: repeatPassword,
        newError: newError,
        repeatError: repeatError,
        newBlurred: newBlurred,
        repeatBlurred: repeatBlurred,
        attemptedSubmit: attemptedSubmit,
        codeInvalid: codeInvalid,
        status: status,
        networkFailure: networkFailure,
        showNewPassword: showNewPassword,
        showRepeatPassword: showRepeatPassword,
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
        networkFailure,
        showNewPassword,
        showRepeatPassword,
      ];
}