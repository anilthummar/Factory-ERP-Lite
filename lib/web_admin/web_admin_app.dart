import '../utils/exports.dart';
import 'auth/web_admin_auth_gate.dart';
import 'shell/web_admin_shell.dart';

/// Root widget for the Factory ERP Lite web admin panel.
class WebAdminApp extends StatelessWidget {
  /// Creates [WebAdminApp].
  const WebAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Factory ERP Lite Admin',
      theme: MyAppTheme.instance.theme,
      home: const WebAdminAuthGate(
        child: WebAdminShell(),
      ),
    );
  }
}
