import '../../utils/exports.dart';

/// Pulls remote Firestore data into Hive before reloading local UI state.
Future<void> pullRemoteBeforeLocalRefresh(
  Future<void> Function() localRefresh,
) async {
  await getIt<SyncService>().pullFromRemote();
  await localRefresh();
}
