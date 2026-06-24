import '../../../../utils/exports.dart';

/// Person list with pull-to-refresh and empty state.
class PersonListView extends StatelessWidget {
  /// Creates [PersonListView].
  const PersonListView({
    required this.persons,
    required this.onRefresh,
    super.key,
  });

  /// Persons to display.
  final List<PersonCardData> persons;

  /// Pull-to-refresh placeholder callback.
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return CustomRefreshableListView(
      isEmpty: persons.isEmpty,
      onRefresh: onRefresh,
      emptyView: CustomEmptyStateWidget(
        icon: Icons.people_outline,
        title: strings.personEmptyTitleKey,
        message: strings.personEmptyMessageKey,
      ),
      itemCount: persons.length,
      itemBuilder: (BuildContext context, int index) {
        return PersonCard(person: persons[index]);
      },
    );
  }
}
