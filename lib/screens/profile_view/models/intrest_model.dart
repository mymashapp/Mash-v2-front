import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Interest {
  Rx<String> title;
  int id;
  Rx<Color> bgColor;
  Rx<Color> borderColor;
  Rx<bool> isSelected;

  Interest(
      {required this.title,
      required this.bgColor,
      required this.id,
      required this.borderColor,
      required this.isSelected});
}
