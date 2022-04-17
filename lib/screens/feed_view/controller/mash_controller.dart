import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:mash/API_handler/api_base_handler.dart';
import 'package:mash/screens/feed_view/models/mash_model.dart';
import 'package:http/http.dart' as http;

class MashController extends GetxController {
  RxBool loading = false.obs;
  RxList<MashModel> mashCollection = <MashModel>[].obs;
  RxList<MashModel> ownMashCollection = <MashModel>[].obs;
  RxString reportReason = "Please select reason".obs;
  RxDouble rate = 1.0.obs;
  RxDouble finalPrice = 0.0.obs;

  RxInt sliderIndex = 0.obs;
  final CarouselController carouselController = CarouselController();

  RxList<String> sliderImages =
      ["assets/static-2.jpg", "assets/static-3.jpg", "assets/static-4.jpg"].obs;
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    loadRate();
  }

  onPriceChange(String amount) {
    if (amount.isEmpty) {
      finalPrice.value = 0;
    } else {
      finalPrice.value = double.parse(amount) * rate.value;
    }
  }

  void loadRate() async {
    http.Response response = await http.get(Uri.parse(
        "https://api.etherscan.io/api?module=stats&action=ethprice&apikey=P116S6PJ6TNP2GT6MT9D8YWE1ENZ2MCHBY"));

    Map<String, dynamic> data =
        Map<String, dynamic>.from(json.decode(response.body));

    rate.value = double.parse("${data["result"]["ethusd"] ?? 1.0}");

    print("result - " + response.body);
  }
}
