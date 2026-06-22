import '../../../../utils/exports.dart';

/// A widget that displays a list with custom pagination.
///
/// This widget uses a [BlocBuilder] to manage the state of pagination
/// and displays a list of items with shimmer and loading effects.
class CustomPaginationListWidget extends StatelessWidget {
  /// The constructor for [CustomPaginationListWidget].
  const CustomPaginationListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomPaginationBloc, CustomPaginationState>(
      builder: (BuildContext context, CustomPaginationState state) {
        return (state.status == BaseStateStatus.loading &&
                state.paginationLocal.isLoadMore == false)
            ? CustomShimmerListWidget(
                child: _listView(
                state,
                context,
                true,
              ))
            : state.paginationLocal.data != null
                ? _listView(state, context, false)
                : const SizedBox();
      },
    );
  }

  /// Builds the list view with pagination.
  ///
  /// [state] is the current state of the pagination.
  /// [context] is the build context.
  /// [isShimmerView] indicates whether to show the shimmer effect.
  Widget _listView(
      CustomPaginationState state, BuildContext context, bool isShimmerView) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.instance<CustomPaginationBloc>().handleRefresh();
      },
      child: ListView.builder(
        controller: state.scrollController,
        itemCount: state.paginationLocal.data?.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Padding(
                padding: Dimens.padding8.padding,
                child: Container(
                  width: context.width,
                  height: isShimmerView ? context.width * Dimens.ratio05 : null,
                  padding: Dimens.padding8.padding,
                  decoration: BoxDecoration(
                      color: AppColors.instance.lightGrayBGColor,
                      borderRadius:
                          BorderRadius.all(Dimens.radius8.circularRadius)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomTextLabelWidget(
                          label: state.paginationLocal.data != null
                              ? state.paginationLocal.data![index].title ?? ''
                              : "",
                          style: context.textTheme.bodyMedium,
                          textAlign: TextAlign.start),
                      const SizedBox(
                        height: Dimens.space8,
                      ),
                      CustomTextLabelWidget(
                        label: state.paginationLocal.data != null
                            ? state.paginationLocal.data![index].body ?? ''
                            : "",
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: state.status == BaseStateStatus.loading &&
                    (state.paginationLocal.isLoadMore ?? false) &&
                    index == (state.paginationLocal.data?.length ?? 0) - 1,
                child: const CustomPaginationLoaderWidget(),
              )
            ],
          ); // Use custom item builder
        },
      ),
    );
  }
}
