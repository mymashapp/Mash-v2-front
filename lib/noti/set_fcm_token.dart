import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mash/API_handler/api_base_handler.dart';
import 'package:mash/configs/base_url.dart';
import 'package:mash/main.dart';

setFcmTokenToApi(String fcm) async {
  final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  String identifier = "";
  if (Platform.isAndroid) {
    var build = await deviceInfoPlugin.androidInfo;
    identifier = build.androidId; //UUID for Android
  } else if (Platform.isIOS) {
    var data = await deviceInfoPlugin.iosInfo;
    identifier = data.identifierForVendor; //UUID for iOS
  }
  await ApiBaseHelper.post(
      WebApi.setToken,
      {
        "user_notification_data_id": authController.user.value.id,
        "user_notification_data_device_id": identifier,
        "user_notification_data_firebase_token": fcm
      },
      true);
}

setFcmToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  messaging.getToken().then((value) {
    print("FCM TOKEN ::: $value");
    if (value!.isNotEmpty) {
      final box = GetStorage();
      if (box.read("fcmToken") == null) {
        box.write("fcmToken", value);
        setFcmTokenToApi(value);
      } else {
        if (box.read("fcmToken") != value) {
          setFcmTokenToApi(value);
        }
      }
    }
  });
}
