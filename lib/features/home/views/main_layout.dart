// // main_layout.dart
// import 'package:flutter/material.dart';
// import 'package:shop/core/utils/app_colors.dart';
// import 'package:shop/features/home/views/widgets/bottom_nav_bar.dart';
// class MainLayout extends StatefulWidget {
//   const MainLayout({super.key});

//   @override
//   State<MainLayout> createState() => _MainLayoutState();
// }

// class _MainLayoutState extends State<MainLayout> {
//   int selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: selectedIndex,
//         children: BottomNavBar.screens,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: selectedIndex,
//         onTap: (index) => setState(() => selectedIndex = index),
//         type: BottomNavigationBarType.fixed, // عشان يظهر النص إذا كانوا 3 عناصر أو أكثر
//         selectedItemColor: AppColors.pink, // ✅ لون مخصص للعنصر النشط
//         unselectedItemColor: Colors.grey,   // ✅ لون مخصص للعنصر غير النشط
//         items: BottomNavBar.items,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/core/utils/app_assets.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shop/features/home/views/home_view.dart';
import 'package:shop/features/items/views/items_view.dart';
import 'package:shop/features/profile/userdata/views/profile_view.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeView(),
      ItemsView(),
      ProfileView(),
    ];
    return Scaffold(
      // backgroundColor: Colors.red,
      // body: screens[currentIndex],
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
     
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.pink,
        backgroundColor: AppColors.backgroundColor,
        // elevation: 0,
        currentIndex: currentIndex,
          onTap: (int index){
            setState(() {
              currentIndex = index;
            });
          },
          items: [
             BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(AppIcons.activeHome),
              icon: SvgPicture.asset(AppIcons.home),
              label: 'home'.tr(),
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(AppIcons.activeCart),
              icon: SvgPicture.asset(AppIcons.cart),
              label: 'items'.tr(),
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(AppIcons.activeProfile),
              icon: SvgPicture.asset(AppIcons.profile),
              label: 'profile'.tr(),
            ),
          ]
      ),
    );
  }
}