import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mash_flutter/controllers/card_controller.dart';

import 'chat_user_list_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'user_screen.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({Key? key}) : super(key: key);

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  final PageController _controller = PageController();

  int _currentIndex = 0;

  static const List<String> _icon = [
    "assets/svgs/home.svg",
    "assets/svgs/chat.svg",
    "assets/svgs/map.svg",
    "assets/svgs/user.svg",
  ];

  static const List<String> _selectedIcon = [
    "assets/svgs/home_fill.svg",
    "assets/svgs/chat_fill.svg",
    "assets/svgs/map_fill.svg",
    "assets/svgs/user_fill.svg",
  ];

  void _onTap(int index) {
    if (index == 0) Get.find<CardController>().getCards();
    setState(() {
      _currentIndex = index;
      _controller.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: _icon.length,
        tabBuilder: (index, isActive) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: SvgPicture.asset(
              isActive ? _selectedIcon[index] : _icon[index],
            ),
          );
        },
        activeIndex: _currentIndex,
        onTap: _onTap,
        height: 50,
        elevation: 0,
        rightCornerRadius: 32,
        leftCornerRadius: 32,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        splashRadius: 20,
        splashColor: Colors.orange,
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          const HomeScreen(),
          const ChatUserListScreen(),
          const MapScreen(),
          UserScreen(),
        ],
      ),
    );
  }
}
