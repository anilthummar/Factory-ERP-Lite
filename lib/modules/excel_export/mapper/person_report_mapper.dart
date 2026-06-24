import '../../../core/domain/entities/person_entity.dart';
import '../../pdf_export/domain/models/report_data_snapshot.dart';
import 'report_mapper_models.dart';

/// Maps domain entities to person report Excel rows.
class PersonReportMapper {
  /// Creates [PersonReportMapper].
  const PersonReportMapper();

  /// Builds mapped person report data from [snapshot].
  PersonReportMappedData map(ReportDataSnapshot snapshot) {
    final int withAddress = snapshot.persons
        .where((PersonEntity person) => (person.address ?? '').isNotEmpty)
        .length;

    return PersonReportMappedData(
      generatedAt: snapshot.generatedAt,
      summary: <SummaryMetricRow>[
        SummaryMetricRow(
          label: 'Total Persons',
          value: '${snapshot.persons.length}',
        ),
        SummaryMetricRow(
          label: 'With Address',
          value: '$withAddress',
        ),
      ],
      details: snapshot.persons
          .map(
            (PersonEntity person) => PersonDetailRow(
              name: person.name,
              mobile: person.mobile,
              address: person.address ?? '',
              notes: person.notes ?? '',
            ),
          )
          .toList(growable: false),
    );
  }
}
