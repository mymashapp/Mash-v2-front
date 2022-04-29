import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
