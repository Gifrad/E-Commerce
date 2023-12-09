import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/theme.dart';

import '../../../providers/transaction_provider.dart';
import '../../../utils/get_token.dart';

class CheckoutSuccessPage extends StatefulWidget {
  const CheckoutSuccessPage({super.key});

  @override
  State<CheckoutSuccessPage> createState() => _CheckoutSuccessPageState();
}

class _CheckoutSuccessPageState extends State<CheckoutSuccessPage> {
  @override
  void initState() {
    getTransaction();
    super.initState();
  }

  void getTransaction() async {
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    final token = await GetToken.getToken();
    await transactionProvider.transactionByUser(token!);
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor3,
        title: const Text('Checkout Success'),
      );
    }

    Widget content() {
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
              'Kamu telah melakukan transaksi',
              style: primaryTextStyle.copyWith(
                fontWeight: medium,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Tetap dirumah kami akan\nmempersiapkan produk idamanmu',
              style: secondaryTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '"Silahkan Melakukan Pembayaran \n pada Halaman History Pesanan Anda!"',
              textAlign: TextAlign.center,
              style: primaryTextStyle.copyWith(
                fontWeight: medium,
                fontSize: 14,
              ),
            ),
            Container(
              width: 196,
              height: 44,
              margin: EdgeInsets.only(
                top: defaultMargin,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
                child: Text(
                  'Pesan Produk Lain',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                ),
              ),
            ),
            Container(
              width: 196,
              height: 44,
              margin: const EdgeInsets.only(
                top: 12,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff39374B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/your-orders');
                },
                child: Text(
                  'Lihat Pesanan Saya',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                    color: const Color(0xffB7B6BF),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: header(),
      body: content(),
    );
  }
}
