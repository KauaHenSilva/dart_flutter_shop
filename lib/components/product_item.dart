import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(
    this.product, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.productForm,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Excluir Produto'),
                    content: const Text('Tem certeza?'),
                    actions: [
                      TextButton(
                        child: const Text('Não'),
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                      TextButton(
                        child: const Text('Sim'),
                        onPressed: () => Navigator.of(ctx).pop(true),
                      ),
                    ],
                  ),
                ).then((value) async {
                  if (value ?? false) {
                    try {
                      await Provider.of<ProductList>(
                        context,
                        listen: false,
                      ).removeProduct(product);
                    } catch (error) {
                      msg.showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                        ),
                      );
                    }
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}