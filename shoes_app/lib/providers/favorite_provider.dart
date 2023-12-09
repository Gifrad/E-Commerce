import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shoes_app/models/product/product_model.dart';

class FavoriteProvider with ChangeNotifier {
  List<ProductModel> _favorite = [];
  List<ProductModel> get favorite => _favorite;

  set favorite(List<ProductModel> favorite) {
    _favorite = favorite;
    notifyListeners();
  }

  void setProduct(ProductModel product) {
    if (!isFavorite(product)) {
      _favorite.add(product);
    } else {
      _favorite.removeWhere((element) => element.id == product.id);
    }
    notifyListeners();
  }

  bool isFavorite(ProductModel product) {
    if (_favorite.indexWhere((element) => element.id == product.id) == -1) {
      return false;
    } else {
      return true;
    }
  }
}
