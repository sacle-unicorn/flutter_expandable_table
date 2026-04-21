import 'package:flutter/widgets.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:flutter_test/flutter_test.dart';

ExpandableTableCell _cell([String text = 'cell']) =>
    ExpandableTableCell(child: Text(text));

void main() {
  test('visibleColumnsCount excludes collapsed children', () {
    final child = ExpandableTableHeader(cell: _cell('child'));
    final parent = ExpandableTableHeader(
      cell: _cell('parent'),
      children: [child],
      childrenExpanded: false,
    );

    expect(parent.columnsCount, 2);
    expect(parent.visibleColumnsCount, 1);
  });
}
