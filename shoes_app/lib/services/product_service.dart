import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shoes_app/utils/url.dart';

import '../models/product/product_model.dart';

class ProductService {
  String baseUrl = base;

  Future<List<ProductModel>> getProducts() async {
    Uri url = Uri.parse('$baseUrl/products');
    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (kDebugMode) {
      print(response.body);
    }

    if (response.statusCode == 200) {
      // List data = jsonDecode(response.body)['data']['data'];
      List data = jsonDecode(response.body)['data'];

      List<ProductModel> products = [];

      for (final item in data) {
        products.add(ProductModel.fromJson(item));
      }

      // List<ProductModel> result = data.map((e) => ProductModel.fromJson(e)).toList();
      return products;
    } else {
      throw Exception('Fail Get Product');
    }
  }

  Future<List<ProductModel>> getByCategoryId(int categoryId) async {
    Uri url = Uri.parse('$baseUrl/products?categories_id=$categoryId');
    final headers = {'Content-Type': 'application/json'};

    final response = await http.get(
      url,
      headers: headers,
    );

    if (kDebugMode) {
      print("respony category Id : ${response.body}");
    }

    if (response.statusCode == 200) {
      // List data = jsonDecode(response.body)['data']['data'];
      List data = jsonDecode(response.body)['data'];

      List<ProductModel> products = [];

      for (final item in data) {
        products.add(ProductModel.fromJson(item));
      }
      return products;
    } else {
      throw Exception('Fail Get Product By Category Id');
    }
  }

  Future<List<ProductModel>> getNewProducts(int limit) async {
    Uri url = Uri.parse('$baseUrl/products?limit=$limit');
    final headers = {'Content-Type': 'application/json'};

    final response = await http.get(
      url,
      headers: headers,
    );

    if (kDebugMode) {
      print("respone product limit : ${response.body}");
    }

    if (response.statusCode == 200) {
      // List data = jsonDecode(response.body)['data']['data'];
      List data = jsonDecode(response.body)['data'];
      List<ProductModel> products = [];

      for (final item in data) {
        products.add(ProductModel.fromJson(item));
      }
      return products;
    } else {
      throw Exception('Fail Get Product By Limit');
    }
  }

  Future<bool> addProduct(
    String token,
    String name,
    String description,
    int price,
    int categoriesId,
  ) async {
    Uri url = Uri.parse('$baseUrl/products');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'name': name,
      'description': description,
      'price': price,
      'categories_id': categoriesId,
    });

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Add Product : ${response.body}');
      }
      return true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed Add Product');
    }
  }

  Future<bool> editProduct(String token, String name, String description,
      int price, int categoriesId, int productId) async {
    Uri url = Uri.parse('$baseUrl/products/$productId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode(
      {
        'name': name,
        'description': description,
        'price': price,
        'categories_id': categoriesId,
      },
    );

    final response = await http.patch(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Edit Product : ${response.body}');
      }
      return true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed Edit Product');
    }
  }

  Future<bool> deleteProduct(
    String token,
    int productId,
  ) async {
    Uri url = Uri.parse('$baseUrl/products/$productId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    
    final response = await http.delete(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Delete Category : ${response.body}');
      }
      return true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed Edit Category');
    }
  }
}
