import '../utils/exports.dart';
import 'web_admin/web_admin_app.dart';

/// Web entry point for the Factory ERP Lite admin panel.
void main() {
  AppInitializer.instance.init(
    () => runApp(const WebAdminApp()),
  );
}
