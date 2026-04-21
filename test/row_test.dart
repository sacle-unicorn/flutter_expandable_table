import 'package:flutter/widgets.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:flutter_test/flutter_test.dart';

ExpandableTableCell _cell([String text = 'cell']) =>
    ExpandableTableCell(child: Text(text));

ExpandableTableRow _row(
  String label, {
  List<ExpandableTableRow>? children,
  bool childrenExpanded = false,
}) {
  return ExpandableTableRow(
    fixedCells: [_cell(label)],
    cells: [_cell('$label-value')],
    children: children,
    childrenExpanded: childrenExpanded,
  );
}

void main() {
  test('rowsCount includes nested children even when collapsed', () {
    final child = _row('child');
    final parent = _row('parent', children: [child], childrenExpanded: false);

    expect(parent.rowsCount, 2);
    expect(parent.visibleRowsCount, 1);
  });
}
