import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mash_flutter/controllers/auth_controller.dart';
import 'package:mash_flutter/controllers/location_controller.dart';
import 'package:mash_flutter/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/app_colors.dart';
import 'views/screens/auth/sign_in_screen.dart';
import 'views/screens/tab_bar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  final sharedPreferences = await SharedPreferences.getInstance();

  // Firebase notification
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  debugPrint('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((event) {});

  FirebaseMessaging.onMessageOpenedApp.listen((event) {});

  // Inject service
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient());

  // Inject controller
  Get.put(AuthController());
  Get.put(LocationController());

  runApp(const MashApp());
}

class MashApp extends StatelessWidget {
  const MashApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: AppColor.orange,
        ),
        textTheme: GoogleFonts.sourceSansProTextTheme(),
      ),
      home: Obx(
        () => AuthController.instance.isUserLogIn.value
            ? const TabBarScreen()
            : const SignInScreen(),
      ),
    );
  }
}
