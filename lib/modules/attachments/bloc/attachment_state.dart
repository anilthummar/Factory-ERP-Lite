import 'package:equatable/equatable.dart';

import '../../../core/domain/entities/attachment_entity.dart';

/// Attachment BLoC loading status.
enum AttachmentBlocStatus {
  /// Initial state.
  initial,

  /// Loading data or performing mutation.
  loading,

  /// Data loaded successfully.
  success,

  /// Mutation or load failed.
  failure,

  /// Attachment picked and saved locally.
  saved,
}

/// Attachment BLoC state.
class AttachmentState extends Equatable {
  /// Creates [AttachmentState].
  const AttachmentState({
    this.status = AttachmentBlocStatus.initial,
    this.attachments = const <AttachmentEntity>[],
    this.lastSavedAttachment,
    this.retriedCount = 0,
    this.errorMessage,
  });

  /// Current loading/mutation status.
  final AttachmentBlocStatus status;

  /// Loaded attachment records.
  final List<AttachmentEntity> attachments;

  /// Most recently saved attachment after pick.
  final AttachmentEntity? lastSavedAttachment;

  /// Number of failed uploads re-queued on last retry.
  final int retriedCount;

  /// Error message when [status] is [AttachmentBlocStatus.failure].
  final String? errorMessage;

  /// Returns a copy with selective overrides.
  AttachmentState copyWith({
    AttachmentBlocStatus? status,
    List<AttachmentEntity>? attachments,
    AttachmentEntity? lastSavedAttachment,
    int? retriedCount,
    String? errorMessage,
    bool clearError = false,
    bool clearLastSaved = false,
  }) {
    return AttachmentState(
      status: status ?? this.status,
      attachments: attachments ?? this.attachments,
      lastSavedAttachment:
          clearLastSaved ? null : lastSavedAttachment ?? this.lastSavedAttachment,
      retriedCount: retriedCount ?? this.retriedCount,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        attachments,
        lastSavedAttachment,
        retriedCount,
        errorMessage,
      ];
}
