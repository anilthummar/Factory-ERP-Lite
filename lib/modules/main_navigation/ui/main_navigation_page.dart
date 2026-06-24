import '../../../../utils/exports.dart';

/// Main app shell with Material 3 bottom navigation after login.
@RoutePage()
class MainNavigationPage extends StatefulWidget {
  /// Creates [MainNavigationPage].
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  static const List<Widget> _tabs = <Widget>[
    DashboardTabPage(),
    EntriesTabPage(),
    ReportsTabPage(),
    CalendarTabPage(),
    ProfileTabPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyAppTheme.instance.systemOverlay(),
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.surface,
        body: IndexedStack(
          index: _selectedIndex,
          children: _tabs,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() => _selectedIndex = index);
          },
          destinations: <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: strings.navDashboardKey,
          ),
          NavigationDestination(
            icon: const Icon(Icons.grid_view_outlined),
            selectedIcon: const Icon(Icons.grid_view),
            label: strings.navEntriesKey,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: strings.navReportsKey,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: strings.navCalendarKey,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: strings.navProfileKey,
          ),
        ],
        ),
      ),
    );
  }
}
