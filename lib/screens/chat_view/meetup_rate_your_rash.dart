import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mash/configs/app_colors.dart';
import 'package:mash/screens/chat_view/controller/chat_controller.dart';
import 'package:mash/widgets/app_button.dart';

class MeetUpRate extends StatefulWidget {
  @override
  _MeetUpRateState createState() => _MeetUpRateState();
}

class _MeetUpRateState extends State<MeetUpRate> {
  ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: AppColors.kOrange.withOpacity(0.2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.kOrange,
                  radius: 60.r,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "David",
                  style: TextStyle(fontSize: 20.sp, color: Colors.black),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            "Did the mashup happen?",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: AppColors.kOrange,
                    onPressed: () {},
                    child: Text(
                      "Yes",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: AppColors.lightOrange,
                    onPressed: () {},
                    child: Text(
                      "No",
                      style: TextStyle(color: AppColors.kOrange, fontSize: 18),
                    )),
              )
            ],
          ),
          // Text(
          //   "Were they on time (0= No show, 5 = On Time)?",
          //   style: TextStyle(color: Colors.black, fontSize: 20.sp),
          //   textAlign: TextAlign.center,
          // ),
          // Text(
          //   "How was the venue?",
          //   style: TextStyle(color: Colors.black, fontSize: 20.sp),
          // ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Rate Your Mash",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          SizedBox(
            height: 15.h,
          ),
          RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            glowColor: AppColors.lightOrange,
            itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: AppColors.kOrange,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
          // SizedBox(
          //   height: 10.h,
          // ),
          // Text(
          //   "Do you want to add [] as a friend?",
          //   style: TextStyle(color: Colors.black, fontSize: 20),
          // ),
          // SizedBox(
          //   height: 10.h,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     OutlinedButton(
          //         onPressed: () {},
          //         child: Text(
          //           "Yes",
          //           style: TextStyle(color: Colors.black),
          //         )),
          //     OutlinedButton(
          //         onPressed: () {},
          //         child: Text(
          //           "No",
          //           style: TextStyle(color: Colors.black),
          //         ))
          //   ],
          // ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       "Upload photo / video of mash",
          //       style: TextStyle(
          //         fontSize: 20.sp,
          //       ),
          //     ),
          //     SizedBox(
          //       width: 10,
          //     ),
          //     Icon(Icons.camera_alt_outlined)
          //   ],
          // ),

          Padding(
            padding: EdgeInsets.only(top: 25.h),
            child: appButton(
              onTap: () {
                // Get.to(() => CongratsScreen());
              },
              buttonName: "Submit",
              buttonBgColor: AppColors.kOrange,
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
