import 'package:flutter/material.dart';

/// Primary navigation destinations for the web admin panel.
enum WebAdminSection {
  /// Dashboard overview.
  dashboard,

  /// Person management.
  persons,

  /// Labor management.
  labor,

  /// Expense and recurring expense management.
  expenses,

  /// Reports and export center.
  reports,

  /// Settings and session.
  settings;

  /// User-facing label for the section.
  String get label {
    return switch (this) {
      WebAdminSection.dashboard => 'Dashboard',
      WebAdminSection.persons => 'Persons',
      WebAdminSection.labor => 'Labor',
      WebAdminSection.expenses => 'Expenses',
      WebAdminSection.reports => 'Reports',
      WebAdminSection.settings => 'Settings',
    };
  }

  /// Material icon for the sidebar.
  IconData get icon {
    return switch (this) {
      WebAdminSection.dashboard => Icons.dashboard_outlined,
      WebAdminSection.persons => Icons.people_outline,
      WebAdminSection.labor => Icons.engineering_outlined,
      WebAdminSection.expenses => Icons.receipt_long_outlined,
      WebAdminSection.reports => Icons.analytics_outlined,
      WebAdminSection.settings => Icons.settings_outlined,
    };
  }

  /// Selected-state icon for the sidebar.
  IconData get selectedIcon {
    return switch (this) {
      WebAdminSection.dashboard => Icons.dashboard,
      WebAdminSection.persons => Icons.people,
      WebAdminSection.labor => Icons.engineering,
      WebAdminSection.expenses => Icons.receipt_long,
      WebAdminSection.reports => Icons.analytics,
      WebAdminSection.settings => Icons.settings,
    };
  }
}
