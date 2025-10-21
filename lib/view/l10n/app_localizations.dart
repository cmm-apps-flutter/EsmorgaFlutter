import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @buttonCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get buttonCreateAccount;

  /// No description provided for @buttonGuest.
  ///
  /// In en, this message translates to:
  /// **'Enter as guest'**
  String get buttonGuest;

  /// No description provided for @buttonLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get buttonLogin;

  /// No description provided for @buttonLoginRegister.
  ///
  /// In en, this message translates to:
  /// **'Login / Register'**
  String get buttonLoginRegister;

  /// No description provided for @buttonNavigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get buttonNavigate;

  /// No description provided for @buttonRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get buttonRegister;

  /// No description provided for @buttonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get buttonRetry;

  /// No description provided for @contentDescriptionBackIcon.
  ///
  /// In en, this message translates to:
  /// **'Back icon'**
  String get contentDescriptionBackIcon;

  /// No description provided for @contentDescriptionForwardIcon.
  ///
  /// In en, this message translates to:
  /// **'Forward icon'**
  String get contentDescriptionForwardIcon;

  /// No description provided for @contentDescriptionEventImage.
  ///
  /// In en, this message translates to:
  /// **'Event {eventName} image'**
  String contentDescriptionEventImage(String eventName);

  /// No description provided for @defaultErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Please retry later'**
  String get defaultErrorBody;

  /// No description provided for @defaultErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong!'**
  String get defaultErrorTitle;

  /// No description provided for @defaultErrorTitleExpanded.
  ///
  /// In en, this message translates to:
  /// **'Something failed, please try again'**
  String get defaultErrorTitleExpanded;

  /// No description provided for @fieldTitleEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldTitleEmail;

  /// No description provided for @fieldTitleLastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get fieldTitleLastName;

  /// No description provided for @fieldTitleName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldTitleName;

  /// No description provided for @fieldTitlePassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldTitlePassword;

  /// No description provided for @fieldTitleRepeatPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get fieldTitleRepeatPassword;

  /// No description provided for @inlineErrorEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get inlineErrorEmail;

  /// No description provided for @inlineErrorEmailAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'Email already in use'**
  String get inlineErrorEmailAlreadyUsed;

  /// No description provided for @inlineErrorEmptyField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get inlineErrorEmptyField;

  /// No description provided for @inlineErrorLastName.
  ///
  /// In en, this message translates to:
  /// **'Only letters, spaces and \' - are accepted'**
  String get inlineErrorLastName;

  /// No description provided for @inlineErrorName.
  ///
  /// In en, this message translates to:
  /// **'Only letters, spaces and \' - are accepted'**
  String get inlineErrorName;

  /// No description provided for @inlineErrorPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get inlineErrorPassword;

  /// No description provided for @inlineErrorPasswordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Min 8 chars, must include at least 1 digit, 1 letter and 1 symbol'**
  String get inlineErrorPasswordInvalid;

  /// No description provided for @inlineErrorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'passwords do not match, try again!'**
  String get inlineErrorPasswordMismatch;

  /// No description provided for @placeholderConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get placeholderConfirmPassword;

  /// No description provided for @placeholderEmail.
  ///
  /// In en, this message translates to:
  /// **'Input your email'**
  String get placeholderEmail;

  /// No description provided for @placeholderLastName.
  ///
  /// In en, this message translates to:
  /// **'Input your last name'**
  String get placeholderLastName;

  /// No description provided for @placeholderName.
  ///
  /// In en, this message translates to:
  /// **'Input your name'**
  String get placeholderName;

  /// No description provided for @placeholderPassword.
  ///
  /// In en, this message translates to:
  /// **'Input your password'**
  String get placeholderPassword;

  /// No description provided for @screenEventDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Event details'**
  String get screenEventDetailsDescription;

  /// No description provided for @screenEventDetailsLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get screenEventDetailsLocation;

  /// No description provided for @screenEventListEmptyText.
  ///
  /// In en, this message translates to:
  /// **'No events available now. Please come back later.'**
  String get screenEventListEmptyText;

  /// No description provided for @screenEventListLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading events…'**
  String get screenEventListLoading;

  /// No description provided for @screenEventListTitle.
  ///
  /// In en, this message translates to:
  /// **'Event list'**
  String get screenEventListTitle;

  /// No description provided for @screenHomescreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get screenHomescreenTitle;

  /// No description provided for @screenLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Hello again!'**
  String get screenLoginTitle;

  /// No description provided for @screenRegistrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get screenRegistrationTitle;

  /// No description provided for @snackbarNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get snackbarNoInternet;

  /// No description provided for @bottomBarExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get bottomBarExplore;

  /// No description provided for @bottomBarMyevents.
  ///
  /// In en, this message translates to:
  /// **'My Events'**
  String get bottomBarMyevents;

  /// No description provided for @bottomBarMyprofile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get bottomBarMyprofile;

  /// No description provided for @buttonJoinEvent.
  ///
  /// In en, this message translates to:
  /// **'Join Event'**
  String get buttonJoinEvent;

  /// No description provided for @buttonLeaveEvent.
  ///
  /// In en, this message translates to:
  /// **'Leave Event'**
  String get buttonLeaveEvent;

  /// No description provided for @buttonLoginToJoin.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sign up'**
  String get buttonLoginToJoin;

  /// No description provided for @snackbarEventJoined.
  ///
  /// In en, this message translates to:
  /// **'Bravo! You have joined the event!'**
  String get snackbarEventJoined;

  /// No description provided for @screenMyEventsEmptyText.
  ///
  /// In en, this message translates to:
  /// **'You are not registered for any event yet. Sign up for the next one!'**
  String get screenMyEventsEmptyText;

  /// No description provided for @screenMyEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your events'**
  String get screenMyEventsTitle;

  /// No description provided for @screenNoConnectionTitle.
  ///
  /// In en, this message translates to:
  /// **'No network connection'**
  String get screenNoConnectionTitle;

  /// No description provided for @screenNoConnectionBody.
  ///
  /// In en, this message translates to:
  /// **'Please, check your connection and try again.'**
  String get screenNoConnectionBody;

  /// No description provided for @buttonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get buttonOk;

  /// No description provided for @snackbarEventLeft.
  ///
  /// In en, this message translates to:
  /// **'Booooo! quitter!'**
  String get snackbarEventLeft;

  /// No description provided for @myProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get myProfileTitle;

  /// No description provided for @myProfileName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get myProfileName;

  /// No description provided for @myProfileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get myProfileEmail;

  /// No description provided for @myProfileOptions.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get myProfileOptions;

  /// No description provided for @myProfileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get myProfileChangePassword;

  /// No description provided for @myProfileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get myProfileLogout;

  /// No description provided for @myProfileLogoutPopUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get myProfileLogoutPopUpTitle;

  /// No description provided for @myProfileLogoutPopUpConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, log out'**
  String get myProfileLogoutPopUpConfirm;

  /// No description provided for @myProfileLogoutPopUpCancel.
  ///
  /// In en, this message translates to:
  /// **'No, cancel'**
  String get myProfileLogoutPopUpCancel;

  /// No description provided for @unauthenticatedErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Ups… You are not logged in!'**
  String get unauthenticatedErrorMessage;

  /// No description provided for @unauthenticatedErrorLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get unauthenticatedErrorLoginButton;

  /// No description provided for @registerConfirmationEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your account'**
  String get registerConfirmationEmailTitle;

  /// No description provided for @registerConfirmationEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We have sent a confirmation link to your email. Please check your inbox and follow the link to activate your account.'**
  String get registerConfirmationEmailSubtitle;

  /// No description provided for @registerConfirmationEmailButtonEmailApp.
  ///
  /// In en, this message translates to:
  /// **'Open mail app'**
  String get registerConfirmationEmailButtonEmailApp;

  /// No description provided for @registerConfirmationEmailButtonResend.
  ///
  /// In en, this message translates to:
  /// **'Resend mail'**
  String get registerConfirmationEmailButtonResend;

  /// No description provided for @registerResendCodeSuccess.
  ///
  /// In en, this message translates to:
  /// **'A new confirmation email has been sent'**
  String get registerResendCodeSuccess;

  /// No description provided for @registerResendCodeError.
  ///
  /// In en, this message translates to:
  /// **'Unable to send a new confirmation e-mail'**
  String get registerResendCodeError;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get loginForgotPassword;

  /// No description provided for @forgotPasswordScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Recover your password'**
  String get forgotPasswordScreenTitle;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get forgotPasswordButton;

  /// No description provided for @forgotPasswordSnackbarSuccess.
  ///
  /// In en, this message translates to:
  /// **'Recovery Email sent'**
  String get forgotPasswordSnackbarSuccess;

  /// No description provided for @invalidCredentialsError.
  ///
  /// In en, this message translates to:
  /// **'Incorrect data, try again!'**
  String get invalidCredentialsError;

  /// No description provided for @resetPasswordScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Change'**
  String get resetPasswordScreenTitle;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get resetPasswordButton;

  /// No description provided for @passwordSetSnackbar.
  ///
  /// In en, this message translates to:
  /// **'New password set!'**
  String get passwordSetSnackbar;

  /// No description provided for @placeholderNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter the new password'**
  String get placeholderNewPassword;

  /// No description provided for @resetPasswordNewPasswordField.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get resetPasswordNewPasswordField;

  /// No description provided for @resetPasswordRepeatPasswordField.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get resetPasswordRepeatPasswordField;

  /// No description provided for @activateAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re almost there…'**
  String get activateAccountTitle;

  /// No description provided for @activateAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'re verifying your account. Please wait a moment.'**
  String get activateAccountDescription;

  /// No description provided for @activateAccountContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get activateAccountContinue;

  /// No description provided for @registerConfirmationErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Expired or invalid code!'**
  String get registerConfirmationErrorTitle;

  /// No description provided for @registerConfirmationButtonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get registerConfirmationButtonRetry;

  /// No description provided for @registerConfirmationButtonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get registerConfirmationButtonCancel;

  /// No description provided for @registrationPasswordMismatchError.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match, please try again!'**
  String get registrationPasswordMismatchError;

  /// No description provided for @registrationReusedPasswordError.
  ///
  /// In en, this message translates to:
  /// **'The new password must be different from the current one.'**
  String get registrationReusedPasswordError;

  /// No description provided for @screenCreateEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your event'**
  String get screenCreateEventTitle;

  /// No description provided for @stepContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get stepContinueButton;

  /// No description provided for @fieldTitleEventName.
  ///
  /// In en, this message translates to:
  /// **'Event Name'**
  String get fieldTitleEventName;

  /// No description provided for @fieldTitleEventDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get fieldTitleEventDescription;

  /// No description provided for @placeholderEventName.
  ///
  /// In en, this message translates to:
  /// **'Enter the name of the event'**
  String get placeholderEventName;

  /// No description provided for @captionEventDescription.
  ///
  /// In en, this message translates to:
  /// **'{count}/5000'**
  String captionEventDescription(int count);

  /// No description provided for @inlineErrorInvalidLengthName.
  ///
  /// In en, this message translates to:
  /// **'The text must be between 3 and 100 characters'**
  String get inlineErrorInvalidLengthName;

  /// No description provided for @inlineErrorInvalidLengthDescription.
  ///
  /// In en, this message translates to:
  /// **'The text must be between 4 and 5000 characters'**
  String get inlineErrorInvalidLengthDescription;

  /// No description provided for @step2OptionParty.
  ///
  /// In en, this message translates to:
  /// **'Party'**
  String get step2OptionParty;

  /// No description provided for @step2OptionSport.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get step2OptionSport;

  /// No description provided for @step2OptionFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get step2OptionFood;

  /// No description provided for @step2OptionCharity.
  ///
  /// In en, this message translates to:
  /// **'Charity'**
  String get step2OptionCharity;

  /// No description provided for @step2OptionGames.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get step2OptionGames;

  /// No description provided for @step2ScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Type'**
  String get step2ScreenTitle;

  /// No description provided for @placeholderEventDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter a description of the event'**
  String get placeholderEventDescription;

  /// No description provided for @step3ScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Event date'**
  String get step3ScreenTitle;

  /// No description provided for @step3ScreenRowTime.
  ///
  /// In en, this message translates to:
  /// **'Event time'**
  String get step3ScreenRowTime;

  /// No description provided for @confirmButtonDialog.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButtonDialog;

  /// No description provided for @cancelButtonDialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButtonDialog;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
