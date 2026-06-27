import 'package:flutter/material.dart';

import '../navigation/web_admin_section.dart';

/// Top app bar for the web admin shell.
class AdminTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates [AdminTopAppBar].
  const AdminTopAppBar({
    required this.section,
    this.pendingSyncCount,
    this.onRefresh,
    this.userName,
    this.userEmail,
    this.onOpenSettings,
    this.onSignOut,
    super.key,
  });

  /// Active section shown in the title.
  final WebAdminSection section;

  /// Pending sync queue count for the status chip.
  final int? pendingSyncCount;

  /// Optional refresh action for the current page.
  final VoidCallback? onRefresh;

  /// Signed-in user display name.
  final String? userName;

  /// Signed-in user email.
  final String? userEmail;

  /// Navigates to settings.
  final VoidCallback? onOpenSettings;

  /// Signs the user out.
  final VoidCallback? onSignOut;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      elevation: 0,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    section.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                if (pendingSyncCount != null && pendingSyncCount! > 0) ...<Widget>[
                  const SizedBox(width: 8),
                  Chip(
                    avatar: const Icon(Icons.sync_problem, size: 18),
                    label: Text('$pendingSyncCount pending'),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
                const Spacer(),
                if (onRefresh != null)
                  IconButton(
                    tooltip: 'Refresh',
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                  ),
                PopupMenuButton<String>(
                  tooltip: 'Account',
                  offset: const Offset(0, 48),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 16,
                          child: Text(
                            (userName ?? 'A').characters.first.toUpperCase(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (MediaQuery.sizeOf(context).width >= 900)
                          Text(userName ?? 'Admin'),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  onSelected: (String value) {
                    switch (value) {
                      case 'settings':
                        onOpenSettings?.call();
                      case 'signout':
                        onSignOut?.call();
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        enabled: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              userName ?? 'Signed in',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            if (userEmail != null)
                              Text(
                                userEmail!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                              ),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: 'settings',
                        child: ListTile(
                          leading: Icon(Icons.settings_outlined),
                          title: Text('Settings'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'signout',
                        child: ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Sign out'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
