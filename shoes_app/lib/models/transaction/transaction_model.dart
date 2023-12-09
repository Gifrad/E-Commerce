import 'package:shoes_app/models/auth/user_model.dart';
import 'package:shoes_app/models/transaction/transaction_item_model.dart';

class TransactionModel {
  int? id;
  int? usersId;
  String? address;
  int? totalPrice;
  int? shippingPrice;
  String? transfer;
  String? status;
  String? payment;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? user;
  List<TransactionItemModel>? items;

  TransactionModel({
    this.id,
    this.usersId,
    this.address,
    this.totalPrice,
    this.shippingPrice,
    this.transfer,
    this.status,
    this.payment,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.items,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usersId = json['users_id'];
    address = json['address'];
    totalPrice = json['total_price'];
    shippingPrice = json['shipping_price'];
    transfer = json['transfer'];
    status = json['status'];
    payment = json['payment'];
    deletedAt = json['deleted_at'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    if (json['items'] != null) {
      items = json['items']
          .map<TransactionItemModel>(
              (item) => TransactionItemModel.fromJson(item))
          .toList();
    } else {
      items = null;
    }
  }
}
