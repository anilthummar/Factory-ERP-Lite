import '../../../../utils/exports.dart';

/// Entries tab — responsive grid of ERP modules.
class EntriesTabPage extends BaseResponsiveView {
  /// Creates [EntriesTabPage].
  const EntriesTabPage({super.key});

  @override
  Widget buildMobileWidget(BuildContext context) => _buildBody(context, 2);

  @override
  Widget buildTabletWidget(BuildContext context) => _buildBody(context, 3);

  @override
  Widget buildDesktopWidget(BuildContext context) => _buildBody(context, 4);

  List<EntryModuleItem> _modules(BuildContext context) {
    final AppString strings = context.appString;

    return <EntryModuleItem>[
      EntryModuleItem(
        title: strings.recordsExplorerQuickActionKey,
        icon: Icons.manage_search_outlined,
        onTap: () {
          unawaited(context.router.push(RecordsExplorerRoute()));
        },
      ),
      EntryModuleItem(
        title: strings.laborManagementKey,
        icon: Icons.engineering_outlined,
        onTap: () {
          unawaited(context.router.push(const LaborRoute()));
        },
      ),
      EntryModuleItem(
        title: strings.personManagementKey,
        icon: Icons.person_outline,
        onTap: () {
          unawaited(context.router.push(const PersonRoute()));
        },
      ),
      EntryModuleItem(
        title: strings.materialPurchaseKey,
        icon: Icons.inventory_2_outlined,
        onTap: () {
          unawaited(context.router.push(const MaterialPurchaseRoute()));
        },
      ),
      EntryModuleItem(
        title: strings.truckExpensesKey,
        icon: Icons.local_shipping_outlined,
        onTap: () {
          unawaited(context.router.push(const TruckExpensesRoute()));
        },
      ),
      EntryModuleItem(
        title: strings.maintenanceExpensesKey,
        icon: Icons.build_outlined,
        onTap: () {
          unawaited(context.router.push(const MaintenanceExpensesRoute()));
        },
      ),
      EntryModuleItem(
        title: strings.electricityExpensesKey,
        icon: Icons.bolt_outlined,
        onTap: () {
          unawaited(context.router.push(const ElectricityExpensesRoute()));
        },
      ),
      EntryModuleItem(
        title: strings.miscExpensesKey,
        icon: Icons.receipt_long_outlined,
        onTap: () {
          unawaited(context.router.push(const MiscellaneousExpensesRoute()));
        },
      ),
      EntryModuleItem(
        title: strings.recurringExpensesKey,
        icon: Icons.autorenew,
        onTap: () {
          unawaited(context.router.push(const RecurringExpensesRoute()));
        },
      ),
    ];
  }

  Widget _buildBody(BuildContext context, int crossAxisCount) {
    final AppString strings = context.appString;
    final List<EntryModuleItem> modules = _modules(context);

    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: strings.navEntriesKey,
          textAlign: TextAlign.start,
        ),
        actions: <Widget>[
          IconButton(
            tooltip: strings.recordsExplorerTitleKey,
            onPressed: () {
              unawaited(context.router.push(RecordsExplorerRoute()));
            },
            icon: const Icon(Icons.manage_search_outlined),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(Dimens.padding16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: Dimens.space12,
          mainAxisSpacing: Dimens.space12,
          childAspectRatio: 0.95,
        ),
        itemCount: modules.length,
        itemBuilder: (BuildContext context, int index) {
          final EntryModuleItem module = modules[index];

          return EntryModuleCard(
            title: module.title,
            icon: module.icon,
            onTap: module.onTap,
          );
        },
      ),
    );
  }
}
