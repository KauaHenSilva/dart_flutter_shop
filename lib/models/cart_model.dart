import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  final String id;
  final String idProd;
  final String title;
  final double price;
  int quantity;

  CartModel({
    required this.id,
    required this.idProd,
    required this.title,
    required this.price,
    this.quantity = 1,
  });
}
