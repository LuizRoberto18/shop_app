import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/utils/app_routes.dart';

import '../models/product.dart';
import '../models/product_list.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.productForm,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: const Text("Excluir produto"),
                      content: const Text("tem certeza"),
                      actions: [
                        TextButton(
                          child: const Text("Não"),
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                        ),
                        TextButton(
                          child: const Text("Sim"),
                          onPressed: () {
                            Provider.of<ProductList>(context, listen: false).removeProduct(product);
                            Navigator.of(ctx).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
