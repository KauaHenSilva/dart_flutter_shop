import 'package:dart_flutter_shop/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      drawer: const MyDrawer(),
      body: const Center(
        child: Text('Orders'),
      ),
    );
  }
}
