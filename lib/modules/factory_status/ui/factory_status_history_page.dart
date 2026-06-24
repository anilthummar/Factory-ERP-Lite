import '../../../../core/domain/entities/factory_status_entity.dart';
import '../../../../utils/exports.dart';
import '../mapper/factory_status_ui_mapper.dart';

/// Full status history screen.
@RoutePage()
class FactoryStatusHistoryPage extends StatelessWidget {
  /// Creates [FactoryStatusHistoryPage].
  const FactoryStatusHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FactoryStatusBloc>(
      create: (BuildContext context) => FactoryStatusBloc(
        getCurrentStatusUseCase: getIt<GetCurrentFactoryStatusUseCase>(),
        getHistoryUseCase: getIt<GetFactoryStatusHistoryUseCase>(),
        changeStatusUseCase: getIt<ChangeFactoryStatusUseCase>(),
      ),
      child: const _FactoryStatusHistoryView(),
    );
  }
}

class _FactoryStatusHistoryView extends StatelessWidget {
  const _FactoryStatusHistoryView();

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: strings.statusHistoryKey,
          textAlign: TextAlign.start,
        ),
      ),
      body: BlocBuilder<FactoryStatusBloc, FactoryStatusState>(
        builder: (BuildContext context, FactoryStatusState state) {
          if (state.status == FactoryStatusBlocStatus.loading &&
              state.history.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<FactoryStatusHistoryData> history = state.history
              .map(
                (FactoryStatusEntity status) => FactoryStatusHistoryData(
                  id: status.id,
                  status: status.status.toUi(),
                  changedAt: status.updatedAt,
                  notes: status.notes,
                ),
              )
              .toList(growable: false);

          return CustomResponsiveContent(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.padding16),
              child: history.isEmpty
                  ? const FactoryStatusHistoryEmptyView()
                  : FactoryStatusHistoryTimeline(history: history),
            ),
          );
        },
      ),
    );
  }
}
