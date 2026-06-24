import '../../../../utils/exports.dart';

/// Person management list screen.
@RoutePage()
class PersonPage extends StatefulWidget {
  /// Creates [PersonPage].
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {}

  void _onAddPerson() {}

  void _onSearchChanged(String value) {}

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: strings.personManagementKey,
          textAlign: TextAlign.start,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddPerson,
        icon: const Icon(Icons.person_add_outlined),
        label: CustomTextLabelWidget(
          label: strings.addPersonKey,
          style: AppStyles.instance.textTheme.labelMedium?.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
      ),
      body: CustomResponsiveContent(
        child: Column(
          children: <Widget>[
            CustomSearchFieldWidget(
              controller: _searchController,
              hint: strings.searchPersonsKey,
              onChanged: _onSearchChanged,
            ),
            Expanded(
              child: PersonListView(
                persons: const <PersonCardData>[],
                onRefresh: _onRefresh,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
