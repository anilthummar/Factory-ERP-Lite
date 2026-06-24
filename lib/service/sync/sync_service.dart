import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../hive/hive_manager.dart';
import 'queue/sync_queue_repository.dart';
import 'sync_config.dart';
import 'sync_engine.dart';

/// Listens for connectivity changes and triggers [SyncEngine] retries.
class SyncService {
  /// Creates [SyncService].
  SyncService({
    required HiveManager hiveManager,
    required SyncEngine syncEngine,
    required SyncQueueRepository queueRepository,
    Connectivity? connectivity,
  })  : _hiveManager = hiveManager,
        _syncEngine = syncEngine,
        _queueRepository = queueRepository,
        _connectivity = connectivity ?? Connectivity();

  final HiveManager _hiveManager;
  final SyncEngine _syncEngine;
  final SyncQueueRepository _queueRepository;
  final Connectivity _connectivity;

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
  Future<SyncEngineReport> processPendingSync() {
    if (!_hiveManager.isInitialized) {
      return Future<SyncEngineReport>.value(const SyncEngineReport());
    }

    return _syncEngine.processPending();
  }

  /// Retries failed sync queue items when connectivity is available.
  Future<SyncEngineReport> retryFailedSync() {
    return processPendingSync();
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
