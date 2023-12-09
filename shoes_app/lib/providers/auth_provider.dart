import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shoes_app/models/auth/user_model.dart';
import 'package:shoes_app/services/auth_service.dart';
import 'package:shoes_app/theme.dart';
import 'package:shoes_app/utils/get_token.dart';

class AuthProvider with ChangeNotifier {
  final authService = AuthService();
  UserModel _user = UserModel();
  // final UserModel _user = UserModel();
  UserModel get user => _user;

  set user(UserModel user) {
    _user = user;
    notifyListeners();
  }

  List<UserModel> _userRoles = [];

  String _searchString = "";

  UnmodifiableListView<UserModel> get userRoles => _searchString.isEmpty
      ? UnmodifiableListView(_userRoles)
      : UnmodifiableListView(_userRoles
          .where((user) => user.name!.toLowerCase().contains(_searchString)));

  void changeSearchString(String searchString) {
    _searchString = searchString;
    notifyListeners();
  }

  set userRoles(List<UserModel> userRoles) {
    _userRoles = userRoles;
    notifyListeners();
  }

  // List<UserModel> _seacrhData = [];
  // List<UserModel> get searchData => _seacrhData;

  // set searchData(List<UserModel> searchData) {
  //   _seacrhData = searchData;
  //   notifyListeners();
  // }

  bool _isTrue = true;
  bool get isTrue => _isTrue;

  get switchObsIcon {
    return _isTrue
        ? Icon(
            Icons.visibility_off,
            color: primaryColor,
          )
        : Icon(
            Icons.visibility,
            color: primaryColor,
          );
  }

  void toggleObs() {
    _isTrue = !_isTrue;
    notifyListeners();
  }

  Future<bool> register(
    String name,
    String username,
    String email,
    String roles,
    String password,
  ) async {
    try {
      bool result = await authService.register(
        name,
        username,
        email,
        roles,
        password,
      );
      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> login(
    String email,
    String password,
  ) async {
    try {
      bool result = await authService
          .login(
        email,
        password,
      )
          .then((value) async {
        final token = await GetToken.getToken();
        await fetch(token!);
        return true;
      });

      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> update(
    String name,
    String username,
    String email,
    String phone,
    String token,
  ) async {
    try {
      bool result = await authService
          .update(
        name,
        username,
        email,
        phone,
        token,
      )
          .then((value) async {
        final token = await GetToken.getToken();
        await fetch(token!);
        return true;
      });

      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
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
    try {
      bool result = await authService
          .updateImage(
        name,
        username,
        email,
        phone,
        token,
        photo,
      )
          .then((value) async {
        final token = await GetToken.getToken();
        await fetch(token!);
        return true;
      });

      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> logout(String token) async {
    try {
      if (await authService.logout(token)) {
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

  Future<UserModel> fetch(String token) async {
    try {
      UserModel result = await authService.fetch(token);
      _user = result;
      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('Gagal Mendapatkan data');
    }
  }

  Future<bool> getRolesUser(String token) async {
    try {
      final result = await authService.getRolesUser(token);
      _userRoles = result;
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('Gagal Mendapatkan data');
    }
  }

  Future<bool> delete(int userId, String token) async {
    try {
      final result = await authService.delete(userId, token);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final result = await authService.forgotPassword(email);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}
