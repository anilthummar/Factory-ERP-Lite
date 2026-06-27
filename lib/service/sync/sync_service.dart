import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../modules/notifications/domain/usecases/notification_use_cases.dart';
import '../hive/hive_manager.dart';
import 'queue/sync_queue_repository.dart';
import 'sync_config.dart';
import 'sync_engine.dart';
import 'sync_pull_engine.dart';

/// Listens for connectivity changes and triggers [SyncEngine] retries.
class SyncService {
  /// Creates [SyncService].
  SyncService({
    required HiveManager hiveManager,
    required SyncEngine syncEngine,
    required SyncQueueRepository queueRepository,
    SyncPullEngine? pullEngine,
    Connectivity? connectivity,
    ShowSyncFailureNotificationUseCase? showSyncFailureNotificationUseCase,
  })  : _hiveManager = hiveManager,
        _syncEngine = syncEngine,
        _queueRepository = queueRepository,
        _pullEngine = pullEngine,
        _connectivity = connectivity ?? Connectivity(),
        _showSyncFailureNotificationUseCase = showSyncFailureNotificationUseCase;

  final HiveManager _hiveManager;
  final SyncEngine _syncEngine;
  final SyncQueueRepository _queueRepository;
  final SyncPullEngine? _pullEngine;
  final Connectivity _connectivity;
  final ShowSyncFailureNotificationUseCase? _showSyncFailureNotificationUseCase;

  StreamSubscription<ConnectivityResult>? _subscription;
  Timer? _backgroundTimer;

  /// Starts connectivity listening and periodic background sync.
  void startListening() {
    _subscription ??= _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        if (_isOnline(result)) {
          unawaited(processPendingSync());
        }
      },
    );

    startBackgroundSync();
  }

  /// Runs an immediate sync and schedules periodic retries while the app runs.
  void startBackgroundSync() {
    unawaited(processPendingSync());

    _backgroundTimer ??= Timer.periodic(
      SyncConfig.backgroundSyncInterval,
      (_) => unawaited(processPendingSync()),
    );
  }

  /// Processes all pending and retry-eligible failed items in the sync queue.
  Future<SyncEngineReport> processPendingSync() async {
    if (!_hiveManager.isInitialized) {
      return const SyncEngineReport();
    }

    final SyncEngineReport report = await _syncEngine.processPending();
    if (report.failedCount > 0) {
      await _showSyncFailureNotificationUseCase?.call(report.failedCount);
    }
    return report;
  }

  /// Retries failed sync queue items when connectivity is available.
  Future<SyncEngineReport> retryFailedSync() {
    return processPendingSync();
  }

  /// Pulls Firestore data into Hive, then pushes any pending local changes.
  Future<SyncPullReport> pullFromRemote({bool pushAfterPull = true}) async {
    if (!_hiveManager.isInitialized || _pullEngine == null) {
      return const SyncPullReport();
    }

    final ConnectivityResult connectivity = await getConnectivityStatus();
    if (!_isOnline(connectivity)) {
      return const SyncPullReport();
    }

    final SyncPullReport pullReport = await _pullEngine!.pullAllModules();
    if (pushAfterPull) {
      await processPendingSync();
    }
    return pullReport;
  }

  /// Returns when the last Firestore pull completed, if recorded.
  Future<DateTime?> getLastRemotePullAt() async {
    if (!_hiveManager.isInitialized) {
      return null;
    }

    final Map<dynamic, dynamic>? entry =
        _hiveManager.meta.get(SyncConfig.lastRemotePullAtKey);
    if (entry == null) {
      return null;
    }

    final Object? raw = entry[SyncConfig.lastRemotePullAtKey];
    if (raw is int) {
      return DateTime.fromMillisecondsSinceEpoch(raw);
    }
    return null;
  }

  /// Returns the number of queue items waiting for sync or retry.
  Future<int> getPendingSyncCount() {
    return _queueRepository.getPendingCount();
  }

  /// Returns when the last successful remote sync completed, if recorded.
  Future<DateTime?> getLastSuccessfulSyncAt() async {
    if (!_hiveManager.isInitialized) {
      return null;
    }

    final Map<dynamic, dynamic>? entry =
        _hiveManager.meta.get(SyncConfig.lastSuccessfulSyncAtKey);
    if (entry == null) {
      return null;
    }

    final Object? raw = entry[SyncConfig.lastSuccessfulSyncAtKey];
    if (raw is int) {
      return DateTime.fromMillisecondsSinceEpoch(raw);
    }
    return null;
  }

  /// Returns the current device connectivity status.
  Future<ConnectivityResult> getConnectivityStatus() {
    return _connectivity.checkConnectivity();
  }

  /// Whether [result] represents an online connection.
  bool isOnline(ConnectivityResult result) => _isOnline(result);

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _backgroundTimer?.cancel();
    _backgroundTimer = null;
  }

  bool _isOnline(ConnectivityResult result) {
    return result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet;
  }
}
