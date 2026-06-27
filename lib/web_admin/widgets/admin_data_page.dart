import 'dart:async';

import 'package:flutter/material.dart';

import 'admin_search_toolbar.dart';

/// Reusable management page with search, filters, pagination, and bulk actions.
class AdminDataPage<T> extends StatefulWidget {
  /// Creates [AdminDataPage].
  const AdminDataPage({
    required this.title,
    required this.columns,
    required this.loadItems,
    required this.buildRow,
    required this.itemKey,
    required this.matchesSearch,
    this.subtitle,
    this.filterChips,
    this.filterItem,
    this.onBulkDelete,
    this.onAdd,
    this.onEdit,
    this.addButtonLabel = 'Add',
    this.refreshTick = 0,
    super.key,
  });

  /// Page title.
  final String title;

  /// Optional subtitle.
  final String? subtitle;

  /// Table column definitions (Actions column added when [onEdit] is set).
  final List<DataColumn> columns;

  /// Loads all items from repositories / use cases.
  final Future<List<T>> Function() loadItems;

  /// Builds a [DataRow] for [item].
  final DataRow Function(
    T item,
    bool selected,
    ValueChanged<bool?> onSelect,
  ) buildRow;

  /// Stable row key for selection.
  final String Function(T item) itemKey;

  /// Search predicate.
  final bool Function(T item, String query) matchesSearch;

  /// Optional filter chip labels.
  final List<String>? filterChips;

  /// Optional filter predicate when a chip is selected.
  final bool Function(T item, String? filter)? filterItem;

  /// Bulk delete handler for selected keys.
  final Future<void> Function(Set<String> ids)? onBulkDelete;

  /// Opens add form; list reloads when the route returns `true`.
  final Future<bool> Function()? onAdd;

  /// Opens edit form for [item].
  final Future<bool> Function(T item)? onEdit;

  /// Label for the add button.
  final String addButtonLabel;

  /// Increment to trigger reload from parent shell refresh.
  final int refreshTick;

  @override
  State<AdminDataPage<T>> createState() => _AdminDataPageState<T>();
}

