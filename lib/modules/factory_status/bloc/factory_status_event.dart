import 'package:equatable/equatable.dart';

import '../../../core/domain/enums/factory_status_type.dart';

/// Factory status BLoC events.
sealed class FactoryStatusEvent extends Equatable {
  const FactoryStatusEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads current status and full history.
final class FactoryStatusLoadRequested extends FactoryStatusEvent {
  /// Creates [FactoryStatusLoadRequested].
  const FactoryStatusLoadRequested();
}

/// Reloads status data without clearing existing state.
final class FactoryStatusRefreshRequested extends FactoryStatusEvent {
  /// Creates [FactoryStatusRefreshRequested].
  const FactoryStatusRefreshRequested();
}

/// Records a new factory status change.
final class FactoryStatusChangeRequested extends FactoryStatusEvent {
  /// Creates [FactoryStatusChangeRequested].
  const FactoryStatusChangeRequested({
    required this.status,
    this.notes,
  });

  /// Selected operating status.
  final FactoryStatusType status;

  /// Optional change notes.
  final String? notes;

  @override
  List<Object?> get props => <Object?>[status, notes];
}
