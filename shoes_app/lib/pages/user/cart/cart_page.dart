import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/pages/widgets/cart_card.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

import '../../../providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    header() {
      return AppBar(
        backgroundColor: backgroundColor3,
        title: const Text('Keranjang'),
        centerTitle: true,
        elevation: 0,
      );
    }

    Widget emptyCart() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon_empty_cart.png',
              width: 80,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Opps! Keranjang kamu kosong',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            Text(
              'Ayo Segera mencari di toko',
              style: secondaryTextStyle,
            ),
            Container(
              width: 154,
              height: 44,
              margin: const EdgeInsets.only(top: 20),
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
                child: Text(
                  'Jelajahi Produk',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget content() {
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        children: cartProvider.cart
            .map((cart) => CartCard(
                  cart: cart,
                ))
            .toList(),
      );
    }

    Widget customButtomNav() {
      return SizedBox(
        height: 180,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: defaultMargin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: primaryTextStyle,
                  ),
                  Text(
                    // '\$${cartProvider.totalPrice()}'
                    CurrencyFormat()
                        .parseNumberCurrencyWithRp(cartProvider.totalPrice()),
                    style: priceTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Divider(
              thickness: 0.3,
              color: subtitleColor,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: defaultMargin),
              height: 50,
              child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/checkout');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Continue to Checkout',
                        style: primaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semiBold,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: primaryTextColor,
                      ),
                    ],
                  )),
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: header(),
      body: cartProvider.cart.isEmpty ? emptyCart() : content(),
      bottomNavigationBar: cartProvider.cart.isEmpty
          ? const SizedBox.shrink()
          : customButtomNav(),
    );
  }
}
