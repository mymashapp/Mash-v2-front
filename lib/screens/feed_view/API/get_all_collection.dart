import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mash/API_handler/api_base_handler.dart';
import 'package:mash/configs/base_url.dart';
import 'package:mash/screens/feed_view/controller/mash_controller.dart';
import 'package:mash/screens/feed_view/models/mash_model.dart';

Future<void> getAllCollection() async {
  final MashController controller = Get.put(MashController());
  controller.loading.value = true;
  GetStorage box = GetStorage();
  List<dynamic> reportUser = [];
  if (box.read("reportUser") != null) {
    reportUser = box.read("reportUser");
  }
  http.Response response = await ApiBaseHelper.get(WebApi.allCollection, true);
  controller.loading.value = false;

  if (response.statusCode == 200) {
    controller.mashCollection.clear();
    List<MashModel> mashModel = mashModelFromJson(response.body);
    mashModel.forEach((element) {
      bool isAvailable = false;
      if (reportUser.isNotEmpty) {
        reportUser.forEach(
          (val) {
            if (val == element.userId) {
              isAvailable = true;
            }
          },
        );
      }
      if (!isAvailable) {
        if (element.approve == 1) controller.mashCollection.add(element);
      }
    });
  }
}
