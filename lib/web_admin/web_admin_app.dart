import '../utils/exports.dart';
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
      home: const WebAdminShell(),
    );
  }
}
