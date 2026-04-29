import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shop/core/app_router/app_router_keys.dart';
import 'package:shop/core/custom_widget/customTextField.dart';
import 'package:shop/core/custom_widget/custom_button.dart';
import 'package:shop/core/utils/app_assets.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/core/utils/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shop/features/auth/register/cubit/register_cubit.dart';
import 'package:shop/features/auth/register/cubit/register_state.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(17.0),
              child: GestureDetector(
                onTap: () {
                 context.go(AppRouterKeys.auth); 
                },
                child: SvgPicture.asset(AppIcons.back, matchTextDirection: true),
              ),
            ),
          ),
          body: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if(state is RegisterError){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('register_error'.tr(), style: TextStyle(color: AppColors.backgroundColor),),
                backgroundColor: AppColors.error,
              ));
            }
            else if(state is RegisterSuccess){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('register_success'.tr(), style: TextStyle(color: AppColors.backgroundColor),),
                backgroundColor: AppColors.success,
              ));
              context.go(AppRouterKeys.login);
            }
            },
            builder: (context, state) {
              var cubit = RegisterCubit.get(context);
              return Padding(
                padding: REdgeInsets.only(left: 32, right: 26, top: 25),
                child: SingleChildScrollView(
                  child: Form(
                    key: cubit.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "create_account".tr(),
                          style: AppTextStyles.authblackText(),
                        ),
                        SizedBox(height: 33.h),
                        CustomTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_full_name'.tr();
                            }
                            return null;
                          },
                          controller: cubit.nameController,
                          hintText: 'full_name'.tr(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return 'please_enter_phone'.tr();
                            }
                            return null;
                          },
                          controller: cubit.phoneController,
                          hintText: 'phone'.tr(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return 'please_enter_email'.tr();
                            }else if(!value.contains('@')){
                              return 'please_enter_valid_email'.tr();
                            }
                            return null;
                          },
                          controller: cubit.emailController,
                          hintText: 'email'.tr(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_password'.tr();
                            }
                            if (value.length < 6) {
                              return 'password_min_length'.tr();
                            }
                            return null;
                          },
                          obSecure: cubit.passwordSecure,
                          controller: cubit.passwordController,         
                          hintText: 'password'.tr(),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              cubit.changePasswordVisibility();
                            },
                            child: Icon(
                              cubit.passwordSecure
                                  ? Icons.visibility_off
                                  : Icons.visibility,

                          ),
                        )),
                        SizedBox(height: 10.h),
                        CustomTextField(
                           validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_password'.tr();
                            }
                            if (value.length < 6) {
                              return 'password_min_length'.tr();
                            }
                            return null;
                          },
                          obSecure: cubit.passwordSecure,
                          controller: cubit.confirmPasswordController,  
                          hintText: 'confirm_password'.tr(),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon:GestureDetector(
                            onTap: () {
                              cubit.changePasswordVisibility();
                            },
                            child: Icon(
                              cubit.passwordSecure
                                  ? Icons.visibility_off
                                  : Icons.visibility,

                          ),
                        )
                        ),
                        SizedBox(height: 21.h),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Lexend_Deca",
                            ), // الستايل الافتراضي
                            children: [
                              TextSpan(text: 'register_agree_prefix'.tr()),
                              TextSpan(
                                text: 'register_agree_button'.tr(),
                                style: TextStyle(color: Colors.red),
                              ),
                              TextSpan(
                                text: 'register_agree_suffix'.tr(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 28.h),
                        CustomButton(
                          onTap: () {
                            state is RegisterLoading ? null : cubit.register();
                          },
                          text: 'register'.tr(),
                          colorbutton: AppColors.pink,
                          colortext: AppColors.backgroundColor,
                          width: 317.w,
                        ),
                        SizedBox(height: 20.h,),
                        if(state is RegisterLoading)
                          Center(child: CircularProgressIndicator(color: AppColors.pink,))
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
