import 'package:file_picker/file_picker.dart';

import '../../../utils/exports.dart';
import '../widgets/admin_data_page.dart';

/// Web admin attachment library with upload, open, and delete.
class AttachmentsAdminPage extends StatefulWidget {
  /// Creates [AttachmentsAdminPage].
  const AttachmentsAdminPage({this.refreshTick = 0, super.key});

  /// Parent shell refresh counter.
  final int refreshTick;

  @override
  State<AttachmentsAdminPage> createState() => _AttachmentsAdminPageState();
}

class _AttachmentsAdminPageState extends State<AttachmentsAdminPage> {
  int _localRefreshTick = 0;

  int get _effectiveRefreshTick => widget.refreshTick + _localRefreshTick;

  Future<void> _bumpReload() async {
    setState(() => _localRefreshTick++);
  }

  Future<void> _retryFailedUploads() async {
    await getIt<RetryFailedAttachmentUploadsUseCase>()();
    await _bumpReload();
  }

  Future<bool> _uploadAttachment() async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: AttachmentFileTypes.allowedExtensions.toList(),
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return false;
    }

    final PlatformFile file = result.files.first;
    final Uint8List? bytes = file.bytes;
    if (bytes == null) {
      throw StateError('Could not read file bytes. Try a smaller file.');
    }

    final String fileName = file.name;
    if (!AttachmentFileTypes.isSupported(fileName)) {
      throw UnsupportedAttachmentTypeException(fileName);
    }

    final String? mimeType = AttachmentFileTypes.mimeTypeForFileName(fileName);
    if (mimeType == null) {
      throw UnsupportedAttachmentTypeException(fileName);
    }

    final DateTime now = DateTime.now();
    final String id = 'attachment_${now.microsecondsSinceEpoch}';
    final String storagePath = 'attachments/$id/$fileName';

    final AttachmentUploadResult upload =
        await getIt<AttachmentStorageRemoteDataSource>().uploadBytes(
      bytes: bytes,
      storagePath: storagePath,
      contentType: mimeType,
    );

    final AttachmentEntity entity = AttachmentEntity(
      id: id,
      createdAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.pending,
      fileName: fileName,
      localPath: '',
      mimeType: mimeType,
      fileSizeBytes: bytes.length,
      attachmentType: AttachmentType.document,
      downloadUrl: upload.downloadUrl,
      storagePath: upload.storagePath,
    );

    await getIt<AttachmentRepository>().create(entity);
    return true;
  }

  Future<void> _openAttachment(AttachmentEntity item) async {
    final String? url = item.downloadUrl;
    if (url == null || url.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File is not uploaded yet. Retry sync or wait.'),
        ),
      );
      return;
    }

    final Uri uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      throw StateError('Could not open attachment URL.');
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _deleteAttachment(AttachmentEntity item) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete attachment?'),
          content: Text('Remove "${item.fileName}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await getIt<DeleteAttachmentUseCase>()(item.id);
    await _bumpReload();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () => unawaited(_retryFailedUploads()),
              icon: const Icon(Icons.cloud_upload_outlined),
              label: const Text('Retry failed uploads'),
            ),
          ),
        ),
        Expanded(
          child: AdminDataPage<AttachmentEntity>(
            title: 'Attachments',
            subtitle: 'Receipts, bills, invoices, and documents synced with mobile',
            refreshTick: _effectiveRefreshTick,
            addButtonLabel: 'Upload file',
            onAdd: _uploadAttachment,
            filterChips: const <String>[
              'pending',
              'synced',
              'failed',
            ],
            filterItem: (AttachmentEntity item, String? filter) {
              if (filter == null) {
                return true;
              }
              return item.syncStatus.name == filter;
            },
            columns: const <DataColumn>[
              DataColumn(label: Text('File')),
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Parent')),
              DataColumn(label: Text('Size')),
              DataColumn(label: Text('Sync')),
              DataColumn(label: Text('Actions')),
            ],
            loadItems: () async {
              await getIt<SyncService>().pullFromRemote();
              return getIt<GetAttachmentsUseCase>()();
            },
            itemKey: (AttachmentEntity item) => item.id,
            matchesSearch: (AttachmentEntity item, String query) {
              return item.fileName.toLowerCase().contains(query) ||
                  (item.parentRecordId ?? '').toLowerCase().contains(query) ||
                  (item.parentModule?.name ?? '').toLowerCase().contains(query);
            },
            onBulkDelete: (Set<String> ids) async {
              final DeleteAttachmentUseCase delete =
                  getIt<DeleteAttachmentUseCase>();
              for (final String id in ids) {
                await delete(id);
              }
            },
            buildRow: (
              AttachmentEntity item,
              bool selected,
              ValueChanged<bool?> onSelect,
            ) {
              final String parentLabel = item.parentModule == null
                  ? '—'
                  : '${item.parentModule!.name}'
                      '${item.parentRecordId == null ? '' : ' · ${item.parentRecordId}'}';

              return DataRow(
                selected: selected,
                onSelectChanged: onSelect,
                cells: <DataCell>[
                  DataCell(Text(item.fileName)),
                  DataCell(Text(item.attachmentType.name)),
                  DataCell(Text(parentLabel)),
                  DataCell(Text(_formatFileSize(item.fileSizeBytes))),
                  DataCell(AdminSyncStatusChip(status: item.syncStatus.name)),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          tooltip: 'Open',
                          onPressed: () => unawaited(_openAttachment(item)),
                          icon: const Icon(Icons.open_in_new, size: 20),
                        ),
                        IconButton(
                          tooltip: 'Delete',
                          onPressed: () => unawaited(_deleteAttachment(item)),
                          icon: const Icon(Icons.delete_outline, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
