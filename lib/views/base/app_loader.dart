import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mash_flutter/constants/app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        alignment: Alignment.center,
        color: AppColor.orange.withOpacity(0.5),
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }
}
