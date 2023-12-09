class UserModel {
  int? id;
  String? name;
  String? email;
  String? roles;
  String? phone;
  String? photo;
  String? username;
  DateTime? createdAt;
  // String? token;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.photo,
    this.roles,
    this.username,
    this.createdAt,
    // this.token,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    roles = json['roles'];
    username = json['username'];
    json['phone'] != null ? phone = json['phone'] : null;
    json['photo'] != null ? photo = json['photo'] : null;
    createdAt = DateTime.parse(json['created_at']);
    // token = json['token'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'roles': roles,
      'username': username,
      'phone': phone,
      'photo': photo,
      'created_at': createdAt.toString(),
      // 'token': token,
    };
  }
}