class _AdminDataPageState<T> extends State<AdminDataPage<T>> {
  List<T> _items = <T>[];
  bool _loading = true;
  String? _error;
  String _search = '';
  String? _activeFilter;
  final Set<String> _selected = <String>{};
  int _page = 0;
  int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void didUpdateWidget(covariant AdminDataPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshTick != widget.refreshTick) {
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _selected.clear();
    });

    try {
      final List<T> items = await widget.loadItems();
      if (!mounted) {
        return;
      }
      setState(() {
        _items = items;
        _loading = false;
        _page = 0;
      });
    } on Object catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  List<T> get _filtered {
    return _items.where((T item) {
      final bool matchesQuery =
          _search.isEmpty || widget.matchesSearch(item, _search);
      final bool matchesFilter = widget.filterItem == null ||
          widget.filterChips == null ||
          _activeFilter == null ||
          widget.filterItem!(item, _activeFilter);
      return matchesQuery && matchesFilter;
    }).toList();
  }

  List<T> get _pageItems {
    final List<T> filtered = _filtered;
    final int start = _page * _rowsPerPage;
    if (start >= filtered.length) {
      return <T>[];
    }
    final int end = (start + _rowsPerPage).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  int get _pageCount {
    final int length = _filtered.length;
    if (length == 0) {
      return 1;
    }
    return (length / _rowsPerPage).ceil();
  }

  Future<void> _bulkDelete() async {
    if (widget.onBulkDelete == null || _selected.isEmpty) {
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete selected?'),
          content: Text('Remove ${_selected.length} selected record(s)?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await widget.onBulkDelete!(_selected);
    await _load();
  }

  Future<void> _handleAdd() async {
    final Future<bool> Function()? onAdd = widget.onAdd;
    if (onAdd == null) {
      return;
    }
    final bool saved = await onAdd();
    if (saved) {
      await _load();
    }
  }

  Future<void> _handleEdit(T item) async {
    final Future<bool> Function(T item)? onEdit = widget.onEdit;
    if (onEdit == null) {
      return;
    }
    final bool saved = await onEdit(item);
    if (saved) {
      await _load();
    }
  }

  List<DataColumn> get _tableColumns {
    if (widget.onEdit == null) {
      return widget.columns;
    }
    return <DataColumn>[
      ...widget.columns,
      const DataColumn(label: Text('Actions')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool stackHeader = constraints.maxWidth < 640;
              final Widget titleBlock = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  if (widget.subtitle != null) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              );

              if (stackHeader) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    titleBlock,
                    if (widget.onAdd != null) ...<Widget>[
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _loading ? null : () => unawaited(_handleAdd()),
                        icon: const Icon(Icons.add, size: 20),
                        label: Text(widget.addButtonLabel),
                      ),
                    ],
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: titleBlock),
                  if (widget.onAdd != null)
                    FilledButton.icon(
                      onPressed: _loading ? null : () => unawaited(_handleAdd()),
                      icon: const Icon(Icons.add, size: 20),
                      label: Text(widget.addButtonLabel),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          AdminSearchToolbar(
            loading: _loading,
            onRefresh: () => unawaited(_load()),
            onChanged: (String value) {
              setState(() {
                _search = value.trim().toLowerCase();
                _page = 0;
              });
            },
          ),
          if (widget.filterChips != null && widget.filterChips!.isNotEmpty)
            ...<Widget>[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: <Widget>[
                  FilterChip(
                    label: const Text('All'),
                    selected: _activeFilter == null,
                    onSelected: (bool? _) => setState(() {
                      _activeFilter = null;
                      _page = 0;
                    }),
                  ),
                  ...widget.filterChips!.map((String chip) {
                    return FilterChip(
                      label: Text(chip),
                      selected: _activeFilter == chip,
                      onSelected: (bool? _) => setState(() {
                        _activeFilter = chip;
                        _page = 0;
                      }),
                    );
                  }),
                ],
              ),
            ],
          if (_selected.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Material(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: <Widget>[
                    Text('${_selected.length} selected'),
                    const Spacer(),
                    if (widget.onBulkDelete != null)
                      TextButton.icon(
                        onPressed: () => unawaited(_bulkDelete()),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete'),
                      ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Expanded(
            child: _buildBody(colorScheme),
          ),
          const SizedBox(height: 8),
          _buildPagination(colorScheme),
        ],
      ),
    );
  }

  Widget _buildBody(ColorScheme colorScheme) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'No records found',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            if (widget.onAdd != null) ...<Widget>[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => unawaited(_handleAdd()),
                icon: const Icon(Icons.add),
                label: Text(widget.addButtonLabel),
              ),
            ],
          ],
        ),
      );
    }

    final List<T> pageItems = _pageItems;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                showCheckboxColumn: widget.onBulkDelete != null,
                columns: _tableColumns,
                rows: pageItems.map((T item) {
                  final String key = widget.itemKey(item);
                  final bool selected = _selected.contains(key);
                  final DataRow row = widget.buildRow(
                    item,
                    selected,
                    (bool? value) {
                      setState(() {
                        if (value ?? false) {
                          _selected.add(key);
                        } else {
                          _selected.remove(key);
                        }
                      });
                    },
                  );
                  if (widget.onEdit == null) {
                    return row;
                  }
                  return DataRow(
                    selected: row.selected,
                    onSelectChanged: row.onSelectChanged,
                    cells: <DataCell>[
                      ...row.cells,
                      DataCell(
                        IconButton(
                          tooltip: 'Edit',
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () => unawaited(_handleEdit(item)),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                headingRowColor: WidgetStatePropertyAll<Color?>(
                  colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPagination(ColorScheme colorScheme) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wrap = constraints.maxWidth < 520;
        final Widget countLabel = Text(
          '${_filtered.length} records',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        );
        final Widget pageControls = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownButton<int>(
              value: _rowsPerPage,
              items: const <DropdownMenuItem<int>>[
                DropdownMenuItem<int>(value: 10, child: Text('10 / page')),
                DropdownMenuItem<int>(value: 25, child: Text('25 / page')),
                DropdownMenuItem<int>(value: 50, child: Text('50 / page')),
              ],
              onChanged: (int? value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _rowsPerPage = value;
                  _page = 0;
                });
              },
            ),
            IconButton(
              onPressed: _page > 0 ? () => setState(() => _page--) : null,
              icon: const Icon(Icons.chevron_left),
            ),
            Text('Page ${_page + 1} of $_pageCount'),
            IconButton(
              onPressed:
                  _page + 1 < _pageCount ? () => setState(() => _page++) : null,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        );

        if (wrap) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              countLabel,
              const SizedBox(height: 4),
              Align(alignment: Alignment.centerRight, child: pageControls),
            ],
          );
        }

        return Row(
          children: <Widget>[
            countLabel,
            const Spacer(),
            pageControls,
          ],
        );
      },
    );
  }
}

/// Sync status chip for admin data tables.
class AdminSyncStatusChip extends StatelessWidget {
  /// Creates [AdminSyncStatusChip].
  const AdminSyncStatusChip({required this.status, super.key});

  /// Sync status label.
  final String status;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color bg;
    switch (status) {
      case 'synced':
        bg = colorScheme.tertiaryContainer;
      case 'failed':
        bg = colorScheme.errorContainer;
      default:
        bg = colorScheme.secondaryContainer;
    }

    return Chip(
      label: Text(status),
      backgroundColor: bg,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }
}
