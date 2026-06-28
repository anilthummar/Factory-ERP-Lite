import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/usecases/notification_use_cases.dart';
import 'notification_event.dart';
import 'notification_state.dart';

export 'notification_event.dart';
export 'notification_state.dart';

/// BLoC for notification initialization, scheduling, and updates.
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  /// Creates [NotificationBloc].
  NotificationBloc({
    required InitializeNotificationsUseCase initializeNotificationsUseCase,
    required RefreshScheduledRemindersUseCase refreshScheduledRemindersUseCase,
    required CancelNotificationUseCase cancelNotificationUseCase,
    required UpdateNotificationUseCase updateNotificationUseCase,
  })  : _initializeNotificationsUseCase = initializeNotificationsUseCase,
        _refreshScheduledRemindersUseCase = refreshScheduledRemindersUseCase,
        _cancelNotificationUseCase = cancelNotificationUseCase,
        _updateNotificationUseCase = updateNotificationUseCase,
        super(const NotificationState()) {
    on<NotificationInitializeRequested>(_onInitialize);
    on<NotificationRefreshRequested>(_onRefresh);
    on<NotificationCancelRequested>(_onCancel);
    on<NotificationUpdateRequested>(_onUpdate);
  }

  final InitializeNotificationsUseCase _initializeNotificationsUseCase;
  final RefreshScheduledRemindersUseCase _refreshScheduledRemindersUseCase;
  final CancelNotificationUseCase _cancelNotificationUseCase;
  final UpdateNotificationUseCase _updateNotificationUseCase;

  Future<void> _onInitialize(
    NotificationInitializeRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: NotificationStatus.initializing,
        clearError: true,
      ),
    );

    try {
      await _initializeNotificationsUseCase();
      emit(
        state.copyWith(
          status: NotificationStatus.success,
          isInitialized: true,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: NotificationStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onRefresh(
    NotificationRefreshRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: NotificationStatus.refreshing,
        clearError: true,
      ),
    );

    try {
      final int count = await _refreshScheduledRemindersUseCase();
      emit(
        state.copyWith(
          status: NotificationStatus.success,
          scheduledCount: count,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: NotificationStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onCancel(
    NotificationCancelRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: NotificationStatus.cancelling,
        clearError: true,
      ),
    );

    try {
      await _cancelNotificationUseCase(event.notificationId);
      emit(state.copyWith(status: NotificationStatus.success));
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: NotificationStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdate(
    NotificationUpdateRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: NotificationStatus.updating,
        clearError: true,
      ),
    );

    try {
      await _updateNotificationUseCase(event.item);
      emit(state.copyWith(status: NotificationStatus.success));
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: NotificationStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
