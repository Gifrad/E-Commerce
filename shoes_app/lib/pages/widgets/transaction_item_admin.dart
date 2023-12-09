import 'package:flutter/material.dart';
import 'package:shoes_app/models/transaction/transaction_item_model.dart';
import 'package:shoes_app/models/transaction/transaction_model.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/parse_number_currency.dart';

class TransactionItemAdmin extends StatelessWidget {
  final TransactionModel? transaction;
  final TransactionItemModel? transactionItem;
  const TransactionItemAdmin(
      {this.transactionItem, this.transaction, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: bgColorAdmin2, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250,
                  child: Text(
                    '${transactionItem!.product!.name}',
                    style: primaryTextStyle.copyWith(
                      fontWeight: semiBold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${transactionItem!.product!.category!.name}',
                  style: primaryTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: light,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '(${transactionItem!.quantity})',
                style: primaryTextStyle.copyWith(fontWeight: medium),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: backgroundColor6,
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  // '\$${transactionItem!.product!.price}'
                  CurrencyFormat().parseNumberCurrencyWithRp(
                      transactionItem!.product!.price!),
                  style: priceTextStyle,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
