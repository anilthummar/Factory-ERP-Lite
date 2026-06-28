import '../../../utils/exports.dart';

/// Web admin sign-in using Firebase Google authentication.
class WebAdminLoginPage extends StatefulWidget {
  /// Creates [WebAdminLoginPage].
  const WebAdminLoginPage({required this.onSignedIn, super.key});

  /// Called after a successful sign-in.
  final VoidCallback onSignedIn;

  @override
  State<WebAdminLoginPage> createState() => _WebAdminLoginPageState();
}

class _WebAdminLoginPageState extends State<WebAdminLoginPage> {
  bool _loading = false;
  String? _error;

  Future<void> _signIn() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await getIt<AuthRepository>().signInWithGoogle();
      widget.onSignedIn();
    } on AuthCancelledException {
      setState(() => _error = null);
    } on Object catch (error) {
      setState(() => _error = error.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(Dimens.padding16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(Dimens.padding16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Factory ERP Lite Admin',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Dimens.space8),
                    Text(
                      'Sign in with your factory Google account',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: Dimens.space24),
                    if (_error != null) ...<Widget>[
                      Text(
                        _error!,
                        style: TextStyle(color: colorScheme.error),
                      ),
                      const SizedBox(height: Dimens.space12),
                    ],
                    FilledButton.icon(
                      onPressed: _loading ? null : _signIn,
                      icon: _loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.login),
                      label: const Text('Sign in with Google'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
