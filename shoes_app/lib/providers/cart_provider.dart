import 'package:flutter/cupertino.dart';
import 'package:shoes_app/models/cart/cart_model.dart';
import 'package:shoes_app/models/product/product_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> _cart = [];
  List<CartModel> get cart => _cart;

  set cart(List<CartModel> cart) {
    _cart = cart;
    notifyListeners();
  }

  void addCart(ProductModel product) {
    if (productExist(product)) {
      int index =
          _cart.indexWhere((element) => element.product?.id == product.id);

      _cart[index].quantity++;
    } else {
      _cart.add(CartModel(
        id: _cart.length,
        product: product,
        quantity: 1,
      ));
    }
    notifyListeners();
  }

  void removeProduct(int id) {
    _cart.removeAt(id);
    notifyListeners();
  }

  void addQuantity(int id) {
    _cart[id].quantity++;
    notifyListeners();
  }

  void reduceQuantity(int id) {
    _cart[id].quantity--;

    if (_cart[id].quantity == 0) {
      _cart.removeAt(id);
    }
    notifyListeners();
  }

  int totalItem() {
    int total = 0;
    for (final item in _cart) {
      total += item.quantity;
    }
    return total;
  }

  double totalPrice() {
    double total = 0;
    for (final item in _cart) {
      total += (item.quantity * item.product!.price!);
    }
    return total;
  }

  bool productExist(ProductModel product) {
    if (_cart.indexWhere((element) => element.id == product.id) == -1) {
      return false;
    } else {
      return true;
    }
  }
}
