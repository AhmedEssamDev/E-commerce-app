class CategoriesResponseModel {
  List<CategoryModel>? categories;
  bool? status;

  CategoriesResponseModel({this.categories, this.status});

  CategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <CategoryModel>[];
      json['categories'].forEach((v) {
        categories!.add( CategoryModel.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class CategoryModel {
  String? description;
  int? id;
  String? imagePath;
  List<Products>? products;
  String? title;

  CategoryModel(
      {this.description, this.id, this.imagePath, this.products, this.title});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    id = json['id'];
    imagePath = json['image_path'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add( Products.fromJson(v));
      });
    }
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['description'] = description;
    data['id'] = id;
    data['image_path'] = imagePath;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['title'] = title;
    return data;
  }
}

class Products {
  int? bestSeller;
  String? description;
  int? id;
  String? imagePath;
  bool? isFavorite;
  String? name;
  double? price;
  double? rating;

  Products(
      {this.bestSeller,
      this.description,
      this.id,
      this.imagePath,
      this.isFavorite,
      this.name,
      this.price,
      this.rating});

  Products.fromJson(Map<String, dynamic> json) {
    bestSeller = json['best_seller'];
    description = json['description'];
    id = json['id'];
    imagePath = json['image_path'];
    isFavorite = json['is_favorite'];
    name = json['name'];
    price = json['price'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['best_seller'] = bestSeller;
    data['description'] = description;
    data['id'] = id;
    data['image_path'] = imagePath;
    data['is_favorite'] = isFavorite;
    data['name'] = name;
    data['price'] = price;
    data['rating'] = rating;
    return data;
  }
}
