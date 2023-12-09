import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:shoes_app/models/product/product_model.dart';
import 'package:shoes_app/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  ProductService productService = ProductService();

  ///SQUENTIAL SEARCH
  List<ProductModel> _products = [];
  String _searchValue = '';
  List<ProductModel> get squentialSearchAllProduct {
    if (_searchValue.isEmpty) {
      return UnmodifiableListView(_products);
    } else {
      return UnmodifiableListView(
        _products.where(
          (product) => product.name!.toLowerCase().contains(_searchValue),
        ),
      );
    }
  }

  void implSquentialSearch(String searchValue) {
    _searchValue = searchValue;
    notifyListeners();
  }

  List<ProductModel> get products => _products;
  List<ProductModel> _productsSepatu = [];
  List<ProductModel> get productsSepatu => _productsSepatu;
  List<ProductModel> _productSendal = [];
  List<ProductModel> get productSendal => _productSendal;
  List<ProductModel> _productsJaket = [];
  List<ProductModel> get productsJaket => _productsJaket;
  List<ProductModel> _productsTas = [];
  List<ProductModel> get productsTas => _productsTas;
  // List<ProductModel> _productsRunning = [];
  // List<ProductModel> get productsRunning => _productsRunning;
  List<ProductModel> _productsLimit = [];
  List<ProductModel> get productsLimit => _productsLimit;

  set products(List<ProductModel> products) {
    _products = products;
    notifyListeners();
  }

  set productsSepatu(List<ProductModel> productsSepatu) {
    _productsSepatu = productsSepatu;
    notifyListeners();
  }

  set productsSendal(List<ProductModel> productsSendal) {
    _productSendal = productsSendal;
    notifyListeners();
  }

  set productsJaket(List<ProductModel> productsJaket) {
    _productsJaket = productsJaket;
    notifyListeners();
  }

  set productsTraning(List<ProductModel> productsTraning) {
    _productsTas = productsTraning;
    notifyListeners();
  }

  // set productsRunning(List<ProductModel> productsRunning) {
  //   _productsRunning = productsRunning;
  //   notifyListeners();
  // }

  set productsLimit(List<ProductModel> productsLimit) {
    _productsLimit = productsLimit;
    notifyListeners();
  }

  Future<void> reloadProduct() async {
    try {
      final products = await productService.getProducts();
      _products = products;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> getProducts() async {
    try {
      final products = await productService.getProducts();
      _products = products;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> getProductsByCategoryId(int categoryId) async {
    try {
      List<ProductModel> products =
          await productService.getByCategoryId(categoryId);
      if (categoryId == 1) {
        _productsSepatu.clear();
        _productsSepatu = products;
      }
      if (categoryId == 2) {
        _productSendal.clear();
        _productSendal = products;
      }
      if (categoryId == 3) {
        _productsJaket.clear();
        _productsJaket = products;
      }
      if (categoryId == 4) {
        _productsTas.clear();
        _productsTas = products;
      }
      // if (categoryId == 5) {
      //   _productsRunning.clear();
      //   _productsRunning = products;
      // }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> getNewProduct(int limit) async {
    try {
      List<ProductModel> products = await productService.getNewProducts(limit);
      _productsLimit = products;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<bool> addProduct(
    String token,
    String name,
    String description,
    int price,
    int categoriesId,
  ) async {
    try {
      final result = await productService
          .addProduct(token, name, description, price, categoriesId)
          .then((value) {
        getProducts();
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

  Future<bool> editProduct(String token, String name, String description,
      int price, int categoriesId, int productId) async {
    try {
      final result = await productService
          .editProduct(token, name, description, price, categoriesId, productId)
          .then(
        (value) {
          getProducts();
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

  Future<bool> deleteProduct(
    String token,
    int productId,
  ) async {
    try {
      final result = await productService.deleteProduct(token, productId);
      reloadProduct();
      return result;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}
