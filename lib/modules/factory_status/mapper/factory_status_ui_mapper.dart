import '../../../core/domain/enums/factory_status_type.dart' as domain;
import '../ui/widget/factory_status_type.dart' as ui;

/// Maps domain factory status values to UI presentation enums.
extension DomainFactoryStatusUiMapper on domain.FactoryStatusType {
  /// Converts to the UI [ui.FactoryStatusType] used by widgets.
  ui.FactoryStatusType toUi() {
    return ui.FactoryStatusType.values.byName(name);
  }
}

/// Maps UI factory status values to domain enums.
extension UiFactoryStatusDomainMapper on ui.FactoryStatusType {
  /// Converts to the domain [domain.FactoryStatusType].
  domain.FactoryStatusType toDomain() {
    return domain.FactoryStatusType.values.byName(name);
  }
}
