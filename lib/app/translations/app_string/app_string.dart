import 'package:flutter/cupertino.dart';

/// An abstract class representing localized strings used throughout the app.
/// Subclasses should implement all the getters to provide appropriate translations.
abstract class AppString {
  /// Returns the localized instance of [AppString] for the given [BuildContext].
  static AppString of(BuildContext context) {
    return Localizations.of<AppString>(context, AppString)!;
  }

  /// The application name.
  String get appNameKey;

  /// Message indicating poor internet connection.
  String get poorInternetConnectionKey;

  /// Message indicating no internet connection.
  String get noInternetConnectionKey;

  /// Description shown when there is no internet connection.
  String get noInternetConnectionDescriptionKey;

  /// Text for the "Cancel" button.
  String get cancelKey;

  /// Message shown when the server does not respond.
  String get serverNotRespondKey;

  /// Message for a bad request error state.
  String get badRequestStateKey;

  /// Message indicating unauthorized access.
  String get unauthorizedKey;

  /// Generic message for unexpected errors.
  String get somethingWentWrongKey;

  /// Message shown when there's a problem with the request.
  String get problemWithRequestKey;

  /// Label for the dashboard page.
  String get dashboardPageKey;

  /// Loading indicator message.
  String get loadingKey;

  /// Success message text.
  String get successMsgKey;

  /// Separator symbol or text.
  String get separatorKey;

  /// Label for the customer and location section.
  String get customerAndLocationKey;

  /// Label for the property and structure section.
  String get propertyAndStructureKey;

  /// Label for the valuation and remarks section.
  String get valuationAndRemarksKey;

  /// Label for a text editing field.
  String get textEditingFieldKey;

  /// Placeholder text prompting the user to write something.
  String get writeSomethingKey;

  /// Text for the "Save" button.
  String get saveKey;

  /// Label for error messages.
  String get errorKey;

  /// Prompt to enter the OTP.
  String get pleaseEnterOTPKey;

  /// Prompt to enter the password.
  String get pleaseEnterPasswordKey;

  /// Prompt to enter a valid OTP.
  String get pleaseEnterValidOTPKey;

  /// Description of password requirements.
  String get passwordShouldHaveKey;

  /// Prompt to add some input or content.
  String get pleaseAddSomethingKey;

  /// Prompt to enter an email ID.
  String get pleaseEnterEmailIdKey;

  /// Prompt to enter a valid email ID.
  String get pleaseEnterValidEmailIdKey;

  /// Label for the first tab.
  String get tab1Key;

  /// Label for the second tab.
  String get tab2Key;

  /// Label for the third tab.
  String get tab3Key;

  /// Label for desktop view layout.
  String get desktopViewKey;

  /// Label for mobile view layout.
  String get mobileViewKey;

  /// Label for tablet view layout.
  String get tabletViewKey;

  /// Label for email field.
  String get emailKey;

  /// Label for name field.
  String get nameKey;

  /// Text directing user to go back.
  String get clickHereToGoBackKey;

  /// Label for changing language option.
  String get changeLanguageKey;

  /// Message displayed when a page is not found (404).
  String get pageNotFoundKey;

  /// Label for email ID field.
  String get emailIdKey;

  /// Label for password field.
  String get passwordKey;

  /// Text for the "Login" button.
  String get loginKey;

  /// Text for retry button/action.
  String get retryKey;

  /// Label for the Hindi language.
  String get hindiKey;

  /// Label for the English language.
  String get englishKey;

  /// Message prompting the user to update the app.
  String get updateAppKey;

  /// Text for the "Update" button.
  String get updateKey;

  /// Label for a detail page with a bottom navigation bar.
  String get detailPageWithBottomBarKey;

  /// Label for a detail page without a bottom navigation bar.
  String get detailPageWithOutBottomBarKey;

  /// Subtitle on the login screen.
  String get signInSubtitleKey;

  /// Google sign-in button label.
  String get signInWithGoogleKey;

  /// Sign out action label.
  String get signOutKey;

  /// Dashboard welcome heading.
  String get welcomeDashboardKey;

  /// Hint text on the dashboard before modules are added.
  String get dashboardModulesHintKey;
}
