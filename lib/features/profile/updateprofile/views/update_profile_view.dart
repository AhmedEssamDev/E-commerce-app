// 
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shop/core/custom_widget/customTextField.dart';
import 'package:shop/core/custom_widget/custom_button.dart';
import 'package:shop/core/utils/app_assets.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/core/utils/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shop/features/profile/updateprofile/cubit/update_cubit.dart';
import 'package:shop/features/profile/updateprofile/cubit/update_state.dart';
import 'package:shop/features/profile/updateprofile/data/update_profile_repo.dart';
import 'package:shop/features/profile/userdata/cubit/user_state.dart';
import 'package:shop/features/profile/widgets/image_manger.dart';

class UpdateProfile extends StatelessWidget {
  final UserSuccess userState;
  const UpdateProfile({super.key, required this.userState});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateProfileCubit(UpdateProfileRepo())
        ..nameController.text = userState.user.name ?? ''
        ..phoneController.text = userState.user.phone ?? '',
      child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('update_success'.tr()),
                backgroundColor: Colors.green,
              ),
            );
            // نرجع للصفحة السابقة بعد التحديث الناجح
            context.pop(true);
          }
          if (state is UpdateProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('update_error'.tr()),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          var cubit = UpdateProfileCubit.get(context);
          return Scaffold(
            body: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: REdgeInsets.only(top: 70, left: 24, right: 24),
                  child: Form(
                    key: cubit.formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => context.pop(),
                              child: SvgPicture.asset(AppIcons.back, matchTextDirection: true),
                            ),
                            SizedBox(width: 125.w),
                            Text('profile'.tr(), style: AppTextStyles.titleText()),
                          ],
                        ),
                        SizedBox(height: 25.h),

                        // ✅ تم التعديل: نستخدم currentImageUrl بدل networkImageBuilder
                        ImageManager(
                          unselectedImageBuilder: CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.pink,
                            child: Icon(Icons.person, size: 50, color: Colors.white),
                          ),
                          selectedImageBuilder: (imagePath) => CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(File(imagePath)),
                          ),
                          currentImageUrl: userState.user.imagePath, // الصورة الحالية من السيرفر
                          onImageSelected: (imagePath) {
                            cubit.imagePath = imagePath; // نحفظ اختيار المستخدم
                          },
                        ),

                        SizedBox(height: 66.h),
                        CustomTextField(
                          hintText: 'full_name_hint'.tr(),
                          prefixIcon: Icon(Icons.person),
                          controller: cubit.nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_name'.tr();
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 25.h),
                        CustomTextField(
                          hintText: 'phone_hint'.tr(),
                          prefixIcon: Icon(Icons.phone),
                          controller: cubit.phoneController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_phone_update'.tr();
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 75.h),

                        if (state is UpdateProfileLoading)
                          CircularProgressIndicator(color: AppColors.pink)
                        else
                          CustomButton(
                            onTap: () => cubit.updateProfile(),
                            text: 'save'.tr(),
                            colorbutton: AppColors.pink,
                            colortext: AppColors.backgroundColor,
                            width: 327.w,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}