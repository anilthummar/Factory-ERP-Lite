import 'app_scroll_behaviour.dart';
export 'exports.dart';

/// Custom scroll behavior for the application.
class AppScrollBehavior extends MaterialScrollBehavior {
  /// Allows dragging with touch, mouse, and trackpad.
  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
