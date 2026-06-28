import 'package:flutter/material.dart';

import '../navigation/web_admin_section.dart';

/// Desktop-first sidebar navigation for the web admin shell.
class AdminSidebar extends StatelessWidget {
  /// Creates [AdminSidebar].
  const AdminSidebar({
    required this.selected,
    required this.onSelected,
    required this.collapsed,
    required this.onToggleCollapsed,
    super.key,
  });

  /// Currently active section.
  final WebAdminSection selected;

  /// Called when the user selects a section.
  final ValueChanged<WebAdminSection> onSelected;

  /// Whether the sidebar is in compact icon-only mode.
  final bool collapsed;

  /// Toggles collapsed state (narrow viewports).
  final VoidCallback onToggleCollapsed;

  static const double expandedWidth = 260;
  static const double collapsedWidth = 72;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double width = collapsed ? collapsedWidth : expandedWidth;

    return Material(
      color: colorScheme.surfaceContainerLow,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 8, 12),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.factory_outlined,
                    color: colorScheme.primary,
                    size: 26,
                  ),
                  if (!collapsed) ...<Widget>[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Factory ERP',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ),
                  ],
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    tooltip: collapsed ? 'Expand sidebar' : 'Collapse sidebar',
                    onPressed: onToggleCollapsed,
                    icon: Icon(
                      collapsed
                          ? Icons.chevron_right
                          : Icons.chevron_left,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: WebAdminSection.values.map((WebAdminSection section) {
                  final bool isSelected = section == selected;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: collapsed
                        ? IconButton(
                            tooltip: section.label,
                            onPressed: () => onSelected(section),
                            icon: Icon(
                              isSelected
                                  ? section.selectedIcon
                                  : section.icon,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                          )
                        : AdminSidebarDestination(
                            icon: Icon(section.icon),
                            selectedIcon: Icon(section.selectedIcon),
                            label: Text(section.label),
                            selected: isSelected,
                            onTap: () => onSelected(section),
                          ),
                  );
                }).toList(),
              ),
            ),
            if (!collapsed)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Admin Panel',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Sidebar row for a [WebAdminSection].
class AdminSidebarDestination extends StatelessWidget {
  /// Creates [AdminSidebarDestination].
  const AdminSidebarDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final Widget icon;
  final Widget selectedIcon;
  final Widget label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: selected ? selectedIcon : icon,
      title: label,
      selected: selected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.55),
      onTap: onTap,
    );
  }
}
