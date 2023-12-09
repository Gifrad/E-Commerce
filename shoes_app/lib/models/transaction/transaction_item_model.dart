import 'package:shoes_app/models/product/product_model.dart';

class TransactionItemModel {
  int? id;
  int? usersId;
  int? productsId;
  int? transactionsId;
  int? quantity;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProductModel? product;

  TransactionItemModel({
    this.id,
    this.usersId,
    this.productsId,
    this.transactionsId,
    this.quantity,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  TransactionItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usersId = json['users_id'];
    productsId = json['products_id'];
    transactionsId = json['transactions_id'];
    quantity = json['quantity'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    if (json['product'] != null) {
      product = ProductModel.fromJson(json['product']);
    } else {
      product = null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'users_id': usersId,
      'products_id': productsId,
      'transactions_id': transactionsId,
      'quantity': quantity,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
      'product': product!.toJson(),
    };
  }
}
