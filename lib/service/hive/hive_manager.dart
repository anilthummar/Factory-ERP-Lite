import 'package:hive_flutter/hive_flutter.dart';

import 'hive_box_names.dart';

/// Initializes Hive and provides access to offline-first module boxes.
class HiveManager {
  HiveManager._();

  static final HiveManager instance = HiveManager._();

  bool _initialized = false;

  /// Whether [init] has completed successfully.
  bool get isInitialized => _initialized;

  /// Initializes Hive and opens foundation + module boxes.
  Future<void> init() async {
    if (_initialized) {
      return;
    }

    await Hive.initFlutter();
    await _openBox(HiveBoxNames.syncQueue);
    await _openBox(HiveBoxNames.meta);

    for (final String boxName in HiveBoxNames.moduleBoxes) {
      await _openBox(boxName);
    }

    _initialized = true;
  }

  /// Pending sync operations queue (maps until typed adapters are added).
  Box<Map<dynamic, dynamic>> get syncQueue =>
      Hive.box<Map<dynamic, dynamic>>(HiveBoxNames.syncQueue);

  /// App-level Hive metadata (last sync timestamps, schema version, etc.).
  Box<Map<dynamic, dynamic>> get meta =>
      Hive.box<Map<dynamic, dynamic>>(HiveBoxNames.meta);

  /// Returns an opened module box by [boxName].
  Box<Map<dynamic, dynamic>> moduleBox(String boxName) =>
      Hive.box<Map<dynamic, dynamic>>(boxName);

  Future<void> _openBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<Map<dynamic, dynamic>>(boxName);
    }
  }
}
