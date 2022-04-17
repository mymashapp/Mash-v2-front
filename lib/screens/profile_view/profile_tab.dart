import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mash/configs/app_colors.dart';
import 'package:mash/screens/auth/setting_screen.dart';
import 'package:mash/screens/profile_view/background_screen.dart';
import 'package:mash/screens/profile_view/preferences_screen.dart';
import 'package:mash/widgets/app_bar_widget.dart';
import 'package:share/share.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  // List<String> tabs = ["Background", "Preferences", "Information"];
  List<String> tabs = ["Background", "Information"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.kOrange,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Settings",
          style: GoogleFonts.sourceSansPro(),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Share.share(
                  "https://apps.apple.com/us/app/mash-fun-meetups-new-friends/id1590373585");
            },
            child: Padding(
              padding: EdgeInsets.only(right: 16.0.sp),
              child: Icon(
                Icons.share,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
              controller: _tabController,
              indicatorColor: AppColors.kOrange,
              physics: BouncingScrollPhysics(),
              onTap: (index) {},
              tabs: List.generate(
                  tabs.length,
                  (index) => Container(
                        alignment: Alignment.center,
                        height: 45.h,
                        child: Text(
                          tabs[index],
                          style: GoogleFonts.sourceSansPro(
                              fontSize: 15.sp, color: AppColors.kOrange),
                        ),
                      ))),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                BackGroundScreen(),
                //PreferencesScreen(),
                SettingScreen(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
