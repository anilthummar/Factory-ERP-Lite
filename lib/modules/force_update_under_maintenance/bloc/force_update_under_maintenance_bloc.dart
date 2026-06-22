import '../../../utils/exports.dart';

/// A bloc that manages the state for force updates and maintenance.
///
/// This bloc handles checking for app updates and maintenance modes
/// using Firebase Remote Config.
class ForceUpdateUnderMaintenanceBloc
    extends Bloc<ForceUpdateUnderMaintenanceEvent, ForceUpdateUnderMaintenanceState> {
  /// The constructor for [ForceUpdateUnderMaintenanceBloc].
  ForceUpdateUnderMaintenanceBloc()
      : super(const ForceUpdateUnderMaintenanceState(
          status: BaseStateStatus.initial,
          underMaintenanceType: UnderMaintenanceType.none,
          updateMaintenanceType: UpdateMaintenanceType.none,
        )) {
    on<ForceUpdateCheckRequested>(_onCheckRequested);
    on<ForceUpdateRedirectToLoginRequested>(_onRedirectToLoginRequested);
  }

  Future<void> _onCheckRequested(
    ForceUpdateCheckRequested event,
    Emitter<ForceUpdateUnderMaintenanceState> emit,
  ) async {
    await showLoader(value: true);
    ForceUpdateConfigModel? config = await readRemoteConfig();
    UpdateMaintenanceType type = getUpdateOrMaintenanceType(config);

    await showLoader(value: false);
    switch (type) {
      case UpdateMaintenanceType.none:
        {
          add(const ForceUpdateRedirectToLoginRequested());
        }
      case UpdateMaintenanceType.force:
        {
          emit(state.copyWith(
              updateMaintenanceType: UpdateMaintenanceType.force,
              underMaintenanceType: UnderMaintenanceType.none,
              forceUpdateConfigModel: config,
              status: BaseStateStatus.success));
        }
      case UpdateMaintenanceType.optional:
        {
          emit(state.copyWith(
              updateMaintenanceType: UpdateMaintenanceType.optional,
              underMaintenanceType: UnderMaintenanceType.none,
              forceUpdateConfigModel: config,
              status: BaseStateStatus.success));
        }
      case UpdateMaintenanceType.maintenance:
        emit(state.copyWith(
            forceUpdateConfigModel: config,
            updateMaintenanceType: UpdateMaintenanceType.maintenance,
            underMaintenanceType: _underMaintenanceType(config),
            status: BaseStateStatus.success));
    }
  }

  Future<void> _onRedirectToLoginRequested(
    ForceUpdateRedirectToLoginRequested event,
    Emitter<ForceUpdateUnderMaintenanceState> emit,
  ) async {
    emit(state.copyWith(status: BaseStateStatus.success, pageRouteInfo: const LoginRoute()));
  }

  /// Retrieves remote configuration details.
  ///
  /// Returns a [ForceUpdateConfigModel] if successful, otherwise null.
  Future<ForceUpdateConfigModel?> readRemoteConfig() async {
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: Dimens.duration10),
        minimumFetchInterval: const Duration(seconds: Dimens.duration10),
      ));
      await remoteConfig.fetchAndActivate();
      if (remoteConfig.getString(AppConstant.updateApp).isNotEmpty) {
        return ForceUpdateConfigModel.fromJson(
            jsonDecode(remoteConfig.getString(AppConstant.updateApp)));
      }
    } on Exception catch (e) {
      debugPrint("Error fetching remote config: $e");
    }
    remoteConfig.onConfigUpdated.listen((RemoteConfigUpdate event) {
      add(const ForceUpdateCheckRequested());
    });
    return null;
  }

  /// Checks for app updates or maintenance.
  Future<void> checkAppUpdate() async {
    add(const ForceUpdateCheckRequested());
  }

  /// Determines the update or maintenance type based on the configuration.
  UpdateMaintenanceType getUpdateOrMaintenanceType(ForceUpdateConfigModel? config) {
    // get details of android version
    String? androidMinVersion = config?.forceUpdate?.androidMinVersion;
    String? androidMaxVersion = config?.forceUpdate?.androidMaxVersion;

    // get details of iOS version
    String? iosMaxVersion = config?.forceUpdate?.iosMaxVersion;
    String? iosMinVersion = config?.forceUpdate?.iosMinVersion;

    // get details current version
    String currentAppVersion = getIt<MainConfig>().packageInfo.version;

    if (config?.underMaintenance?.isMaintainanceModeEnable ?? false) {
      return UpdateMaintenanceType.maintenance;
    }
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        if (androidMinVersion != null) {
          // check if current app version is less than min version
          // then do force update
          if (currentAppVersion.compareTo(androidMinVersion) < 0) {
            return UpdateMaintenanceType.force;
          } else if (androidMaxVersion != null &&
              currentAppVersion.compareTo(androidMinVersion) >= 0 &&
              currentAppVersion.compareTo(androidMaxVersion) < 0) {
            return UpdateMaintenanceType.optional;
          }
        }
        return UpdateMaintenanceType.none;
      } else if (Platform.isIOS) {
        if (iosMinVersion != null) {
          if (currentAppVersion.compareTo(iosMinVersion) < 0) {
            return UpdateMaintenanceType.force;
          } else if (iosMaxVersion != null &&
              currentAppVersion.compareTo(iosMinVersion) >= 0 &&
              currentAppVersion.compareTo(iosMaxVersion) < 0) {
            return UpdateMaintenanceType.optional;
          }
        }
        return UpdateMaintenanceType.none;
      }
    }
    return UpdateMaintenanceType.none;
  }

  /// Determines the type of under maintenance mode.
  static UnderMaintenanceType _underMaintenanceType(ForceUpdateConfigModel? config) {
    if ((config?.underMaintenance?.maintainancePriority ?? 0) == UnderMaintenanceType.image.type) {
      return UnderMaintenanceType.image;
    } else {
      return UnderMaintenanceType.text;
    }
  }

  /// Opens the Play Store or App Store for updates.
  Future<void> openPlayStoreAppStore() async {
    Uri parseUrl;
    try {
      if (Platform.isAndroid) {
        parseUrl = Uri.parse(
            '${AppConstant.playStoreURL}${getIt<MainConfig>().packageInfo.packageName}');
      } else if (Platform.isIOS) {
        parseUrl = Uri.parse('${AppConstant.appstoreURL}${AppConstant.appId}');
      } else {
        throw PlatformException(
            code: 'PlatformNotSupported', message: 'This platform is not supported');
      }

      if (await canLaunchUrl(parseUrl)) {
        await launchUrl(parseUrl);
      } else {
        throw 'Could not launch ${parseUrl.toString()}';
      }
    } on Exception catch (e) {
      debugPrint("Error launching store: $e");
    }
  }

  /// Redirects to the login page.
  void redirectToLogin() {
    add(const ForceUpdateRedirectToLoginRequested());
  }
}
