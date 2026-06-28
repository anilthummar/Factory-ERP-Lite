import '../../../modules/labor_management/ui/labor_form_page.dart';
import '../../../modules/person_management/ui/person_form_page.dart';
import '../../../modules/recurring_expenses/ui/recurring_expense_form_page.dart';

/// English form labels for web admin (no localization wrapper required).
abstract final class AdminEnglishLabels {
  static const PersonFormLabels person = PersonFormLabels(
    titleAdd: 'Add Person',
    titleEdit: 'Edit Person',
    nameLabel: 'Name',
    mobileLabel: 'Mobile / Email',
    addressLabel: 'Address',
    notesLabel: 'Notes',
    nameHint: 'Enter name',
    mobileHint: 'Enter contact',
    addressHint: 'Enter address',
    notesHint: 'Optional notes',
    nameRequiredMessage: 'Name is required',
    mobileRequiredMessage: 'Contact is required',
    mobileInvalidMessage: 'Enter a valid contact',
    saveLabel: 'Save',
  );

  static const LaborFormLabels labor = LaborFormLabels(
    titleAdd: 'Add Labor',
    titleEdit: 'Edit Labor',
    nameLabel: 'Name',
    mobileLabel: 'Mobile',
    skillLabel: 'Skill',
    dailyWageLabel: 'Daily Wage',
    notesLabel: 'Notes',
    nameHint: 'Enter name',
    mobileHint: 'Enter mobile',
    skillHint: 'Enter skill',
    dailyWageHint: 'Enter wage',
    notesHint: 'Optional notes',
    nameRequiredMessage: 'Name is required',
    mobileRequiredMessage: 'Mobile is required',
    mobileInvalidMessage: 'Enter a valid mobile',
    skillRequiredMessage: 'Skill is required',
    dailyWageRequiredMessage: 'Daily wage is required',
    saveLabel: 'Save',
  );

  static const RecurringExpenseFormLabels recurringExpense =
      RecurringExpenseFormLabels(
    titleAdd: 'Add Recurring Expense',
    titleEdit: 'Edit Recurring Expense',
    titleLabel: 'Title',
    amountLabel: 'Amount',
    frequencyLabel: 'Frequency',
    startDateLabel: 'Start Date',
    endDateLabel: 'End Date (optional)',
    notesLabel: 'Notes',
    titleHint: 'Enter title',
    amountHint: 'Enter amount',
    startDateHint: 'Select date',
    endDateHint: 'Select date',
    notesHint: 'Optional notes',
    frequencyHint: 'Select frequency',
    titleRequiredMessage: 'Title is required',
    amountRequiredMessage: 'Amount is required',
    frequencyRequiredMessage: 'Frequency is required',
    startDateRequiredMessage: 'Start date is required',
    saveLabel: 'Save',
  );
}
