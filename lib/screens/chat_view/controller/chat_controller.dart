import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:mash/screens/chat_view/models/chat_users_model.dart';
import 'package:mash/screens/chat_view/models/direct_chat_model.dart';

class ChatController extends GetxController {
  RxInt selectedIndex = 100.obs;
  GetStorage box = GetStorage();
  RxInt selectedRate = 100.obs;
  RxList<ChatUsersModel> chatUserList = <ChatUsersModel>[].obs;
  RxList<Direct> direct = <Direct>[].obs;
  List deleteList = [];
  List deleteGroupList = [];
  RxInt currentPage = 1.obs;
  RxInt currentTab = 0.obs;
  RxBool lastPage = false.obs;
  RxBool bottomLoader = false.obs;
  RxBool loading = false.obs;
  RxInt count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }
}
