import 'package:flutter/foundation.dart';
import 'package:shoes_app/models/category/category_model.dart';
import 'package:shoes_app/services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryService categoryService = CategoryService();
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  set categories(List<CategoryModel> categories) {
    _categories = categories;
    notifyListeners();
  }

  Future<void> fetchCategories(String token) async {
    try {
      final result = await categoryService.fetch(token);
      _categories = result;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<bool> addCategory(String token, String name) async {
    try {
      final result = await categoryService.addCategory(token, name).then(
        (value) async {
          await fetchCategories(token);
          return true;
        },
      );
      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> updateCategory(String token, String name, int id) async {
    try {
      final result = await categoryService.updateCategory(token, name, id).then(
        (value) async {
          await fetchCategories(token);
          return true;
        },
      );
      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> deleteCategory(String token, int id) async {
    try {
      final result = await categoryService.deleteCategory(token, id).then(
        (value) async {
          await fetchCategories(token);
          return true;
        },
      );
      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}
