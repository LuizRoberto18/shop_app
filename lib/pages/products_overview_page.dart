import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/utils/app_routes.dart';

import '../components/app_drawer.dart';
import '../components/badge.dart';
import '../components/product_grid.dart';
import '../models/cart.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProdcutsOverviewPage extends StatefulWidget {
  ProdcutsOverviewPage({Key? key}) : super(key: key);

  @override
  State<ProdcutsOverviewPage> createState() => _ProdcutsOverviewPageState();
}

class _ProdcutsOverviewPageState extends State<ProdcutsOverviewPage> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minha Loja"),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.Favorite,
                child: Text("Somente favoritos"),
              ),
              const PopupMenuItem(
                value: FilterOptions.All,
                child: Text("Todos"),
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
                print(_showFavoriteOnly);
              });
            },
          ),
          Consumer<Cart>(
            builder: (ctx, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.cart);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: ProductGrid(_showFavoriteOnly),
      drawer: const AppDrawer(),
    );
  }
}
