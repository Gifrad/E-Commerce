import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoes_app/models/transaction/transaction_model.dart';
import 'package:shoes_app/pages/admin/transaction/transaction_detail_admin_page.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

class TransactionAdminCard extends StatelessWidget {
  final TransactionModel? transaction;
  const TransactionAdminCard({this.transaction, super.key});

  @override
  Widget build(BuildContext context) {
    final dateTime = Timestamp.fromDate(transaction!.createdAt!).toDate();

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetailAdminPage(
                transaction: transaction,
              ),
            ));
      },
      child: Card(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        elevation: 8,
        color: bgColorAdmin3,
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transaction ID : ${transaction!.id}',
                            style: blackTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: semiBold,
                            ),
                          ),
                          Text(
                            '${transaction!.user!.name}',
                            style: blackTextStyle.copyWith(
                              fontSize: 20,
                              fontWeight: semiBold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    transaction!.status == 'SUCCESS'
                        ? Text(
                            '${transaction!.status}',
                            style: secondaryColorStyle.copyWith(
                              fontWeight: semiBold,
                            ),
                          )
                        : transaction!.status == 'PENDING'
                            ? Text(
                                '${transaction!.status}',
                                style: alertTextStyle.copyWith(
                                  fontWeight: semiBold,
                                ),
                              )
                            : Text(
                                '${transaction!.status}',
                                style: alertTextStyle.copyWith(
                                  color: Colors.amber.shade300,
                                  fontWeight: semiBold,
                                ),
                              ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          DateFormat.yMMMMd().format(dateTime),
                        ),
                        Text(
                          DateFormat.Hm().format(dateTime),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        // '\$${transaction!.totalPrice}'
                        CurrencyFormat().parseNumberCurrencyWithRp(
                            transaction!.totalPrice!),
                        style: priceTextStyle.copyWith(
                          fontWeight: semiBold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
