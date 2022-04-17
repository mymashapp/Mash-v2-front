import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:mash/constants/constants.dart';
import 'package:mash/screens/chat_view/API/get_chat_users.dart';
import 'package:mash/screens/chat_view/chat_view.dart';
import 'package:mash/screens/feed_view/API/get_friend_request_list.dart';
import 'package:mash/widgets/error_snackbar.dart';

import '../main.dart';

notificationHandlerService() {
  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    notiSnackBar(
        event.notification!.title ?? "", event.notification!.body ?? "", (ob) {
      handleNoti(event);
    });
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    // storeInLocalDb(message, true);
    handleNoti(message);
  });
}

handleNoti(RemoteMessage message) {
  print("NOTI DATA :: ${message.data}");
  if (message.data["type"] == "Friend Request") {
    authController.feedTabController.value.animateTo(1);
    authController.friendController.value.animateTo(1);
    getFriendRequestList();
    authController.bottomIndex.value = 2;
    pageController.jumpToPage(2);
  } else if (message.data["type"] == "Friend Photos") {
    authController.feedTabController.value.animateTo(0);
    authController.discoverController.value.animateTo(1);
    authController.bottomIndex.value = 2;
    pageController.jumpToPage(2);
  } else if (message.data["type"] == "New Mash") {
    getChatUsers();
    authController.bottomIndex.value = 1;
    pageController.jumpToPage(1);
    Get.to(() => ChatView(
          messageId: message.data["chat_id"],
          eventName: message.data["eventName"],
          event: true,
          eventImage: message.data["eventImage"],
        ));
  } else {
    getChatUsers();
    authController.bottomIndex.value = 1;
    pageController.jumpToPage(1);
  }
}
