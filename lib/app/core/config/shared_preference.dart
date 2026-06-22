import '../../../utils/exports.dart';

/// A utility class for handling encrypted shared preferences storage.
///
/// This class provides methods to store and retrieve various data types
/// in an encrypted format using platform-specific encryption keys.
/// It uses GetStorage for the underlying storage mechanism.
class SharedPref {
  /// Key for storing the user's logged-in state
  static String isLoggedInKey = "keyIsLoggedIn";

  /// Key for storing the user's ID
  static String userIdKey = 'keyUserID';

  /// Key for storing the current locale/language setting
  static String currentLocaleKey = "KeyCurrentLocale";

  /// Singleton instance of SharedPref
  static SharedPref instance = getIt<SharedPref>();

  /// Instance of GetStorage for data persistence
  GetStorage? _prefsInstance;

  /// Encryption key used for data encryption/decryption
  String encryptKey = "";

  /// Initialization vector used for encryption/decryption
  String encryptIv = "";

  /// Initializes the shared preferences and encryption keys.
  ///
  /// This method must be called before using any other methods.
  /// Sets up platform-specific encryption initialization vectors.
  void init() {
    _prefsInstance ??= GetStorage();
    _getEncryptionKey();
    if (kIsWeb) {
      encryptIv = AppConstant.web.padLeft(AppConstant.encryptionLength, "0");
    } else {
      if (Platform.isAndroid) {
        encryptIv =
            AppConstant.android.padLeft(AppConstant.encryptionLength, "0");
      } else if (Platform.isIOS) {
        encryptIv = AppConstant.ios.padLeft(AppConstant.encryptionLength, "0");
      }
    }
  }

  /// Verifies if preferences are initialized.
  ///
  /// Throws an assertion error if preferences are not initialized.
  void _isPreferenceReady() {
    assert(_prefsInstance != null, "SharedPreferences not ready yet!");
  }

  /// Retrieves a boolean value from storage.
  ///
  /// [key] The key to retrieve the value for
  /// [defValue] Optional default value if key doesn't exist
  /// Returns the stored boolean value or the default value
  bool getBool(String key, [dynamic defValue]) {
    String? value = _decodedValue(key);
    return value.isNotNullOrEmpty ? bool.parse(value!) : defValue ?? false;
  }

  /// Retrieves an integer value from storage.
  ///
  /// [key] The key to retrieve the value for
  /// [defValue] Optional default value if key doesn't exist
  /// Returns the stored integer value or the default value
  int getInt(String key, [int? defValue]) {
    String? value = _decodedValue(key);
    return value.isNotNullOrEmpty ? int.parse(value!) : defValue ?? 0;
  }

  /// Retrieves a double value from storage.
  ///
  /// [key] The key to retrieve the value for
  /// [defValue] Optional default value if key doesn't exist
  /// Returns the stored double value or the default value
  double getDouble(String key, [double? defValue]) {
    String? value = _decodedValue(key);
    return value.isNotNullOrEmpty ? double.parse(value!) : defValue ?? 0.0;
  }

  /// Retrieves a string value from storage.
  ///
  /// [key] The key to retrieve the value for
  /// [defValue] Optional default value if key doesn't exist
  /// Returns the stored string value or the default value
  String getString(String key, [String? defValue]) {
    String? value = _decodedValue(key);
    return value.isNotNullOrEmpty ? value! : defValue ?? "";
  }

  /// Stores an encrypted value in storage.
  ///
  /// [key] The key to store the value under
  /// [value] The value to store (will be converted to string)
  /// Returns a Future that completes when the value is stored
  Future<void> setValue(String key, dynamic value) async {
    String? encrypted = AESEncryption.instance.encryptCode(
      encryptKey,
      encryptIv,
      text: value.toString(),
    );
    await _prefsInstance?.write(key, encrypted);
  }

  /// Removes a value from storage.
  ///
  /// [key] The key to remove
  /// Returns a Future that completes when the value is removed
  Future<void> remove(String key) async {
    await _prefsInstance?.remove(key);
  }

  /// Gets all keys currently stored in preferences.
  ///
  /// Returns a Set of strings containing all stored keys
  Set<String>? getKeys() {
    _isPreferenceReady();
    return _prefsInstance?.getKeys();
  }

  /// Clears all stored data from preferences.
  ///
  /// Returns a Future that completes when all data is cleared
  Future<void> clearData() async {
    await _prefsInstance?.erase();
  }

  /// Disposes of the shared preferences instance.
  ///
  /// Should be called in the State object's dispose() method
  void dispose() {
    _prefsInstance = null;
  }

  /// Decrypts and retrieves a value from storage.
  ///
  /// [key] The key of the value to decrypt
  /// Returns the decrypted value as a string or null if not found
  String? _decodedValue(String key) {
    _isPreferenceReady();
    if (_prefsInstance?.read(key) != null) {
      dynamic value = _prefsInstance?.read(key);
      return AESEncryption.instance
          .decryptCode(encryptKey, encryptIv, text: value);
    } else {
      return null;
    }
  }

  /// Initializes the encryption key based on package name.
  ///
  /// Ensures the encryption key meets the required length by
  /// either truncating or padding with zeros.
  void _getEncryptionKey() {
    encryptKey =
        getIt<MainConfig>().packageInfo.packageName.replaceAll(".", "0");
    //check if encryption key is less than AppConstant.encryptionLength digit then add 0 in the end
    if (encryptKey.length > AppConstant.encryptionLength) {
      encryptKey = encryptKey.substring(0, AppConstant.encryptionLength);
    } else {
      encryptKey = encryptKey.padLeft(AppConstant.encryptionLength, "0");
    }
  }
}
