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

  /// Login screen section title.
  String get createAccountKey;

  /// Login screen email instruction.
  String get enterEmailToSignUpKey;

  /// Login email field placeholder.
  String get emailPlaceholderKey;

  /// Continue button label.
  String get continueKey;

  /// Divider label between auth methods.
  String get orKey;

  /// Google social login button label.
  String get continueWithGoogleKey;

  /// Apple social login button label.
  String get continueWithAppleKey;

  /// Terms footer prefix text.
  String get termsAgreementPrefixKey;

  /// Terms of service link label.
  String get termsOfServiceKey;

  /// Conjunction between legal links.
  String get termsAndKey;

  /// Privacy policy link label.
  String get privacyPolicyKey;

  /// Bottom navigation — Dashboard tab.
  String get navDashboardKey;

  /// Bottom navigation — Entries tab.
  String get navEntriesKey;

  /// Bottom navigation — Reports tab.
  String get navReportsKey;

  /// Bottom navigation — Calendar tab.
  String get navCalendarKey;

  /// Bottom navigation — Profile tab.
  String get navProfileKey;

  /// Entries page title.
  String get entriesPageKey;

  /// Reports page placeholder.
  String get reportsPageKey;

  /// Calendar page placeholder.
  String get calendarPageKey;

  /// Profile page placeholder.
  String get profilePageKey;

  /// Dashboard overview subtitle.
  String get dashboardOverviewKey;

  /// Dashboard total expenses metric.
  String get totalExpensesKey;

  /// Dashboard active labor metric.
  String get activeLaborKey;

  /// Dashboard materials metric.
  String get materialsKey;

  /// Dashboard pending sync metric.
  String get pendingSyncKey;

  /// Factory status section title.
  String get factoryStatusKey;

  /// Factory operational status label.
  String get operationalKey;

  /// Recent activity section title.
  String get recentActivityKey;

  /// Empty recent activity message.
  String get noRecentActivityKey;

  /// Profile settings hint.
  String get profileSettingsHintKey;

  /// Labor management module title.
  String get laborManagementKey;

  /// Person management module title.
  String get personManagementKey;

  /// Material purchase module title.
  String get materialPurchaseKey;

  /// Truck expenses module title.
  String get truckExpensesKey;

  /// Maintenance expenses module title.
  String get maintenanceExpensesKey;

  /// Electricity expenses module title.
  String get electricityExpensesKey;

  /// Miscellaneous expenses module title.
  String get miscExpensesKey;

  /// Recurring expenses module title.
  String get recurringExpensesKey;
}
