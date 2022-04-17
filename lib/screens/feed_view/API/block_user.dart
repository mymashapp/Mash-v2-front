import 'package:mash/API_handler/api_base_handler.dart';
import 'package:mash/configs/base_url.dart';

Future<bool> blockUser(int userId) async {
  var response =
      await ApiBaseHelper.post(WebApi.blockUser, {"friend_id": userId}, true);

  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}
