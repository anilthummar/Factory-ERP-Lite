/// Business category for an attachment record.
enum AttachmentType {
  /// Receipt image or document.
  receipt,

  /// Bill document.
  bill,

  /// Invoice document.
  invoice,

  /// Photo attachment.
  photo,

  /// General document.
  document,
}

/// Parses [AttachmentType] from persisted string values.
AttachmentType attachmentTypeFromString(String? value) {
  return AttachmentType.values.firstWhere(
    (AttachmentType type) => type.name == value,
    orElse: () => AttachmentType.document,
  );
}

/// Serializes [type] for Hive / Firestore.
String attachmentTypeToString(AttachmentType type) => type.name;
