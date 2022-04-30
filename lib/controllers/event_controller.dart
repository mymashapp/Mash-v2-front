import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_place/google_place.dart';
import 'package:mash_flutter/controllers/auth_controller.dart';
import 'package:mash_flutter/models/address_result.dart';
import 'package:mash_flutter/models/category.dart';
import 'package:mash_flutter/services/api.dart';
import 'package:mash_flutter/services/api_client.dart';
import 'package:mash_flutter/utils/error.dart';

class EventController extends GetxController {
  static EventController instance = Get.find();

  final ApiClient _client = Get.find();

  final Rx<TextEditingController> nameController = TextEditingController().obs;
  final Rx<TextEditingController> locationController =
      TextEditingController().obs;
  final RxList<Category> categories = <Category>[].obs;
  final Rx<Category> selectedCategory = Category().obs;
  final RxInt selectedTime = 0.obs;
  final Rx<DateTime> eventDate =
      DateTime.now().add(const Duration(days: 2)).obs;
  final Rx<File?> eventImage = Rx<File?>(null);
  final RxBool loading = false.obs;

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
    loading.value = true;

    if (selectedTime.value == 0) {
      eventDate.value = DateTime.now();
    } else if (selectedTime.value == 1) {
      eventDate.value = DateTime.now().add(const Duration(days: 1));
    }

    final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${selectedLocation!.description!}&key=AIzaSyArgtGCvxqhaW-EdFHnSeI4vTANeGvRFTg');

    final response = await http.get(uri);

    AddressResult addressResult =
        AddressResult.fromJson(jsonDecode(response.body));

    String zipcode = '94103';
    double latitude = 0;
    double longitude = 0;

    if (addressResult.results != null) {
      for (Result result in addressResult.results!) {
        for (var component in result.addressComponents!) {
          if (component.types!.contains('postal_code')) {
            zipcode = component.longName ?? '94103';
            latitude = result.geometry!.location?.lat ?? 0;
            longitude = result.geometry!.location?.lng ?? 0;

            break;
          }
        }
      }
    }

    final bytes = await eventImage.value!.readAsBytes();
    final base64String = base64.encode(bytes);

    String base64Image = 'data:image/png;base64,' + base64String;

    final body = {
      "id": AuthController.instance.user?.id ?? 0,
      "name": nameController.value.text,
      "categoryId": selectedCategory.value.id,
      "address": locationController.value.text,
      "zip": zipcode,
      "latitude": latitude,
      "longitude": longitude,
      "cardType": 2,
      "dateUtc": eventDate.value.toIso8601String(),
      "pictureUrl": base64Image,
    };

    final apiResponse = await _client.postData(Api.CREATE_CARD, body);
    final apiJson = jsonDecode(apiResponse);

    loading.value = false;

    if (apiJson['isSucceeded']) {
      Get.back();
      appSnackBar('Event Created Successfully',
          'Wait to someone find your event interesting');
    } else {
      showErrorSnackBar('Something wrong!', 'Problem with event creation');
    }
  }
}
