import '../../utils/exports.dart';
import '../pages/dashboard_admin_page.dart';
import '../pages/expenses_admin_page.dart';
import '../pages/exports_admin_page.dart';
import '../pages/labor_admin_page.dart';
import '../pages/persons_admin_page.dart';
import '../pages/reports_admin_page.dart';
import '../pages/settings_admin_page.dart';

/// Navigation destinations for the web admin shell.
enum WebAdminSection {
  /// Dashboard overview.
  dashboard,

  /// Expense management.
  expenses,

  /// Person management.
  persons,

  /// Labor management.
  labor,

  /// Reports.
  reports,

  /// Export center.
  exports,

  /// Settings and sign out.
  settings,
}

/// Responsive shell with navigation rail for the web admin panel.
class WebAdminShell extends StatefulWidget {
  /// Creates [WebAdminShell].
  const WebAdminShell({super.key});

  @override
  State<WebAdminShell> createState() => _WebAdminShellState();
}

class _WebAdminShellState extends State<WebAdminShell> {
  WebAdminSection _section = WebAdminSection.dashboard;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final User? user = getIt<AuthRepository>().currentUser;

    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _section.index,
            onDestinationSelected: (int index) {
              setState(() {
                _section = WebAdminSection.values[index];
              });
            },
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.space12),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    child: Text(
                      (user?.displayName ?? 'A').characters.first.toUpperCase(),
                    ),
                  ),
                  const SizedBox(height: Dimens.space8),
                  Text(
                    'Admin',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: Text('Expenses'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('Persons'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.engineering_outlined),
                selectedIcon: Icon(Icons.engineering),
                label: Text('Labor'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.analytics_outlined),
                selectedIcon: Icon(Icons.analytics),
                label: Text('Reports'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.file_download_outlined),
                selectedIcon: Icon(Icons.file_download),
                label: Text('Exports'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: ColoredBox(
              color: colorScheme.surface,
              child: _buildSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection() {
    return switch (_section) {
      WebAdminSection.dashboard => const DashboardAdminPage(),
      WebAdminSection.expenses => const ExpensesAdminPage(),
      WebAdminSection.persons => const PersonsAdminPage(),
      WebAdminSection.labor => const LaborAdminPage(),
      WebAdminSection.reports => const ReportsAdminPage(),
      WebAdminSection.exports => const ExportsAdminPage(),
      WebAdminSection.settings => const SettingsAdminPage(),
    };
  }
}
