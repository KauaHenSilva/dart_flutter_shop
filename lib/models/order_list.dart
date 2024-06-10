import 'dart:convert';
import 'package:dart_flutter_shop/const/my_const.dart';
import 'package:dart_flutter_shop/models/cart_list.dart';
import 'package:dart_flutter_shop/models/cart_model.dart';
import 'package:dart_flutter_shop/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderList extends ChangeNotifier {
  final List<OrderModel> itens = [];

  Future<void> getOrders() async {
    final resp = await http.get(Uri.parse('${MyConst().urlOrders}.json'));
    if (resp.body == 'null') return;

    final Map<String, dynamic> data = jsonDecode(resp.body);
    data.forEach((key, value) => OrderModel(
        id: key,
        amount: value['amount'],
        date: value['dateTime'],
        cart: (value['products'] as List<dynamic>)
            .map(
              (e) => CartModel(
                  id: e['id'],
                  idProd: e['idProd'],
                  title: e['title'],
                  price: e['price']),
            )
            .toList()));
  }

  Future<void> addOrder(CartList cart) async {
    final time = DateTime.now();
    http.post(Uri.parse('${MyConst().urlOrders}.json'),
        body: jsonEncode({
          'amount': cart.valueTotal,
          'dataTime': time.toIso8601String(),
          'products': cart.itens.map(
            (e) => {
              'idProd': e.idProd,
              'title': e.title,
              'price': e.price,
              'cont': e.quantity,
            },
          )
        }));
  }
}
