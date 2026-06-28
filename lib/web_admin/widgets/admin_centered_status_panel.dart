import 'package:flutter/material.dart';

/// Centered status panel for admin pages (loading, errors, empty states).
class AdminCenteredStatusPanel extends StatelessWidget {
  /// Creates [AdminCenteredStatusPanel].
  const AdminCenteredStatusPanel({
    required this.message,
    this.icon = Icons.info_outline,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  /// Primary status text.
  final String message;

  /// Optional leading icon.
  final IconData icon;

  /// Optional action button label.
  final String? actionLabel;

  /// Optional action callback.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox.expand(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(icon, size: 48, color: colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                ),
                if (actionLabel != null && onAction != null) ...<Widget>[
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: onAction,
                    child: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
