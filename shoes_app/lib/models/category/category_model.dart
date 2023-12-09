class CategoryModel {
  int? id;
  String? name;

  CategoryModel({
    this.id,
    this.name,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      id = json['id'];
    } else {
      id = null;
    }
    if (json['name'] != null) {
      name = json['name'];
    } else {
      name = null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
