//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shop/core/app_router/app_router_keys.dart';
import 'package:shop/core/cache/cache_helper.dart';
import 'package:shop/core/cache/cache_keys.dart';
import 'package:shop/core/utils/app_assets.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/core/utils/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shop/features/profile/userdata/cubit/user_cubit.dart';
import 'package:shop/features/profile/userdata/cubit/user_state.dart';
import 'package:shop/features/profile/userdata/data/user_repo.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(UserRepo())..getUserData(),
      child: Scaffold(
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is UserError) {
              return Center(child: Text('error_occurred'.tr()));
            }

            if (state is UserSuccess) {
              var user = state.user;
              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Padding(
                  padding: REdgeInsets.only(top: 50, left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('profile'.tr(), style: AppTextStyles.titleText()),
                      SizedBox(height: 20.h),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.pink,
                        backgroundImage:
                            (user.imagePath != null &&
                                user.imagePath!.isNotEmpty)
                            ? NetworkImage(user.imagePath!)
                            : null,
                        child:
                            (user.imagePath == null || user.imagePath!.isEmpty)
                            ? Icon(Icons.person, size: 50, color: Colors.white)
                            : null,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        user.name ?? '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.pink,
                        ),
                      ),
                      SizedBox(height: 54.h),
                      // ✅ التغيير هنا: async + await
                      ListTile(
                        onTap: () async {
                          await context.push(
                            AppRouterKeys.updateProfile,
                            extra: state,
                          );
                          if (context.mounted) {
                            context.read<UserCubit>().getUserData();
                          }
                        },
                        leading: SvgPicture.asset(AppIcons.profile),
                        trailing: SvgPicture.asset(AppIcons.forward, matchTextDirection: true),
                        title: Text('my_profile'.tr()),
                      ),
                      ListTile(
                        onTap: () {
                          context.push(AppRouterKeys.order);
                        },
                        leading: SvgPicture.asset(AppIcons.bag),
                        trailing: SvgPicture.asset(AppIcons.forward, matchTextDirection: true),
                        title: Text('my_orders'.tr()),
                      ),
                      ListTile(
                        onTap: () {},
                        leading: SvgPicture.asset(AppIcons.heart),
                        trailing: SvgPicture.asset(AppIcons.forward, matchTextDirection: true),
                        title: Text('my_favorites'.tr()),
                      ),
                      ListTile(
                        onTap: () {
                          context.push(AppRouterKeys.settings);
                        },
                        leading: SvgPicture.asset(AppIcons.setting),
                        trailing: SvgPicture.asset(AppIcons.forward, matchTextDirection: true),
                        title: Text('settings'.tr()),
                      ),
                      SizedBox(height: 50.h),
                      Container(
                        width: 308.w,
                        height: 1.h,
                        color: AppColors.pink,
                      ),
                      SizedBox(height: 50.h),
                      ListTile(
                        onTap: () async{
                          await CacheHelper.removeValue(Cachekeys.accessToken);
                          context.go(AppRouterKeys.auth);
                        },
                        leading: SvgPicture.asset(AppIcons.logout),
                        title: Text('logout'.tr()),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SizedBox();
          },
        ),
      ),
    );
  }
}
