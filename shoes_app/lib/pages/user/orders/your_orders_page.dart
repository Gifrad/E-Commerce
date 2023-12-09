import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/pages/widgets/transaction_card.dart';
import 'package:shoes_app/theme.dart';

import '../../../providers/transaction_provider.dart';

class YourOrdersPage extends StatefulWidget {
  const YourOrdersPage({super.key});

  @override
  State<YourOrdersPage> createState() => _YourOrdersPageState();
}

class _YourOrdersPageState extends State<YourOrdersPage> {
  @override
  Widget build(BuildContext context) {
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context);
    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: backgroundColor3,
        elevation: 0,
        centerTitle: true,
        title: const Text('Your Orders'),
      );
    }

    Widget body() {
      return SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            top: 16,
          ),
          child: Column(
            children: transactionProvider.transactions
                .map((transaction) => TransactionCard(
                      transaction: transaction,
                    ))
                .toList(),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: header(),
      body: transactionProvider.transactions.isEmpty
          ? Center(
              child: Text(
                'Not Found....',
                style: secondaryTextStyle.copyWith(
                  fontSize: 24,
                  fontWeight: bold,
                ),
              ),
            )
          : body(),
    );
  }
}
