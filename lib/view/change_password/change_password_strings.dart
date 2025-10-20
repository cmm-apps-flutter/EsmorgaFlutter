import 'package:esmorga_flutter/view/change_password/cubit/change_password_state.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations.dart';

class ChangePasswordStrings {
  static const String passwordChangedSuccess = 'password_changed_successfully';
  static const String currentPasswordEmpty = 'current_password_empty';
  static const String newPasswordEmpty = 'new_password_empty';
  static const String passwordReused = 'password_reused';

  static String mapSuccess(String key, AppLocalizations l10n) {
    switch (key) {
      case passwordChangedSuccess:
        return l10n.passwordSetSnackbar;
      default:
        return '';
    }
  }

  static String mapFailure(ChangePasswordFailure failure, AppLocalizations l10n) {
    switch (failure) {
      case ChangePasswordFailure.network:
        return l10n.snackbarNoInternet;
      case ChangePasswordFailure.unauthorized:
        return l10n.defaultErrorTitle;
      case ChangePasswordFailure.generic:
        return l10n.defaultErrorTitle;
    }
  }
}
