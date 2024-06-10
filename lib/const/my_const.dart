import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyConst {
  final url = dotenv.get('FIREBASE_URL');

  String get urlProducts => '$url/products';
  String get urlCart => '$url/cart';
  String get urlOrders => '$url/orders';
}