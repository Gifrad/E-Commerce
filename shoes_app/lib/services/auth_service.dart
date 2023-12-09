import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoes_app/models/auth/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shoes_app/utils/url.dart';

class AuthService {
  String baseUrl = base;

  Future<bool> register(
    String name,
    String username,
    String email,
    String roles,
    String password,
  ) async {
    Uri url = Uri.parse('$baseUrl/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': name,
      'username': username,
      'roles': roles,
      'email': email,
      'password': password,
    });
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];

      if (kDebugMode) {
        print(data);
      }
      return true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed Register');
    }
  }

  Future<bool> login(
    String email,
    String password,
  ) async {
    Uri url = Uri.parse('$baseUrl/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': email,
      'password': password,
    });
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];

      if (kDebugMode) {
        print(data);
      }
      final String token = data['access_token'];
      final String roles = jsonDecode(response.body)['data']['user']['roles'];
      final helper = await SharedPreferences.getInstance();
      await helper.setString('token', token);
      await helper.setString('roles', roles);
      if (kDebugMode) {
        print('token Login : $token');
        print('roles Login : $roles');
      }
      return true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed Login');
    }
  }

  Future<bool> update(
    String name,
    String username,
    String email,
    String phone,
    String token,
  ) async {
    Uri url = Uri.parse('$baseUrl/user');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
    });
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      if (kDebugMode) {
        print(data);
      }
      return true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed Updated');
    }
  }

  Future<bool> updateImage(
    String name,
    String username,
    String email,
    String phone,
    String token,
    File? photo,
  ) async {
    Uri url = Uri.parse('$baseUrl/user');
    final header = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    final request = http.MultipartRequest('POST', url);

    request.fields['name'] = name;
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['phone'] = phone;
    request.headers.addAll(header);

    final multipartFile =
        await http.MultipartFile.fromPath('photo', photo!.path);

    request.files.add(multipartFile);

    final response = await request.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      if (kDebugMode) {
        print(res.body);
      }
      return true;
    } else {
      throw Exception('Failed Add Photo');
    }

    // Uri url = Uri.parse('$baseUrl/user');
    // final headers = {
    //   'Content-Type': 'application/json',
    //   'Authorization': 'Bearer $token',
    // };
    // final body = jsonEncode({
    //   'name': name,
    //   'username': username,
    //   'email': email,
    //   'phone' : phone,
    // });
    // final response = await http.post(
    //   url,
    //   headers: headers,
    //   body: body,
    // );

    // if (response.statusCode == 200) {
    //   final data = jsonDecode(response.body)['data'];
    //   if (kDebugMode) {
    //     print(data);
    //   }
    //   return true;
    // } else {
    //   if (kDebugMode) {
    //     print(response.body);
    //   }
    //   throw Exception('Failed Updated');
    // }
  }

  Future<bool> logout(String token) async {
    Uri url = Uri.parse('$baseUrl/logout');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
    };
    final response = await http.post(url, headers: headers);
    if (response.statusCode == 200) {
      final helper = await SharedPreferences.getInstance();
      await helper.remove('token');
      await helper.remove('roles');
      if (kDebugMode) {
        print(response.body);
      }
      return true;
    } else {
      throw Exception('Gagal Logout');
    }
  }

  Future<UserModel> fetch(String token) async {
    Uri url = Uri.parse('$baseUrl/user');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data);
      // user.token = 'Bearer $token';
      if (kDebugMode) {
        print(data);
      }
      return user;
    } else {
      throw Exception('Failed Get Data User');
    }
  }

  Future<List<UserModel>> getRolesUser(String token) async {
    Uri url = Uri.parse('$baseUrl/users?roles=USER');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      List<UserModel> result = [];
      if (kDebugMode) {
        print(data);
      }
      // result = data
      //     .map<List<UserModel>>((data) => UserModel.fromJson(data))
      //     .toList();
      for (final item in data) {
        result.add(UserModel.fromJson(item));
      }
      return result;
    } else {
      throw Exception('Failed Get Data User');
    }
  }

  Future<bool> delete(int userId, String token) async {
    Uri url = Uri.parse('$baseUrl/user/$userId');
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
        print('Success Delete User: ${response.body}');
      }
      return true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed Delete User');
    }
  }

  Future<bool> forgotPassword(String email) async {
    Uri url = Uri.parse('$baseUrl/forgot-password');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': email,
    });
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = (response.body);

      if (kDebugMode) {
        print(data);
      }
      return true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception('Failed Register');
    }
  }
}
