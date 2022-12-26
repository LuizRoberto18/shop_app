import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import 'auth_page.dart';
import 'products_overview_page.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return auth.isAuth ? const ProductsOverviewPage() : const AuthPage();
  }
}
