import 'package:flutter/material.dart';

class MyConst {
  final url = const String.fromEnvironment('URL_BASE');

  String get urlProducts {
    debugPrint('URL_BASE: $url');
    return '$url/products';
  }
  String get urlCart => '$url/cart';
  String get urlOrders => '$url/orders';
}
