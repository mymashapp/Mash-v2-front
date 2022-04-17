import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:mash/screens/auth/controller/auth_controller.dart';
import 'package:mash/screens/auth/sign_in%20_screen.dart';
import 'package:mash/screens/home/home_screen.dart';

import 'noti/notification_handler_service.dart';

late AuthController authController;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  authController = Get.put(AuthController());
  notificationHandlerService();
  runApp(MyApp());
}

GetStorage getStorage = GetStorage();
bool testing = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: () {
        return GetMaterialApp(
          defaultTransition: Transition.noTransition,
          debugShowCheckedModeBanner: false,
          title: 'MyMash',
          theme: ThemeData(
            textTheme: GoogleFonts.sourceSansProTextTheme(),
            primarySwatch: Colors.blue,
          ),
          home: authController.logged.value ? HomeScreen() : SignIn(),
          // home: LocationEnable(),
        );
      },
    );
  }
}

// TODO: 7 Feb 2022
// 1. Add back button in Friends & Friend Requests
// 2. Dispaly start like yelp in Home screen when type was Yelp
// 3. Check map screen, when click on profile that time need to show message section
