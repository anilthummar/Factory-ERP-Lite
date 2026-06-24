import 'package:hive_ce/hive_ce.dart';

import '../../../core/domain/entities/person_entity.dart';
import '../../../service/hive/hive_manager.dart';
import '../model/local/person_hive_model.dart';
import 'person_local_data_source.dart';
import 'person_local_exception.dart';

/// Hive implementation of [PersonLocalDataSource].
class PersonLocalDataSourceImpl implements PersonLocalDataSource {
  /// Creates [PersonLocalDataSourceImpl].
  PersonLocalDataSourceImpl({HiveManager? hiveManager})
      : _hiveManager = hiveManager ?? HiveManager.instance;

  final HiveManager _hiveManager;

  Box<PersonHiveModel> get _box => _hiveManager.personBox;

  @override
  Future<List<PersonEntity>> getAllPersons() async {
    return _runStorage('load persons', () async {
      final List<PersonEntity> persons = _box.values
          .map((PersonHiveModel model) => model.toEntity())
          .toList(growable: false);
      return _sortPersons(persons);
    });
  }

  @override
  Future<PersonEntity?> getPersonById(String id) async {
    return _runStorage('load person', () async {
      final PersonHiveModel? model = _box.get(id);
      return model?.toEntity();
    });
  }

  @override
  Future<PersonEntity> addPerson(PersonEntity person) async {
    return _runStorage('add person', () async {
      if (_box.containsKey(person.id)) {
        throw PersonAlreadyExistsException(person.id);
      }

      final PersonHiveModel model = PersonHiveModel.fromEntity(person);
      await _box.put(person.id, model);
      return model.toEntity();
    });
  }

  @override
  Future<PersonEntity> updatePerson(PersonEntity person) async {
    return _runStorage('update person', () async {
      if (!_box.containsKey(person.id)) {
        throw PersonNotFoundException(person.id);
      }

      final PersonHiveModel model = PersonHiveModel.fromEntity(person);
      await _box.put(person.id, model);
      return model.toEntity();
    });
  }

  @override
  Future<void> deletePerson(String id) async {
    await _runStorage('delete person', () async {
      if (!_box.containsKey(id)) {
        throw PersonNotFoundException(id);
      }

      await _box.delete(id);
    });
  }

  @override
  Future<List<PersonEntity>> searchPersons(String query) async {
    return _runStorage('search persons', () async {
      final String normalizedQuery = query.trim().toLowerCase();
      if (normalizedQuery.isEmpty) {
        final List<PersonEntity> persons = _box.values
            .map((PersonHiveModel model) => model.toEntity())
            .toList(growable: false);
        return _sortPersons(persons);
      }

      final List<PersonEntity> matches = _box.values
          .map((PersonHiveModel model) => model.toEntity())
          .where(
            (PersonEntity person) => _matchesQuery(person, normalizedQuery),
          )
          .toList(growable: false);

      return _sortPersons(matches);
    });
  }

  Future<T> _runStorage<T>(
    String operation,
    Future<T> Function() action,
  ) async {
    if (!_hiveManager.isInitialized) {
      throw PersonLocalStorageException(
        'Hive is not initialized. Cannot $operation.',
      );
    }

    if (!_hiveManager.isPersonBoxOpen) {
      throw PersonLocalStorageException(
        'Person Hive box is not open. Cannot $operation.',
      );
    }

    try {
      return await action();
    } on PersonLocalException {
      rethrow;
    } on HiveError catch (error) {
      throw PersonLocalStorageException(
        'Hive error while trying to $operation: ${error.message}',
      );
    } on Object catch (error) {
      throw PersonLocalStorageException(
        'Unexpected error while trying to $operation: $error',
      );
    }
  }

  List<PersonEntity> _sortPersons(List<PersonEntity> persons) {
    final List<PersonEntity> sorted = List<PersonEntity>.from(persons)
      ..sort(
        (PersonEntity a, PersonEntity b) =>
            b.updatedAt.compareTo(a.updatedAt),
      );
    return sorted;
  }

  bool _matchesQuery(PersonEntity person, String normalizedQuery) {
    return person.name.toLowerCase().contains(normalizedQuery) ||
        person.mobile.toLowerCase().contains(normalizedQuery) ||
        (person.address?.toLowerCase().contains(normalizedQuery) ?? false) ||
        (person.notes?.toLowerCase().contains(normalizedQuery) ?? false);
  }
}
