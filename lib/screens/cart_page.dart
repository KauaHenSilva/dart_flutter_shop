import 'package:dart_flutter_shop/models/cart_list.dart';
import 'package:dart_flutter_shop/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<void> _productsFuture;

  @override
  void initState() {
    _productsFuture = _fetchCart();
    super.initState();
  }

  Future<void> _fetchCart() async {
    await context.read<CartList>().fetchCart();
  }

  Future<void> _refreshCart() async {
    setState(() {
      _productsFuture = _fetchCart();
    });
    await _productsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Page'),
      ),
      drawer: const MyDrawer(),
      body: Consumer<CartList>(
        builder: (context, cartList, child) {
          return FutureBuilder(
            future: _productsFuture,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshCart,
                    child: CartScreen(
                      cartList: cartList,
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final CartList cartList;

  const CartScreen({
    super.key,
    required this.cartList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Card(
            child: Row(
          children: [],
        )),
        Expanded(
          child: ListView.builder(
            itemCount: cartList.itens.length,
            itemBuilder: (context, index) {
              final cartItem = [...cartList.itens][index];
              return ListTile(
                title: Text(cartItem.title),
                subtitle: Text('Quantity: ${cartItem.quantity.toString()}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
