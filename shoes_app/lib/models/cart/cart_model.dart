import 'package:shoes_app/models/product/product_model.dart';

class CartModel {
  int? id;
  ProductModel? product;
  late int quantity;

  CartModel({this.id, this.product, required this.quantity});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = ProductModel.fromJson(json['product']);
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product?.toJson(),
      'quantity': quantity,
    };
  }

  double getTotalPrice() {
    return product!.price! * quantity;
  }
}
