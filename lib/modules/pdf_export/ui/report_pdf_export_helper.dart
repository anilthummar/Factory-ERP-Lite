import '../../../../utils/exports.dart';
import '../domain/models/pdf_export_result.dart';

/// Runs a PDF export use case with loading UI and user feedback.
Future<void> runReportPdfExport(
  BuildContext context, {
  required Future<PdfExportResult> Function() exportAction,
}) async {
  final AppString strings = context.appString;

  await EasyLoading.show(status: strings.exportPdfKey);
  try {
    final PdfExportResult result = await exportAction();
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomTextLabelWidget(
          label: '${strings.pdfExportSuccessKey} (${result.fileName})',
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
