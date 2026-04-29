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
import 'package:shop/features/auth/login/cubit/login_cubit.dart';
import 'package:shop/features/auth/login/cubit/login_state.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
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
          body: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
               if(state is LoginError){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('login_error'.tr(), style: TextStyle(color: AppColors.backgroundColor),),
                backgroundColor: AppColors.error,
              ));
            }else if(state is LoginSuccess){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${'login_success'.tr()}\n${'welcome'.tr()} ${state.userModel.name}', style: TextStyle(color: AppColors.backgroundColor),),
                backgroundColor: AppColors.success,
              ));
              context.go(AppRouterKeys.mainLayout);
            }
            },
            builder: (context, state) {
            var cubit = LoginCubit.get(context);
              return Padding(
                padding: REdgeInsets.only(left: 32, right: 26, top: 42),
                child: SingleChildScrollView(
                  child: Form(
                    key: cubit.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "welcome_back".tr(),
                          style: AppTextStyles.authblackText(),
                        ),
                        SizedBox(height: 45.h),
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
                        SizedBox(height: 22.h),
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
                          controller: cubit.passwordController,
                          hintText: 'password'.tr(),
                          prefixIcon: Icon(Icons.lock),
                          obSecure: cubit.passwordSecure,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              cubit.changePasswordVisibility();
                            },
                            child: Icon(
                              cubit.passwordSecure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ), 
                          ),
                        ),
                        SizedBox(height: 56.h),
                        CustomButton(
                          onTap: () {
                           state is LoginLoading ? null :cubit.login() ;
                          },
                          text: 'login'.tr(),
                          colorbutton: AppColors.pink,
                          colortext: AppColors.backgroundColor,
                          width: 317.w,
                        ),
                         SizedBox(height: 20.h,),
                        if(state is LoginLoading)
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
