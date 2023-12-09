import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoes_app/models/transaction/transaction_model.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

import '../user/orders/detail_order_page.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel? transaction;
  const TransactionCard({this.transaction, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailOrderPage(
              transaction: transaction,
            ),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 110,
        margin: EdgeInsets.only(
            left: defaultMargin, right: defaultMargin, bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaction ID : ${transaction!.id}',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                  Text(
                    'Items ${transaction!.items!.length}',
                    style: primaryTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        'Total Price',
                        style: primaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semiBold,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        // '\$${transaction!.totalPrice}'
                        CurrencyFormat().parseNumberCurrencyWithRp(
                            transaction!.totalPrice!),
                        style: priceTextStyle.copyWith(
                          fontWeight: semiBold,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
                right: 16,
              ),
              child: Column(
                children: [
                  Text(
                    "${transaction!.status}",
                    style: transaction!.status == 'SUCCESS'
                        ? secondaryColorStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                          )
                        : transaction!.status == 'PENDING'
                            ? alertTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: semiBold,
                              )
                            : alertTextStyle.copyWith(
                                color: Colors.amber.shade300,
                                fontSize: 16,
                                fontWeight: semiBold,
                              ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    DateFormat.yMMMd().format(transaction!.createdAt!),
                    style: primaryTextStyle.copyWith(
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
