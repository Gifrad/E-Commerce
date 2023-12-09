import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shoes_app/models/category/category_model.dart';
import 'package:http/http.dart' as http;

import '../utils/url.dart';

class CategoryService {
  String baseUrl = base;

  Future<List<CategoryModel>> fetch(String token) async {
    Uri url = Uri.parse('$baseUrl/categories');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (kDebugMode) {
      print('Category List : ${response.body}');
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      List<CategoryModel> categories = [];

      for (final item in data) {
        categories.add(CategoryModel.fromJson(item));
      }

      return categories;
    } else {
      throw Exception('Fail Get Categories');
    }
  }

  Future<bool> addCategory(String token, String name) async {
    Uri url = Uri.parse('$baseUrl/categories');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'name': name,
    });

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Add Category : ${response.body}');
      }
      return true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed Add Category');
    }
  }

  Future<bool> updateCategory(String token, String name, int id) async {
    Uri url = Uri.parse('$baseUrl/categories/$id');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'name': name,
    });

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Update Category : ${response.body}');
      }
      return true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed Update Category');
    }
  }

  Future<bool> deleteCategory(String token, int id) async {
    Uri url = Uri.parse('$baseUrl/categories/$id');
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
      throw Exception('Failed Delete Category');
    }
  }
}
