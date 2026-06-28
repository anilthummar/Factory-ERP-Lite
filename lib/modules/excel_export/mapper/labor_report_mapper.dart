import '../../../core/domain/entities/labor_entity.dart';
import '../../pdf_export/domain/models/report_data_snapshot.dart';
import '../templates/excel_report_helpers.dart';
import 'report_mapper_models.dart';

/// Maps domain entities to labor report Excel rows.
class LaborReportMapper {
  /// Creates [LaborReportMapper].
  const LaborReportMapper();

  /// Builds mapped labor report data from [snapshot].
  LaborReportMappedData map(ReportDataSnapshot snapshot) {
    final double totalDailyWage = snapshot.labor.fold<double>(
      0,
      (double sum, LaborEntity labor) => sum + labor.dailyWage,
    );
    final double averageWage = snapshot.labor.isEmpty
        ? 0
        : totalDailyWage / snapshot.labor.length;

    return LaborReportMappedData(
      generatedAt: snapshot.generatedAt,
      summary: <SummaryMetricRow>[
        SummaryMetricRow(
          label: 'Total Workers',
          value: '${snapshot.labor.length}',
        ),
        SummaryMetricRow(
          label: 'Total Daily Wage',
          value: ExcelReportHelpers.formatCurrency(totalDailyWage),
        ),
        SummaryMetricRow(
          label: 'Average Daily Wage',
          value: ExcelReportHelpers.formatCurrency(averageWage),
        ),
      ],
      details: snapshot.labor
          .map(
            (LaborEntity labor) => LaborDetailRow(
              name: labor.name,
              skill: labor.skill,
              mobile: labor.mobile,
              dailyWage: labor.dailyWage,
              notes: labor.notes ?? '',
            ),
          )
          .toList(growable: false),
    );
  }
}
