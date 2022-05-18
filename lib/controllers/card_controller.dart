import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mash_flutter/models/card_model.dart';
import 'package:mash_flutter/services/api.dart';
import 'package:mash_flutter/services/api_client.dart';
import 'package:mash_flutter/utils/error.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_controller.dart';
import 'location_controller.dart';

class CardController extends GetxController {
  final ApiClient _client = Get.find();

  final RxList<CardModel> cards = <CardModel>[].obs;
  final RxBool loading = false.obs;

  late Position currentPosition;

  @override
  void onReady() {
    super.onReady();

    getCards();
  }

  void getCards() async {
    loading.value = true;

    LocationController locationController = Get.find();
    // check permission
    final position = await locationController.getCurrentPosition();
    currentPosition = position;
    // get zip code
    final zipCode = await locationController.getCurrentZipCode(
        position.latitude, position.longitude);

    final body = {
      "userId": Get.find<SharedPreferences>().getInt('USER_ID'),
      "zipCode": zipCode
    };

    final response = await _client.postData(Api.GET_CARDS, body);
    final result = jsonDecode(response);

    loading.value = false;

    if (result['isSucceeded'] == true) {
      List<CardModel> _cards = List<CardModel>.from(
          result['data'].map((e) => CardModel.fromJson(e)));
      // Randomize
      _cards.shuffle();
      cards.assignAll(_cards);
    } else {
      showErrorSnackBar('Error', result['message']);
    }
  }

  void onSwipeLeft(CardModel card) async {
    final body = {
      'cardId': card.id!,
      'userId': AuthController.instance.user?.id ?? 0,
      'swipeType': 0,
    };
    await _client.postData(Api.SWIPE, body);
  }

  void onSwipeRight(CardModel card) async {
    final body = {
      'cardId': card.id!,
      'userId': AuthController.instance.user?.id ?? 0,
      'swipeType': 1,
    };
    await _client.postData(Api.SWIPE, body);
  }
}
