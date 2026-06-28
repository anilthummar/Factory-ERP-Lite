import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../core/sync/sync_queue_item.dart';
import '../../../service/firebase/domain/firebase_health_check_result.dart';
import '../../../service/firebase/firebase_health_check_service.dart';
import '../../../service/sync/queue/sync_queue_repository.dart';
import '../../../service/sync/sync_service.dart';
import '../domain/entities/sync_diagnostics_data.dart';
import 'sync_diagnostics_repository.dart';

/// Hive-backed sync diagnostics repository.
class SyncDiagnosticsRepositoryImpl implements SyncDiagnosticsRepository {
  /// Creates [SyncDiagnosticsRepositoryImpl].
  SyncDiagnosticsRepositoryImpl({
    required SyncQueueRepository queueRepository,
    required SyncService syncService,
    required FirebaseHealthCheckService firebaseHealthCheckService,
  })  : _queueRepository = queueRepository,
        _syncService = syncService,
        _firebaseHealthCheckService = firebaseHealthCheckService;

  final SyncQueueRepository _queueRepository;
  final SyncService _syncService;
  final FirebaseHealthCheckService _firebaseHealthCheckService;

  @override
  Future<SyncDiagnosticsData> loadDiagnostics() async {
    final List<SyncQueueItem> items = await _queueRepository.getAllItems();
    final int pendingQueueCount = items
        .where(
          (SyncQueueItem item) => item.status == SyncQueueItemStatus.pending,
        )
        .length;
    final int failedQueueCount = items
        .where(
          (SyncQueueItem item) =>
              item.status == SyncQueueItemStatus.failed ||
              item.status == SyncQueueItemStatus.deadLetter,
        )
        .length;
    final DateTime? lastSyncAt = await _syncService.getLastSuccessfulSyncAt();
    final ConnectivityResult connectivityStatus =
        await _syncService.getConnectivityStatus();
    final FirebaseHealthCheckResult firebaseHealth =
        await _firebaseHealthCheckService.run();

    return SyncDiagnosticsData(
      pendingQueueCount: pendingQueueCount,
      failedQueueCount: failedQueueCount,
      lastSyncAt: lastSyncAt,
      connectivityStatus: connectivityStatus,
      isOnline: _syncService.isOnline(connectivityStatus),
      firebaseHealth: firebaseHealth,
    );
  }

  @override
  Future<void> retrySync() {
    return _syncService.retryFailedSync();
  }
}
