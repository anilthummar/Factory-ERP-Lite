import '../../../utils/exports.dart';
import 'web_admin_login_page.dart';

/// Google sign-in gate for the web admin panel.
class WebAdminAuthGate extends StatefulWidget {
  /// Creates [WebAdminAuthGate].
  const WebAdminAuthGate({required this.child, super.key});

  /// Authenticated admin shell.
  final Widget child;

  @override
  State<WebAdminAuthGate> createState() => _WebAdminAuthGateState();
}

class _WebAdminAuthGateState extends State<WebAdminAuthGate> {
  bool _checking = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    unawaited(_checkSession());
  }

  Future<void> _checkSession() async {
    final bool loggedIn = getIt<AuthRepository>().isLoggedIn;
    if (!mounted) {
      return;
    }
    setState(() {
      _checking = false;
      _isLoggedIn = loggedIn;
    });
  }

  Future<void> _onSignedIn() async {
    setState(() => _isLoggedIn = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isLoggedIn) {
      return WebAdminLoginPage(onSignedIn: _onSignedIn);
    }

    return widget.child;
  }
}
