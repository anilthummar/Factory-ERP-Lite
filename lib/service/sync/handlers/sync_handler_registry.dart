import '../../../core/sync/sync_module_type.dart';
import 'sync_module_handler.dart';

/// Registry of module-specific sync handlers.
class SyncHandlerRegistry {
  final Map<SyncModuleType, SyncModuleHandler> _handlers =
      <SyncModuleType, SyncModuleHandler>{};

  /// Registers [handler] for its [SyncModuleHandler.moduleType].
  void register(SyncModuleHandler handler) {
    _handlers[handler.moduleType] = handler;
  }

  /// Returns the handler for [module], if registered.
  SyncModuleHandler? handlerFor(SyncModuleType module) => _handlers[module];

  /// All registered handlers.
  Iterable<SyncModuleHandler> get handlers => _handlers.values;
}
