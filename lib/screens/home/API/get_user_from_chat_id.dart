import 'package:mash/API_handler/api_base_handler.dart';
import 'package:mash/configs/base_url.dart';
import 'package:mash/screens/home/model/user_list_model.dart';

Future<List<UserOfMashList>> getUsersFromChatId(String chatId) async {
  var response =
      await ApiBaseHelper.get(WebApi.getUsersFromChatId + chatId, true);

  if (response.statusCode == 200) {
    try {
      usersOfMashFromJson(response.body).list!;
    } catch (e) {
      print(e.toString());
    }
    return usersOfMashFromJson(response.body).list!;
  } else {
    return <UserOfMashList>[];
  }
}
