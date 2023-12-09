import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoes_app/providers/auth_provider.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/get_roles.dart';

import '../../../providers/category_provider.dart';
import '../../../providers/product_provider.dart';
import '../../../utils/get_token.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    getInit();
    super.initState();
  }

  void getInit() async {
    Timer(const Duration(seconds: 3), () {
      checkToken();
      getInitlogin();
    });
  }

  Future<void> getInitlogin() async {
    final product = Provider.of<ProductProvider>(context, listen: false);
    await product.getProducts();
    await product.getNewProduct(5);
  }

  void checkToken() async {
    final user = Provider.of<AuthProvider>(context, listen: false);
    final helper = await SharedPreferences.getInstance();
    final token = helper.getString('token');
    final roles = await GetRoles.getRoles();
    if (token != null && roles == 'USER') {
      getCategory();
      await user.fetch(token);
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } else if (token != null && roles == 'ADMIN') {
      getCategory();
      await user.fetch(token);
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/home-admin', (route) => false);
      }
    } else {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/sign-in',
          (route) => false,
        );
      }
    }
  }

  void getCategory() async {
    CategoryProvider categoryProvider = Provider.of(context, listen: false);
    final token = await GetToken.getToken();
    await categoryProvider.fetchCategories(token!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor1,
      body: Center(
        child: Container(
          width: 225,
          height: 225,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: backgroundColor1),
              left: BorderSide(color: backgroundColor1),
              right: BorderSide(color: backgroundColor1),
              top: BorderSide(
                color: backgroundColor1,
              ),
            ),
            image: const DecorationImage(
              image: AssetImage('assets/image_splash.png'),
            ),
          ),
        ),
      ),
    );
  }
}
