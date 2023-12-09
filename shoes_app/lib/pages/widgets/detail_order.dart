import 'package:flutter/material.dart';
import 'package:shoes_app/models/transaction/transaction_item_model.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

class DetailOrder extends StatelessWidget {
  final TransactionItemModel? transactionItem;
  const DetailOrder({this.transactionItem, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 124,
      margin: EdgeInsets.only(
        left: defaultMargin,
        right: defaultMargin,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${transactionItem!.product!.name}',
              style: primaryTextStyle.copyWith(
                fontSize: 18,
                fontWeight: bold,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  'Price',
                  style: primaryTextStyle,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  // '\$${transactionItem!.product!.price}'
                  CurrencyFormat().parseNumberCurrencyWithRp(
                      transactionItem!.product!.price!),
                  style: priceTextStyle,
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              'Quantity ${transactionItem!.quantity}',
              style: primaryTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
