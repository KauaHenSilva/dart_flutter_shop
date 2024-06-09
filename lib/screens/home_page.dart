import 'package:dart_flutter_shop/models/product_list.dart';
import 'package:dart_flutter_shop/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<void> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    await context.read<ProductList>().getProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _productsFuture = _fetchProducts();
    });
    await _productsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Shopping'),
        ),
        body: Consumer<ProductList>(
          builder: (context, productList, child) {
            return FutureBuilder(
              future: _productsFuture,
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
                              onPressed: _refreshProducts,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _refreshProducts,
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
                  leading: IconButton(
                    icon: const Icon(Icons.shopping_basket_sharp),
                    onPressed: () {},
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
