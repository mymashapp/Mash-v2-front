import 'dart:convert';

import 'package:get/get.dart';
import 'package:mash_flutter/models/card_model.dart';
import 'package:mash_flutter/services/api.dart';
import 'package:mash_flutter/services/api_client.dart';
import 'package:mash_flutter/utils/error.dart';

class CardController extends GetxController {
  final ApiClient _client = Get.find();

  RxList<CardModel> cards = <CardModel>[].obs;

  @override
  void onReady() {
    super.onReady();

    _getCards();
  }

  void _getCards() async {
    final body = {"userId": 27, "zipCode": "94103"};
    final response = await _client.postData(Api.GET_CARDS, body);
    final result = jsonDecode(response);

    if (result['isSucceeded'] == true) {
      List<CardModel> _cards = List<CardModel>.from(
          result['data'].map((e) => CardModel.fromJson(e)));
      cards.assignAll(_cards);
    } else {
      showErrorSnackBar('Error', result['message']);
    }
  }
}
