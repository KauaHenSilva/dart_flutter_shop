import 'dart:convert';
import 'package:flutter/material.dart';
import 'product_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ProductList extends ChangeNotifier {
  final List<ProductModel> _products = [];
  final urlFireBase = dotenv.get('FIREBASE_URL');

  int get productLen => _products.length;
  List<ProductModel> get products => [..._products];

  Future<void> getProducts() async {
    final resp = await http.get(Uri.parse('$urlFireBase/products.json'));
    if (resp.body == 'null') return;

    if (resp.statusCode >= 400) throw Exception('Failed to load products');

    _products.clear();
    final Map<String, dynamic> valores = jsonDecode(resp.body);
    valores.forEach(
      (key, value) {
        _products.add(
          ProductModel(
              id: key,
              title: value['title'],
              description: value['description'],
              imageUrl: value['imageUrl'],
              price: value['price'],
              isFavorite: value['isFavorite']),
        );
      },
    );
    notifyListeners();
    return Future.value();
  }
}
