import 'package:flutter/material.dart';

import '../../core/domain/entities/expense_entity.dart';
import '../../core/domain/entities/labor_entity.dart';
import '../../core/domain/entities/person_entity.dart';
import '../../core/domain/entities/recurring_expense_entity.dart';
import '../../core/domain/enums/expense_category.dart';
import '../../core/domain/enums/recurring_expense_frequency.dart';
import '../../core/enums/sync_status.dart';
import '../../modules/expense/ui/expense_form_page.dart';
import '../../modules/labor_management/ui/labor_form_page.dart';
import '../../modules/person_management/ui/person_form_page.dart';
import '../../modules/recurring_expenses/ui/recurring_expense_form_page.dart';
import '../../utils/exports.dart';
import '../widgets/admin_english_labels.dart';

/// Opens shared mobile form screens from the web admin panel.
abstract final class AdminFormNavigation {
  static Future<bool> openPersonForm(
    BuildContext context, {
    PersonEntity? person,
  }) async {
    final bool isEdit = person != null;
    final bool? saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (BuildContext context) => PersonFormPage(
              isEdit: isEdit,
              initialName: person?.name,
              initialMobile: person?.mobile,
              initialAddress: person?.address,
              initialNotes: person?.notes,
              labels: AdminEnglishLabels.person,
              onSubmit: ({
                required String name,
                required String mobile,
                String? address,
                String? notes,
              }) {
                unawaited(
                  _savePerson(
                    context,
                    person: person,
                    name: name,
                    mobile: mobile,
                    address: address,
                    notes: notes,
                  ),
                );
              },
            ),
          ),
        );
    return saved ?? false;
  }

  static Future<void> _savePerson(
    BuildContext context, {
    PersonEntity? person,
    required String name,
    required String mobile,
    String? address,
    String? notes,
  }) async {
    final DateTime now = DateTime.now();
    if (person == null) {
      await getIt<AddPersonUseCase>()(
        PersonEntity(
          id: 'person_${now.microsecondsSinceEpoch}',
          createdAt: now,
          updatedAt: now,
          syncStatus: SyncStatus.pending,
          name: name,
          mobile: mobile,
          address: address,
          notes: notes,
        ),
      );
    } else {
      await getIt<UpdatePersonUseCase>()(
        PersonEntity(
          id: person.id,
          createdAt: person.createdAt,
          updatedAt: now,
          syncStatus: SyncStatus.pending,
          name: name,
          mobile: mobile,
          address: address,
          notes: notes,
        ),
      );
    }
    if (context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  static Future<bool> openLaborForm(
    BuildContext context, {
    LaborEntity? labor,
  }) async {
    final bool isEdit = labor != null;
    final bool? saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (BuildContext context) => LaborFormPage(
              isEdit: isEdit,
              initialName: labor?.name,
              initialMobile: labor?.mobile,
              initialSkill: labor?.skill,
              initialDailyWage: labor?.dailyWage.toString(),
              initialNotes: labor?.notes,
              labels: AdminEnglishLabels.labor,
              onSubmit: ({
                required String name,
                required String mobile,
                required String skill,
                required double dailyWage,
                String? notes,
              }) {
                unawaited(
                  _saveLabor(
                    context,
                    labor: labor,
                    name: name,
                    mobile: mobile,
                    skill: skill,
                    dailyWage: dailyWage,
                    notes: notes,
                  ),
                );
              },
            ),
          ),
        );
    return saved ?? false;
  }

  static Future<void> _saveLabor(
    BuildContext context, {
    LaborEntity? labor,
    required String name,
    required String mobile,
    required String skill,
    required double dailyWage,
    String? notes,
  }) async {
    final DateTime now = DateTime.now();
    if (labor == null) {
      await getIt<AddLaborUseCase>()(
        LaborEntity(
          id: 'labor_${now.microsecondsSinceEpoch}',
          createdAt: now,
          updatedAt: now,
          syncStatus: SyncStatus.pending,
          name: name,
          mobile: mobile,
          skill: skill,
          dailyWage: dailyWage,
          notes: notes,
        ),
      );
    } else {
      await getIt<UpdateLaborUseCase>()(
        LaborEntity(
          id: labor.id,
          createdAt: labor.createdAt,
          updatedAt: now,
          syncStatus: SyncStatus.pending,
          name: name,
          mobile: mobile,
          skill: skill,
          dailyWage: dailyWage,
          notes: notes,
        ),
      );
    }
    if (context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  static Future<bool> openExpenseForm(
    BuildContext context, {
    ExpenseEntity? expense,
    ExpenseCategory? category,
  }) async {
    final ExpenseCategory selectedCategory =
        expense?.category ?? category ?? await _pickExpenseCategory(context);
    if (!context.mounted) {
      return false;
    }

    final bool isEdit = expense != null;
    final ExpenseFormUiConfig config = ExpenseFormUiConfig(
      pageTitleAdd: 'Add ${_categoryTitle(selectedCategory)}',
      pageTitleEdit: 'Edit ${_categoryTitle(selectedCategory)}',
      titleLabel: 'Title',
      amountLabel: 'Amount',
      dateLabel: 'Date',
      notesLabel: 'Notes',
      attachmentLabel: 'Attachment',
      addAttachmentLabel: 'Add attachment',
      titleHint: 'Enter title',
      amountHint: 'Enter amount',
      dateHint: 'Select date',
      notesHint: 'Optional notes',
      titleRequiredMessage: 'Title is required',
      amountRequiredMessage: 'Amount is required',
      amountInvalidMessage: 'Enter a valid amount',
      dateRequiredMessage: 'Date is required',
      saveLabel: 'Save',
    );

    final bool? saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (BuildContext context) => ExpenseFormPage(
          config: config,
          isEdit: isEdit,
          initialTitle: expense?.title,
          initialAmount: expense?.amount.toString(),
          initialDate: expense?.date.toIso8601String().split('T').first,
          initialNotes: expense?.notes,
          initialAttachmentPath: expense?.attachmentPath,
          onSubmit: ({
            required String title,
            required double amount,
            required DateTime date,
            String? notes,
            String? attachmentPath,
          }) {
            unawaited(
              _saveExpense(
                context,
                expense: expense,
                category: selectedCategory,
                title: title,
                amount: amount,
                date: date,
                notes: notes,
                attachmentPath: attachmentPath,
              ),
            );
          },
        ),
      ),
    );
    return saved ?? false;
  }

  static Future<ExpenseCategory> _pickExpenseCategory(
    BuildContext context,
  ) async {
    const List<ExpenseCategory> categories = <ExpenseCategory>[
      ExpenseCategory.materialPurchase,
      ExpenseCategory.truck,
      ExpenseCategory.maintenance,
      ExpenseCategory.electricity,
      ExpenseCategory.miscellaneous,
    ];

    final ExpenseCategory? picked = await showDialog<ExpenseCategory>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Expense category'),
          children: categories
              .map(
                (ExpenseCategory category) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, category),
                  child: Text(_categoryTitle(category)),
                ),
              )
              .toList(),
        );
      },
    );
    return picked ?? ExpenseCategory.miscellaneous;
  }

  static Future<void> _saveExpense(
    BuildContext context, {
    ExpenseEntity? expense,
    required ExpenseCategory category,
    required String title,
    required double amount,
    required DateTime date,
    String? notes,
    String? attachmentPath,
  }) async {
    final DateTime now = DateTime.now();
    final ExpenseEntity entity = expense == null
        ? ExpenseEntity(
            id: '${_idPrefix(category)}${now.microsecondsSinceEpoch}',
            createdAt: now,
            updatedAt: now,
            syncStatus: SyncStatus.pending,
            title: title,
            amount: amount,
            date: date,
            category: category,
            notes: notes,
            attachmentPath: attachmentPath,
          )
        : ExpenseEntity(
            id: expense.id,
            createdAt: expense.createdAt,
            updatedAt: now,
            syncStatus: SyncStatus.pending,
            title: title,
            amount: amount,
            date: date,
            category: category,
            notes: notes,
            attachmentPath: attachmentPath,
          );

    if (expense == null) {
      await _addExpense(category, entity);
    } else {
      await _updateExpense(category, entity);
    }

    if (context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  static Future<bool> openRecurringExpenseForm(
    BuildContext context, {
    RecurringExpenseEntity? expense,
  }) async {
    final bool isEdit = expense != null;
    final bool? saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (BuildContext context) => RecurringExpenseFormPage(
              isEdit: isEdit,
              initialTitle: expense?.title,
              initialAmount: expense?.amount.toString(),
              initialFrequency: expense?.frequency,
              initialStartDate:
                  expense?.startDate.toIso8601String().split('T').first,
              initialEndDate:
                  expense?.endDate?.toIso8601String().split('T').first,
              initialNotes: expense?.notes,
              labels: AdminEnglishLabels.recurringExpense,
              onSubmit: ({
                required String title,
                required double amount,
                required RecurringExpenseFrequency frequency,
                required DateTime startDate,
                DateTime? endDate,
                String? notes,
              }) {
                unawaited(
                  _saveRecurringExpense(
                    context,
                    expense: expense,
                    title: title,
                    amount: amount,
                    frequency: frequency,
                    startDate: startDate,
                    endDate: endDate,
                    notes: notes,
                  ),
                );
              },
            ),
          ),
        );
    return saved ?? false;
  }

  static Future<void> _saveRecurringExpense(
    BuildContext context, {
    RecurringExpenseEntity? expense,
    required String title,
    required double amount,
    required RecurringExpenseFrequency frequency,
    required DateTime startDate,
    DateTime? endDate,
    String? notes,
  }) async {
    final DateTime now = DateTime.now();
    if (expense == null) {
      await getIt<AddRecurringExpenseUseCase>()(
        RecurringExpenseEntity(
          id: 'recurring_${now.microsecondsSinceEpoch}',
          createdAt: now,
          updatedAt: now,
          syncStatus: SyncStatus.pending,
          title: title,
          amount: amount,
          frequency: frequency,
          startDate: startDate,
          endDate: endDate,
          notes: notes,
        ),
      );
    } else {
      await getIt<UpdateRecurringExpenseUseCase>()(
        RecurringExpenseEntity(
          id: expense.id,
          createdAt: expense.createdAt,
          updatedAt: now,
          syncStatus: SyncStatus.pending,
          title: title,
          amount: amount,
          frequency: frequency,
          startDate: startDate,
          endDate: endDate,
          notes: notes,
        ),
      );
    }
    if (context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  static String _categoryTitle(ExpenseCategory category) {
    return switch (category) {
      ExpenseCategory.materialPurchase => 'Material Purchase',
      ExpenseCategory.truck => 'Truck Expense',
      ExpenseCategory.maintenance => 'Maintenance',
      ExpenseCategory.electricity => 'Electricity',
      ExpenseCategory.miscellaneous => 'Miscellaneous',
    };
  }

  static String _idPrefix(ExpenseCategory category) {
    return switch (category) {
      ExpenseCategory.materialPurchase => 'material_',
      ExpenseCategory.truck => 'truck_',
      ExpenseCategory.maintenance => 'maintenance_',
      ExpenseCategory.electricity => 'electricity_',
      ExpenseCategory.miscellaneous => 'misc_',
    };
  }

  static Future<void> _addExpense(
    ExpenseCategory category,
    ExpenseEntity entity,
  ) {
    return switch (category) {
      ExpenseCategory.materialPurchase =>
        getIt<AddMaterialPurchaseUseCase>()(entity),
      ExpenseCategory.truck => getIt<AddTruckExpenseUseCase>()(entity),
      ExpenseCategory.maintenance =>
        getIt<AddMaintenanceExpenseUseCase>()(entity),
      ExpenseCategory.electricity =>
        getIt<AddElectricityExpenseUseCase>()(entity),
      ExpenseCategory.miscellaneous =>
        getIt<AddMiscellaneousExpenseUseCase>()(entity),
    };
  }

  static Future<void> _updateExpense(
    ExpenseCategory category,
    ExpenseEntity entity,
  ) {
    return switch (category) {
      ExpenseCategory.materialPurchase =>
        getIt<UpdateMaterialPurchaseUseCase>()(entity),
      ExpenseCategory.truck => getIt<UpdateTruckExpenseUseCase>()(entity),
      ExpenseCategory.maintenance =>
        getIt<UpdateMaintenanceExpenseUseCase>()(entity),
      ExpenseCategory.electricity =>
        getIt<UpdateElectricityExpenseUseCase>()(entity),
      ExpenseCategory.miscellaneous =>
        getIt<UpdateMiscellaneousExpenseUseCase>()(entity),
    };
  }
}
