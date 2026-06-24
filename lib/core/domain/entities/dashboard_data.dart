import 'package:equatable/equatable.dart';

import '../enums/factory_status_type.dart';
import 'dashboard_activity_item.dart';

/// Aggregated dashboard metrics from local Hive repositories.
class DashboardData extends Equatable {
  /// Creates [DashboardData].
  const DashboardData({
    required this.totalPersons,
    required this.totalLabor,
    required this.totalExpenses,
    required this.pendingSyncCount,
    this.lastSyncAt,
    this.currentFactoryStatus,
    this.currentFactoryStatusNotes,
    this.factoryStatusUpdatedAt,
    this.recentActivities = const <DashboardActivityItem>[],
  });

  /// Total person records in Hive.
  final int totalPersons;

  /// Total labor records in Hive.
  final int totalLabor;

  /// Total one-time expense records across all expense modules.
  final int totalExpenses;

  /// Sync queue items waiting for remote push.
  final int pendingSyncCount;

  /// Timestamp of the last successful Firebase sync, if any.
  final DateTime? lastSyncAt;

  /// Latest factory operating status, if any.
  final FactoryStatusType? currentFactoryStatus;

  /// Notes on the latest factory status entry.
  final String? currentFactoryStatusNotes;

  /// When the current factory status was last changed.
  final DateTime? factoryStatusUpdatedAt;

  /// Recent mutations across ERP modules.
  final List<DashboardActivityItem> recentActivities;

  @override
  List<Object?> get props => <Object?>[
        totalPersons,
        totalLabor,
        totalExpenses,
        pendingSyncCount,
        lastSyncAt,
        currentFactoryStatus,
        currentFactoryStatusNotes,
        factoryStatusUpdatedAt,
        recentActivities,
      ];
}
