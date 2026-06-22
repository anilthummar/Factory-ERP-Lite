/// Model representing the full configuration for force update and maintenance mode.
class ForceUpdateConfigModel {
  /// Configuration related to force updates.
  ForceUpdate? forceUpdate;

  /// Configuration related to maintenance mode.
  UnderMaintainance? underMaintenance;

  /// Constructor for [ForceUpdateConfigModel].
  ForceUpdateConfigModel({this.forceUpdate, this.underMaintenance});

  /// Creates a [ForceUpdateConfigModel] from a JSON map.
  ForceUpdateConfigModel.fromJson(Map<String, dynamic> json) {
    forceUpdate = json['force_update'] != null
        ? ForceUpdate.fromJson(json['force_update'])
        : null;
    underMaintenance = json['under_maintainance'] != null
        ? UnderMaintainance.fromJson(json['under_maintainance'])
        : null;
  }

  /// Converts the model to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (forceUpdate != null) {
      data['force_update'] = forceUpdate!.toJson();
    }
    if (underMaintenance != null) {
      data['under_maintainance'] = underMaintenance!.toJson();
    }
    return data;
  }
}

/// Model representing force update configurations for Android and iOS.
class ForceUpdate {
  /// Maximum supported version for Android.
  String? androidMaxVersion;

  /// Minimum required version for Android.
  String? androidMinVersion;

  /// Maximum supported version for iOS.
  String? iosMaxVersion;

  /// Minimum required version for iOS.
  String? iosMinVersion;

  /// Message to be shown during force update.
  String? forceUpdateMsg;

  /// Constructor for [ForceUpdate].
  ForceUpdate({
    this.androidMaxVersion,
    this.androidMinVersion,
    this.iosMaxVersion,
    this.iosMinVersion,
    this.forceUpdateMsg,
  });

  /// Creates a [ForceUpdate] instance from a JSON map.
  ForceUpdate.fromJson(Map<String, dynamic> json) {
    androidMaxVersion = json['android_max_version'];
    androidMinVersion = json['android_min_version'];
    iosMaxVersion = json['ios_max_version'];
    iosMinVersion = json['ios_min_version'];
    forceUpdateMsg = json['force_update_msg'];
  }

  /// Converts the model to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['android_max_version'] = androidMaxVersion;
    data['android_min_version'] = androidMinVersion;
    data['ios_max_version'] = iosMaxVersion;
    data['ios_min_version'] = iosMinVersion;
    data['force_update_msg'] = forceUpdateMsg;
    return data;
  }
}

/// Model representing maintenance mode configuration and details.
class UnderMaintainance {
  /// Whether maintenance mode is enabled.
  bool? isMaintainanceModeEnable;

  /// Title to be displayed during maintenance.
  String? maintainanceTitle;

  /// Description to be displayed during maintenance.
  String? maintainanceDescription;

  /// Image URL or asset used during maintenance mode.
  String? maintainanceImage;

  /// Priority level of the maintenance message.
  int? maintainancePriority;

  /// Constructor for [UnderMaintainance].
  UnderMaintainance({
    this.isMaintainanceModeEnable,
    this.maintainanceTitle,
    this.maintainanceDescription,
    this.maintainanceImage,
    this.maintainancePriority,
  });

  /// Creates an [UnderMaintainance] instance from a JSON map.
  UnderMaintainance.fromJson(Map<String, dynamic> json) {
    isMaintainanceModeEnable = json['is_maintainance_mode_enable'];
    maintainanceTitle = json['maintainance_title'];
    maintainanceDescription = json['maintainance_description'];
    maintainanceImage = json['maintainance_image'];
    maintainancePriority = json['maintainance_priority'];
  }

  /// Converts the model to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_maintainance_mode_enable'] = isMaintainanceModeEnable;
    data['maintainance_title'] = maintainanceTitle;
    data['maintainance_description'] = maintainanceDescription;
    data['maintainance_image'] = maintainanceImage;
    data['maintainance_priority'] = maintainancePriority;
    return data;
  }
}
