import 'package:equatable/equatable.dart';

import '../../../core/domain/entities/labor_entity.dart';

/// Labor feature events.
sealed class LaborEvent extends Equatable {
  /// Creates [LaborEvent].
  const LaborEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads all labor records from local storage.
final class LaborLoadRequested extends LaborEvent {
  /// Creates [LaborLoadRequested].
  const LaborLoadRequested();
}

/// Reloads labor records (pull-to-refresh).
final class LaborRefreshRequested extends LaborEvent {
  /// Creates [LaborRefreshRequested].
  const LaborRefreshRequested();
}

/// Searches labor records by [query].
final class LaborSearchRequested extends LaborEvent {
  /// Creates [LaborSearchRequested].
  const LaborSearchRequested(this.query);

  /// Search text.
  final String query;

  @override
  List<Object?> get props => <Object?>[query];
}

/// Creates a new labor record.
final class LaborCreateRequested extends LaborEvent {
  /// Creates [LaborCreateRequested].
  const LaborCreateRequested({
    required this.name,
    required this.mobile,
    required this.skill,
    required this.dailyWage,
    this.notes,
  });

  /// Labor display name.
  final String name;

  /// Contact mobile number.
  final String mobile;

  /// Skill or trade.
  final String skill;

  /// Daily wage amount.
  final double dailyWage;

  /// Optional notes.
  final String? notes;

  @override
  List<Object?> get props => <Object?>[name, mobile, skill, dailyWage, notes];
}

/// Updates an existing labor record.
final class LaborUpdateRequested extends LaborEvent {
  /// Creates [LaborUpdateRequested].
  const LaborUpdateRequested({
    required this.labor,
    required this.name,
    required this.mobile,
    required this.skill,
    required this.dailyWage,
    this.notes,
  });

  /// Existing labor record to update.
  final LaborEntity labor;

  /// Updated display name.
  final String name;

  /// Updated mobile number.
  final String mobile;

  /// Updated skill.
  final String skill;

  /// Updated daily wage.
  final double dailyWage;

  /// Updated notes.
  final String? notes;

  @override
  List<Object?> get props =>
      <Object?>[labor, name, mobile, skill, dailyWage, notes];
}

/// Deletes a labor record by [id].
final class LaborDeleteRequested extends LaborEvent {
  /// Creates [LaborDeleteRequested].
  const LaborDeleteRequested(this.id);

  /// Labor identifier.
  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}
