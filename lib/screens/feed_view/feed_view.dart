import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mash/configs/app_colors.dart';
import 'package:mash/main.dart';
import 'package:mash/screens/feed_view/API/get_all_collection.dart';
import 'package:mash/screens/feed_view/tabs/discover.dart';

import 'API/get_friends_list.dart';
import 'API/get_leaderboard.dart';
import 'mesh_page.dart';

class FeedViewScreen extends StatefulWidget {
  const FeedViewScreen({Key? key}) : super(key: key);

  @override
  _FeedViewScreenState createState() => _FeedViewScreenState();
}

class _FeedViewScreenState extends State<FeedViewScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    getAllCollection();
  }

  List<String> tabs = ["Mash NFT Collection", "Discover"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: Get.width,
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Text(
                  "Mash NFT Collection",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kOrange),
                ),
                Divider(
                  color: AppColors.kOrange,
                  height: 16,
                  endIndent: 15,
                  indent: 15,
                  thickness: 1.5,
                ),
              ],
            )
            // TabBar(
            //   labelPadding: EdgeInsets.only(left: 20, right: 20, bottom: 8.0),
            //   indicatorColor: AppColors.kOrange,
            //   physics: BouncingScrollPhysics(),
            //   controller: authController.feedTabController.value,
            //   onTap: (index) async {
            //     if (index == 0) {
            //       print("Mash NFT");
            //       getAllCollection();
            //       // getFriendList();
            //     } else if (index == 2) {
            //       getLeaderBoard();
            //     } else if (index == 3) {
            //       // await getNearByFriends();
            //     }
            //   },
            //   tabs: List.generate(
            //     tabs.length,
            //     (index) => Container(
            //       alignment: Alignment.center,
            //       height: 40,
            //       child: Text(
            //         tabs[index],
            //         style: GoogleFonts.sourceSansPro(
            //           fontSize: 16,
            //           color: AppColors.kOrange,
            //         ),
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //   ),
            // ),
            ),
        Expanded(
          child: MeshPage(),
          // TabBarView(
          //   physics: NeverScrollableScrollPhysics(),
          //   controller: authController.feedTabController.value,
          //   children: [
          //     MeshPage(),
          //     Discover(),
          //   ],
          // ),
        )
      ],
    );
  }
}
