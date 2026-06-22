import '../../utils/exports.dart';

/// Utility class for Permission asking and granting.
///
/// Customized [PermissionManager] as per this app's
/// requirement.
class PermissionManager {
  static final PermissionManager _singletonApiProvider =
      PermissionManager._internal();

  /// The factory constructor for [PermissionManager].
  factory PermissionManager() {
    return _singletonApiProvider;
  }

  PermissionManager._internal();

  /// Requests multiple permissions.
  FutureOr<bool> requestPermissions(List<Permission> permissions) async {
    final Map<Permission, PermissionStatus> status = await permissions.request();

    bool granted = true;
    for (final MapEntry<Permission, PermissionStatus> entry in status.entries) {
      if (!entry.value.isGranted) {
        granted = false;
      }
    }

    return granted;
  }

  /// Checks if all permissions are granted.
  FutureOr<bool> isAllPermissionsGranted(List<Permission> permissions) async {
    Map<Permission, PermissionStatus> permissionStatuses =
        await permissions.request();

    for (final Permission permission in permissionStatuses.keys) {
      if (permissionStatuses[permission] != PermissionStatus.granted) {
        return false; // Permission not granted
      }
    }

    return true; // All permissions granted
  }

  //----------------------------------------------------------------
  /// Checks if the Android OS version is 33 or greater.
  FutureOr<bool> isAndroidOSVersionIS13() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt > 32) {
      return true;
    } else {
      return false;
    }
  }

  /// Checks if the location permission is granted.
  FutureOr<bool> checkLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    } else {
      if (status.isDenied) {
        // We didn't ask for permission yet or
        //the permission has been denied before but not permanently.
        return false;
      } else {
        return false;
      }
    }
  }

  /// Requests the location permission.
  FutureOr<bool> requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    bool st = false;
    if (status == PermissionStatus.granted) {
      DebugLog.instance.d('Permission granted');
      st = true;
    } else if (status == PermissionStatus.denied) {
      //await openAppSettings();
      st = false;
      DebugLog.instance.d(
          'Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      DebugLog.instance.d('Take the user to the settings page.');
      await openAppSettings();
    }
    return st;
  }

  /// Checks if the storage permission is granted.
  FutureOr<bool> checkStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    } else {
      if (status.isDenied) {
        // We didn't ask for permission yet or
        //the permission has been denied before but not permanently.
        return true;
      } else {
        return false;
      }
    }
  }

  /// Requests the storage permission.
  FutureOr<bool> requestStoragePermission() async {
    final PermissionStatus status = await Permission.storage.request();
    bool st = false;
    if (status == PermissionStatus.granted) {
      DebugLog.instance.d('Permission granted');
      st = true;
    } else if (status == PermissionStatus.denied) {
      //await openAppSettings();
      st = false;
      DebugLog.instance.d(
          'Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      DebugLog.instance.d('Take the user to the settings page.');
      await openAppSettings();
    }
    return st;
  }

  /// Checks if the SMS permission is granted.
  FutureOr<bool> checkSMSPermission() async {
    PermissionStatus status = await Permission.sms.status;
    if (status.isGranted) {
      return true;
    } else {
      if (status.isDenied) {
        // We didn't ask for permission yet or
        //the permission has been denied before but not permanently.
        return true;
      } else {
        return false;
      }
    }
  }

  /// Requests the SMS permission.
  FutureOr<bool> requestSMSPermission() async {
    final PermissionStatus status = await Permission.sms.request();
    bool st = false;
    if (status == PermissionStatus.granted) {
      DebugLog.instance.d('Permission granted');
      st = true;
    } else if (status == PermissionStatus.denied) {
      //await openAppSettings();
      st = false;
      DebugLog.instance.d(
          'Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      DebugLog.instance.d('Take the user to the settings page.');
      await openAppSettings();
    }
    return st;
  }

  /// Checks if the contacts permission is granted.
  FutureOr<bool> checkContactsPermission() async {
    PermissionStatus status = await Permission.contacts.status;
    if (status.isGranted) {
      return true;
    } else {
      if (status.isDenied) {
        // We didn't ask for permission yet or
        //the permission has been denied before but not permanently.
        return true;
      } else {
        return false;
      }
    }
  }

  /// Requests the contacts permission.
  FutureOr<bool> requestContactPermission() async {
    final PermissionStatus status = await Permission.contacts.request();
    bool st = false;
    if (status == PermissionStatus.granted) {
      DebugLog.instance.d('Permission granted');
      st = true;
    } else if (status == PermissionStatus.denied) {
      //await openAppSettings();
      st = false;
      DebugLog.instance.d(
          'Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      DebugLog.instance.d('Take the user to the settings page.');
      await openAppSettings();
    }
    return st;
  }

  /// Checks if the phone permission is granted.
  FutureOr<bool> checkPhonePermission() async {
    PermissionStatus status = await Permission.phone.status;
    if (status.isGranted) {
      return true;
    } else {
      if (status.isDenied) {
        // We didn't ask for permission yet or
        //the permission has been denied before but not permanently.
        return true;
      } else {
        return false;
      }
    }
  }

  /// Requests the phone permission.
  FutureOr<bool> requestPhonePermission() async {
    final PermissionStatus status = await Permission.phone.request();
    bool st = false;
    if (status == PermissionStatus.granted) {
      DebugLog.instance.d('Permission granted');
      st = true;
    } else if (status == PermissionStatus.denied) {
      //await openAppSettings();
      st = false;
      DebugLog.instance.d(
          'Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      DebugLog.instance.d('Take the user to the settings page.');
      await openAppSettings();
    }
    return st;
  }

  /// Checks if the camera permission is granted.
  FutureOr<bool> checkCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    } else {
      if (status.isDenied) {
        return false;
      } else {
        return false;
      }
    }
  }

  /// Requests the camera permission.
  FutureOr<bool> requestCameraPermission() async {
    final PermissionStatus status = await Permission.camera.request();
    bool st = false;
    if (status == PermissionStatus.granted) {
      DebugLog.instance.d('Permission granted');
      st = true;
    } else if (status == PermissionStatus.denied) {
      //await openAppSettings();
      DebugLog.instance.d(
          'Permission denied. Show a dialog and again ask for the permission');
      st = false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      DebugLog.instance.d('Take the user to the settings page.');
      await openAppSettings();
    }
    return st;
  }

  /// Requests the notifications permission.
  FutureOr<bool> requestNotificationsPermission() async {
    final PermissionStatus status = await Permission.notification.request();
    bool st = false;
    if (status == PermissionStatus.granted) {
      DebugLog.instance.d('Permission granted');
      st = true;
    } else if (status == PermissionStatus.denied) {
      //await openAppSettings();
      DebugLog.instance.d(
          'Permission denied. Show a dialog and again ask for the permission');
      st = false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      DebugLog.instance.d('Take the user to the settings page.');
      await openAppSettings();
    }
    return st;
  }

  /// Asks for necessary permissions.
  Future<void> askPermission() async {
    bool value = await PermissionManager().requestLocationPermission();
    if (value) {
      bool contactPermission = await requestContactPermission();
      if (contactPermission) {
        bool storagePermission = await requestPhonePermission();
        if (storagePermission) {
          // var smsPermission = await requestSMSPermission();
        }
      }
    }
  }

  /// Opens the mobile settings page.
  Future<void> openMobileSetting() async {
    await openAppSettings();
  }
}
