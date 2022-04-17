import 'package:mash/API_handler/api_base_handler.dart';
import 'package:mash/configs/base_url.dart';

chatOpenedService(String chatId) async {
  await ApiBaseHelper.post(WebApi.chatOpened, {"chat_id": chatId}, true);
}
