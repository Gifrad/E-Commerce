import 'package:flutter/material.dart';
import 'package:shoes_app/models/transaction/transaction_model.dart';
import 'package:shoes_app/pages/user/orders/upload_transfer_page.dart';
import 'package:shoes_app/pages/widgets/detail_order.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

class DetailOrderPage extends StatelessWidget {
  final TransactionModel? transaction;
  const DetailOrderPage({this.transaction, super.key});

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        elevation: 0,
        backgroundColor: backgroundColor3,
        centerTitle: true,
        title: const Text('Detail Order'),
      );
    }

    Widget body() {
      return SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 16, bottom: 60),
          child: Column(
            children: transaction!.items!
                .map((items) => DetailOrder(
                      transactionItem: items,
                    ))
                .toList(),
          ),
        ),
      );
    }

    Widget bottom() {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 110,
        decoration: BoxDecoration(
          color: backgroundColor3,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Price',
                    style: primaryTextStyle.copyWith(
                      fontWeight: bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    // '\$${transaction!.totalPrice}.0'
                    CurrencyFormat()
                        .parseNumberCurrencyWithRp(transaction!.totalPrice!),
                    style: priceTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UploadTransferPage(transaction: transaction!, transactionId: transaction!.id!),
                    ),
                  );
                },
                child: const Text('Upload Bukti Transfer'),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: header(),
      body: body(),
      bottomSheet: bottom(),
    );
  }
}
