import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mash/API_handler/api_base_handler.dart';
import 'package:mash/configs/base_url.dart';
import 'package:mash/screens/feed_view/controller/mash_controller.dart';
import 'package:mash/screens/feed_view/models/mash_model.dart';

Future<void> getCollection(int userId) async {
  final MashController controller = Get.find();
  controller.loading.value = true;

  http.Response response = await ApiBaseHelper.get(WebApi.allCollection + "?user_id=$userId", true);
  controller.loading.value = false;

  if (response.statusCode == 200) {
    controller.ownMashCollection.clear();
    List<MashModel> mashModel = mashModelFromJson(response.body);
    mashModel.forEach((element) {
      controller.ownMashCollection.add(element);
    });
  }
}
