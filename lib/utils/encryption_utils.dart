import 'package:encrypt/encrypt.dart';
import '../base/singleton.dart';

/// Utility class for AES encryption and decryption.
///
/// Uses AES algorithm with PKCS7 padding and CBC mode.
class AESEncryption {
  /// The instance of the [AESEncryption].
  static AESEncryption instance = getIt<AESEncryption>();

  /// Encrypts the given text using the provided key and IV.
  ///
  /// [encryptKey] is the encryption key.
  /// [encryptIV] is the initialization vector.
  /// [text] is the text to encrypt.
  ///
  /// Returns the encrypted text as a base64 string.
  String encryptCode(String encryptKey, String encryptIV, {String? text = ""}) {
    Key key = Key.fromUtf8(encryptKey);
    IV iv = IV.fromUtf8(encryptIV);
    return Encrypter(AES(key, mode: AESMode.cbc)).encrypt(text!, iv: iv).base64;
  }

  /// Decrypts the given text using the provided key and IV.
  ///
  /// [encryptKey] is the encryption key.
  /// [encryptIV] is the initialization vector.
  /// [text] is the text to decrypt.
  ///
  /// Returns the decrypted text.
  String decryptCode(
    String encryptKey,
    String encryptIV, {
    String? text = "",
  }) {
    Key key = Key.fromUtf8(encryptKey);
    IV iv = IV.fromUtf8(encryptIV);
    return Encrypter(AES(key, mode: AESMode.cbc)).decrypt64(text!, iv: iv);
  }
}
