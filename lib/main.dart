import 'package:dart_flutter_shop/models/cart_list.dart';
import 'package:dart_flutter_shop/models/order_list.dart';
import 'package:dart_flutter_shop/models/product_list.dart';
import 'package:dart_flutter_shop/screens/cart_page.dart';
import 'package:dart_flutter_shop/screens/form_product_page.dart';
import 'package:dart_flutter_shop/screens/manage_page.dart';
import 'package:dart_flutter_shop/screens/order_page.dart';
import 'utils/my_routes.dart';
import 'screens/home_page.dart';

import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';

void main() {
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
        ChangeNotifierProvider(create: (context) => OrderList()),
      ],
      child: MaterialApp(
        supportedLocales: const [
          ...FormBuilderLocalizations.supportedLocales,
        ],
        localizationsDelegates: const [
          ...GlobalMaterialLocalizations.delegates,
          FormBuilderLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        title: 'Shopping App',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        routes: {
          MyRoutes.home: (context) => const HomePage(),
          MyRoutes.cartPage: (context) => const CartPage(),
          MyRoutes.order: (context) => const OrderPage(),
          MyRoutes.manage: (context) => const ManagePage(),
          MyRoutes.formProduct: (context) => const FormProductPage(),
        },
      ),
    );
  }
}
