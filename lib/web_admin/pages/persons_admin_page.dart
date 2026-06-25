import '../../../core/domain/entities/person_entity.dart';
import '../widgets/admin_list_scaffold.dart';
import '../../../utils/exports.dart';

/// Web admin person list reusing [GetPersonsUseCase].
class PersonsAdminPage extends StatefulWidget {
  /// Creates [PersonsAdminPage].
  const PersonsAdminPage({super.key});

  @override
  State<PersonsAdminPage> createState() => _PersonsAdminPageState();
}

class _PersonsAdminPageState extends State<PersonsAdminPage> {
  List<PersonEntity> _persons = <PersonEntity>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final ResponseHandler<List<PersonEntity>> result =
        await getIt<GetPersonsUseCase>()();
    if (!mounted) {
      return;
    }
    setState(() {
      _loading = false;
      if (result is OnSuccessResponse<List<PersonEntity>>) {
        _persons = result.response;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminListScaffold(
      title: 'Person Management',
      loading: _loading,
      empty: _persons.isEmpty,
      child: ListView.separated(
        itemCount: _persons.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (BuildContext context, int index) {
          final PersonEntity person = _persons[index];
          return ListTile(
            title: Text(person.name),
            subtitle: Text(person.mobile),
          );
        },
      ),
    );
  }
}
