import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shoes_app/models/transaction/transaction_model.dart';
import 'package:shoes_app/utils/url.dart';

import '../models/cart/cart_model.dart';

class TransactionService {
  String baseUrl = base;

  Future<List<TransactionModel>> allTransactions(
    String token,
  ) async {
    Uri url = Uri.parse('$baseUrl/transactions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
    };
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("respone body transactions : ${response.body}");
      }
      List data = jsonDecode(response.body)['data'];
      List<TransactionModel> transactions = [];
      for (final transaction in data) {
        transactions.add(TransactionModel.fromJson(transaction));
      }
      return transactions;
    } else {
      throw Exception('Fail Get Transactions');
    }
  }

  Future<List<TransactionModel>> transactionByUser(
    String token,
  ) async {
    Uri url = Uri.parse('$baseUrl/transaction');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
    };
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("respone body transaction by user : ${response.body}");
      }
      List data = jsonDecode(response.body)['data'];
      List<TransactionModel> transactions = [];
      for (final transaction in data) {
        transactions.add(TransactionModel.fromJson(transaction));
      }
      return transactions;
    } else {
      throw Exception('Fail Get Transaction By User');
    }
  }

  Future<bool> checkout(
    String token,
    List<CartModel> carts,
    double totalPrice,
    String address,
  ) async {
    Uri url = Uri.parse('$baseUrl/checkout');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
    };
    final body = jsonEncode({
      'address': address,
      'items': carts
          .map(
            (cart) => {
              'id': cart.product?.id,
              'quantity': cart.quantity,
            },
          )
          .toList(),
      'status': "PENDING",
      'total_price': totalPrice,
      'shipping_price': 0,
    });

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (kDebugMode) {
      print(response.body);
    }

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Fail Checkout');
    }
  }

  Future<bool> updateTransaction(String token, String status,int id) async {
    Uri url = Uri.parse('$baseUrl/transactions/$id');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode(
      {
        'status': status,
        '_method': "PATCH",
      },
    );

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Edit Transaction success : ${response.body}');
      }
      return true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed Edit Transaction');
    }
  }
  
  Future<bool> uploadTransfer(int id, File image, String token) async {
    Uri url = Uri.parse('$baseUrl/transactions/$id');
    final header = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    final request = http.MultipartRequest('POST', url);

    request.headers.addAll(header);

    final multipartFile = await http.MultipartFile.fromPath('transfer', image.path);

    request.files.add(multipartFile);

    final response = await request.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      if (kDebugMode) {
        print(res.body);
      }
      return true;
    } else {
      throw Exception('Failed Upload Transfer Service');
    }

  }
}
