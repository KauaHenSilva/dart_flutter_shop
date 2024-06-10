import 'dart:convert';
import 'package:dart_flutter_shop/const/my_const.dart';
import 'package:flutter/material.dart';
import 'product_model.dart';
import 'package:http/http.dart' as http;

class ProductList extends ChangeNotifier {
  final List<ProductModel> _products = [];

  int get productLen => _products.length;
  List<ProductModel> get products => [..._products];

  Future<void> getProducts() async {
    final resp = await http.get(Uri.parse('${MyConst().urlProducts}.json'));

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

  Future<void> addProduct(ProductModel product) async {
    if (product.id.isNotEmpty) {
      final index = _products.indexWhere((element) => element.id == product.id);
      final productBackup = products[index];

      _products[index] = product;
      notifyListeners();

      if (index >= 0) {
        final res = await http.patch(
          Uri.parse('${MyConst().urlProducts}/${product.id}.json'),
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          }),
        );

        if (res.statusCode >= 400) {
          _products[index] = productBackup;
          throw Exception('Failed to update product');
        }

        return Future.value();
      }
    }

    final res = await http.post(
      Uri.parse('${MyConst().urlProducts}.json'),
      body: jsonEncode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }),
    );

    if (res.statusCode >= 400) throw Exception('Failed to add product');
    final resData = jsonDecode(res.body);
    final newProduct = ProductModel(
      id: resData['name'],
      title: product.title,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
    );

    _products.add(newProduct);
    notifyListeners();
  }
}
