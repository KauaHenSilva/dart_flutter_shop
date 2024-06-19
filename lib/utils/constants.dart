class Constants {
  final url = const String.fromEnvironment('url_base');

  String get urlProducts => '$url/products';
  String get urlCart => '$url/cart';
  String get urlOrders => '$url/orders';
}
