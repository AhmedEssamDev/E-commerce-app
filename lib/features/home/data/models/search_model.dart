class SearchResponseModel {
  List<ProductsSearch>? products;
  bool? status;

  SearchResponseModel({this.products, this.status});

  SearchResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <ProductsSearch>[];
      json['products'].forEach((v) {
        products!.add(ProductsSearch.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class ProductsSearch {
  int? bestSeller;
  Category? category;
  String? description;
  int? id;
  String? imagePath;
  bool? isFavorite;
  String? name;
  double? price;        // ✅ تغير من int? لـ double?
  double? rating;

  ProductsSearch({
    this.bestSeller,
    this.category,
    this.description,
    this.id,
    this.imagePath,
    this.isFavorite,
    this.name,
    this.price,
    this.rating,
  });

  ProductsSearch.fromJson(Map<String, dynamic> json) {
    bestSeller = json['best_seller'];
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    description = json['description'];
    id = json['id'];
    imagePath = json['image_path'];
    isFavorite = json['is_favorite'];
    name = json['name'];
    
    // ✅ تحويل آمن للسعر
    price = json['price'] != null 
        ? double.tryParse(json['price'].toString()) 
        : null;
    
    // ✅ تحويل آمن للتقييم
    rating = json['rating'] != null 
        ? double.tryParse(json['rating'].toString()) 
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['best_seller'] = bestSeller;
    if (category != null) {
      data['category'] = category!.toJson();
    }
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

class Category {
  String? description;
  int? id;
  String? imagePath;
  String? title;

  Category({this.description, this.id, this.imagePath, this.title});

  Category.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    id = json['id'];
    imagePath = json['image_path'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['id'] = id;
    data['image_path'] = imagePath;
    data['title'] = title;
    return data;
  }
}