/// Base exception for attachment local storage failures.
class AttachmentLocalException implements Exception {
  /// Creates [AttachmentLocalException].
  const AttachmentLocalException(this.message);

  /// Human-readable failure description.
  final String message;

  @override
  String toString() => 'AttachmentLocalException: $message';
}

/// Thrown when an attachment record is not found.
class AttachmentNotFoundException extends AttachmentLocalException {
  /// Creates [AttachmentNotFoundException].
  AttachmentNotFoundException(String id) : super('Attachment not found: $id');
}

/// Thrown when Hive is unavailable for attachment storage.
class AttachmentLocalStorageException extends AttachmentLocalException {
  /// Creates [AttachmentLocalStorageException].
  const AttachmentLocalStorageException(super.message);
}

/// Thrown when a picked file type is not supported.
class UnsupportedAttachmentTypeException extends AttachmentLocalException {
  /// Creates [UnsupportedAttachmentTypeException].
  const UnsupportedAttachmentTypeException(String fileName)
      : super('Unsupported attachment type: $fileName');
}
