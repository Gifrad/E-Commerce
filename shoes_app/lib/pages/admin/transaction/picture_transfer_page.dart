import 'package:flutter/material.dart';
import 'package:shoes_app/models/transaction/transaction_model.dart';

class PictureTransfer extends StatelessWidget {
  final TransactionModel transaction;
  const PictureTransfer({required this.transaction, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,

      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              offset: Offset(2, 2),
            )
          ],
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(transaction.transfer!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
