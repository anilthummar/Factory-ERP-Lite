import 'package:flutter/material.dart';

/// Compact search bar for admin list pages (web + narrow layouts).
class AdminSearchToolbar extends StatelessWidget {
  /// Creates [AdminSearchToolbar].
  const AdminSearchToolbar({
    required this.onChanged,
    this.hintText = 'Search records…',
    this.onRefresh,
    this.loading = false,
    super.key,
  });

  /// Search text change callback (already trimmed + lowercased by caller).
  final ValueChanged<String> onChanged;

  /// Hint shown inside the field.
  final String hintText;

  /// Optional refresh action.
  final VoidCallback? onRefresh;

  /// Disables refresh while loading.
  final bool loading;

  static const double _maxFieldWidth = 420;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final bool compact = width < 600;
    final double maxWidth = compact ? width : _maxFieldWidth;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: TextField(
                decoration: InputDecoration(
                  hintText: hintText,
                  isDense: true,
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
        if (onRefresh != null) ...<Widget>[
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Refresh',
            visualDensity: VisualDensity.compact,
            onPressed: loading ? null : onRefresh,
            icon: const Icon(Icons.refresh, size: 22),
          ),
        ],
      ],
    );
  }
}
