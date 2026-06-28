import 'package:flutter/material.dart';

/// A labeled bar for simple dashboard charts (no external chart library).
class AdminBarChartEntry {
  /// Creates [AdminBarChartEntry].
  const AdminBarChartEntry({
    required this.label,
    required this.value,
  });

  /// Category label.
  final String label;

  /// Numeric value.
  final int value;
}

/// Horizontal bar chart for web admin dashboards.
class AdminSimpleBarChart extends StatelessWidget {
  /// Creates [AdminSimpleBarChart].
  const AdminSimpleBarChart({
    required this.title,
    required this.entries,
    super.key,
  });

  /// Chart title.
  final String title;

  /// Data points to render.
  final List<AdminBarChartEntry> entries;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final int maxValue = entries.fold<int>(
      0,
      (int max, AdminBarChartEntry entry) =>
          entry.value > max ? entry.value : max,
    );

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            if (entries.isEmpty)
              Text(
                'No data',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              )
            else
              ...entries.map((AdminBarChartEntry entry) {
                final double fraction =
                    maxValue == 0 ? 0 : entry.value / maxValue;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(child: Text(entry.label)),
                          Text('${entry.value}'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: fraction,
                          minHeight: 10,
                          backgroundColor:
                              colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
