import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget logo() {
  return Hero(
    tag: "logo",
    child: Column(
      children: [
        Image.asset(
          "assets/mash_logo.png",
          width: Get.width / 1.5,
        ),
        Center(
          child: Material(
            color: Colors.transparent,
            child: Text(
              // "The Friend Zone",
              "",
              style: GoogleFonts.specialElite(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w100),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ),
  );
}
