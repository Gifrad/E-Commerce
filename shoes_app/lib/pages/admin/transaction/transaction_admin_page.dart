import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/models/transaction/transaction_model.dart';
import 'package:shoes_app/pages/widgets/transaction_admin_card.dart';
import 'package:shoes_app/providers/transaction_provider.dart';
import 'package:shoes_app/theme.dart';

class TransactionAdminPage extends StatelessWidget {
  const TransactionAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    PreferredSizeWidget header() {
      return AppBar(
        title: const Text('Transactions'),
        centerTitle: true,
        backgroundColor: bgColorAdmin1,
        bottom: TabBar(tabs: [
          Tab(
            child: Text(
              'PENDING',
              style: TextStyle(color: alertColor),
            ),
          ),
          Tab(
            child: Text(
              'SHIPPING',
              style: TextStyle(color: Colors.amber.shade300),
            ),
          ),
          Tab(
            child: Text(
              'SUCCESS',
              style: TextStyle(color: secondaryColor),
            ),
          ),
        ]),
      );
    }

    Widget body(String status) {
      return Consumer<TransactionProvider>(
        builder: (context, value, child) {
          Iterable<TransactionModel> pending = value.allTransaction
              .where((transaction) => transaction.status!.contains(status));
          return status == 'SHIPPING' && pending.isEmpty
              ? Center(
                  child: Text(
                    'NOT FOUND...',
                    style: blackTextStyle.copyWith(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : status == 'SUCCESS' && pending.isEmpty
                  ? Center(
                      child: Text(
                        'NOT FOUND...',
                        style: blackTextStyle.copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : status == 'PENDING' && pending.isEmpty
                      ? Center(
                          child: Text(
                            'NOT FOUND...',
                            style: blackTextStyle.copyWith(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: defaultMargin,
                          ),
                          child: ListView(
                            children: pending.map(
                              (transaction) {
                                return TransactionAdminCard(
                                  transaction: transaction,
                                );
                              },
                            ).toList(),
                          ),
                        );
        },
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: bgColorAdmin3,
        appBar: header(),
        body: transactionProvider.allTransaction.isEmpty
            ? Center(
                child: Text(
                'NOT FOUND...',
                style: blackTextStyle.copyWith(
                  fontSize: 22,
                  fontWeight: bold,
                ),
              ))
            : TabBarView(
                children: [
                  body('PENDING'),
                  body('SHIPPING'),
                  body('SUCCESS'),
                ],
              ),
      ),
    );
  }
}
