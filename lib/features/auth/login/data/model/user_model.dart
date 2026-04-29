class UserModel {
  String? email;
  List<dynamic>? favoriteProducts; // ✅ dynamic لحد ما تعرف النوع
  int? id;
  String? imagePath;
  String? name;
  String? phone;

  UserModel({this.email, this.favoriteProducts, this.id, this.imagePath, this.name, this.phone});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    favoriteProducts = json['favorite_products'] ?? [];
    id = json['id'];
    imagePath = json['image_path'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'favorite_products': favoriteProducts ?? [],
      'id': id,
      'image_path': imagePath,
      'name': name,
      'phone': phone,
    };
  }
}