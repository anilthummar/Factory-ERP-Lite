import 'package:equatable/equatable.dart';

import '../../../core/domain/enums/attachment_type.dart';
import '../../../core/sync/sync_module_type.dart';

/// Attachment BLoC events.
sealed class AttachmentEvent extends Equatable {
  const AttachmentEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads attachments for the optional parent scope.
final class AttachmentLoadRequested extends AttachmentEvent {
  /// Creates [AttachmentLoadRequested].
  const AttachmentLoadRequested({
    this.parentModule,
    this.parentRecordId,
  });

  /// Optional parent module filter.
  final SyncModuleType? parentModule;

  /// Optional parent record filter.
  final String? parentRecordId;

  @override
  List<Object?> get props => <Object?>[parentModule, parentRecordId];
}

/// Picks and saves a new attachment locally.
final class AttachmentPickRequested extends AttachmentEvent {
  /// Creates [AttachmentPickRequested].
  const AttachmentPickRequested({
    this.attachmentType = AttachmentType.document,
    this.parentModule,
    this.parentRecordId,
  });

  /// Business category for the attachment.
  final AttachmentType attachmentType;

  /// Optional parent module.
  final SyncModuleType? parentModule;

  /// Optional parent record id.
  final String? parentRecordId;

  @override
  List<Object?> get props => <Object?>[
        attachmentType,
        parentModule,
        parentRecordId,
      ];
}

/// Deletes an attachment by id.
final class AttachmentDeleteRequested extends AttachmentEvent {
  /// Creates [AttachmentDeleteRequested].
  const AttachmentDeleteRequested(this.id);

  /// Attachment identifier.
  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}

/// Retries failed attachment uploads.
final class AttachmentRetryFailedRequested extends AttachmentEvent {
  /// Creates [AttachmentRetryFailedRequested].
  const AttachmentRetryFailedRequested();
}
