import '../../../utils/exports.dart';

/// Base event for force-update and maintenance flow.
sealed class ForceUpdateUnderMaintenanceEvent extends Equatable {
  /// Creates base event.
  const ForceUpdateUnderMaintenanceEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Triggers check of app update and maintenance configuration.
class ForceUpdateCheckRequested extends ForceUpdateUnderMaintenanceEvent {
  /// Creates check event.
  const ForceUpdateCheckRequested();
}

/// Triggers redirect to login flow.
class ForceUpdateRedirectToLoginRequested extends ForceUpdateUnderMaintenanceEvent {
  /// Creates redirect event.
  const ForceUpdateRedirectToLoginRequested();
}
