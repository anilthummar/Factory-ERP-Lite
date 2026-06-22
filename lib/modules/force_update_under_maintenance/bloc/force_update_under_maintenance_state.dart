import '../../../utils/exports.dart';

/// Represents the state for handling force updates and maintenance modes.
///
/// This state is used to manage the configuration and status of force updates
/// and maintenance modes within the application. It includes information about
/// the current update and maintenance types, visibility of alert dialogs, and
/// navigation routes.
class ForceUpdateUnderMaintenanceState extends Equatable {
  /// The configuration model for force updates.
  final ForceUpdateConfigModel? forceUpdateConfigModel;

  /// The type of maintenance currently active.
  final UnderMaintenanceType? underMaintenanceType;

  /// The type of update currently active.
  final UpdateMaintenanceType? updateMaintenanceType;

  /// Indicates whether the alert dialog is visible.
  final bool? isAlertDialogVisible;

  /// The current status of the state.
  final BaseStateStatus status;

  /// The navigation route information.
  final PageRouteInfo? pageRouteInfo;

  /// Creates a new instance of [ForceUpdateUnderMaintenanceState].
  ///
  /// The [status] parameter is required.
  const ForceUpdateUnderMaintenanceState({
    required this.status,
    this.underMaintenanceType,
    this.updateMaintenanceType,
    this.forceUpdateConfigModel,
    this.isAlertDialogVisible,
    this.pageRouteInfo,
  });

  /// Creates a copy of this state with the given fields replaced with new values.
  ///
  /// The [status] parameter is required.
  ForceUpdateUnderMaintenanceState copyWith({
    ForceUpdateConfigModel? forceUpdateConfigModel,
    UnderMaintenanceType? underMaintenanceType,
    UpdateMaintenanceType? updateMaintenanceType,
    bool? isAlertDialogVisible,
    PageRouteInfo? pageRouteInfo,
    required BaseStateStatus status,
  }) {
    return ForceUpdateUnderMaintenanceState(
      forceUpdateConfigModel: forceUpdateConfigModel ?? this.forceUpdateConfigModel,
      isAlertDialogVisible: isAlertDialogVisible ?? this.isAlertDialogVisible,
      underMaintenanceType: underMaintenanceType ?? this.underMaintenanceType,
      updateMaintenanceType: updateMaintenanceType ?? this.updateMaintenanceType,
      pageRouteInfo: pageRouteInfo,
      status: status,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        forceUpdateConfigModel,
        underMaintenanceType,
        updateMaintenanceType,
        isAlertDialogVisible,
        pageRouteInfo,
      ];
}
