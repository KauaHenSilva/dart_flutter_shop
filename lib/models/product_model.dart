import 'package:flutter/material.dart';

class ProductModel extends ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  void toggleFavorite(){
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
