import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mash/configs/app_colors.dart';
import 'package:mash/main.dart';
import 'package:mash/screens/home/controller/home_controller.dart';
import 'package:mash/screens/home/create_event_screen.dart';
import 'package:mash/screens/home/notification_list.dart';
import 'package:mash/screens/home/widget/mashed_view_widget.dart';
import 'package:mash/screens/home/widget/tcard.dart';
import 'package:mash/widgets/app_button.dart';
import 'package:share/share.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with WidgetsBindingObserver {
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      authController.isLocationEnabled.value = true;
      if (!homeController.loading.value) {
        // homeController.fetchAllEvents();
      }
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 10.w,
            right: 10.w,
            top: 40.h,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.to(() => InsertEventScreen());
                },
                icon: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppColors.kOrange,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Share.share(
                      "https://apps.apple.com/us/app/mash-fun-meetups-new-friends/id1590373585");
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0.sp),
                  child: Icon(
                    Icons.share,
                    color: AppColors.kOrange,
                    size: 28,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.to(() => NotificationList());
                },
                icon: Icon(
                  Icons.notifications_outlined,
                  color: AppColors.kOrange,
                  size: 34,
                ),
              ),
              const SizedBox(width: 7)
            ],
          ),
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Obx(() => authController.isLocationEnabled.value
                  ? TCardPage()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Oops",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: AppColors.kOrange),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "In order to use Mash you need to\n enable your location.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, color: Colors.blueGrey.shade300),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Go to Settings > Mash > Location >\nEnable Location While Using the App",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, color: Colors.blueGrey.shade300),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: Get.width / 2,
                          child: appButton(
                              buttonBgColor: AppColors.kOrange,
                              onTap: AppSettings.openLocationSettings,
                              buttonName: "OPEN SETTINGS"),
                        )
                      ],
                    )),
              // Obx(
              //   () => homeController.selectedIndex.value == 2 // filter
              //       ? selectedStackContainer(
              //           onSelect: (i) {
              //             homeController.categorySelected.value = i;
              //           },
              //           onTap: () {
              //             homeController.selectedIndex.value = 99;
              //           },
              //           title: homeController.categoryList,
              //           listLength: homeController.categoryList.length,
              //           selectedIndex: homeController.categorySelected.value,
              //         )
              //       : SizedBox(),
              // ),
              // Obx(() => homeController.selectedIndex.value ==
              //         2 // filter bar restauratnyt
              //     ? selectedStackContainer(
              //         onSelect: (i) {
              //           homeController.activitySelected.value = i;
              //         },
              //         onTap: () {
              //           homeController.selectedIndex.value = 99;
              //         },
              //         title: homeController.activityList,
              //         listLength: homeController.activityList.length,
              //         selectedIndex: homeController.activitySelected.value,
              //       )
              //     : SizedBox()),
              // Obx(() => homeController.selectedIndex.value ==
              //         2 // men /women filter
              //     ? ClipRRect(
              //         borderRadius: BorderRadius.circular(10.r),
              //         child: Container(
              //           margin: EdgeInsets.all(32),
              //           padding: EdgeInsets.all(16),
              //           decoration: BoxDecoration(
              //               color: Color(0xffFBD8B4).withAlpha(200),
              //               borderRadius: BorderRadius.circular(15.r)),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Row(
              //                 children: [
              //                   Expanded(
              //                     child: ListView.builder(
              //                         padding: EdgeInsets.zero,
              //                         shrinkWrap: true,
              //                         itemCount:
              //                             homeController.partyList.length,
              //                         itemBuilder: (context, i) {
              //                           return GestureDetector(
              //                               onTap: () {
              //                                 homeController
              //                                     .partySelectedIndex.value = i;
              //                               },
              //                               child: Obx(
              //                                 () => Container(
              //                                   height: 52.h,
              //                                   padding: EdgeInsets.symmetric(
              //                                       horizontal: 10.w),
              //                                   decoration: BoxDecoration(
              //                                       boxShadow: homeController
              //                                                   .partySelectedIndex
              //                                                   .value ==
              //                                               i
              //                                           ? [
              //                                               BoxShadow(
              //                                                 color: Colors
              //                                                     .black12,
              //                                                 offset:
              //                                                     Offset(4, 4),
              //                                                 blurRadius: 6,
              //                                               )
              //                                             ]
              //                                           : null,
              //                                       color: homeController
              //                                                   .partySelectedIndex
              //                                                   .value ==
              //                                               i
              //                                           ? AppColors.kOrange
              //                                           : Colors.transparent,
              //                                       borderRadius:
              //                                           BorderRadius.circular(
              //                                               8.r)),
              //                                   child: Row(
              //                                     mainAxisAlignment:
              //                                         MainAxisAlignment
              //                                             .spaceBetween,
              //                                     children: [
              //                                       Text(
              //                                         homeController
              //                                             .partyList[i],
              //                                         style: GoogleFonts.sourceSansPro(
              //                                             fontSize: 20.sp,
              //                                             color: homeController
              //                                                         .partySelectedIndex
              //                                                         .value ==
              //                                                     i
              //                                                 ? Colors.white
              //                                                 : Colors.black,
              //                                             fontWeight:
              //                                                 FontWeight.bold),
              //                                       ),
              //                                       homeController
              //                                                   .partySelectedIndex
              //                                                   .value ==
              //                                               i
              //                                           ? Icon(
              //                                               Icons
              //                                                   .task_alt_outlined,
              //                                               color: homeController
              //                                                           .partySelectedIndex
              //                                                           .value ==
              //                                                       i
              //                                                   ? Colors.white
              //                                                   : Colors.black,
              //                                               size: 30.sp,
              //                                             )
              //                                           : SizedBox()
              //                                     ],
              //                                   ),
              //                                 ),
              //                               ));
              //                         }),
              //                   ),
              //                   Expanded(
              //                     child: ListView.builder(
              //                         padding: EdgeInsets.zero,
              //                         shrinkWrap: true,
              //                         itemCount:
              //                             homeController.genderList.length,
              //                         itemBuilder: (context, i) {
              //                           return GestureDetector(
              //                               onTap: () {
              //                                 homeController
              //                                     .genderSelected.value = i;
              //                               },
              //                               child: Obx(
              //                                 () => Container(
              //                                   height: 52.h,
              //                                   padding: EdgeInsets.symmetric(
              //                                       horizontal: 10.w),
              //                                   decoration: BoxDecoration(
              //                                       boxShadow: homeController
              //                                                   .genderSelected
              //                                                   .value ==
              //                                               i
              //                                           ? [
              //                                               BoxShadow(
              //                                                 color: Colors
              //                                                     .black12,
              //                                                 offset:
              //                                                     Offset(4, 4),
              //                                                 blurRadius: 6,
              //                                               )
              //                                             ]
              //                                           : null,
              //                                       color: homeController
              //                                                   .genderSelected
              //                                                   .value ==
              //                                               i
              //                                           ? AppColors.kOrange
              //                                           : Colors.transparent,
              //                                       borderRadius:
              //                                           BorderRadius.circular(
              //                                               8.r)),
              //                                   child: Row(
              //                                     mainAxisAlignment:
              //                                         MainAxisAlignment
              //                                             .spaceBetween,
              //                                     children: [
              //                                       Text(
              //                                         homeController
              //                                             .genderList[i],
              //                                         style: GoogleFonts.sourceSansPro(
              //                                             fontSize: 20.sp,
              //                                             color: homeController
              //                                                         .genderSelected
              //                                                         .value ==
              //                                                     i
              //                                                 ? Colors.white
              //                                                 : Colors.black,
              //                                             fontWeight:
              //                                                 FontWeight.bold),
              //                                       ),
              //                                       homeController
              //                                                   .genderSelected
              //                                                   .value ==
              //                                               i
              //                                           ? Icon(
              //                                               Icons
              //                                                   .task_alt_outlined,
              //                                               color: homeController
              //                                                           .genderSelected
              //                                                           .value ==
              //                                                       i
              //                                                   ? Colors.white
              //                                                   : Colors.black,
              //                                               size: 30.sp,
              //                                             )
              //                                           : SizedBox()
              //                                     ],
              //                                   ),
              //                                 ),
              //                               ));
              //                         }),
              //                   )
              //                 ],
              //               ),
              //               appButton(
              //                 onTap: () {
              //                   homeController.selectedIndex.value = 99;
              //                 },
              //                 buttonBgColor: Color(0xff564B40),
              //                 buttonName: "Apply",
              //                 textColor: Colors.white,
              //               )
              //             ],
              //           ),
              //         ),
              //       )
              //     : SizedBox()),
              // Obx(() => homeController.selectedIndex.value ==
              //         2 // dating no dating
              //     ? selectedStackContainer(
              //         onSelect: (i) {
              //           homeController.datingSelectedIndex.value = i;
              //         },
              //         onTap: () {
              //           homeController.selectedIndex.value = 99;
              //           homeController.oneToOne.value = true;
              //         },
              //         title: homeController.datingList,
              //         listLength: homeController.datingList.length,
              //         selectedIndex: homeController.datingSelectedIndex.value,
              //       )
              //     : SizedBox()),
              // Obx(
              //   () => homeController.selectedIndex.value == 2 // today filter
              //       ? selectedStackContainer(
              //           onSelect: (i) {
              //             homeController.timeListSelectedIndex.value = i;
              //           },
              //           onTap: () {
              //             homeController.selectedIndex.value = 99;
              //           },
              //           title: homeController.timeList,
              //           listLength: homeController.timeList.length,
              //           selectedIndex:
              //               homeController.timeListSelectedIndex.value,
              //         )
              //       : SizedBox(),
              // ),
              Obx(() => homeController.userOfMashList.length > 1
                  ? oneToOneMashedView()
                  : SizedBox()),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
