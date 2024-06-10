import 'dart:convert';

import 'package:dart_flutter_shop/const/my_const.dart';
import 'package:http/http.dart' as http;
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

  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();

    final res = await http.patch(Uri.parse('${MyConst().urlProducts}/$id.json'),
        body: jsonEncode({
          'isFavorite': isFavorite,
        }));

    if (res.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();

      throw Exception('Failed to update favorite status');
    }

    return Future.value();
  }
}
