import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';

import '../hive/hive_manager.dart';

/// Orchestrates background sync from Hive to Firebase when connectivity returns.
///
/// Feature repositories register module-specific sync handlers in a later phase.
class SyncService {
  SyncService({
    required HiveManager hiveManager,
    Connectivity? connectivity,
  })  : _hiveManager = hiveManager,
        _connectivity = connectivity ?? Connectivity();

  final HiveManager _hiveManager;
  final Connectivity _connectivity;

  StreamSubscription<ConnectivityResult>? _subscription;

  /// Starts listening for connectivity changes to trigger sync retries.
  void startListening() {
    _subscription ??= _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        if (_isOnline(result)) {
          unawaited(processPendingSync());
        }
      },
    );
  }

  /// Processes all pending items in the Hive sync queue.
  Future<void> processPendingSync() async {
    if (!_hiveManager.isInitialized) {
      return;
    }

    final Box<Map<dynamic, dynamic>> box = _hiveManager.syncQueue;
    if (box.isEmpty) {
      return;
    }

    // Module repositories will implement per-collection push logic.
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  bool _isOnline(ConnectivityResult result) {
    return result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet;
  }
}
