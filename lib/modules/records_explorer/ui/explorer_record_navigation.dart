import 'package:share_plus/share_plus.dart';

import '../../../utils/exports.dart';
import '../domain/entities/explorer_record_item.dart';
import '../domain/enums/explorer_module_type.dart';
import 'explorer_module_labels.dart';

/// Navigation and actions for Records Explorer rows.
abstract final class ExplorerRecordNavigation {
  /// Opens the source module screen for [record].
  static Future<void> openModule(BuildContext context, ExplorerRecordItem record) {
    return switch (record.moduleType) {
      ExplorerModuleType.person =>
        context.router.push(const PersonRoute()),
      ExplorerModuleType.labor => context.router.push(const LaborRoute()),
      ExplorerModuleType.materialPurchase =>
        context.router.push(const MaterialPurchaseRoute()),
      ExplorerModuleType.truckExpense =>
        context.router.push(const TruckExpensesRoute()),
      ExplorerModuleType.maintenanceExpense =>
        context.router.push(const MaintenanceExpensesRoute()),
      ExplorerModuleType.electricityExpense =>
        context.router.push(const ElectricityExpensesRoute()),
      ExplorerModuleType.miscellaneousExpense =>
        context.router.push(const MiscellaneousExpensesRoute()),
      ExplorerModuleType.recurringExpense =>
        context.router.push(const RecurringExpensesRoute()),
      ExplorerModuleType.factoryStatus =>
        context.router.push(const FactoryStatusOverviewRoute()),
      ExplorerModuleType.calendarEvent =>
        context.router.push(const MainNavigationRoute()),
    };
  }

  /// Shares a text summary of [record].
  static Future<void> shareRecord(
    BuildContext context,
    ExplorerRecordItem record,
  ) async {
    final AppString strings = context.appString;
    final String module = ExplorerModuleLabels.label(strings, record.moduleType);
    final String date = dateToString(
      record.recordDate,
      dateFormat: DateConstants.yearMonthDayFormat,
    );
    final String amount = record.amount == null
        ? '—'
        : record.amount!.toStringAsFixed(2);
  final String text = '${record.name}\n'
        '$module · $date\n'
        '${strings.amountKey}: $amount\n'
        '${record.notes ?? ''}';
    await Share.share(text.trim());
  }
}
