import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/pages/admin/auth/sign_up_admin_page.dart';
import 'package:shoes_app/pages/admin/category/add_category_page.dart';
import 'package:shoes_app/pages/admin/category/category_page.dart';
import 'package:shoes_app/pages/admin/customer/customer_admin_page.dart';
import 'package:shoes_app/pages/admin/home/home_admin_page.dart';
import 'package:shoes_app/pages/admin/message/message_admin_page.dart';
import 'package:shoes_app/pages/admin/product/add_product_admin_page.dart';
import 'package:shoes_app/pages/admin/product/product_admin_page.dart';
import 'package:shoes_app/pages/admin/transaction/transaction_admin_page.dart';
import 'package:shoes_app/pages/main_page.dart';
import 'package:shoes_app/pages/user/auth/sign_in_page.dart';
import 'package:shoes_app/pages/user/auth/sign_up_page.dart';
import 'package:shoes_app/pages/user/cart/cart_page.dart';
import 'package:shoes_app/pages/user/checkout/checkout_page.dart';
import 'package:shoes_app/pages/user/checkout/checkout_success_page.dart';
import 'package:shoes_app/pages/user/orders/your_orders_page.dart';
import 'package:shoes_app/pages/user/profile/edit_profile_page.dart';
import 'package:shoes_app/pages/user/splash/splash_page.dart';
import 'package:shoes_app/providers/auth_provider.dart';
import 'package:shoes_app/providers/cart_provider.dart';
import 'package:shoes_app/providers/category_provider.dart';
import 'package:shoes_app/providers/favorite_provider.dart';
import 'package:shoes_app/providers/gallery_provider.dart';
import 'package:shoes_app/providers/page_provider.dart';
import 'package:shoes_app/providers/product_provider.dart';
import 'package:shoes_app/providers/transaction_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => ProductProvider()),
    ChangeNotifierProvider(create: (context) => FavoriteProvider()),
    ChangeNotifierProvider(create: (context) => CartProvider()),
    ChangeNotifierProvider(create: (context) => TransactionProvider()),
    ChangeNotifierProvider(create: (context) => PageProvider()),
    ChangeNotifierProvider(create: (context) => CategoryProvider()),
    ChangeNotifierProvider(create: (context) => GalleryProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        //User
        '/': (context) => const SplashPage(),
        '/sign-in': (context) => const SignInPage(),
        '/sign-up': (context) => const SignUpPage(),
        '/home': (context) => const MainPage(),
        '/edit-profile': (context) => const EditProfilePage(),
        '/cart': (context) => const CartPage(),
        '/checkout': (context) => const CheckoutPage(),
        '/checkout-success': (context) => const CheckoutSuccessPage(),
        '/your-orders': (context) => const YourOrdersPage(),

        //Admin
        '/home-admin': (context) => const HomeAdminPage(),
        '/sign-up-admin': (context) => const SignUpAdminPage(),
        '/category': (context) => const CategoryPage(),
        '/add-category': (context) => const AddCategoryPage(),
        '/product-admin': (context) => const ProductAdminPage(),
        '/add-product-admin': (context) => const AddProductAdminPage(),
        '/transaction-admin': (context) => const TransactionAdminPage(),
        '/customers-admin': (context) => const CustomerAdminPage(),
        '/message-admin': (context) => const MessageAdminPage(),
      },
    );
  }
}
