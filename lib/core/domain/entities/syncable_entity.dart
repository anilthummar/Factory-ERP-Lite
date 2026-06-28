import 'package:equatable/equatable.dart';

import '../../enums/sync_status.dart';

/// Base fields shared by all syncable domain entities.
abstract class SyncableEntity extends Equatable {
  /// Creates [SyncableEntity].
  const SyncableEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
  });

  /// Unique entity identifier.
  final String id;

  /// When the entity was first created.
  final DateTime createdAt;

  /// When the entity was last modified.
  final DateTime updatedAt;

  /// Offline-first sync state.
  final SyncStatus syncStatus;

  @override
  List<Object?> get props => <Object?>[
        id,
        createdAt,
        updatedAt,
        syncStatus,
      ];
}
