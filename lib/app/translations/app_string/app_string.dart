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

  /// Reports dashboard subtitle.
  String get reportsDashboardSubtitleKey;

  /// Expense reports screen title.
  String get expenseReportsKey;

  /// Labor reports screen title.
  String get laborReportsKey;

  /// Person reports screen title.
  String get personReportsKey;

  /// Monthly summary report screen title.
  String get monthlySummaryKey;

  /// Search reports field hint.
  String get searchReportsKey;

  /// Report category filter label.
  String get reportCategoryKey;

  /// All categories filter option.
  String get reportAllCategoriesKey;

  /// Report date range from label.
  String get reportFromDateKey;

  /// Report date range to label.
  String get reportToDateKey;

  /// Export PDF button label.
  String get exportPdfKey;

  /// Shown after a PDF is saved and shared successfully.
  String get pdfExportSuccessKey;

  /// Export Excel button label.
  String get exportExcelKey;

  /// Shown after an Excel file is saved and shared successfully.
  String get excelExportSuccessKey;

  /// Chart placeholder message.
  String get reportChartPlaceholderKey;

  /// Report empty state title.
  String get reportEmptyTitleKey;

  /// Report empty state message.
  String get reportEmptyMessageKey;

  /// Calendar page placeholder.
  String get calendarPageKey;

  /// Calendar month view toggle label.
  String get calendarMonthViewKey;

  /// Calendar agenda view toggle label.
  String get calendarAgendaViewKey;

  /// Selected date events section title.
  String get calendarSelectedDateEventsKey;

  /// No events on selected date title.
  String get calendarNoEventsTitleKey;

  /// No events on selected date message.
  String get calendarNoEventsMessageKey;

  /// Calendar agenda empty title.
  String get calendarAgendaEmptyTitleKey;

  /// Calendar agenda empty message.
  String get calendarAgendaEmptyMessageKey;

  /// Add calendar event FAB label.
  String get addCalendarEventKey;

  /// Recurring expense calendar event type label.
  String get calendarEventRecurringExpenseKey;

  /// Factory event calendar event type label.
  String get calendarEventFactoryEventKey;

  /// Maintenance reminder calendar event type label.
  String get calendarEventMaintenanceReminderKey;

  /// Holiday calendar event type label.
  String get calendarEventHolidayKey;

  /// Profile page placeholder.
  String get profilePageKey;

  /// Dashboard overview subtitle.
  String get dashboardOverviewKey;

  /// Factory status card hint when no notes exist.
  String get dashboardFactoryStatusHintKey;

  /// Factory status card text when status exists but has no notes.
  String get dashboardFactoryStatusNoNotesKey;

  /// Shown when no factory status has been recorded yet.
  String get noFactoryStatusSetKey;

  /// Recent activity label for one-time expenses.
  String get dashboardActivityExpenseKey;

  /// Dashboard total expenses metric.
  String get totalExpensesKey;

  /// Dashboard total persons metric.
  String get totalPersonsKey;

  /// Dashboard total labor metric.
  String get totalLaborKey;

  /// Dashboard active labor metric.
  String get activeLaborKey;

  /// Dashboard materials metric.
  String get materialsKey;

  /// Dashboard pending sync metric.
  String get pendingSyncKey;

  /// Dashboard last successful sync metric.
  String get lastSyncTimeKey;

  /// Shown when no sync has completed yet.
  String get neverSyncedKey;

  /// Sync diagnostics screen title.
  String get syncDiagnosticsTitleKey;

  /// Pending sync queue metric on diagnostics screen.
  String get syncDiagnosticsPendingQueueKey;

  /// Failed sync queue metric on diagnostics screen.
  String get syncDiagnosticsFailedQueueKey;

  /// Connectivity status metric on diagnostics screen.
  String get syncDiagnosticsConnectivityKey;

  /// Online connectivity label.
  String get syncDiagnosticsOnlineKey;

  /// Offline connectivity label.
  String get syncDiagnosticsOfflineKey;

  /// Bluetooth connectivity label.
  String get syncDiagnosticsBluetoothKey;

  /// VPN connectivity label.
  String get syncDiagnosticsVpnKey;

  /// Retry sync button on diagnostics screen.
  String get syncDiagnosticsRetryKey;

  /// Refresh diagnostics action label.
  String get syncDiagnosticsRefreshKey;

  /// Firebase initialization status on diagnostics screen.
  String get syncDiagnosticsFirebaseStatusKey;

  /// Auth status on diagnostics screen.
  String get syncDiagnosticsAuthStatusKey;

  /// Firestore status on diagnostics screen.
  String get syncDiagnosticsFirestoreStatusKey;

  /// Storage status on diagnostics screen.
  String get syncDiagnosticsStorageStatusKey;

  /// Healthy / OK status label.
  String get syncDiagnosticsStatusOkKey;

  /// Failed status label.
  String get syncDiagnosticsStatusFailedKey;

  /// Not signed in status label.
  String get syncDiagnosticsStatusNotSignedInKey;

  /// Skipped because offline status label.
  String get syncDiagnosticsStatusSkippedOfflineKey;

  /// Backup & restore screen title.
  String get backupRestoreTitleKey;

  /// Backup overview card title.
  String get backupRestoreOverviewKey;

  /// Total records subtitle on backup screen.
  String get backupRestoreTotalRecordsKey;

  /// JSON backup export button label.
  String get backupRestoreJsonExportKey;

  /// JSON backup restore button label.
  String get backupRestoreJsonImportKey;

  /// Google Sheets backup button label.
  String get backupRestoreGoogleSheetsKey;

  /// Open Google Sheets link label.
  String get backupRestoreOpenSheetsKey;

  /// Restore confirmation dialog title.
  String get backupRestoreConfirmTitleKey;

  /// Restore confirmation dialog message.
  String get backupRestoreConfirmMessageKey;

  /// Restore confirmation action label.
  String get backupRestoreConfirmActionKey;

  /// Summary label shown after backup validation.
  String get backupRestoreValidationSummaryKey;

  /// Profile entry for backup & restore.
  String get backupRestoreProfileEntryKey;

  /// Factory status section title.
  String get factoryStatusKey;

  /// Factory operational status label.
  String get operationalKey;

  /// Current factory status label.
  String get currentStatusKey;

  /// Last updated timestamp label.
  String get lastUpdatedKey;

  /// Change factory status button label.
  String get changeFactoryStatusKey;

  /// View full status history action label.
  String get viewStatusHistoryKey;

  /// Status history screen title.
  String get statusHistoryKey;

  /// Factory status notes section title.
  String get factoryStatusNotesKey;

  /// Empty factory status notes message.
  String get factoryStatusNotesEmptyKey;

  /// Status history empty title.
  String get factoryStatusHistoryEmptyTitleKey;

  /// Status history empty message.
  String get factoryStatusHistoryEmptyMessageKey;

  /// Under maintenance factory status label.
  String get factoryStatusMaintenanceKey;

  /// Shut down factory status label.
  String get factoryStatusShutdownKey;

  /// Partial operations factory status label.
  String get factoryStatusPartialKey;

  /// Select factory status field label.
  String get selectFactoryStatusKey;

  /// Factory status required validation message.
  String get factoryStatusRequiredKey;

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

  /// Search persons field hint.
  String get searchPersonsKey;

  /// Add person FAB label.
  String get addPersonKey;

  /// Edit person screen title.
  String get editPersonKey;

  /// Delete person action label.
  String get deletePersonKey;

  /// Delete person confirmation message.
  String get deletePersonConfirmKey;

  /// Empty persons list title.
  String get personEmptyTitleKey;

  /// Empty persons list message.
  String get personEmptyMessageKey;

  /// Search labor field hint.
  String get searchLaborKey;

  /// Add labor FAB label.
  String get addLaborKey;

  /// Empty labor list title.
  String get laborEmptyTitleKey;

  /// Empty labor list message.
  String get laborEmptyMessageKey;

  /// Labor skill field label.
  String get laborSkillKey;

  /// Daily wage field label.
  String get dailyWageKey;

  /// Search expenses field hint.
  String get searchExpensesKey;

  /// Add expense FAB label.
  String get addExpenseKey;

  /// Empty expenses list title.
  String get expenseEmptyTitleKey;

  /// Empty expenses list message.
  String get expenseEmptyMessageKey;

  /// Filter action label.
  String get filterKey;

  /// Apply filter button label.
  String get applyFilterKey;

  /// Clear filter button label.
  String get clearFilterKey;

  /// Expense title field label.
  String get expenseTitleKey;

  /// Expense amount field label.
  String get amountKey;

  /// Expense date field label.
  String get dateKey;

  /// Attachment section label.
  String get attachmentKey;

  /// Add attachment placeholder label.
  String get addAttachmentKey;

  /// Shown when a picked file type is not supported.
  String get unsupportedAttachmentTypeKey;

  /// Expense title required validation message.
  String get expenseTitleRequiredKey;

  /// Expense amount required validation message.
  String get expenseAmountRequiredKey;

  /// Expense amount invalid validation message.
  String get expenseAmountInvalidKey;

  /// Hint for tappable date fields.
  String get selectDateKey;

  /// Expense date required validation message.
  String get expenseDateRequiredKey;

  /// Search recurring expenses field hint.
  String get searchRecurringExpensesKey;

  /// Add recurring expense FAB label.
  String get addRecurringExpenseKey;

  /// Empty recurring expenses list title.
  String get recurringExpenseEmptyTitleKey;

  /// Empty recurring expenses list message.
  String get recurringExpenseEmptyMessageKey;

  /// Edit recurring expense screen title.
  String get editRecurringExpenseKey;

  /// Recurring expense frequency field label.
  String get frequencyKey;

  /// Recurring expense start date field label.
  String get startDateKey;

  /// Recurring expense end date field label (optional).
  String get endDateOptionalKey;

  /// Daily frequency option label.
  String get frequencyDailyKey;

  /// Weekly frequency option label.
  String get frequencyWeeklyKey;

  /// Monthly frequency option label.
  String get frequencyMonthlyKey;

  /// Yearly frequency option label.
  String get frequencyYearlyKey;

  /// Frequency required validation message.
  String get recurringExpenseFrequencyRequiredKey;

  /// Start date required validation message.
  String get recurringExpenseStartDateRequiredKey;
}
