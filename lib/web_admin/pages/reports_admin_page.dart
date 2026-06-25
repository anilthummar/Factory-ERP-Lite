import '../../../utils/exports.dart';

/// Web admin reports hub linking to shared report export use cases.
class ReportsAdminPage extends StatelessWidget {
  /// Creates [ReportsAdminPage].
  const ReportsAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Dimens.padding16),
      children: <Widget>[
        Text(
          'Reports',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: Dimens.space16),
        const ListTile(
          leading: Icon(Icons.receipt_long_outlined),
          title: Text('Expense Report'),
          subtitle: Text('Live data from repositories'),
        ),
        const ListTile(
          leading: Icon(Icons.engineering_outlined),
          title: Text('Labor Report'),
        ),
        const ListTile(
          leading: Icon(Icons.people_outline),
          title: Text('Person Report'),
        ),
        const ListTile(
          leading: Icon(Icons.calendar_month_outlined),
          title: Text('Monthly Summary'),
        ),
      ],
    );
  }
}
