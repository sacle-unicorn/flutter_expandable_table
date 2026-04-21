import 'package:flutter/widgets.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:flutter_test/flutter_test.dart';

ExpandableTableCell _cell([String text = 'cell']) =>
    ExpandableTableCell(child: Text(text));

void main() {
  test('getTotalFixedColumnsWidth repeats the last configured width', () {
    final controller = ExpandableTableController(
      fixedHeaderCells: [_cell('fixed-1'), _cell('fixed-2')],
      headers: [
        ExpandableTableHeader(cell: _cell('header')),
      ],
      rows: [
        ExpandableTableRow(
          fixedCells: [_cell('row-fixed-1'), _cell('row-fixed-2')],
          cells: [_cell('value')],
        ),
      ],
      fixedColumnWidths: const [80],
    );

    expect(controller.getTotalFixedColumnsWidth(), 160);
  });
}
