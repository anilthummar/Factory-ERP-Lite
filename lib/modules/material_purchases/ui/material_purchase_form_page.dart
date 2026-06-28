import '../../../../utils/exports.dart';

/// Material purchase expense add/edit form.
class MaterialPurchaseFormPage extends StatelessWidget {
  /// Creates [MaterialPurchaseFormPage].
  const MaterialPurchaseFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return ExpenseFormPage(
      config: ExpenseFormUiConfig.of(
        strings,
        pageTitleAdd: strings.materialPurchaseKey,
      ),
      onSave: () => context.router.maybePop(),
    );
  }
}
