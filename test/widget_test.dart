// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:flutter_expandable_table/src/widget_internal/table.dart';

// Project imports:
import 'my_app_test.dart';

void main() {
  const widget = MyApp();
  group('Simple table', () {
    testWidgets('First header table cell', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('Simple\nTable'), findsOneWidget);
    });
    testWidgets('Visible columns and rows limits', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('_Column 0').hitTestable(), findsOneWidget);
      expect(find.text('_Column 3').hitTestable(), findsOneWidget);
      expect(find.text('_Column 4').hitTestable(), findsNothing);
      expect(find.text('_Row 0').hitTestable(), findsOneWidget);
      expect(find.text('_Row 12').hitTestable(), findsOneWidget);
      expect(find.text('_Row 13').hitTestable(), findsNothing);
      expect(find.text('_Cell 0:0').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 0:3').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 0:4').hitTestable(), findsNothing);
      expect(find.text('_Cell 12:0').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 12:3').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 12:4').hitTestable(), findsNothing);
    });
    testWidgets('First column vertical scroll', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('_Row 0').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 0:0').hitTestable(), findsOneWidget);
      expect(find.text('_Row 18').hitTestable(), findsNothing);
      expect(find.text('_Cell 18:0').hitTestable(), findsNothing);
      await tester.dragFrom(
        tester.getCenter(find.text('_Row 12')),
        const Offset(0, -500),
      );
      await tester.pump();
      expect(find.text('_Row 18').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 18:0').hitTestable(), findsOneWidget);
      expect(find.text('_Row 0').hitTestable(), findsNothing);
      expect(find.text('_Cell 0:0').hitTestable(), findsNothing);
    });
    testWidgets('Header horizontal scroll', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('_Column 0').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 0:0').hitTestable(), findsOneWidget);
      expect(find.text('_Column 7').hitTestable(), findsNothing);
      expect(find.text('_Cell 0:7').hitTestable(), findsNothing);
      await tester.dragFrom(
        tester.getCenter(find.text('_Column 3')),
        const Offset(-730, 0),
      );
      await tester.pump();
      expect(find.text('_Column 0').hitTestable(), findsNothing);
      expect(find.text('_Cell 0:0').hitTestable(), findsNothing);
      expect(find.text('_Column 7').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 0:7').hitTestable(), findsOneWidget);
    });
    testWidgets('Body vertical scroll', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('_Row 0').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 0:0').hitTestable(), findsOneWidget);
      expect(find.text('_Row 18').hitTestable(), findsNothing);
      expect(find.text('_Cell 18:0').hitTestable(), findsNothing);
      await tester.dragFrom(
        tester.getCenter(find.text('_Cell 12:0')),
        const Offset(0, -500),
      );
      await tester.pump();
      expect(find.text('_Row 18').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 18:0').hitTestable(), findsOneWidget);
      expect(find.text('_Row 0').hitTestable(), findsNothing);
      expect(find.text('_Cell 0:0').hitTestable(), findsNothing);
    });
    testWidgets('Body horizontal scroll', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('_Column 0').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 0:0').hitTestable(), findsOneWidget);
      expect(find.text('_Column 7').hitTestable(), findsNothing);
      expect(find.text('_Cell 0:7').hitTestable(), findsNothing);
      await tester.dragFrom(
        tester.getCenter(find.text('_Cell 0:3')),
        const Offset(-730, 0),
      );
      await tester.pump();
      expect(find.text('_Column 0').hitTestable(), findsNothing);
      expect(find.text('_Cell 0:0').hitTestable(), findsNothing);
      expect(find.text('_Column 7').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 0:7').hitTestable(), findsOneWidget);
    });
  });
  group('Expandable table', () {
    testWidgets('First header table cell', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('Expandable\nTable'), findsOneWidget);
    });
    testWidgets('Visible columns and rows limits', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('&Column 0').hitTestable(), findsOneWidget);
      expect(find.text('&Column 3').hitTestable(), findsOneWidget);
      expect(find.text('&Column 4').hitTestable(), findsNothing);
      expect(find.text('&Row 0').hitTestable(), findsOneWidget);
      expect(find.text('&Row 5').hitTestable(), findsOneWidget);
      expect(find.text('&Cell 0:0').hitTestable(), findsOneWidget);
      expect(find.text('&Cell 0:5').hitTestable(), findsOneWidget);
      expect(find.text('&Cell 0:6').hitTestable(), findsNothing);
      expect(find.text('&Cell 5:0').hitTestable(), findsOneWidget);
      expect(find.text('&Cell 5:5').hitTestable(), findsOneWidget);
      expect(find.text('&Cell 5:6').hitTestable(), findsNothing);
    }); /*
    testWidgets('Rows expansion', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('&Row 2').hitTestable(), findsOneWidget);
      expect(find.text('&Sub &Row 0').hitTestable(), findsNothing);
      expect(find.text('&Cell 0:0').hitTestable(), findsOneWidget);
      await tester.tap(find.text('&Row 2'));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('&Row 2').hitTestable(), findsOneWidget);
      expect(find.text('&Cell 0:0').hitTestable(), findsNWidgets(2));
      expect(find.textContaining('&Sub &Row 0').hitTestable(), findsOneWidget);
    });*/

    // Fix documentation:
    // Problem: collapsed tables with zero rows could crash during layout.
    // Root cause: the collapsed sizing path assumed at least one visible row
    // and read dimensions from an empty collection.
    // Solution: this regression verifies that an empty collapsed table renders
    // without exceptions.
    testWidgets('collapsed layout does not crash with zero rows', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(
        MaterialApp(
          home: ExpandableTable(
            fixedHeaderCells: [
              ExpandableTableCell(child: const Text('Header')),
            ],
            headers: [
              ExpandableTableHeader(
                cell: ExpandableTableCell(child: const Text('Column')),
              ),
            ],
            rows: const [],
            expanded: false,
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Column'), findsOneWidget);
    });
    // Fix documentation:
    // Problem: collapsed table size included headers and rows that should have
    // been hidden while their parents were expanded.
    // Root cause: the collapsed-size calculation used total counts instead of
    // visible counts.
    // Solution: this regression verifies that hidden expanded parents do not
    // inflate the shrink-wrapped table size.
    testWidgets(
      'collapsed layout size excludes hidden expanded parent header and row',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 600));

        final parentHeader = ExpandableTableHeader(
          width: 100,
          hideWhenExpanded: true,
          childrenExpanded: true,
          cell: ExpandableTableCell(child: const Text('Parent Column')),
          children: [
            ExpandableTableHeader(
              width: 80,
              cell: ExpandableTableCell(child: const Text('Child Column')),
            ),
          ],
        );

        final childRow = ExpandableTableRow(
          height: 25,
          fixedCells: [ExpandableTableCell(child: const Text('Child Row'))],
          cells: [
            ExpandableTableCell(child: const Text('Child Parent Cell')),
            ExpandableTableCell(child: const Text('Child Cell')),
          ],
        );

        final parentRow = ExpandableTableRow(
          height: 40,
          hideWhenExpanded: true,
          childrenExpanded: true,
          fixedCells: [ExpandableTableCell(child: const Text('Parent Row'))],
          cells: [
            ExpandableTableCell(child: const Text('Parent Cell')),
            ExpandableTableCell(child: const Text('Parent Child Cell')),
          ],
          children: [childRow],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Align(
              alignment: Alignment.topLeft,
              child: ExpandableTable(
                fixedHeaderCells: [
                  ExpandableTableCell(child: const Text('Fixed Header')),
                ],
                headers: [parentHeader],
                rows: [parentRow],
                expanded: false,
                headerHeight: 30,
                fixedColumnWidths: const [50],
                defaultsColumnWidth: 120,
                defaultsRowHeight: 20,
              ),
            ),
          ),
        );

        final tableSize = tester.getSize(find.byType(InternalTable));
        expect(tableSize.width, 130);
        expect(tableSize.height, 55);
      },
    );
    // Fix documentation:
    // Problem: malformed nested child rows were accepted during setup and only
    // failed later as render-time range errors.
    // Root cause: table validation checked only top-level rows.
    // Solution: this regression verifies that mismatched nested rows fail
    // validation immediately during initialization.
    testWidgets('nested rows with mismatched cell counts fail validation', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));

      await tester.pumpWidget(
        MaterialApp(
          home: ExpandableTable(
            fixedHeaderCells: [
              ExpandableTableCell(child: const Text('Fixed Header')),
            ],
            headers: [
              ExpandableTableHeader(
                cell: ExpandableTableCell(child: const Text('Column')),
              ),
            ],
            rows: [
              ExpandableTableRow(
                fixedCells: [
                  ExpandableTableCell(child: const Text('Parent Row')),
                ],
                cells: [ExpandableTableCell(child: const Text('Parent Cell'))],
                childrenExpanded: true,
                children: [
                  ExpandableTableRow(
                    fixedCells: [
                      ExpandableTableCell(child: const Text('Child Row')),
                    ],
                    cells: [
                      ExpandableTableCell(child: const Text('Child Cell 1')),
                      ExpandableTableCell(child: const Text('Child Cell 2')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isA<FormatException>());
    });
  });
}
