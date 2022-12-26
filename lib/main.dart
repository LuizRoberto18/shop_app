import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/order_list.dart';
import 'package:shop_app/models/product_list.dart';
import 'package:shop_app/pages/cart_page.dart';
import 'package:shop_app/pages/product_detail_page.dart';
import 'package:shop_app/pages/products_overview_page.dart';
import 'package:shop_app/utils/app_routes.dart';

import 'models/cart.dart';
import 'pages/orders_page.dart';
import 'pages/product_form_page.dart';
import 'pages/products_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData tema = ThemeData();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: tema.copyWith(
          colorScheme: tema.colorScheme.copyWith(
            primary: Colors.purple,
            secondary: Colors.deepOrange,
          ),
          textTheme: tema.textTheme.copyWith(
            headline6: const TextStyle(fontFamily: 'Lato'),
          ),
        ),
        routes: {
          AppRoutes.home: (ctx) => const ProdcutsOverviewPage(),
          AppRoutes.productDetail: (ctx) => const ProductDetailPage(),
          AppRoutes.cart: (ctx) => const CartPage(),
          AppRoutes.orders: (ctx) => const OrdersPage(),
          AppRoutes.products: (ctx) => const ProductsPage(),
          AppRoutes.productForm: (ctx) => const ProductFormPage(),
        },
        // home: ProdcutsOverviewPage(),
      ),
    );
  }
}
