import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/domain/entities/attachment_entity.dart';
import '../../../core/sync/sync_module_type.dart';
import '../domain/usecases/delete_attachment_use_case.dart';
import '../domain/usecases/get_attachments_use_case.dart';
import '../domain/usecases/pick_and_save_attachment_use_case.dart';
import '../domain/usecases/retry_failed_attachment_uploads_use_case.dart';
import 'attachment_event.dart';
import 'attachment_state.dart';

/// BLoC for attachment pick, list, delete, and retry flows.
class AttachmentBloc extends Bloc<AttachmentEvent, AttachmentState> {
  /// Creates [AttachmentBloc].
  AttachmentBloc({
    required GetAttachmentsUseCase getAttachmentsUseCase,
    required PickAndSaveAttachmentUseCase pickAndSaveAttachmentUseCase,
    required DeleteAttachmentUseCase deleteAttachmentUseCase,
    required RetryFailedAttachmentUploadsUseCase retryFailedUploadsUseCase,
  })  : _getAttachmentsUseCase = getAttachmentsUseCase,
        _pickAndSaveAttachmentUseCase = pickAndSaveAttachmentUseCase,
        _deleteAttachmentUseCase = deleteAttachmentUseCase,
        _retryFailedUploadsUseCase = retryFailedUploadsUseCase,
        super(const AttachmentState()) {
    on<AttachmentLoadRequested>(_onLoad);
    on<AttachmentPickRequested>(_onPick);
    on<AttachmentDeleteRequested>(_onDelete);
    on<AttachmentRetryFailedRequested>(_onRetryFailed);
  }

  final GetAttachmentsUseCase _getAttachmentsUseCase;
  final PickAndSaveAttachmentUseCase _pickAndSaveAttachmentUseCase;
  final DeleteAttachmentUseCase _deleteAttachmentUseCase;
  final RetryFailedAttachmentUploadsUseCase _retryFailedUploadsUseCase;

  SyncModuleType? _parentModule;
  String? _parentRecordId;

  Future<void> _onLoad(
    AttachmentLoadRequested event,
    Emitter<AttachmentState> emit,
  ) async {
    _parentModule = event.parentModule;
    _parentRecordId = event.parentRecordId;

    emit(
      state.copyWith(
        status: AttachmentBlocStatus.loading,
        clearError: true,
        clearLastSaved: true,
      ),
    );

    await _loadAttachments(emit);
  }

  Future<void> _onPick(
    AttachmentPickRequested event,
    Emitter<AttachmentState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AttachmentBlocStatus.loading,
        clearError: true,
      ),
    );

    try {
      final AttachmentEntity? saved =
          await _pickAndSaveAttachmentUseCase.pickAndSave(
        attachmentType: event.attachmentType,
        parentModule: event.parentModule,
        parentRecordId: event.parentRecordId,
      );

      if (saved == null) {
        emit(
          state.copyWith(
            status: AttachmentBlocStatus.success,
            clearError: true,
          ),
        );
        return;
      }

      final List<AttachmentEntity> attachments =
          await _getAttachmentsUseCase(
        parentModule: _parentModule,
        parentRecordId: _parentRecordId,
      );

      emit(
        state.copyWith(
          status: AttachmentBlocStatus.saved,
          attachments: attachments,
          lastSavedAttachment: saved,
          clearError: true,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: AttachmentBlocStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onDelete(
    AttachmentDeleteRequested event,
    Emitter<AttachmentState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AttachmentBlocStatus.loading,
        clearError: true,
      ),
    );

    try {
      await _deleteAttachmentUseCase(event.id);
      await _loadAttachments(emit);
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: AttachmentBlocStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onRetryFailed(
    AttachmentRetryFailedRequested event,
    Emitter<AttachmentState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AttachmentBlocStatus.loading,
        clearError: true,
      ),
    );

    try {
      final int retriedCount = await _retryFailedUploadsUseCase();
      await _loadAttachments(emit, retriedCount: retriedCount);
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: AttachmentBlocStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _loadAttachments(
    Emitter<AttachmentState> emit, {
    int? retriedCount,
  }) async {
    try {
      final List<AttachmentEntity> attachments =
          await _getAttachmentsUseCase(
        parentModule: _parentModule,
        parentRecordId: _parentRecordId,
      );
      emit(
        state.copyWith(
          status: AttachmentBlocStatus.success,
          attachments: attachments,
          retriedCount: retriedCount ?? state.retriedCount,
          clearError: true,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: AttachmentBlocStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
