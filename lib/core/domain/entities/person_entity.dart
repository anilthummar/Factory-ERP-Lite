import 'syncable_entity.dart';

/// Domain entity for a person record.
class PersonEntity extends SyncableEntity {
  /// Creates [PersonEntity].
  const PersonEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.syncStatus,
    required this.name,
    required this.mobile,
    this.address,
    this.notes,
  });

  /// Person display name.
  final String name;

  /// Contact mobile number.
  final String mobile;

  /// Optional address.
  final String? address;

  /// Optional notes.
  final String? notes;

  @override
  List<Object?> get props => <Object?>[
        ...super.props,
        name,
        mobile,
        address,
        notes,
      ];
}
