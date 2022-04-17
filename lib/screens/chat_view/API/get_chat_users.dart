import 'package:get/get.dart';
import 'package:mash/API_handler/api_base_handler.dart';
import 'package:mash/configs/base_url.dart';
import 'package:mash/screens/chat_view/controller/chat_controller.dart';
import 'package:mash/screens/chat_view/models/chat_users_model.dart';
import 'package:mash/screens/chat_view/models/direct_chat_model.dart';
import 'package:mash/screens/home/model/all_event_model.dart';

getChatUsers() async {
  ChatController chatController = Get.put(ChatController());
  List deletedGroupList = [];
  if (chatController.box.read("deleteGroupList") != null) {
    deletedGroupList = chatController.box.read("deleteGroupList");
  }
  chatController.loading.value = true;
  var response = await ApiBaseHelper.get(
      WebApi.getChatIds +
          "?stream=${chatController.currentPage.value}&limit=9&order_by=DESC&at_least_have_user=2",
      true);
  chatController.loading.value = false;

  List<ChatUsersModel> chatUserList = chatUsersModelFromJson(response.body);
  chatUserList.forEach((element) {
    chatController.chatUserList.add(element);
    deletedGroupList.forEach((element1) {
      if (element1 == element.chatMainId) {
        chatController.chatUserList.remove(element);
      }
    });
  });
  chatController.currentPage.value = chatController.currentPage.value + 1;
  if (chatUserList.length < 9) {
    chatController.lastPage.value = true;
  }
  chatController.bottomLoader.value = false;
}

getPrivateChatUsers() async {
  ChatController chatController = Get.put(ChatController());
  List deletedList = [];
  if (chatController.box.read("deleteList") != null) {
    deletedList = chatController.box.read("deleteList");
  }

  chatController.loading.value = true;
  var response = await ApiBaseHelper.get(
      WebApi.getPrivateChatIds + "?stream=${chatController.currentPage.value}",
      true);
  print("HEE ::: ${response.statusCode}");
  print("HEE ::: ${response.body}");
  chatController.loading.value = false;
  List<Direct> chatUserList = directChatListFromJson(response.body).data!;
  chatUserList.forEach((element) {
    chatController.direct.add(element);

    deletedList.forEach((element1) {
      if (element1 == element.usersFriendsListFriendId) {
        chatController.direct.remove(element);
      }
    });
  });
  print(chatController.direct.length);
  chatController.currentPage.value = chatController.currentPage.value + 1;
  if (chatUserList.length < 9) {
    chatController.lastPage.value = true;
  }
  chatController.bottomLoader.value = false;
}
