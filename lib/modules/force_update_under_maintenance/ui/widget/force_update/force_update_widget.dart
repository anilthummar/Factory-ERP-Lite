import '../../../../../utils/exports.dart';

/// A widget that handles force updates and maintenance views.
///
/// This widget uses a [BlocConsumer] to manage the state of force updates
/// and maintenance, displaying appropriate views based on the state.
class ForceUpdateWidget extends BaseResponsiveView {
  /// The constructor for [ForceUpdateWidget].
  const ForceUpdateWidget({super.key});

  @override
  Widget buildDesktopWidget(BuildContext context) {
    return _buildView(context);
  }

  @override
  Widget buildMobileWidget(BuildContext context) {
    return _buildView(context);
  }

  @override
  Widget buildTabletWidget(BuildContext context) {
    return _buildView(context);
  }

  /// Builds the view for the force update and maintenance widget.
  ///
  /// [context] is the build context.
  Widget _buildView(BuildContext context) {
    return BlocConsumer<ForceUpdateUnderMaintenanceBloc,
        ForceUpdateUnderMaintenanceState>(
      builder: (BuildContext context, ForceUpdateUnderMaintenanceState state) {
        return Visibility(
          replacement: Container(color: AppColors.instance.transparent),
          visible: state.underMaintenanceType != UnderMaintenanceType.none,
          child: Center(
            child: state.underMaintenanceType == UnderMaintenanceType.image
                ? UnderMaintenanceImageWidget(
                    config: state.forceUpdateConfigModel)
                : UnderMaintenanceTextWidget(
                    config: state.forceUpdateConfigModel),
          ),
        );
      },
      listener:
          (BuildContext context, ForceUpdateUnderMaintenanceState state) async {
        if (state.status == BaseStateStatus.success &&
            state.pageRouteInfo != null) {
          if (context.mounted) {
            await context.router.pushAndPopUntil(state.pageRouteInfo!,
                predicate: (Route<dynamic> route) => false);
          }
        }
        if (state.updateMaintenanceType != UpdateMaintenanceType.none &&
            state.updateMaintenanceType != UpdateMaintenanceType.maintenance &&
            context.mounted) {
          await _showUpdateDialog(state.forceUpdateConfigModel,
              isMandatory:
                  state.updateMaintenanceType == UpdateMaintenanceType.force,
              context: context);
        }
      },
      buildWhen: (ForceUpdateUnderMaintenanceState previous,
              ForceUpdateUnderMaintenanceState current) =>
          (current.status == BaseStateStatus.success) &&
          (current.underMaintenanceType != previous.underMaintenanceType),
      listenWhen: (ForceUpdateUnderMaintenanceState previous,
              ForceUpdateUnderMaintenanceState current) =>
          ((current.status == BaseStateStatus.success) &&
              (current.updateMaintenanceType !=
                  previous.updateMaintenanceType)) ||
          ((current.status == BaseStateStatus.success) &&
              (current.pageRouteInfo != null)),
    );
  }

  /// Displays a dialog with update information.
  ///
  /// [configModel] is the configuration model for force updates.
  /// [isMandatory] indicates if the update is mandatory.
  /// [context] is the build context.
  Future<void> _showUpdateDialog(ForceUpdateConfigModel? configModel,
      {required bool isMandatory, required BuildContext context}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (BuildContext ctx) {
        return PopScope(
          canPop: false,
          child: DialogUtils(
            isDialogHideOnClick: false,
            message: configModel?.forceUpdate?.forceUpdateMsg ?? '',
            title: ctx.appString.updateAppKey,
            okBtnTitle: ctx.appString.updateKey,
            cancelBtnTitle: isMandatory ? null : ctx.appString.cancelKey,
            onOkClicked: () async {
              await context
                  .instance<ForceUpdateUnderMaintenanceBloc>()
                  .openPlayStoreAppStore();
              if (context.mounted) {
                await goBack(context);
              }
            },
            onCancelClicked: isMandatory
                ? null
                : () {
                   unawaited( goBack(context));
                    context
                        .instance<ForceUpdateUnderMaintenanceBloc>()
                        .redirectToLogin();
                  },
          ),
        );
      },
    );
  }
}
