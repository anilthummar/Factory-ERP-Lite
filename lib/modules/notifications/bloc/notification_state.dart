import 'package:equatable/equatable.dart';

/// Status for notification operations.
enum NotificationStatus {
  /// Idle.
  idle,

  /// Initializing services.
  initializing,

  /// Refreshing scheduled reminders.
  refreshing,

  /// Cancelling a notification.
  cancelling,

  /// Updating a notification.
  updating,

  /// Last operation succeeded.
  success,

  /// Last operation failed.
  failure,
}

/// State for notification BLoC.
class NotificationState extends Equatable {
  /// Creates [NotificationState].
  const NotificationState({
    this.status = NotificationStatus.idle,
    this.scheduledCount = 0,
    this.isInitialized = false,
    this.errorMessage,
  });

  /// Current operation status.
  final NotificationStatus status;

  /// Number of locally scheduled reminders after last refresh.
  final int scheduledCount;

  /// Whether local + FCM handlers are ready.
  final bool isInitialized;

  /// Error from the last failed operation.
  final String? errorMessage;

  /// Returns a copy with the given fields replaced.
  NotificationState copyWith({
    NotificationStatus? status,
    int? scheduledCount,
    bool? isInitialized,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationState(
      status: status ?? this.status,
      scheduledCount: scheduledCount ?? this.scheduledCount,
      isInitialized: isInitialized ?? this.isInitialized,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        scheduledCount,
        isInitialized,
        errorMessage,
      ];
}
