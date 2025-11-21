import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';

class FormValidator {
  static const String nameRegex = r"^[A-Za-zÁÉÍÓÚáéíóúÀÈÌÒÙàèìòùÜüÑñÇç\s'-]+$";
  static const String emailRegex = r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String passwordRegex = r'^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!-/:-@\[-`{-~]).{8,50}$';

  final l10n = getIt<LocalizationService>().current;

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

  String? validateName(String value, {bool acceptsEmpty = true}) => _fieldError(
        value: value,
        acceptsEmpty: acceptsEmpty,
        matches: RegExp(nameRegex).hasMatch(value),
        invalidErrorKey: l10n.inlineErrorName,
        emptyErrorKey: l10n.inlineErrorEmptyField,
      );

  String? validateLastName(String value, {bool acceptsEmpty = true}) => _fieldError(
        value: value,
        acceptsEmpty: acceptsEmpty,
        matches: RegExp(nameRegex).hasMatch(value),
        invalidErrorKey: l10n.inlineErrorLastName,
        emptyErrorKey: l10n.inlineErrorEmptyField,
      );

  String? validateEmail(String value, {bool acceptsEmpty = true}) => _fieldError(
        value: value,
        acceptsEmpty: acceptsEmpty,
        matches: RegExp(emailRegex).hasMatch(value),
        invalidErrorKey: l10n.inlineErrorEmail,
        emptyErrorKey: l10n.inlineErrorEmptyField,
      );

  String? validatePassword(String value, {bool acceptsEmpty = true}) => _fieldError(
        value: value,
        acceptsEmpty: acceptsEmpty,
        matches: RegExp(passwordRegex).hasMatch(value),
        invalidErrorKey: l10n.inlineErrorPassword,
        emptyErrorKey: l10n.inlineErrorEmptyField,
      );

  String? validateRepeatPassword(
    String value,
    String? comparisonField, {
    bool acceptsEmpty = true,
  }) {
    if (!acceptsEmpty && value.isEmpty) {
      return l10n.inlineErrorEmptyField;
    }
    if (value.isEmpty) {
      return null;
    }
    if (value != comparisonField) {
      return l10n.inlineErrorPasswordMismatch;
    }
    return null;
  }
}
