import 'package:dart_flutter_shop/models/cart_model.dart';

class OrderModel {
  final String id;
  final double amount;
  final DateTime date;
  final List<CartModel> cart;

  OrderModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.cart,
  });
}
