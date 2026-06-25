import 'package:flutter/material.dart';

/// Shared list page scaffold for web admin CRUD views.
class AdminListScaffold extends StatelessWidget {
  /// Creates [AdminListScaffold].
  const AdminListScaffold({
    required this.title,
    required this.loading,
    required this.empty,
    required this.child,
    super.key,
  });

  /// Page title.
  final String title;

  /// Whether data is loading.
  final bool loading;

  /// Whether the list is empty after load.
  final bool empty;

  /// List content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Expanded(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : empty
                  ? const Center(child: Text('No records found'))
                  : child,
        ),
      ],
    );
  }
}
