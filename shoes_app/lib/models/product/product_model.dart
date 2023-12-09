import 'package:shoes_app/models/category/category_model.dart';
import 'package:shoes_app/models/gallery/gallery_model.dart';

class ProductModel {
  int? id;
  String? name;
  double? price;
  String? description;
  String? tags;
  DateTime? createdAt;
  DateTime? updatedAt;
  CategoryModel? category;
  List<GalleryModel>? galleries;

  ProductModel({
    this.id,
    this.name,
    this.price,
    this.description,
    this.tags,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.galleries,
  });

  // ProductModel.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   name = json['name'];
  //   price = double.parse(json['price'].toString());
  //   description = json['description'];
  //   tags = json['tags'];
  //   category = CategoryModel.fromJson(json['category']);
  //   galleries = json['galeries']
  //       .map<GalleryModel>((gallery) => GalleryModel.fromJson(gallery))
  //       .toList();
  //   createdAt = DateTime.parse(json['created_at']);
  //   updatedAt = DateTime.parse(json['updated_at']);
  // }
  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = double.parse(json['price'].toString());
    description = json['description'];
    tags = json['tags'];
    if (json['category'] != null) {
      category = CategoryModel.fromJson(json['category']);
    } else {
      category = CategoryModel(id: json['categories_id'], name: null);
    }
    if (json['galeries'] != null) {
      galleries = json['galeries']
          .map<GalleryModel>((gallery) => GalleryModel.fromJson(gallery))
          .toList();
    } else {
      galleries = null;
    }
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'tags': tags,
      'category': category?.toJson(),
      'galeries': galleries?.map((gallery) => gallery.toJson()).toList(),
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}
