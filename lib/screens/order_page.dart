import 'package:dart_flutter_shop/models/order_list.dart';
import 'package:dart_flutter_shop/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Future<void> statusRefresh;

  @override
  void initState() {
    super.initState();
    statusRefresh = _refresh();
  }

  Future<void> _fetch() async {
    await context.read<OrderList>().getOrders();
  }

  Future<void> _refresh() async {
    setState(() {
      statusRefresh = _fetch();
    });
    await statusRefresh;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
        ),
        drawer: const MyDrawer(),
        body: Consumer<OrderList>(builder: (context, orderList, child) {
          return FutureBuilder(
              future: statusRefresh,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      );
                    }

                    if (orderList.itens.isEmpty) {
                      return const Center(
                        child: Text('No orders found.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: orderList.itens.length,
                      itemBuilder: (context, index) {
                        final order = orderList.itens[index];
                        return ListTile(
                          title: Text(order.amount.toStringAsFixed(2)),
                        );
                      },
                    );
                }
              });
        }));
  }
}
