import 'package:dart_flutter_shop/models/product_list.dart';
import 'package:dart_flutter_shop/utils/my_routes.dart';
import 'package:dart_flutter_shop/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({super.key});

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  late Future<void> statusLoading;

  @override
  void initState() {
    super.initState();
    statusLoading = _reload();
  }

  Future<void> _fetch() async {
    await context.read<ProductList>().getProducts();
  }

  Future<void> _reload() async {
    setState(() {
      statusLoading = _fetch();
    });
    await statusLoading;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(MyRoutes.formProduct);
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Consumer<ProductList>(
        builder: (context, productList, child) => FutureBuilder(
          future: statusLoading,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                return RefreshIndicator(
                  onRefresh: _reload,
                  child: Page(productList: productList),
                );
            }
          },
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final ProductList productList;
  const Page({
    super.key,
    required this.productList,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: productList.products.length,
        itemBuilder: (context, index) {
          final product = productList.products[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(product.imageUrl),
            ),
            title: Text(product.title),
            trailing: SizedBox(
              width: 80,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        MyRoutes.formProduct,
                        arguments: product,
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
