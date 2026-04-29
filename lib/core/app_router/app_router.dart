import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop/core/app_router/app_router_keys.dart';
import 'package:shop/features/auth/auth_view.dart';
import 'package:shop/features/auth/login/view/login_view.dart';
import 'package:shop/features/auth/register/views/register_view.dart';
import 'package:shop/features/home/views/home_view.dart';
import 'package:shop/features/home/views/main_layout.dart';
import 'package:shop/features/items/views/items_view.dart';
import 'package:shop/features/onboarding/onboarding_view.dart';
import 'package:shop/features/profile/order/views/order_view.dart';
import 'package:shop/features/profile/updateprofile/views/update_profile_view.dart';
import 'package:shop/features/profile/userdata/cubit/user_state.dart';
import 'package:shop/features/profile/userdata/views/profile_view.dart';
import 'package:shop/features/profile/widgets/setting_view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: AppRouterKeys.onboarding,
  routes: [
    GoRoute(
      path: AppRouterKeys.onboarding,
      name: 'onboarding',
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(
      path: AppRouterKeys.auth,
      name: 'auth',
      builder: (context, state) => AuthView(),
    ),
    GoRoute(
      path: AppRouterKeys.login,
      name: 'login',
      builder: (context, state) => LoginView(),
    ),
    GoRoute(
      path: AppRouterKeys.register,
      name: 'register',
      builder: (context, state) => RegisterView(),
    ),
    GoRoute(
      path: AppRouterKeys.mainLayout,
      name: 'mainLayout',
      builder: (context, state) => MainLayout(),
    ),
    GoRoute(
      path: AppRouterKeys.home,
      name: 'home',
      builder: (context, state) => HomeView(),
    ),
    GoRoute(
      path: AppRouterKeys.items,
      name: 'items',
      builder: (context, state) => ItemsView(),
    ),
    GoRoute(
      path: AppRouterKeys.profile,
      name: 'profile',
      builder: (context, state) => ProfileView(),
    ),
    GoRoute(
      path: AppRouterKeys.updateProfile,
      name: 'updateProfile',
      builder: (context, state) =>
          UpdateProfile(userState: state.extra as UserSuccess),
    ),
    GoRoute(
      path: AppRouterKeys.settings,
      name: 'settings',
      builder: (context, state) => SettingView(),
    ),
    GoRoute(
      path: AppRouterKeys.order,
      name: 'order',
      builder: (context, state) => OrdersView(),
    ),
  ],
);
