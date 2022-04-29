import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import 'about_screen.dart';
import 'preference_screen.dart';
import 'profile_screen.dart';

class SettingTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();

    super.onClose();
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingTabController _controller = Get.put(SettingTabController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
        actions: [
          IconButton(
            onPressed: () {
              Share.share(
                  "https://apps.apple.com/us/app/mash-fun-meetups-new-friends/id1590373585");
            },
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _controller.tabController,
          physics: const BouncingScrollPhysics(),
          indicatorColor: Colors.orange,
          tabs: const [
            Tab(text: 'Background'),
            Tab(text: 'Preferences'),
            Tab(text: 'Information'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller.tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ProfileScreen(),
          const PreferenceScreen(),
          const AboutScreen(),
        ],
      ),
    );
  }
}
