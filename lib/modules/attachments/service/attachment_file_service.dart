import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../datasource/attachment_local_exception.dart';

/// Supported attachment file extensions.
abstract final class AttachmentFileTypes {
  /// Allowed file extensions for attachments.
  static const Set<String> allowedExtensions = <String>{
    'jpg',
    'jpeg',
    'png',
    'pdf',
  };

  /// Returns MIME type for [fileName], or null when unsupported.
  static String? mimeTypeForFileName(String fileName) {
    final String extension = _extension(fileName);
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      default:
        return null;
    }
  }

  /// Whether [fileName] has an allowed extension.
  static bool isSupported(String fileName) {
    return mimeTypeForFileName(fileName) != null;
  }

  static String _extension(String fileName) {
    final int index = fileName.lastIndexOf('.');
    if (index < 0 || index == fileName.length - 1) {
      return '';
    }
    return fileName.substring(index + 1).toLowerCase();
  }

  static String _basename(String fileName) {
    final int index = fileName.lastIndexOf('/');
    if (index < 0) {
      return fileName;
    }
    return fileName.substring(index + 1);
  }
}

/// Copies picked files into the app documents directory.
class AttachmentFileService {
  /// Creates [AttachmentFileService].
  AttachmentFileService({Directory? documentsDirectory})
      : _documentsDirectory = documentsDirectory;

  final Directory? _documentsDirectory;

  /// Persists a picked file under `attachments/{attachmentId}/`.
  Future<String> persistPickedFile({
    required String sourcePath,
    required String attachmentId,
    required String fileName,
  }) async {
    if (!AttachmentFileTypes.isSupported(fileName)) {
      throw UnsupportedAttachmentTypeException(fileName);
    }

    final Directory documentsDir = _documentsDirectory ??
        await getApplicationDocumentsDirectory();
    final Directory targetDir =
        Directory('${documentsDir.path}/attachments/$attachmentId');
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final String sanitizedName = AttachmentFileTypes._basename(fileName);
    final String targetPath = '${targetDir.path}/$sanitizedName';
    await File(sourcePath).copy(targetPath);
    return targetPath;
  }

  /// Deletes the local file copy for [localPath] when it exists.
  Future<void> deleteLocalFile(String localPath) async {
    if (localPath.isEmpty) {
      return;
    }

    final File file = File(localPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Returns file size in bytes for [path].
  Future<int> fileSizeBytes(String path) async {
    final File file = File(path);
    return file.length();
  }
}
