// sliders_response_model.dart
class SlidersResponseModel {
  final List<SliderModel>? sliders;

  SlidersResponseModel({this.sliders});

  factory SlidersResponseModel.fromJson(Map<String, dynamic> json) {
    return SlidersResponseModel(
      sliders: (json['sliders'] as List)
          .map((e) => SliderModel.fromJson(e))
          .toList(),
    );
  }
}

// slider_model.dart
class SliderModel {
  final int? id;
  final String? title;
  final String? description;
  final String? imagePath;

  SliderModel({this.id, this.title, this.description, this.imagePath});

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imagePath: json['image_path'],
    );
  }
}