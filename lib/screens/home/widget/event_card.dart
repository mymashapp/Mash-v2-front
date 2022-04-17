import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mash/configs/app_colors.dart';
import 'package:mash/main.dart';
import 'package:mash/screens/chat_view/API/sned_personal_message.dart';
import 'package:mash/screens/feed_view/API/get_friends_list.dart';
import 'package:mash/screens/feed_view/controller/friend_controller.dart';
import 'package:mash/screens/home/model/all_event_model.dart';
import 'package:mash/screens/home/widget/tcard.dart';
import 'package:mash/screens/profile_view/API/create_perosnal_chat.dart';
import 'package:mash/widgets/blur_loader.dart';
import 'package:mash/widgets/user_profile.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

Widget eventCard(Event event) {
  Widget _buildEventStar() {
    String image = "assets/yelp_star/5.png";

    int starRating = (10 * event.eventExtra!.rating!).round();

    switch (starRating) {
      case 0:
        image = "assets/yelp_star/0.png";
        break;
      case 10:
        image = "assets/yelp_star/1.png";
        break;
      case 15:
        image = "assets/yelp_star/1_5.png";
        break;
      case 20:
        image = "assets/yelp_star/2.png";
        break;
      case 25:
        image = "assets/yelp_star/2_5.png";
        break;
      case 30:
        image = "assets/yelp_star/3.png";
        break;
      case 35:
        image = "assets/yelp_star/3_5.png";
        break;
      case 40:
        image = "assets/yelp_star/4.png";
        break;
      case 45:
        image = "assets/yelp_star/4_5.png";
        break;
      case 50:
        image = "assets/yelp_star/5.png";
        break;
    }

    return Image.asset(
      image,
      height: 25,
    );
  }

  return Stack(children: [
    ClipRRect(
      borderRadius: BorderRadius.circular(15.r),
      child: FancyShimmerImage(
        height: Get.height,
        width: Get.width,
        imageUrl: event.eventExtra == null ? "" : event.eventExtra!.imageUrl!,
        shimmerBaseColor: AppColors.lightOrange,
        shimmerHighlightColor: AppColors.kOrange,
        shimmerBackColor: AppColors.lightOrange,
        boxFit: BoxFit.cover,
        errorWidget: Container(
            color: Colors.white, child: Image.asset("assets/mash_logo.png")),
      ),
    ),
    Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.black.withOpacity(0.8),
          Colors.transparent,
          Colors.transparent,
          Colors.transparent,
          Colors.transparent,
          Colors.black.withOpacity(0.8)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
            decoration: BoxDecoration(
                color: AppColors.kOrange,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                gradient: LinearGradient(
                  colors: [AppColors.kOrange, Colors.black.withOpacity(0.2)],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                )),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    FriendController friendController =
                        Get.put(FriendController());
                    getFriendList();
                    Get.dialog(Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      insetPadding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 16, left: 16),
                            child: Row(
                              children: [
                                Text(
                                  "Friends",
                                  style: TextStyle(
                                      fontSize: 20, color: AppColors.kOrange),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Share.share(
                                        "https://apps.apple.com/us/app/mash-fun-meetups-new-friends/id1590373585");
                                  },
                                  icon: Icon(
                                    Icons.share,
                                    color: AppColors.kOrange,
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: AppColors.kOrange,
                                    ))
                              ],
                            ),
                          ),
                          Obx(() => friendController.loading.value
                              ? SizedBox(
                                  height: Get.height / 2, child: loading())
                              : friendController.friendList.length == 0
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      child: Center(child: Text("No Friends")),
                                    )
                                  : ListView.separated(
                                      padding: EdgeInsets.all(16),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) =>
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color:
                                                          AppColors.shadowColor,
                                                      offset: Offset(2, 2),
                                                      blurRadius: 6)
                                                ],
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Row(
                                              children: [
                                                userProfile(
                                                    friendController
                                                        .friendList[index]
                                                        .usersFriendsListFriendId
                                                        .toString(),
                                                    20),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  friendController
                                                      .friendList[index]
                                                      .fullName!,
                                                  style: TextStyle(
                                                      color: AppColors.kOrange,
                                                      fontSize: 16),
                                                )),
                                                MaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  onPressed: () async {
                                                    if (friendController
                                                            .friendList[index]
                                                            .usersFriendsListChatId ==
                                                        null) {
                                                      await createPersonalChat(
                                                              friendController
                                                                  .friendList[
                                                                      index]
                                                                  .usersFriendsListFriendId!,
                                                              friendController
                                                                  .friendList[
                                                                      index]
                                                                  .fullName!,
                                                              false)
                                                          .then((value) {
                                                        sendPersonalMessage(
                                                            event.eventId
                                                                .toString(),
                                                            value,
                                                            "event");
                                                      });
                                                    } else {
                                                      sendPersonalMessage(
                                                          event.eventId
                                                              .toString(),
                                                          friendController
                                                              .friendList[index]
                                                              .usersFriendsListChatId!,
                                                          "event");
                                                    }
                                                  },
                                                  child: Text(
                                                    "Send",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  color: AppColors.kOrange,
                                                )
                                              ],
                                            ),
                                          ),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                            height: 16,
                                          ),
                                      itemCount:
                                          friendController.friendList.length))
                        ],
                      ),
                    ));
                  },
                  icon: Icon(
                    Icons.send_outlined,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        event.eventName!,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 24.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                  color: Colors.black38,
                                  offset: Offset(2, 2),
                                  blurRadius: 10)
                            ]),
                      ),
                      Text(
                        event.eventExtra == null ||
                                event.eventExtra!.categories == null
                            ? event.placeName!
                            : event.eventExtra!.categories![0].title!,
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                  color: Colors.black38,
                                  offset: Offset(2, 2),
                                  blurRadius: 10)
                            ]),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  event.eventExtra == null
                      ? SizedBox()
                      : event.eventExtra!.rating == null
                          ? SizedBox()
                          : _buildEventStar(),
                  Spacer(),
                  SizedBox(
                    width: 100,
                    child: Image.asset(
                      "assets/new_logo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.dialog(Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        insetPadding: EdgeInsets.all(16),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(event.eventId.toString()),
                              Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        event.placeName!,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: AppColors.kOrange,
                                            fontWeight: FontWeight.w600),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        launch(
                                            "tel:${event.eventExtra!.phone}");
                                      },
                                      icon: Icon(Icons.call),
                                      color: AppColors.kOrange,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        launch(event.eventExtra!.url!);
                                      },
                                      icon: Icon(Icons.link),
                                      color: AppColors.kOrange,
                                    )
                                  ],
                                ),
                              ),
                              infoTiles(
                                  title: "# of swipes today",
                                  value: "${event.totalJoinedPeople}",
                                  iconData: Icons.groups_outlined),
                              // infoTiles(
                              //     title: "Total Allowed Peoples",
                              //     value:
                              //         "${data.}",
                              //     iconData: Icons.badge_outlined),
                              infoTiles(
                                  title: "Distance",
                                  value:
                                      "${event.distanceInMiles!.toStringAsFixed(2)} Miles",
                                  iconData: Icons.directions_outlined),
                            ],
                          ),
                        ),
                      ));
                    },
                    child: Icon(
                      Icons.error,
                      size: 40,
                      color: AppColors.kOrange,
                    ),
                  ),
                ],
              ))
        ],
      ),
    ),
    // likeNope(event.eventId.toString())
  ]);
}

likeNope(String id) {
  return Obx(() => authController.swipeStatus.value == 2
      ? SizedBox()
      : Row(
          children: [
            Expanded(
                child: authController.swipeStatus.value == 0 &&
                        authController.swipeId.value == id
                    ? Image.asset(
                        "assets/icons/nope.png",
                      )
                    : SizedBox()),
            Expanded(
                child: authController.swipeStatus.value == 1 &&
                        authController.swipeId.value == id
                    ? Image.asset("assets/icons/LIKE.png")
                    : SizedBox()),
          ],
        ));
}
