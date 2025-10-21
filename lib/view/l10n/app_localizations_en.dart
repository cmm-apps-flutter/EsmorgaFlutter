// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get buttonCreateAccount => 'Register';

  @override
  String get buttonGuest => 'Enter as guest';

  @override
  String get buttonLogin => 'Login';

  @override
  String get buttonLoginRegister => 'Login / Register';

  @override
  String get buttonNavigate => 'Navigate';

  @override
  String get buttonRegister => 'Register';

  @override
  String get buttonRetry => 'Retry';

  @override
  String get contentDescriptionBackIcon => 'Back icon';

  @override
  String get contentDescriptionForwardIcon => 'Forward icon';

  @override
  String contentDescriptionEventImage(String eventName) {
    return 'Event $eventName image';
  }

  @override
  String get defaultErrorBody => 'Please retry later';

  @override
  String get defaultErrorTitle => 'Something went wrong!';

  @override
  String get defaultErrorTitleExpanded => 'Something failed, please try again';

  @override
  String get fieldTitleEmail => 'Email';

  @override
  String get fieldTitleLastName => 'Last name';

  @override
  String get fieldTitleName => 'Name';

  @override
  String get fieldTitlePassword => 'Password';

  @override
  String get fieldTitleRepeatPassword => 'Repeat password';

  @override
  String get inlineErrorEmail => 'Invalid email';

  @override
  String get inlineErrorEmailAlreadyUsed => 'Email already in use';

  @override
  String get inlineErrorEmptyField => 'Required field';

  @override
  String get inlineErrorLastName =>
      'Only letters, spaces and \' - are accepted';

  @override
  String get inlineErrorName => 'Only letters, spaces and \' - are accepted';

  @override
  String get inlineErrorPassword => 'Invalid password';

  @override
  String get inlineErrorPasswordInvalid =>
      'Min 8 chars, must include at least 1 digit, 1 letter and 1 symbol';

  @override
  String get inlineErrorPasswordMismatch =>
      'passwords do not match, try again!';

  @override
  String get placeholderConfirmPassword => 'Confirm your password';

  @override
  String get placeholderEmail => 'Input your email';

  @override
  String get placeholderLastName => 'Input your last name';

  @override
  String get placeholderName => 'Input your name';

  @override
  String get placeholderPassword => 'Input your password';

  @override
  String get screenEventDetailsDescription => 'Event details';

  @override
  String get screenEventDetailsLocation => 'Location';

  @override
  String get screenEventListEmptyText =>
      'No events available now. Please come back later.';

  @override
  String get screenEventListLoading => 'Loading events…';

  @override
  String get screenEventListTitle => 'Event list';

  @override
  String get screenHomescreenTitle => 'Hello!';

  @override
  String get screenLoginTitle => 'Hello again!';

  @override
  String get screenRegistrationTitle => 'Register';

  @override
  String get snackbarNoInternet => 'No internet connection.';

  @override
  String get bottomBarExplore => 'Explore';

  @override
  String get bottomBarMyevents => 'My Events';

  @override
  String get bottomBarMyprofile => 'Profile';

  @override
  String get buttonJoinEvent => 'Join Event';

  @override
  String get buttonLeaveEvent => 'Leave Event';

  @override
  String get buttonLoginToJoin => 'Sign in to sign up';

  @override
  String get snackbarEventJoined => 'Bravo! You have joined the event!';

  @override
  String get screenMyEventsEmptyText =>
      'You are not registered for any event yet. Sign up for the next one!';

  @override
  String get screenMyEventsTitle => 'Your events';

  @override
  String get screenNoConnectionTitle => 'No network connection';

  @override
  String get screenNoConnectionBody =>
      'Please, check your connection and try again.';

  @override
  String get buttonOk => 'OK';

  @override
  String get snackbarEventLeft => 'Booooo! quitter!';

  @override
  String get myProfileTitle => 'Profile';

  @override
  String get myProfileName => 'Name';

  @override
  String get myProfileEmail => 'Email';

  @override
  String get myProfileOptions => 'Options';

  @override
  String get myProfileChangePassword => 'Change password';

  @override
  String get myProfileLogout => 'Log out';

  @override
  String get myProfileLogoutPopUpTitle => 'Are you sure you want to log out?';

  @override
  String get myProfileLogoutPopUpConfirm => 'Yes, log out';

  @override
  String get myProfileLogoutPopUpCancel => 'No, cancel';

  @override
  String get unauthenticatedErrorMessage => 'Ups… You are not logged in!';

  @override
  String get unauthenticatedErrorLoginButton => 'Login';

  @override
  String get registerConfirmationEmailTitle => 'Confirm your account';

  @override
  String get registerConfirmationEmailSubtitle =>
      'We have sent a confirmation link to your email. Please check your inbox and follow the link to activate your account.';

  @override
  String get registerConfirmationEmailButtonEmailApp => 'Open mail app';

  @override
  String get registerConfirmationEmailButtonResend => 'Resend mail';

  @override
  String get registerResendCodeSuccess =>
      'A new confirmation email has been sent';

  @override
  String get registerResendCodeError =>
      'Unable to send a new confirmation e-mail';

  @override
  String get loginForgotPassword => 'Forgot your password?';

  @override
  String get forgotPasswordScreenTitle => 'Recover your password';

  @override
  String get forgotPasswordButton => 'Send';

  @override
  String get forgotPasswordSnackbarSuccess => 'Recovery Email sent';

  @override
  String get invalidCredentialsError => 'Incorrect data, try again!';

  @override
  String get resetPasswordScreenTitle => 'Password Change';

  @override
  String get resetPasswordButton => 'Change password';

  @override
  String get passwordSetSnackbar => 'New password set!';

  @override
  String get placeholderNewPassword => 'Enter the new password';

  @override
  String get resetPasswordNewPasswordField => 'New password';

  @override
  String get resetPasswordRepeatPasswordField => 'Repeat password';

  @override
  String get activateAccountTitle => 'We\'re almost there…';

  @override
  String get activateAccountDescription =>
      'We\'re verifying your account. Please wait a moment.';

  @override
  String get activateAccountContinue => 'Continue';

  @override
  String get registerConfirmationErrorTitle => 'Expired or invalid code!';

  @override
  String get registerConfirmationButtonRetry => 'Try again';

  @override
  String get registerConfirmationButtonCancel => 'Cancel';

  @override
  String get registrationPasswordMismatchError =>
      'Passwords do not match, please try again!';

  @override
  String get registrationReusedPasswordError =>
      'The new password must be different from the current one.';

  @override
  String get screenCreateEventTitle => 'Create your event';

  @override
  String get stepContinueButton => 'Continue';

  @override
  String get fieldTitleEventName => 'Event Name';

  @override
  String get fieldTitleEventDescription => 'Description';

  @override
  String get placeholderEventName => 'Enter the name of the event';

  @override
  String captionEventDescription(int count) {
    return '$count/5000';
  }

  @override
  String get inlineErrorInvalidLengthName =>
      'The text must be between 3 and 100 characters';

  @override
  String get inlineErrorInvalidLengthDescription =>
      'The text must be between 4 and 5000 characters';

  @override
  String get step2OptionParty => 'Party';

  @override
  String get step2OptionSport => 'Sport';

  @override
  String get step2OptionFood => 'Food';

  @override
  String get step2OptionCharity => 'Charity';

  @override
  String get step2OptionGames => 'Games';

  @override
  String get step2ScreenTitle => 'Event Type';

  @override
  String get placeholderEventDescription => 'Enter a description of the event';

  @override
  String get step3ScreenTitle => 'Event date';

  @override
  String get step3ScreenRowTime => 'Event time';

  @override
  String get confirmButtonDialog => 'Confirm';

  @override
  String get cancelButtonDialog => 'Cancel';
}
