import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

const Color _primaryColor = Color(0xFF1e2f36); //corner
const Color _accentColor = Color(0xFF0d2026); //background
const TextStyle _textStyle = TextStyle(color: Colors.white);
const TextStyle _priceStyle = TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold);

void main() => runApp(const _MyApp());

class _MyApp extends StatelessWidget {
  const _MyApp();

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'ExpandableTable Example',
        theme: ThemeData(primarySwatch: Colors.grey),
        home: const _MyHomePage(),
        scrollBehavior: _AppCustomScrollBehavior(),
      );
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage();

  @override
  State<_MyHomePage> createState() => _MyHomePageState();
}

class _DefaultCellCard extends StatelessWidget {
  final Widget child;

  const _DefaultCellCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Container(
        color: _primaryColor,
        margin: const EdgeInsets.all(1),
        child: child,
      );
}

class Product {
  final String name;
  final double price;
  final int quantity;
  final String category;

  Product({
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
  });

  double get total => price * quantity;
}

class _MyHomePageState extends State<_MyHomePage> {
  // Sample product data
  final List<Product> _products = [
    Product(name: 'Laptop', price: 999.99, quantity: 5, category: 'Electronics'),
    Product(name: 'Smartphone', price: 499.99, quantity: 10, category: 'Electronics'),
    Product(name: 'Headphones', price: 99.99, quantity: 20, category: 'Electronics'),
    Product(name: 'Chair', price: 149.99, quantity: 8, category: 'Furniture'),
    Product(name: 'Desk', price: 249.99, quantity: 5, category: 'Furniture'),
    Product(name: 'Bookshelf', price: 199.99, quantity: 3, category: 'Furniture'),
    Product(name: 'T-shirt', price: 19.99, quantity: 50, category: 'Clothing'),
    Product(name: 'Jeans', price: 49.99, quantity: 30, category: 'Clothing'),
    Product(name: 'Jacket', price: 79.99, quantity: 15, category: 'Clothing'),
  ];

  // Group products by category
  Map<String, List<Product>> get _groupedProducts {
    final Map<String, List<Product>> result = {};
    for (var product in _products) {
      if (!result.containsKey(product.category)) {
        result[product.category] = [];
      }
      result[product.category]!.add(product);
    }
    return result;
  }

  // Calculate total price for a category
  double _calculateCategoryTotal(String category) {
    final products = _groupedProducts[category] ?? [];
    return products.fold(0, (sum, product) => sum + product.total);
  }

  ExpandableTableCell _buildCell(String content, {CellBuilder? builder}) =>
      ExpandableTableCell(
        child: builder != null
            ? null
            : _DefaultCellCard(
                child: Center(
                  child: Text(
                    content,
                    style: _textStyle,
                  ),
                ),
              ),
        builder: builder,
      );

  ExpandableTableCell _buildPriceCell(double price) =>
      ExpandableTableCell(
        child: _DefaultCellCard(
          child: Center(
            child: Text(
              '\$${price.toStringAsFixed(2)}',
              style: _priceStyle,
            ),
          ),
        ),
      );

  ExpandableTable _buildProductTable() {
    //Creation header
    final List<ExpandableTableHeader> headers = [
      ExpandableTableHeader(
        width: 150,
        cell: _buildCell('Name'),
      ),
      ExpandableTableHeader(
        width: 150,
        cell: _buildCell('Price'),
      ),
      ExpandableTableHeader(
        width: 150,
        cell: _buildCell('Quantity'),
      ),
      ExpandableTableHeader(
        width: 150,
        cell: _buildCell('Total Value'),
      ),
    ];

    //Creation rows
    final List<ExpandableTableRow> rows = [];

    // Add rows for each category and its products
    _groupedProducts.forEach((category, products) {
      // Add grouped row for the category with total price
      final double categoryTotal = _calculateCategoryTotal(category);
      
      final List<ExpandableTableRow> productRows = products.map((product) {
        return ExpandableTableRow(
          fixedCells: [
            _buildCell('-'),
            _buildPriceCell(product.price),
          ],
          cells: [
            _buildCell(product.name),
            _buildCell(product.price.toString()),
            _buildCell(product.quantity.toString()),
            _buildPriceCell(product.total),
          ],
        );
      }).toList();
      
      rows.add(
        ExpandableTableRow(
          fixedCells: [
            _buildCell(category),
            _buildPriceCell(categoryTotal),
          ],
          legend: _DefaultCellCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '$category Category - ${products.length} products - Total Value: \$${categoryTotal.toStringAsFixed(2)}',
                      style: _textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          children: productRows,
        ),
      );
    });

    return ExpandableTable(
      fixedHeaderCells: [_buildCell('Category'), _buildCell('Cat. Total')],
      fixedColumnWidths: const [200, 120], // Width for product name and price columns
      headers: headers,
      scrollShadowColor: _accentColor,
      rows: rows,
      visibleScrollbar: true,
      trackVisibilityScrollbar: true,
      thumbVisibilityScrollbar: true,
      headerHeight: 60,
      defaultsRowHeight: 60,
      defaultsColumnWidth: 150,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Products Table with Multiple Fixed Columns'),
          centerTitle: true,
        ),
        body: Container(
          color: _accentColor,
          padding: const EdgeInsets.all(20.0),
          child: _buildProductTable(),
        ),
      );
}

class _AppCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
