import 'package:dart_flutter_shop/models/cart_list.dart';
import 'package:dart_flutter_shop/models/product_list.dart';
import 'package:dart_flutter_shop/screens/cart_page.dart';
import 'package:dart_flutter_shop/screens/order_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'screens/home_page.dart';
import 'utils/my_routes.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductList()),
        ChangeNotifierProvider(create: (context) => CartList()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopping App',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        routes: {
          MyRoutes.home: (context) => const HomePage(),
          MyRoutes.cartPage: (context) => const CartPage(),
          MyRoutes.order: (context) => const OrderPage(),
        },
      ),
    );
  }
}
