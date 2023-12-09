import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/providers/auth_provider.dart';
import 'package:shoes_app/providers/category_provider.dart';
import 'package:shoes_app/providers/product_provider.dart';
import 'package:shoes_app/providers/transaction_provider.dart';
import 'package:shoes_app/theme.dart';

import '../../../models/message/message_model.dart';
import '../../../services/message_service.dart';
import '../../../utils/get_token.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  @override
  void initState() {
    getCategory();
    getTransactions();
    getProduct();
    getRolesUser();
    super.initState();
  }

  void getCategory() async {
    CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final token = await GetToken.getToken();
    await categoryProvider.fetchCategories(token!);
  }

  void getProduct() async {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    await productProvider.getProducts();
  }

  void getTransactions() async {
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    final token = await GetToken.getToken();
    await transactionProvider.allTransactions(token!);
  }

  void getRolesUser() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final token = await GetToken.getToken();
    await authProvider.getRolesUser(token!);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    Widget drawerTile(String text, String image, String route) {
      return ListTile(
        minLeadingWidth: 0,
        title: Text(
          text,
          style: thridColorStyle.copyWith(
            fontWeight: bold,
          ),
        ),
        leading: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
            ),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      );
    }

    Widget drawer() {
      return Drawer(
        width: MediaQuery.of(context).size.width * 0.5,
        backgroundColor: bgColorAdmin3,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(color: bgColorAdmin1),
                width: MediaQuery.of(context).size.width,
                height: 135,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'SHOES STORE',
                      style: primaryTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: semiBold,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      authProvider.user.name!,
                      style: primaryTextStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      authProvider.user.email!,
                      style: primaryTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  children: [
                    drawerTile('Products', 'assets/icon_product.png',
                        '/product-admin'),
                    drawerTile(
                        'Categories', 'assets/icon_category.png', '/category'),
                    drawerTile('Transactions', 'assets/icon_transaction.png',
                        '/transaction-admin'),
                    drawerTile('Costumers', 'assets/icon_customer.png',
                        '/customers-admin'),
                    drawerTile('Response', 'assets/icon_response.png',
                        '/message-admin'),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ListTile(
                          onTap: () async {
                            AuthProvider authProvider =
                                Provider.of<AuthProvider>(context,
                                    listen: false);
                            final token = await GetToken.getToken();
                            if (await authProvider.logout(token!)) {
                              if (mounted) {}
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/sign-in', (route) => false);
                            } else {
                              if (mounted) {}
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: alertColor,
                                  content: const Text(
                                    'Logout Failed!',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                          },
                          title: Text(
                            'LOGOUT',
                            style: thridColorStyle.copyWith(
                              fontSize: 16,
                              fontWeight: semiBold,
                            ),
                          ),
                          trailing: Icon(
                            Icons.logout_outlined,
                            color: alertColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    PreferredSizeWidget header() {
      return AppBar(
        title: const Text('Shoes Store'),
        backgroundColor: bgColorAdmin1,
      );
    }

    Widget homeCard(String image, String name, String length, String route) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Container(
          height: 129,
          decoration: BoxDecoration(
            color: bgColorAdmin2,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 16,
                  bottom: 16,
                ),
                child: Image.asset(
                  image,
                  color: primaryTextColor,
                  width: 100,
                  height: 100,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 60,
                  top: 16,
                  bottom: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: primaryTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: semiBold,
                      ),
                    ),
                    Text(
                      length,
                      style: primaryTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: semiBold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget body() {
      return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: defaultMargin,
            vertical: 16,
          ),
          child: Center(
            child: Column(
              children: [
                Consumer<ProductProvider>(
                  builder: (context, value, child) => homeCard(
                      'assets/icon_product.png',
                      'PRODUCTS',
                      '${value.products.length}',
                      '/product-admin'),
                ),
                const SizedBox(
                  height: 16,
                ),
                Consumer<CategoryProvider>(
                  builder: (context, value, child) {
                    return homeCard(
                      'assets/icon_category.png',
                      'CATEGORIES',
                      '${value.categories.length}',
                      '/category',
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Consumer<TransactionProvider>(
                  builder: (context, value, child) => homeCard(
                    'assets/icon_transaction.png',
                    'TRANSACTIONS',
                    '${value.allTransaction.length}',
                    '/transaction-admin',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Consumer<AuthProvider>(
                    builder: (context, value, child) => homeCard(
                        'assets/icon_customer.png',
                        'CUSTOMERS',
                        '${value.userRoles.length}',
                        '/customers-admin')),
                StreamBuilder<List<MessageModel>>(
                  stream: MesssageService().getAllMessages(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return homeCard('assets/icon_response.png', 'RESPONSE',
                          '0', '/message-admin');
                    } else {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        width: double.infinity,
                        color: bgColorAdmin3,
                        child: homeCard('assets/icon_response.png', 'RESPONSE',
                            '${snapshot.data!.length}', '/message-admin'),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColorAdmin3,
      drawer: drawer(),
      appBar: header(),
      body: body(),
    );
  }
}
