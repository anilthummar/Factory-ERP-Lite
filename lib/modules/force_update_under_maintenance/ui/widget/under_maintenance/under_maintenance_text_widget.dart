import '../../../../../utils/exports.dart';

/// A widget that displays maintenance information as text.
///
/// This widget shows maintenance title and description based on the
/// provided `ForceUpdateConfigModel` configuration.
class UnderMaintenanceTextWidget extends StatelessWidget {
  /// The configuration for the maintenance.
  final ForceUpdateConfigModel? config;

  /// The constructor for [UnderMaintenanceTextWidget]. 
  const UnderMaintenanceTextWidget({super.key, this.config});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.padding8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomTextLabelWidget(
            label: config?.underMaintenance?.maintainanceTitle ?? '',
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: Dimens.space20),
          CustomTextLabelWidget(
            label: config?.underMaintenance?.maintainanceDescription ?? '',
            style: context.textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
