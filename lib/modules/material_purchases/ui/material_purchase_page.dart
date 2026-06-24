import '../../../../utils/exports.dart';

/// Material purchase expense list screen.
@RoutePage()
class MaterialPurchasePage extends StatelessWidget {
  /// Creates [MaterialPurchasePage].
  const MaterialPurchasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return ExpenseListPage(
      config: ExpenseListUiConfig.of(
        strings,
        pageTitle: strings.materialPurchaseKey,
      ),
      onAdd: () {
        unawaited(
          context.router.pushWidget(const MaterialPurchaseFormPage()),
        );
      },
    );
  }
}
