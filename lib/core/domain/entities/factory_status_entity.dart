import '../enums/factory_status_type.dart';
import 'syncable_entity.dart';

/// Domain entity for the current factory operating status.
class FactoryStatusEntity extends SyncableEntity {
  /// Creates [FactoryStatusEntity].
  const FactoryStatusEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.syncStatus,
    required this.status,
    this.notes,
  });

  /// Current factory operating status.
  final FactoryStatusType status;

  /// Optional status change notes.
  final String? notes;

  @override
  List<Object?> get props => <Object?>[
        ...super.props,
        status,
        notes,
      ];
}
