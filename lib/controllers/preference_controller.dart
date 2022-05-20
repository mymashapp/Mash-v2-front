import 'package:get/get.dart';
import 'package:mash_flutter/controllers/auth_controller.dart';

class PreferenceController extends GetxController {
  final RxBool isAgeSelected = false.obs;
  final RxDouble minAge = 18.0.obs;
  final RxDouble maxAge = 65.0.obs;

  final Rx<String> genderPref = "".obs;
  final Rx<String> groupNoPref = "".obs;

  @override
  void onInit() {
    super.onInit();

    // get data from auth controller
    final authController = Get.find<AuthController>();
    isAgeSelected.value = authController.isAgeSelected.value;
    minAge.value = authController.minAge.value;
    maxAge.value = authController.minAge.value;
    genderPref.value = authController.genderPref.value;
    groupNoPref.value = authController.groupNoPref.value;
  }

  void updateUserData() {
    final authController = Get.find<AuthController>();
    authController.isAgeSelected.value = isAgeSelected.value;
    authController.minAge.value = minAge.value;
    authController.minAge.value = maxAge.value;
    authController.genderPref.value = genderPref.value;
    authController.groupNoPref.value = groupNoPref.value;

    authController.updateUserData();
  }
}
