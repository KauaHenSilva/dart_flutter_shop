class MyConst {
  final url = const String.fromEnvironment('URL_BASE');

  String get urlProducts => '$url/products';
  String get urlCart => '$url/cart';
  String get urlOrders => '$url/orders';
}
