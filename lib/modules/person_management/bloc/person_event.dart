import 'package:equatable/equatable.dart';

import '../../../core/domain/entities/person_entity.dart';

/// Person feature events.
sealed class PersonEvent extends Equatable {
  /// Creates [PersonEvent].
  const PersonEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads all persons from local storage.
final class PersonLoadRequested extends PersonEvent {
  /// Creates [PersonLoadRequested].
  const PersonLoadRequested();
}

/// Reloads persons (pull-to-refresh).
final class PersonRefreshRequested extends PersonEvent {
  /// Creates [PersonRefreshRequested].
  const PersonRefreshRequested();
}

/// Searches persons by [query].
final class PersonSearchRequested extends PersonEvent {
  /// Creates [PersonSearchRequested].
  const PersonSearchRequested(this.query);

  /// Search text.
  final String query;

  @override
  List<Object?> get props => <Object?>[query];
}

/// Creates a new person record.
final class PersonCreateRequested extends PersonEvent {
  /// Creates [PersonCreateRequested].
  const PersonCreateRequested({
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
  List<Object?> get props => <Object?>[name, mobile, address, notes];
}

/// Updates an existing person record.
final class PersonUpdateRequested extends PersonEvent {
  /// Creates [PersonUpdateRequested].
  const PersonUpdateRequested({
    required this.person,
    required this.name,
    required this.mobile,
    this.address,
    this.notes,
  });

  /// Existing person record to update.
  final PersonEntity person;

  /// Updated display name.
  final String name;

  /// Updated mobile number.
  final String mobile;

  /// Updated address.
  final String? address;

  /// Updated notes.
  final String? notes;

  @override
  List<Object?> get props => <Object?>[
        person,
        name,
        mobile,
        address,
        notes,
      ];
}

/// Deletes a person record by [id].
final class PersonDeleteRequested extends PersonEvent {
  /// Creates [PersonDeleteRequested].
  const PersonDeleteRequested(this.id);

  /// Person identifier.
  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}
