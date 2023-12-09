import 'package:shoes_app/models/product/product_model.dart';
import 'package:shoes_app/models/product/uninitialized_product_model.dart';

class MessageModel {
  String? userPhone;
  String? message;
  int? userId;
  String? userName;
  String? userImage;
  bool? isFromUser;
  ProductModel? product;
  DateTime? createdAt;
  DateTime? updatedAt;

  MessageModel({
    this.userPhone,
    this.message,
    this.userId,
    this.userName,
    this.userImage,
    this.isFromUser,
    this.product,
    this.createdAt,
    this.updatedAt,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    userPhone = json['userPhone'];
    message = json['message'];
    userId = json['userId'];
    userName = json['userName'];
    userImage = json['userPhoto'];
    isFromUser = json['isFromUser'];
    product = json['product'].isEmpty
        ? UninitializedProductModel()
        : ProductModel.fromJson(json['product']);
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'isFromUser': isFromUser,
      'product': product is UninitializedProductModel ? {} : product?.toJson(),
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }
}
