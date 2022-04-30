import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mash_flutter/constants/app_colors.dart';

showErrorSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    duration: const Duration(seconds: 1),
    colorText: Colors.white,
    backgroundColor: Colors.redAccent,
    margin: EdgeInsets.zero,
    borderRadius: 0,
    snackPosition: SnackPosition.BOTTOM,
    icon: const Icon(
      Icons.error,
      color: Colors.white,
    ),
    shouldIconPulse: true,
  );
}

showSuccessSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    duration: const Duration(seconds: 1),
    colorText: Colors.white,
    backgroundColor: Colors.green,
    margin: EdgeInsets.zero,
    borderRadius: 0,
    snackPosition: SnackPosition.BOTTOM,
    icon: const Icon(
      Icons.error,
      color: Colors.white,
    ),
    shouldIconPulse: true,
  );
}

appSnackBar(title, message) {
  Get.snackbar(
    title,
    message,
    colorText: Colors.white,
    backgroundColor: AppColor.blue,
    snackPosition: SnackPosition.TOP,
    icon: const Icon(
      Icons.check_circle_outlined,
      color: Colors.white,
    ),
    shouldIconPulse: true,
  );
}
