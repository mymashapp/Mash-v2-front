import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_place/google_place.dart';
import 'package:mash_flutter/models/category.dart';
import 'package:mash_flutter/services/api.dart';
import 'package:mash_flutter/services/api_client.dart';

class EventController extends GetxController {
  final ApiClient _client = Get.find();

  final Rx<TextEditingController> nameController = TextEditingController().obs;
  final Rx<TextEditingController> locationController =
      TextEditingController().obs;
  final RxList<Category> categories = <Category>[].obs;
  final Rx<Category> selectedCategory = Category().obs;
  final RxInt selectedTime = 0.obs;
  final Rx<DateTime> eventDate =
      DateTime.now().add(const Duration(days: 2)).obs;

  final RxList<AutocompletePrediction> predictions =
      <AutocompletePrediction>[].obs;
  AutocompletePrediction? selectedLocation;

  @override
  void onReady() {
    super.onReady();

    _getAllCategory();
  }

  void _getAllCategory() async {
    final response = await _client.getData(Api.GET_CATEGORY);

    final _categories = List<Category>.from(
        jsonDecode(response).map((x) => Category.fromJson(x)));

    categories.assignAll(_categories);
  }

  void onCategoryChanged(Category? category) {
    selectedCategory.value = category!;
  }

  void autoCompleteSearch(String? location) async {
    if (location != null && location.trim().isNotEmpty) {
      GooglePlace googlePlace =
          GooglePlace('AIzaSyArgtGCvxqhaW-EdFHnSeI4vTANeGvRFTg');
      predictions.clear();
      final response = await googlePlace.autocomplete.get(location);

      predictions.assignAll(response!.predictions!);
    } else {
      predictions.clear();
    }
  }

  void createCard() async {
    if (selectedTime.value == 0) {
      eventDate.value = DateTime.now();
    } else if (selectedTime.value == 1) {
      eventDate.value = DateTime.now().add(const Duration(days: 1));
    }

    /*final body = {
      "id": 0,
      "name": nameController.value.text,
      "categoryId": selectedCategory.value.id,
      "address": locationController.value.text,
      "zip": "94103",
      "latitude": 0,
      "longitude": 0,
      "cardType": 2,
      "dateUtc": eventDate.value.toIso8601String(),
      "pictureUrl": "string"
    };*/
  }
}
