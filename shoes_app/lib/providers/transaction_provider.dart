import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shoes_app/models/transaction/transaction_model.dart';
import 'package:shoes_app/services/transaction_service.dart';

import '../models/cart/cart_model.dart';

class TransactionProvider with ChangeNotifier {
  TransactionService transactionService = TransactionService();
  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;
  set transactions(List<TransactionModel> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  List<TransactionModel> _allTransaction = [];
  List<TransactionModel> get allTransaction => _allTransaction;
  set allTransaction(List<TransactionModel> allTransaction) {
    _allTransaction = allTransaction;
    notifyListeners();
  }

  Future<void> allTransactions(String token) async {
    try {
      final result = await transactionService.allTransactions(token);
      _allTransaction = result;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> transactionByUser(String token) async {
    try {
      final result = await transactionService.transactionByUser(token);
      _transactions = result;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<bool> checkout(
    String token,
    List<CartModel> carts,
    double totalPrice,
    String address,
  ) async {
    try {
      if (await transactionService.checkout(
          token, carts, totalPrice, address)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> updateTransaction(
    String token,
    String status,
    int id,
  ) async {
    try {
      final result =
          await transactionService.updateTransaction(token, status, id);
      reloadTransaction(token);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<void> reloadTransaction(String token) async {
    final result = await transactionService.allTransactions(token);
    _allTransaction = result;
    notifyListeners();
  }

  Future<bool> uploadTransfer(int id, File image, String token) async {
    try {
      final result = await transactionService.uploadTransfer(id, image, token);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}
