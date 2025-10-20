
enum ChangePasswordFailure { network, unauthorized, generic }

sealed class ChangePasswordState {
  const ChangePasswordState();
}

class ChangePasswordInitial extends ChangePasswordState {
  const ChangePasswordInitial();
}

class ChangePasswordEditing extends ChangePasswordState {
  final String currentPassword;
  final String newPassword;
  final String repeatPassword;
  final String? currentErrorKey;
  final String? newErrorKey;
  final String? repeatErrorKey;
  final bool currentTouched;
  final bool newTouched;
  final bool repeatTouched;
  final bool isSubmitting;

  const ChangePasswordEditing({
    this.currentPassword = '',
    this.newPassword = '',
    this.repeatPassword = '',
    this.currentErrorKey,
    this.newErrorKey,
    this.repeatErrorKey,
    this.currentTouched = false,
    this.newTouched = false,
    this.repeatTouched = false,
    this.isSubmitting = false,
  });

  bool get isValid =>
      currentPassword.isNotEmpty &&
          newPassword.isNotEmpty &&
          repeatPassword.isNotEmpty &&
          currentErrorKey == null &&
          newErrorKey == null &&
          repeatErrorKey == null;

  ChangePasswordEditing copyWith({
    String? currentPassword,
    String? newPassword,
    String? repeatPassword,
    String? currentErrorKey,
    String? newErrorKey,
    String? repeatErrorKey,
    bool? currentTouched,
    bool? newTouched,
    bool? repeatTouched,
    bool? isSubmitting,
  }) {
    return ChangePasswordEditing(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      repeatPassword: repeatPassword ?? this.repeatPassword,
      currentErrorKey: currentErrorKey,
      newErrorKey: newErrorKey,
      repeatErrorKey: repeatErrorKey,
      currentTouched: currentTouched ?? this.currentTouched,
      newTouched: newTouched ?? this.newTouched,
      repeatTouched: repeatTouched ?? this.repeatTouched,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class ChangePasswordSuccess extends ChangePasswordState {
  final String messageKey;
  const ChangePasswordSuccess(this.messageKey);
}

class ChangePasswordError extends ChangePasswordState {
  final ChangePasswordFailure failure;
  const ChangePasswordError(this.failure);
}
