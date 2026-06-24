import '../../../../utils/exports.dart';

/// UI model for an entries grid module tile.
class EntryModuleItem {
  /// Creates [EntryModuleItem].
  const EntryModuleItem({
    required this.title,
    required this.icon,
    this.onTap,
  });

  /// Module display title.
  final String title;

  /// Module icon.
  final IconData icon;

  /// Navigation callback placeholder.
  final VoidCallback? onTap;
}
