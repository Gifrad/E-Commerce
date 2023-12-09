import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/pages/user/chat/chat_page.dart';
import 'package:shoes_app/pages/user/favorite/favorite_page.dart';
import 'package:shoes_app/pages/user/home/home_page.dart';
import 'package:shoes_app/pages/user/profile/profile_page.dart';
import 'package:shoes_app/providers/page_provider.dart';
import 'package:shoes_app/theme.dart';

import '../providers/product_provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/get_token.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    getCategoryProduct(1);
    getCategoryProduct(2);
    getCategoryProduct(3);
    getCategoryProduct(4);
    // getCategoryProduct(5);
    getTransaction();
    getNewProduct();
    super.initState();
  }

  getCategoryProduct(int categoryId) async {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    await productProvider.getProductsByCategoryId(categoryId);
  }

  getNewProduct() async {
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    await productProvider.getNewProduct(5);
  }

  getTransaction() async {
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    final token = await GetToken.getToken();
    await transactionProvider.transactionByUser(token!);
  }

  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider = Provider.of<PageProvider>(context);

    Widget cartButton() {
      return FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
        child: Image.asset(
          'assets/icon_cart.png',
          fit: BoxFit.contain,
        ),
      );
    }

    Widget customeButtonNav() {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 12,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: BottomNavigationBar(
            backgroundColor: textFieldBg,
            type: BottomNavigationBarType.fixed,
            currentIndex: pageProvider.currentIndex,
            onTap: (value) {
              pageProvider.currentIndex = value;
            },
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                  ),
                  child: Image.asset(
                    'assets/icon_home.png',
                    width: 21,
                    color: pageProvider.currentIndex == 0
                        ? primaryColor
                        : offButtomNavBar,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                    right: 20,
                  ),
                  child: Image.asset(
                    'assets/icon_chat.png',
                    width: 20,
                    color: pageProvider.currentIndex == 1
                        ? primaryColor
                        : offButtomNavBar,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                    left: 20,
                  ),
                  child: Image.asset(
                    'assets/icon_favorite.png',
                    width: 20,
                    color: pageProvider.currentIndex == 2
                        ? primaryColor
                        : offButtomNavBar,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                  ),
                  child: Image.asset(
                    'assets/icon_profile.png',
                    width: 18,
                    color: pageProvider.currentIndex == 3
                        ? primaryColor
                        : offButtomNavBar,
                  ),
                ),
                label: '',
              ),
            ],
          ),
        ),
      );
    }

    Widget body() {
      switch (pageProvider.currentIndex) {
        case 0:
          return const HomePage();
        case 1:
          return const ChatPage();
        case 2:
          return const FavoritePage();
        case 3:
          return const ProfilePage();
        default:
          return const HomePage();
      }
    }

    return Scaffold(
      backgroundColor:
          pageProvider.currentIndex == 0 ? backgroundColor1 : backgroundColor3,
      floatingActionButton: cartButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: customeButtonNav(),
      body: body(),
    );
  }
}
