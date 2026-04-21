// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:flutter_expandable_table/src/widget_internal/cell.dart';

/// [InternalTable] it is the widget that builds the table.
class InternalTable extends StatefulWidget {
  /// [InternalTable] constructor.
  const InternalTable({
    super.key,
  });

  @override
  InternalTableState createState() => InternalTableState();
}

/// [InternalTable] state.
class InternalTableState extends State<InternalTable> {
  late LinkedScrollControllerGroup _horizontalLinkedControllers;
  late ScrollController _headController;
  late ScrollController _horizontalBodyController;
  late LinkedScrollControllerGroup _verticalLinkedControllers;
  late ScrollController _fixedColumnsController;
  late ScrollController _restColumnsController;

  @override
  void initState() {
    super.initState();
    _horizontalLinkedControllers = LinkedScrollControllerGroup();
    _headController = _horizontalLinkedControllers.addAndGet();
    _horizontalBodyController = _horizontalLinkedControllers.addAndGet();
    _verticalLinkedControllers = LinkedScrollControllerGroup();
    _fixedColumnsController = _verticalLinkedControllers.addAndGet();
    _restColumnsController = _verticalLinkedControllers.addAndGet();
  }

  @override
  void dispose() {
    _headController.dispose();
    _horizontalBodyController.dispose();
    _restColumnsController.dispose();
    _fixedColumnsController.dispose();
    super.dispose();
  }

  List<Widget> _buildHeaderCells(ExpandableTableController data) =>
      data.allHeaders
      .map(
        (e) => ExpandableTableCellWidget(
          height: data.headerHeight,
          width: e.width ?? data.defaultsColumnWidth,
          header: e,
          onTap: () {
            if (!e.disableDefaultOnTapExpansion) {
              e.toggleExpand();
            }
          },
          builder: e.cell.build,
        ),
      )
      .toList();

  Widget _buildRowCells(
      ExpandableTableController data, ExpandableTableRow row) {
    if (row.cells != null) {
      return Row(
        children: row.cells!
            .map(
              (cell) => ExpandableTableCellWidget(
                header: data.allHeaders[row.cells!.indexOf(cell)],
                row: row,
                height: row.height ?? data.defaultsRowHeight,
                width: data.allHeaders[row.cells!.indexOf(cell)].width ??
                    data.defaultsColumnWidth,
                builder: cell.build,
              ),
            )
            .toList(),
      );
    } else {
      return ExpandableTableCellWidget(
        height: row.height ?? data.defaultsRowHeight,
        width: double.infinity,
        row: row,
        builder: (context, details) => row.legend!,
      );
    }
  }

