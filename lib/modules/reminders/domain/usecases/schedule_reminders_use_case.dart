import '../../service/reminder_scheduler_service.dart';

/// Schedules recurring, maintenance, and calendar event reminders.
class ScheduleRemindersUseCase {
  /// Creates [ScheduleRemindersUseCase].
  const ScheduleRemindersUseCase(this._scheduler);

  final ReminderSchedulerService _scheduler;

  /// Refreshes all upcoming local reminders.
  Future<void> call() => _scheduler.refreshScheduledReminders();
}
