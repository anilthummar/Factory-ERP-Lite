import '../auth/web_admin_auth_gate.dart';
import '../navigation/web_admin_section.dart';
import '../pages/attachments_admin_page.dart';
import '../pages/dashboard_admin_page.dart';
import '../pages/expenses_admin_page.dart';
import '../pages/factory_status_admin_page.dart';
import '../pages/labor_admin_page.dart';
import '../pages/persons_admin_page.dart';
import '../pages/reports_admin_page.dart';
import '../pages/settings_admin_page.dart';
import '../../utils/exports.dart';
import 'admin_sidebar.dart';
import 'admin_top_app_bar.dart';

/// Responsive admin shell with sidebar navigation and top app bar.
class WebAdminShell extends StatefulWidget {
  /// Creates [WebAdminShell].
  const WebAdminShell({super.key});

  @override
  State<WebAdminShell> createState() => _WebAdminShellState();
}

class _WebAdminShellState extends State<WebAdminShell> {
  WebAdminSection _section = WebAdminSection.dashboard;
  bool _sidebarCollapsed = false;
  int? _pendingSyncCount;
  final ValueNotifier<int> _refreshTick = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    unawaited(_loadPendingSync());
    unawaited(_pullFromFirestore());
  }

  Future<void> _pullFromFirestore() async {
    try {
      await getIt<SyncService>().pullFromRemote();
      if (mounted) {
        _refreshTick.value++;
        await _loadPendingSync();
      }
    } on Object {
      // Non-blocking for shell chrome.
    }
  }

  Future<void> _loadPendingSync() async {
    try {
      final int count = await getIt<SyncService>().getPendingSyncCount();
      if (mounted) {
        setState(() => _pendingSyncCount = count);
      }
    } on Object {
      // Non-blocking for shell chrome.
    }
  }

  void _refreshCurrentPage() {
    unawaited(_pullAndRefresh());
  }

  Future<void> _pullAndRefresh() async {
    try {
      await getIt<SyncService>().pullFromRemote();
    } on Object {
      // Still refresh local data if pull fails.
    }
    _refreshTick.value++;
    await _loadPendingSync();
  }

  void _selectSection(WebAdminSection section) {
    setState(() => _section = section);
  }

  Future<void> _signOut() async {
    await getIt<AuthRepository>().signOut();
    if (!mounted) {
      return;
    }
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const WebAdminAuthGate(
          child: WebAdminShell(),
        ),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  void dispose() {
    _refreshTick.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final bool compact = width < 1100;
    final bool collapsed = compact || _sidebarCollapsed;
    final User? user = getIt<AuthRepository>().currentUser;

    return Scaffold(
      body: Row(
        children: <Widget>[
          AdminSidebar(
            selected: _section,
            onSelected: _selectSection,
            collapsed: collapsed,
            onToggleCollapsed: () {
              setState(() => _sidebarCollapsed = !_sidebarCollapsed);
            },
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: <Widget>[
                AdminTopAppBar(
                  section: _section,
                  pendingSyncCount: _pendingSyncCount,
                  onRefresh: _refreshCurrentPage,
                  userName: user?.displayName,
                  userEmail: user?.email,
                  onOpenSettings: () => _selectSection(WebAdminSection.settings),
                  onSignOut: () => unawaited(_signOut()),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.surface,
                    child: ValueListenableBuilder<int>(
                      valueListenable: _refreshTick,
                      builder: (BuildContext context, int tick, Widget? child) {
                        return _buildSection(tick);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(int refreshTick) {
    return switch (_section) {
      WebAdminSection.dashboard => DashboardAdminPage(
          refreshTick: refreshTick,
        ),
      WebAdminSection.factoryStatus => FactoryStatusAdminPage(
          refreshTick: refreshTick,
        ),
      WebAdminSection.attachments => AttachmentsAdminPage(
          refreshTick: refreshTick,
        ),
      WebAdminSection.persons => PersonsAdminPage(refreshTick: refreshTick),
      WebAdminSection.labor => LaborAdminPage(refreshTick: refreshTick),
      WebAdminSection.expenses => ExpensesAdminPage(refreshTick: refreshTick),
      WebAdminSection.reports => ReportsAdminPage(refreshTick: refreshTick),
      WebAdminSection.settings => SettingsAdminPage(refreshTick: refreshTick),
    };
  }
}
