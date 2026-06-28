import '../auth/web_admin_auth_gate.dart';
import '../shell/web_admin_shell.dart';
import '../../../utils/exports.dart';
import 'sync_diagnostics_admin_page.dart';

/// Web admin settings: session info, sync diagnostics, and sign out.
class SettingsAdminPage extends StatelessWidget {
  /// Creates [SettingsAdminPage].
  const SettingsAdminPage({this.refreshTick = 0, super.key});

  /// Parent shell refresh counter.
  final int refreshTick;

  @override
  Widget build(BuildContext context) {
    final User? user = getIt<AuthRepository>().currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: Dimens.space16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  title: Text(user?.displayName ?? 'Signed in'),
                  subtitle: Text(user?.email ?? ''),
                ),
              ),
              const SizedBox(height: Dimens.space12),
              FilledButton.icon(
                onPressed: () {
                  unawaited(_signOut(context));
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
              ),
            ],
          ),
        ),
        const Divider(height: 32),
        Expanded(
          child: SyncDiagnosticsAdminPage(refreshTick: refreshTick),
        ),
      ],
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await getIt<AuthRepository>().signOut();
    if (!context.mounted) {
      return;
    }
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const WebAdminAuthGate(
          child: WebAdminShell(),
        ),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
