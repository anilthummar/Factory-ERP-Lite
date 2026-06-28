import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../../../service/firebase/firebase_service.dart';

/// Result of a Firebase Storage upload.
class AttachmentUploadResult {
  /// Creates [AttachmentUploadResult].
  const AttachmentUploadResult({
    required this.downloadUrl,
    required this.storagePath,
  });

  /// Public download URL for the uploaded file.
  final String downloadUrl;

  /// Firebase Storage object path.
  final String storagePath;
}

/// Uploads attachment files to Firebase Storage.
class AttachmentStorageRemoteDataSource {
  /// Creates [AttachmentStorageRemoteDataSource].
  AttachmentStorageRemoteDataSource({
    required FirebaseService firebaseService,
    FirebaseStorage? storage,
  })  : _firebaseService = firebaseService,
        _storage = storage;

  final FirebaseService _firebaseService;
  final FirebaseStorage? _storage;

  FirebaseStorage get _resolvedStorage =>
      _storage ?? _firebaseService.storage;

  /// Uploads [localPath] to Firebase Storage at [storagePath].
  Future<AttachmentUploadResult> uploadFile({
    required String localPath,
    required String storagePath,
    required String contentType,
  }) async {
    if (!_firebaseService.isInitialized) {
      throw StateError('Firebase is not initialized.');
    }

    final File file = File(localPath);
    if (!await file.exists()) {
      throw StateError('Local attachment file not found: $localPath');
    }

    final Reference reference = _resolvedStorage.ref().child(storagePath);
    final SettableMetadata metadata = SettableMetadata(contentType: contentType);
    await reference.putFile(file, metadata);
    final String downloadUrl = await reference.getDownloadURL();

    return AttachmentUploadResult(
      downloadUrl: downloadUrl,
      storagePath: storagePath,
    );
  }

  /// Uploads [bytes] to Firebase Storage at [storagePath].
  Future<AttachmentUploadResult> uploadBytes({
    required Uint8List bytes,
    required String storagePath,
    required String contentType,
  }) async {
    if (!_firebaseService.isInitialized) {
      throw StateError('Firebase is not initialized.');
    }

    final Reference reference = _resolvedStorage.ref().child(storagePath);
    final SettableMetadata metadata = SettableMetadata(contentType: contentType);
    await reference.putData(bytes, metadata);
    final String downloadUrl = await reference.getDownloadURL();

    return AttachmentUploadResult(
      downloadUrl: downloadUrl,
      storagePath: storagePath,
    );
  }
}
