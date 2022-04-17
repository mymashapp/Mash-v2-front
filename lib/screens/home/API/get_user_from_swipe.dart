import 'package:get/get.dart';
import 'package:mash/API_handler/api_base_handler.dart';
import 'package:mash/configs/base_url.dart';
import 'package:mash/screens/auth/API/get_profile_picture.dart';
import 'package:mash/screens/home/controller/home_controller.dart';
import 'package:mash/screens/home/model/user_list_model.dart';

Future<List<UserOfMashList>> getUsersFromSwipe(String chatId) async {
  HomeController homeController = Get.put(HomeController());
  print(WebApi.baseUrl + WebApi.getUsersFromChatId + chatId);
  var response =
      await ApiBaseHelper.get(WebApi.getUsersFromChatId + chatId, true);
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    homeController.userOfMashList.value =
        usersOfMashFromJson(response.body).list!;
    homeController.userOfMashList.forEach((element) async {
      String url = await getProfile(element.chatMainUsersId);
      homeController.userProfile.addIf(true, element.chatMainUsersId!, url);
    });
    return homeController.userOfMashList;
  } else {
    return <UserOfMashList>[];
  }
}
