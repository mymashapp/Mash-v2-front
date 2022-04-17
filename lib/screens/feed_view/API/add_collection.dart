import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mash/configs/base_url.dart';
import 'package:mash/main.dart';
import 'package:mash/screens/feed_view/controller/mash_controller.dart';
import 'package:mash/widgets/error_snackbar.dart';

addCollection(
  File file, {
  required String name,
  required String description,
  required String price,
}) async {
  MashController controller = Get.find();

  controller.loading.value = true;

  var request = http.MultipartRequest('POST', Uri.parse(WebApi.baseUrl + WebApi.addCollection));

  request.fields.addAll({
    'nft_name': name,
    'description': description,
    'price': price,
  });

  request.files.add(await http.MultipartFile.fromPath('file', file.path));

  request.headers.addAll({"Authorization": "Bearer ${authController.accessToken.value}"});

  http.StreamedResponse response = await request.send();

  controller.loading.value = false;

  print(response.statusCode);

  if (response.statusCode == 201) {
    final responseString = await response.stream.bytesToString();

    Get.back();
  } else {
    appSnackBar("Error", "Mash NFT not added");
  }
}
