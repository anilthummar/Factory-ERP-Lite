import 'syncable_entity.dart';

/// Domain entity for a labor record.
class LaborEntity extends SyncableEntity {
  /// Creates [LaborEntity].
  const LaborEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.syncStatus,
    required this.name,
    required this.mobile,
    required this.skill,
    required this.dailyWage,
    this.notes,
  });

  /// Worker display name.
  final String name;

  /// Contact mobile number.
  final String mobile;

  /// Worker skill or trade.
  final String skill;

  /// Daily wage amount.
  final double dailyWage;

  /// Optional notes.
  final String? notes;

  @override
  List<Object?> get props => <Object?>[
        ...super.props,
        name,
        mobile,
        skill,
        dailyWage,
        notes,
      ];
}
