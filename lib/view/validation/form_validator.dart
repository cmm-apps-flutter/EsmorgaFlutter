import 'package:esmorga_flutter/view/validation/form_validator_strings.dart';

class FormValidator {
  static const String nameRegex = r"^[a-zA-Z\s'-]+$";
  static const String emailRegex =
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String passwordRegex =
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&]).{8,}';

  String? _fieldError({
    required String value,
    required bool acceptsEmpty,
    required bool matches,
    required String invalidErrorKey,
    required String emptyErrorKey,
  }) {
    if (!acceptsEmpty && value.isEmpty) {
      return emptyErrorKey;
    }
    if (value.isEmpty) {
      return null;
    }
    return matches ? null : invalidErrorKey;
  }

  String? validateName(String value, {bool acceptsEmpty = true}) =>
      _fieldError(
        value: value,
        acceptsEmpty: acceptsEmpty,
        matches: RegExp(nameRegex).hasMatch(value),
        invalidErrorKey: ValidationStrings.nameInvalid,
        emptyErrorKey: ValidationStrings.fieldEmpty,
      );

  String? validateLastName(String value, {bool acceptsEmpty = true}) =>
      _fieldError(
        value: value,
        acceptsEmpty: acceptsEmpty,
        matches: RegExp(nameRegex).hasMatch(value),
        invalidErrorKey: ValidationStrings.lastNameInvalid,
        emptyErrorKey: ValidationStrings.fieldEmpty,
      );

  String? validateEmail(String value, {bool acceptsEmpty = true}) =>
      _fieldError(
        value: value,
        acceptsEmpty: acceptsEmpty,
        matches: RegExp(emailRegex).hasMatch(value),
        invalidErrorKey: ValidationStrings.emailInvalid,
        emptyErrorKey: ValidationStrings.fieldEmpty,
      );

  String? validatePassword(String value, {bool acceptsEmpty = true}) =>
      _fieldError(
        value: value,
        acceptsEmpty: acceptsEmpty,
        matches: RegExp(passwordRegex).hasMatch(value),
        invalidErrorKey: ValidationStrings.passwordInvalid,
        emptyErrorKey: ValidationStrings.fieldEmpty,
      );

  String? validateRepeatPassword(
      String value,
      String? comparisonField, {
        bool acceptsEmpty = true,
      }) {
    if (!acceptsEmpty && value.isEmpty) {
      return ValidationStrings.fieldEmpty;
    }
    if (value.isEmpty) {
      return null;
    }
    if (value != comparisonField) {
      return ValidationStrings.passwordMismatch;
    }
    return null;
  }
}