  Widget _buildBody(ExpandableTableController data) => Row(
    children: [
      Builder(
        builder: (context) {
          final Widget child = ListView(
            controller: _fixedColumnsController,
            physics: const ClampingScrollPhysics(),
                children: data.allRows.map(
                  (e) => ChangeNotifierProvider<ExpandableTableRow>.value(
                    value: e,
                    builder: (context, child) => Row(
                      children: context.watch<ExpandableTableRow>().fixedCells.asMap().entries.map(
                        (entry) {
                            final int index = entry.key;
                            final ExpandableTableCell cell = entry.value;
                          final double width = index < data.fixedColumnWidths.length 
                                ? data.fixedColumnWidths[index]
                                : data.fixedColumnWidths.last;

                            return ExpandableTableCellWidget(
                              row: context.watch<ExpandableTableRow>(),
                            height: context.watch<ExpandableTableRow>().height ??
                                  data.defaultsRowHeight,
                              width: width,
                              builder: cell.build,
                              onTap: () {
                                if (!e.disableDefaultOnTapExpansion) {
                                  e.toggleExpand();
                                }
                              },
                            );
                        },
                      ).toList(),
                    ),
                  ),
                ).toList(),
          );

          return SizedBox(
            width: data.getTotalFixedColumnsWidth(),
            child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
              child: ScrollShadow(
                size: data.scrollShadowSize,
                color: data.scrollShadowColor,
                fadeInCurve: data.scrollShadowFadeInCurve,
                fadeOutCurve: data.scrollShadowFadeOutCurve,
                duration: data.scrollShadowDuration,
                child: data.visibleScrollbar
                    ? Scrollbar(
                        controller: _fixedColumnsController,
                        thumbVisibility: data.thumbVisibilityScrollbar,
                        trackVisibility: data.trackVisibilityScrollbar,
                        scrollbarOrientation: ScrollbarOrientation.left,
                        child: child,
                      )
                    : child,
              ),
            ),
          );
        },
      ),
      Builder(
        builder: (context) {
          final Widget child = SingleChildScrollView(
            controller: _horizontalBodyController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: AnimatedContainer(
              width: data.visibleHeadersWidth,
              duration: data.duration,
              curve: data.curve,
              child: ScrollShadow(
                size: data.scrollShadowSize,
                color: data.scrollShadowColor,
                fadeInCurve: data.scrollShadowFadeInCurve,
                fadeOutCurve: data.scrollShadowFadeOutCurve,
                duration: data.scrollShadowDuration,
                child: ListView(
                  controller: _restColumnsController,
                  physics: const ClampingScrollPhysics(),
                  children: data.allRows
                          .map(
                            (e) => _buildRowCells(data, e),
                          )
                      .toList(),
                ),
              ),
            ),
          );

          return Expanded(
            child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
              child: ScrollShadow(
                size: data.scrollShadowSize,
                color: data.scrollShadowColor,
                fadeInCurve: data.scrollShadowFadeInCurve,
                fadeOutCurve: data.scrollShadowFadeOutCurve,
                duration: data.scrollShadowDuration,
                child: data.visibleScrollbar
                    ? Scrollbar(
                        controller: _horizontalBodyController,
                        thumbVisibility: data.thumbVisibilityScrollbar,
                        trackVisibility: data.trackVisibilityScrollbar,
                        child: child,
                      )
                    : child,
              ),
            ),
          );
        },
      ),
    ],
  );

  double _computeTableWidth({required ExpandableTableController data}) {

    // Problem: collapsed tables reported widths that still included hidden
    // expanded descendants.
    // Root cause: width was recomputed from the full header tree instead of the
    // controller's visible-header projection.
    // Solution: use visibleHeadersWidth plus the fixed-column width actually
    // rendered in the collapsed layout.
    return data.getTotalFixedColumnsWidth() + data.visibleHeadersWidth;
  }

  double _computeTableHeight({required ExpandableTableController data}) =>
      // Fix documentation:
      // Problem: collapsed tables could over-report height, and zero-row tables
      // could hit invalid reductions while computing body height.
      // Root cause: height used full row-tree traversal instead of the
      // controller's visible row height aggregate.
      // Solution: derive height from visibleRowsHeight so only rendered rows
      // contribute and empty tables remain valid.
      data.headerHeight + data.visibleRowsHeight;

  @override
  Widget build(BuildContext context) {
    final ExpandableTableController data = context
        .watch<ExpandableTableController>();
    return SizedBox(
      width: data.expanded ? null : _computeTableWidth(data: data),
      height: data.expanded ? null : _computeTableHeight(data: data),
      child: Column(
        children: [
          SizedBox(
            height: data.headerHeight,
            child: Row(
              children: [
                Row(
                  children: data.fixedHeaderCells.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final ExpandableTableCell cell = entry.value;
                    final double width = index < data.fixedColumnWidths.length
                        ? data.fixedColumnWidths[index]
                        : data.fixedColumnWidths.last;

                    return ExpandableTableCellWidget(
                      height: data.headerHeight,
                      width: width,
                      builder: cell.build,
                    );
                  }).toList(),
                ),
                Expanded(
                  child: ScrollShadow(
                    size: data.scrollShadowSize,
                    color: data.scrollShadowColor,
                    fadeInCurve: data.scrollShadowFadeInCurve,
                    fadeOutCurve: data.scrollShadowFadeOutCurve,
                    duration: data.scrollShadowDuration,
                    child: ListView(
                      controller: _headController,
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: _buildHeaderCells(data),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildBody(data),
          ),
        ],
      ),
    );
  }
}
