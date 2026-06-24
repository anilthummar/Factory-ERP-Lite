import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

/// Sync diagnostics snapshot for the developer screen.
class SyncDiagnosticsData extends Equatable {
  /// Creates [SyncDiagnosticsData].
  const SyncDiagnosticsData({
    required this.pendingQueueCount,
    required this.failedQueueCount,
    required this.connectivityStatus,
    required this.isOnline,
    this.lastSyncAt,
  });

  /// Queue items waiting for first sync attempt.
  final int pendingQueueCount;

  /// Queue items in failed or dead-letter state.
  final int failedQueueCount;

  /// When the last successful remote sync completed.
  final DateTime? lastSyncAt;

  /// Raw connectivity result from the device.
  final ConnectivityResult connectivityStatus;

  /// Whether the device can reach the network.
  final bool isOnline;

  @override
  List<Object?> get props => <Object?>[
        pendingQueueCount,
        failedQueueCount,
        lastSyncAt,
        connectivityStatus,
        isOnline,
      ];
}
