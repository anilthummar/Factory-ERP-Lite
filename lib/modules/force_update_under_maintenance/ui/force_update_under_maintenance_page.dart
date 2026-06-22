import '../../../../utils/exports.dart';

/// A page that handles force updates and maintenance.
///
/// This page uses the [ForceUpdateUnderMaintenanceBloc] to check for updates
/// and displays the [ForceUpdateWidget].
@RoutePage()
class ForceUpdateUnderMaintenancePage extends StatelessWidget {
  /// The constructor for [ForceUpdateUnderMaintenancePage].
  const ForceUpdateUnderMaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    unawaited(context.instance<ForceUpdateUnderMaintenanceBloc>().checkAppUpdate());
    return const ForceUpdateWidget();
  }
}
