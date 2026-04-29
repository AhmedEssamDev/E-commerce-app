// 

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageManager extends StatefulWidget {
  final Widget unselectedImageBuilder;
  final Widget Function(String imagePath) selectedImageBuilder;
  final String? currentImageUrl; // رابط الصورة من السيرفر
  final void Function(String imagePath)? onImageSelected;

  const ImageManager({
    super.key,
    required this.unselectedImageBuilder,
    required this.selectedImageBuilder,
    this.currentImageUrl,
    this.onImageSelected,
  });

  @override
  State<ImageManager> createState() => _ImageManagerState();
}

class _ImageManagerState extends State<ImageManager> {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: pickImage,
      child: Builder(builder: (context) {
        // لو اختار صورة من المعرض
        if (image != null) {
          return widget.selectedImageBuilder(image!.path);
        }
        // لو موجود صورة من السيرفر
        else if (widget.currentImageUrl != null &&
            widget.currentImageUrl!.isNotEmpty) {
          return CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(widget.currentImageUrl!),
          );
        }
        // الصورة الافتراضية
        else {
          return widget.unselectedImageBuilder;
        }
      }),
    );
  }

  Future<void> pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && widget.onImageSelected != null) {
      widget.onImageSelected!(image!.path);
    }
    setState(() {});
  }
}