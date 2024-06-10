import 'package:dart_flutter_shop/utils/my_routes.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                'Drawer Header',
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(MyRoutes.home);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(MyRoutes.cartPage);
            },
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on_rounded),
            title: const Text('Order'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(MyRoutes.order);
            },
          ),
          ListTile(
            leading: const Icon(Icons.manage_accounts),
            title: const Text('manage'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(MyRoutes.manage);
            },
          ),
        ],
      ),
    );
  }
}
