// update_profile_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop/features/profile/updateprofile/cubit/update_state.dart';
import 'package:shop/features/profile/updateprofile/data/update_profile_repo.dart';
class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final UpdateProfileRepo updateProfileRepo;
  UpdateProfileCubit(this.updateProfileRepo) : super(UpdateProfileInitial());

  static UpdateProfileCubit get(context) => BlocProvider.of(context);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? imagePath;


  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imagePath = picked.path;
      emit(UpdateProfileInitial()); // عشان يعمل rebuild ويظهر الصورة الجديدة
    }
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    emit(UpdateProfileLoading());

    var result = await updateProfileRepo.updateProfile(
      name: nameController.text,
      phone: phoneController.text,
      imagePath: imagePath,
    );

    result.fold(
      (error) => emit(UpdateProfileError(error: error)),
      (message) => emit(UpdateProfileSuccess(message: message)),
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    return super.close();
  }
}