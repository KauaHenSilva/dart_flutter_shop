import 'package:dart_flutter_shop/models/cart_list.dart';
import 'package:dart_flutter_shop/models/product_list.dart';
import 'package:dart_flutter_shop/models/product_model.dart';
import 'package:dart_flutter_shop/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<void> statusRefresh;

  @override
  void initState() {
    super.initState();
    statusRefresh = _fetch();
  }

  Future<void> _fetch() async {
    await Future.wait([
      context.read<ProductList>().getProducts(),
      context.read<CartList>().fetchCart(),
    ]);
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
          title: const Text('Shopping'),
        ),
        drawer: const MyDrawer(),
        body: Consumer<ProductList>(
          builder: (context, productList, child) {
            return FutureBuilder(
              future: statusRefresh,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Error loading products.'),
                            ElevatedButton(
                              onPressed: _refresh,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: MyListProduct(productList: productList),
                    );
                }
              },
            );
          },
        ));
  }
}

class MyListProduct extends StatelessWidget {
  final ProductList productList;

  const MyListProduct({
    super.key,
    required this.productList,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: productList.productLen,
      itemBuilder: (context, index) {
        final product = productList.products[index];
        return ChangeNotifierProvider.value(
          value: product,
          child: Consumer<ProductModel>(
            builder: (context, value, child) {
              return GridTile(
                footer: GridTileBar(
                  title: Center(child: Text(product.title)),
                  backgroundColor: Colors.black87,
                  trailing: IconButton(
                    icon: value.isFavorite
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border_rounded),
                    onPressed: () {
                      value.toggleFavorite();
                    },
                  ),
                  leading: Consumer<CartList>(
                    builder: (context, cartList, child) {
                      Widget icon;
                      try {
                        final itemQuantity = cartList.itens[index].quantity;
                        icon = Badge(
                          label: Text(
                            itemQuantity.toString(),
                          ),
                          child: const Icon(Icons.shopping_cart),
                        );
                      } catch (e) {
                        icon = const Icon(Icons.shopping_cart);
                      }

                      return IconButton(
                        icon: icon,
                        onPressed: () {
                          cartList.addProduct(value);
                        },
                      );
                    },
                  ),
                ),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.fill,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
