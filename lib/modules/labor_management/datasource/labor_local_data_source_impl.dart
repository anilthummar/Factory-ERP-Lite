import 'package:hive_ce/hive_ce.dart';

import '../../../core/domain/entities/labor_entity.dart';
import '../../../service/hive/hive_manager.dart';
import '../model/local/labor_hive_model.dart';
import 'labor_local_data_source.dart';
import 'labor_local_exception.dart';

/// Hive implementation of [LaborLocalDataSource].
class LaborLocalDataSourceImpl implements LaborLocalDataSource {
  LaborLocalDataSourceImpl({HiveManager? hiveManager})
      : _hiveManager = hiveManager ?? HiveManager.instance;

  final HiveManager _hiveManager;

  Box<LaborHiveModel> get _box => _hiveManager.laborBox;

  @override
  Future<List<LaborEntity>> getAllLabor() async {
    return _runStorage('load labor', () async {
      final List<LaborEntity> records = _box.values
          .map((LaborHiveModel model) => model.toEntity())
          .toList(growable: false);
      return _sort(records);
    });
  }

  @override
  Future<LaborEntity?> getLaborById(String id) async {
    return _runStorage('load labor', () async {
      return _box.get(id)?.toEntity();
    });
  }

  @override
  Future<LaborEntity> addLabor(LaborEntity labor) async {
    return _runStorage('add labor', () async {
      if (_box.containsKey(labor.id)) {
        throw LaborAlreadyExistsException(labor.id);
      }
      final LaborHiveModel model = LaborHiveModel.fromEntity(labor);
      await _box.put(labor.id, model);
      return model.toEntity();
    });
  }

  @override
  Future<LaborEntity> updateLabor(LaborEntity labor) async {
    return _runStorage('update labor', () async {
      if (!_box.containsKey(labor.id)) {
        throw LaborNotFoundException(labor.id);
      }
      final LaborHiveModel model = LaborHiveModel.fromEntity(labor);
      await _box.put(labor.id, model);
      return model.toEntity();
    });
  }

  @override
  Future<void> deleteLabor(String id) async {
    await _runStorage('delete labor', () async {
      if (!_box.containsKey(id)) {
        throw LaborNotFoundException(id);
      }
      await _box.delete(id);
    });
  }

  @override
  Future<List<LaborEntity>> searchLabor(String query) async {
    return _runStorage('search labor', () async {
      final String normalizedQuery = query.trim().toLowerCase();
      if (normalizedQuery.isEmpty) {
        return getAllLabor();
      }
      final List<LaborEntity> matches = _box.values
          .map((LaborHiveModel model) => model.toEntity())
          .where((LaborEntity labor) => _matchesQuery(labor, normalizedQuery))
          .toList(growable: false);
      return _sort(matches);
    });
  }

  Future<T> _runStorage<T>(String operation, Future<T> Function() action) async {
    if (!_hiveManager.isInitialized) {
      throw LaborLocalStorageException(
        'Hive is not initialized. Cannot $operation.',
      );
    }
    if (!_hiveManager.isLaborBoxOpen) {
      throw LaborLocalStorageException(
        'Labor Hive box is not open. Cannot $operation.',
      );
    }
    try {
      return await action();
    } on LaborLocalException {
      rethrow;
    } on HiveError catch (error) {
      throw LaborLocalStorageException(
        'Hive error while trying to $operation: ${error.message}',
      );
    } on Object catch (error) {
      throw LaborLocalStorageException(
        'Unexpected error while trying to $operation: $error',
      );
    }
  }

  List<LaborEntity> _sort(List<LaborEntity> records) {
    final List<LaborEntity> sorted = List<LaborEntity>.from(records)
      ..sort((LaborEntity a, LaborEntity b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted;
  }

  bool _matchesQuery(LaborEntity labor, String query) {
    return labor.name.toLowerCase().contains(query) ||
        labor.mobile.toLowerCase().contains(query) ||
        labor.skill.toLowerCase().contains(query) ||
        (labor.notes?.toLowerCase().contains(query) ?? false);
  }
}
