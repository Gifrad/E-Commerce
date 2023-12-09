import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/pages/widgets/checkout_card.dart';
import 'package:shoes_app/pages/widgets/loading_button.dart';
import 'package:shoes_app/providers/cart_provider.dart';
import 'package:shoes_app/providers/transaction_provider.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/get_token.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController addressController = TextEditingController();
  bool isLoading = false;
  String address = '';

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context);

    void handleCheckout() async {
      final token = await GetToken.getToken();
      setState(() {
        isLoading = true;
      });
      if (address == '') {
        if (mounted) {}
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: alertColor,
            content: const Text(
              'Add Your Address',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        final result = await transactionProvider.checkout(
          token!,
          cartProvider.cart,
          cartProvider.totalPrice(),
          address,
        );

        if (result) {
          if (mounted) {}
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: secondaryColor,
              content: const Text(
                'Success Checkout',
                textAlign: TextAlign.center,
              ),
            ),
          );
          cartProvider.cart = [];
          if (mounted) {}
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/checkout-success',
            (route) => false,
          );
        } else {
          if (mounted) {}
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: alertColor,
              content: const Text(
                'Failed Checkout',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      }
      setState(() {
        isLoading = false;
      });
    }

    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: backgroundColor3,
        elevation: 0,
        centerTitle: true,
        title: const Text('Checkout Details'),
      );
    }

    Widget content() {
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        children: [
          // NOTE : LIST ITEMS
          // const SizedBox(
          //   height: 30,
          // ),
          Container(
            margin: EdgeInsets.only(top: defaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'List Items',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                ),
                Column(
                  children: cartProvider.cart
                      .map((cart) => CheckoutCard(
                            cart: cart,
                          ))
                      .toList(),
                )
              ],
            ),
          ),

          //NOTE : ADDRESS DETAILS
          Container(
            margin: EdgeInsets.only(top: defaultMargin),
            padding: const EdgeInsets.only(top: 20,bottom: 20),
            decoration: BoxDecoration(
              color: backgroundColor4,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Address Details',
                    style: primaryTextStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/icon_store_location.png',
                            width: 40,
                          ),
                          Image.asset(
                            'assets/icon_line.png',
                            height: 30,
                          ),
                          Image.asset(
                            'assets/icon_your_address.png',
                            width: 40,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lokasi Toko',
                            style: secondaryTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: light,
                            ),
                          ),
                          Text(
                            'Sparrow Leather Works Jakarta',
                            style: primaryTextStyle.copyWith(
                              fontWeight: medium,
                            ),
                          ),
                          SizedBox(
                            height: defaultMargin,
                          ),
                          Row(
                            children: [
                              Text(
                                'Alamat Kamu',
                                style: secondaryTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: light,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: backgroundColor4,
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Add your address',
                                              style: primaryTextStyle,
                                            ),
                                            TextFormField(
                                              controller: addressController,
                                              style: primaryTextStyle,
                                              cursorColor: backgroundColor1,
                                              decoration: InputDecoration(
                                                  focusColor: primaryTextColor),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      secondaryColor),
                                              onPressed: () {
                                                setState(() {
                                                  address =
                                                      addressController.text;
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Accept'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.change_circle_outlined,
                                  color: primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 260,
                            child: Text(
                              address == '' ? 'Tambahkan Alamat' : address,
                              style: address == ''
                                  ? alertTextStyle
                                  : primaryTextStyle.copyWith(
                                      fontWeight: medium,
                                    ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          //NOTE : PAYMENT SUMMARY
          Container(
            margin: EdgeInsets.only(top: defaultMargin),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: backgroundColor4,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Summary',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Jumlah Produk',
                      style: secondaryTextStyle.copyWith(fontSize: 12),
                    ),
                    Text(
                      '${cartProvider.totalItem()} Items',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Jumlah Harga',
                      style: secondaryTextStyle.copyWith(fontSize: 12),
                    ),
                    Text(
                      // '\$${cartProvider.totalPrice()}'
                      CurrencyFormat()
                          .parseNumberCurrencyWithRp(cartProvider.totalPrice()),
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Penigiriman',
                      style: secondaryTextStyle.copyWith(fontSize: 12),
                    ),
                    Text(
                      'Gratis',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                const Divider(
                  thickness: 1,
                  color: Color(0xff2E3141),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: priceTextStyle.copyWith(
                          fontSize: 14, fontWeight: semiBold),
                    ),
                    Text(
                      // '\$${cartProvider.totalPrice()}'
                      CurrencyFormat()
                          .parseNumberCurrencyWithRp(cartProvider.totalPrice()),
                      style: priceTextStyle.copyWith(
                        fontWeight: semiBold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //NOTE : CHECKOUT BUTTON
          SizedBox(
            height: defaultMargin,
          ),
          const Divider(
            thickness: 1,
            color: Color(0xff2E3141),
          ),
          isLoading
              ? Container(
                  margin: EdgeInsets.only(bottom: defaultMargin),
                  child: const LoadingButton())
              : Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.symmetric(
                    vertical: defaultMargin,
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: handleCheckout,
                      child: Text(
                        'Checkout Now',
                        style: primaryTextStyle.copyWith(
                          fontWeight: semiBold,
                          fontSize: 16,
                        ),
                      )),
                ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: header(),
      body: content(),
    );
  }
}
