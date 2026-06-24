import 'package:equatable/equatable.dart';

import '../../../core/domain/entities/factory_status_entity.dart';

/// Factory status BLoC loading status.
enum FactoryStatusBlocStatus {
  /// Initial state.
  initial,

  /// Loading data.
  loading,

  /// Data loaded successfully.
  success,

  /// Mutation or load failed.
  failure,

  /// Status change saved successfully.
  saved,
}

/// Factory status BLoC state.
class FactoryStatusState extends Equatable {
  /// Creates [FactoryStatusState].
  const FactoryStatusState({
    this.status = FactoryStatusBlocStatus.initial,
    this.currentStatus,
    this.history = const <FactoryStatusEntity>[],
    this.errorMessage,
  });

  /// Current loading/mutation status.
  final FactoryStatusBlocStatus status;

  /// Latest factory status entry.
  final FactoryStatusEntity? currentStatus;

  /// Full status history, newest first.
  final List<FactoryStatusEntity> history;

  /// Error message when [status] is [FactoryStatusBlocStatus.failure].
  final String? errorMessage;

  /// Recent history entries for overview timeline.
  List<FactoryStatusEntity> get recentHistory {
    if (history.length <= 5) {
      return history;
    }
    return history.sublist(0, 5);
  }

  /// Returns a copy with selective overrides.
  FactoryStatusState copyWith({
    FactoryStatusBlocStatus? status,
    FactoryStatusEntity? currentStatus,
    List<FactoryStatusEntity>? history,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FactoryStatusState(
      status: status ?? this.status,
      currentStatus: currentStatus ?? this.currentStatus,
      history: history ?? this.history,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        currentStatus,
        history,
        errorMessage,
      ];
}
