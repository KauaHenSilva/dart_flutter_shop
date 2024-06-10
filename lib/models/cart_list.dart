import 'dart:convert';

import 'package:dart_flutter_shop/const/my_const.dart';
import 'package:dart_flutter_shop/models/cart_model.dart';
import 'package:dart_flutter_shop/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartList extends ChangeNotifier {
  final List<CartModel> _itens = [];
  List<CartModel> get itens => [..._itens];

  void addProduct(ProductModel product) async {
    final index = _itens.indexWhere((element) => element.idProd == product.id);

    if (index >= 0) {
      final existingItem = _itens[index];
      final updatedItem = CartModel(
        id: existingItem.id,
        idProd: existingItem.idProd,
        title: existingItem.title,
        price: existingItem.price,
        quantity: existingItem.quantity + 1,
      );
      _itens[index] = updatedItem;
      notifyListeners();

      final res = await http.patch(
        Uri.parse('${MyConst().urlCart}/${updatedItem.id}.json'),
        body: jsonEncode({
          'idProd': updatedItem.idProd,
          'title': updatedItem.title,
          'price': updatedItem.price,
          'cont': updatedItem.quantity,
        }),
      );

      if (res.statusCode >= 400) {
        _itens[index] = existingItem;
        notifyListeners();

        throw Exception('Error updating product in cart');
      }
    } else {
      final res = await http.post(
        Uri.parse('${MyConst().urlCart}.json'),
        body: jsonEncode({
          'idProd': product.id,
          'title': product.title,
          'price': product.price,
          'cont': 1,
        }),
      );

      if (res.statusCode >= 400) {
        throw Exception('Error adding product to cart');
      }

      final resData = jsonDecode(res.body);
      final cartId = resData['name'];
      final newItem = CartModel(
        id: cartId,
        idProd: product.id,
        title: product.title,
        price: product.price,
        quantity: 1,
      );
      _itens.add(newItem);
      notifyListeners();
    }
  }

  Future<void> fetchCart() async {
    final response = await http.get(Uri.parse('${MyConst().urlCart}.json'));
    if (response.body == 'null') return;

    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    _itens.clear();
    extractedData.forEach((key, value) {
      _itens.add(CartModel(
        id: key,
        idProd: value['idProd'],
        title: value['title'],
        quantity: value['cont'],
        price: value['price'],
      ));
    });

    notifyListeners();
  }

  bool isInCart(String productId) {
    return _itens.any((item) => item.idProd == productId);
  }
}
