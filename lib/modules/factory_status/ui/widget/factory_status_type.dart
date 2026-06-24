import '../../../../utils/exports.dart';

/// Factory operating status values (UI only).
enum FactoryStatusType {
  /// Factory is running normally.
  operational,

  /// Factory is under maintenance.
  maintenance,

  /// Factory is shut down.
  shutdown,

  /// Factory is running with limited capacity.
  partial,
}

/// Localized labels and styling for [FactoryStatusType].
extension FactoryStatusTypeUi on FactoryStatusType {
  /// Localized status label.
  String label(AppString strings) {
    switch (this) {
      case FactoryStatusType.operational:
        return strings.operationalKey;
      case FactoryStatusType.maintenance:
        return strings.factoryStatusMaintenanceKey;
      case FactoryStatusType.shutdown:
        return strings.factoryStatusShutdownKey;
      case FactoryStatusType.partial:
        return strings.factoryStatusPartialKey;
    }
  }

  /// Status icon.
  IconData get icon {
    switch (this) {
      case FactoryStatusType.operational:
        return Icons.check_circle_outline;
      case FactoryStatusType.maintenance:
        return Icons.build_outlined;
      case FactoryStatusType.shutdown:
        return Icons.power_settings_new_outlined;
      case FactoryStatusType.partial:
        return Icons.speed_outlined;
    }
  }

  /// Badge background color.
  Color backgroundColor(ColorScheme colorScheme) {
    switch (this) {
      case FactoryStatusType.operational:
        return colorScheme.primaryContainer;
      case FactoryStatusType.maintenance:
        return colorScheme.tertiaryContainer;
      case FactoryStatusType.shutdown:
        return colorScheme.errorContainer;
      case FactoryStatusType.partial:
        return colorScheme.secondaryContainer;
    }
  }

  /// Badge foreground color.
  Color foregroundColor(ColorScheme colorScheme) {
    switch (this) {
      case FactoryStatusType.operational:
        return colorScheme.onPrimaryContainer;
      case FactoryStatusType.maintenance:
        return colorScheme.onTertiaryContainer;
      case FactoryStatusType.shutdown:
        return colorScheme.onErrorContainer;
      case FactoryStatusType.partial:
        return colorScheme.onSecondaryContainer;
    }
  }
}

/// All selectable factory statuses.
const List<FactoryStatusType> kFactoryStatusTypes = <FactoryStatusType>[
  FactoryStatusType.operational,
  FactoryStatusType.maintenance,
  FactoryStatusType.shutdown,
  FactoryStatusType.partial,
];

/// Display data for a status history entry (UI only).
class FactoryStatusHistoryData {
  /// Creates [FactoryStatusHistoryData].
  const FactoryStatusHistoryData({
    required this.id,
    required this.status,
    required this.changedAt,
    this.notes,
  });

  /// Unique history entry identifier.
  final String id;

  /// Status at this point in time.
  final FactoryStatusType status;

  /// When the status was changed.
  final DateTime changedAt;

  /// Optional notes for this change.
  final String? notes;
}
