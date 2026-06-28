import 'package:hive_ce/hive_ce.dart';

import '../../../core/domain/entities/factory_status_entity.dart';
import '../../../service/hive/hive_manager.dart';
import '../model/local/factory_status_hive_model.dart';
import 'factory_status_local_data_source.dart';
import 'factory_status_local_exception.dart';

/// Hive implementation of [FactoryStatusLocalDataSource].
class FactoryStatusLocalDataSourceImpl implements FactoryStatusLocalDataSource {
  /// Creates [FactoryStatusLocalDataSourceImpl].
  FactoryStatusLocalDataSourceImpl({HiveManager? hiveManager})
      : _hiveManager = hiveManager ?? HiveManager.instance;

  final HiveManager _hiveManager;

  Box<FactoryStatusHiveModel> get _box => _hiveManager.factoryStatusBox;

  @override
  Future<List<FactoryStatusEntity>> getAll() async {
    return _runStorage('load factory status history', () async {
      final List<FactoryStatusEntity> statuses = _box.values
          .map((FactoryStatusHiveModel model) => model.toEntity())
          .toList(growable: false);
      return _sortStatuses(statuses);
    });
  }

  @override
  Future<FactoryStatusEntity?> getById(String id) async {
    return _runStorage('load factory status', () async {
      final FactoryStatusHiveModel? model = _box.get(id);
      return model?.toEntity();
    });
  }

  @override
  Future<FactoryStatusEntity> add(FactoryStatusEntity status) async {
    return _runStorage('add factory status', () async {
      final FactoryStatusHiveModel model =
          FactoryStatusHiveModel.fromEntity(status);
      await _box.put(status.id, model);
      return model.toEntity();
    });
  }

  @override
  Future<FactoryStatusEntity> update(FactoryStatusEntity status) async {
    return _runStorage('update factory status', () async {
      if (!_box.containsKey(status.id)) {
        throw FactoryStatusNotFoundException(status.id);
      }

      final FactoryStatusHiveModel model =
          FactoryStatusHiveModel.fromEntity(status);
      await _box.put(status.id, model);
      return model.toEntity();
    });
  }

  @override
  Future<void> delete(String id) async {
    await _runStorage('delete factory status', () async {
      if (!_box.containsKey(id)) {
        throw FactoryStatusNotFoundException(id);
      }
      await _box.delete(id);
    });
  }

  Future<T> _runStorage<T>(
    String operation,
    Future<T> Function() action,
  ) async {
    if (!_hiveManager.isInitialized) {
      throw FactoryStatusLocalStorageException(
        'Hive is not initialized. Cannot $operation.',
      );
    }

    if (!_hiveManager.isFactoryStatusBoxOpen) {
      throw FactoryStatusLocalStorageException(
        'Factory status Hive box is not open. Cannot $operation.',
      );
    }

    try {
      return await action();
    } on FactoryStatusLocalException {
      rethrow;
    } on HiveError catch (error) {
      throw FactoryStatusLocalStorageException(
        'Hive error while trying to $operation: ${error.message}',
      );
    } on Object catch (error) {
      throw FactoryStatusLocalStorageException(
        'Unexpected error while trying to $operation: $error',
      );
    }
  }

  List<FactoryStatusEntity> _sortStatuses(
    List<FactoryStatusEntity> statuses,
  ) {
    final List<FactoryStatusEntity> sorted =
        List<FactoryStatusEntity>.from(statuses)
          ..sort(
            (FactoryStatusEntity a, FactoryStatusEntity b) =>
                b.updatedAt.compareTo(a.updatedAt),
          );
    return sorted;
  }
}
