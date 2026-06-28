import '../../../../utils/exports.dart';
import '../domain/models/excel_export_result.dart';

/// Runs an Excel export use case with loading UI and user feedback.
Future<void> runReportExcelExport(
  BuildContext context, {
  required Future<ExcelExportResult> Function() exportAction,
}) async {
  final AppString strings = context.appString;

  await EasyLoading.show(status: strings.exportExcelKey);
  try {
    final ExcelExportResult result = await exportAction();
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomTextLabelWidget(
          label: '${strings.excelExportSuccessKey} (${result.fileName})',
        ),
      ),
    );
  } on Object catch (error) {
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomTextLabelWidget(
          label: error.toString(),
        ),
      ),
    );
  } finally {
    await EasyLoading.dismiss();
  }
}
