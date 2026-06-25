import '../auth/web_admin_auth_gate.dart';
import '../shell/web_admin_shell.dart';
import '../../../utils/exports.dart';

/// Web admin settings: session info and sign out.
class SettingsAdminPage extends StatelessWidget {
  /// Creates [SettingsAdminPage].
  const SettingsAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = getIt<AuthRepository>().currentUser;

    return ListView(
      padding: const EdgeInsets.all(Dimens.padding16),
      children: <Widget>[
        Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium,
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
