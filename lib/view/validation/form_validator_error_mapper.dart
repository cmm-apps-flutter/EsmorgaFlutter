import 'package:esmorga_flutter/view/l10n/app_localizations.dart';
import 'package:esmorga_flutter/view/validation/form_validator_strings.dart';

class ErrorMessageMapper {
  static String mapValidationKey(String key, AppLocalizations l10n) {
    switch (key) {
      case ValidationStrings.fieldEmpty:
        return l10n.inlineErrorEmptyField;
      case ValidationStrings.nameInvalid:
        return l10n.inlineErrorName;
      case ValidationStrings.lastNameInvalid:
        return l10n.inlineErrorLastName;
      case ValidationStrings.emailInvalid:
        return l10n.inlineErrorEmail;
      case ValidationStrings.passwordInvalid:
        return l10n.inlineErrorPassword;
      case ValidationStrings.passwordMismatch:
        return l10n.registrationPasswordMismatchError;
      default:
        return l10n.defaultErrorTitle;
    }
  }
}
