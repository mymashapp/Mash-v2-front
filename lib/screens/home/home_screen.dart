import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mash/configs/app_colors.dart';
import 'package:mash/constants/constants.dart';
import 'package:mash/main.dart';
import 'package:mash/screens/chat_view/chat_user_screen.dart';
import 'package:mash/screens/feed_view/feed_view.dart';
import 'package:mash/screens/feed_view/tabs/app_map.dart';
import 'package:mash/screens/home/controller/home_controller.dart';
import 'package:mash/screens/home/widget/home_tab.dart';
import 'package:mash/screens/profile_view/profile_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());

  List<String> icon = [
    //"assets/icons/chat.svg",
    // "assets/icons/feed.svg",
    // "assets/icons/map.svg",
    "assets/icons/user.svg",
    "assets/icons/home.svg",
  ];

  List<String> selectedIcon = [
    // "assets/icons/chat_fill.svg",
    // "assets/icons/feed_fill.svg",
    // "assets/icons/map_fill.svg",
    "assets/icons/user_fill.svg",
    "assets/icons/home_fill.svg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Obx(() => AnimatedBottomNavigationBar.builder(
          itemCount: 2,
          height: 50.h,
          tabBuilder: (index, isActive) {
            return Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
              child: SvgPicture.asset(
                isActive ? selectedIcon[index] : icon[index],
              ),
            );
          },
          splashColor: AppColors.kOrange,
          splashRadius: 20.h,
          elevation: 0,
          rightCornerRadius: 32,
          leftCornerRadius: 32,
          activeIndex: authController.bottomIndex.value,
          gapLocation: GapLocation.none,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          onTap: (index) {
            authController.bottomIndex.value = index;
            pageController.jumpToPage(index);
          })),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          //  HomeTab(),
          //  ChatUserScreen(),
          // FeedViewScreen(),
          // AppMap(),
          ProfileScreen(),
          Container(),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
