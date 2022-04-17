import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mash/configs/app_colors.dart';
import 'package:mash/main.dart';
import 'package:mash/screens/profile_view/API/upload_profile.dart';

import '../../profile_view/API/get_profile.dart';

profileUploadingDialog() {
  Get.dialog(Dialog(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              XFile? res =
                  await ImagePicker().pickImage(source: ImageSource.camera);
              if (res != null) {
                Get.back();
                File? file = await ImageCropper.cropImage(
                    sourcePath: res.path,
                    compressQuality: 100,
                    maxHeight: 1000,
                    maxWidth: 1000,
                    aspectRatio: CropAspectRatio(ratioX: 5, ratioY: 5),
                    aspectRatioPresets: [
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio3x2,
                      CropAspectRatioPreset.original,
                      CropAspectRatioPreset.ratio4x3,
                      CropAspectRatioPreset.ratio16x9
                    ],
                    androidUiSettings: AndroidUiSettings(
                        toolbarTitle: 'Cropper',
                        toolbarColor: Colors.deepOrange,
                        toolbarWidgetColor: Colors.white,
                        cropGridColumnCount: 9,
                        cropGridRowCount: 9,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false));
                authController.profileUploading.value = true;
                if (file != null) {
                  await uploadProfile(file.path).then((value) async {
                    getMe(isFromProfileUpdate: true);
                    await Future.delayed(Duration(seconds: 3));
                    //await authController.refreshProfile();
                    authController.profileUploading.value = false;
                  });
                }
              }
            },
            child: SizedBox(
                height: 60,
                child: Icon(
                  Icons.camera,
                  color: AppColors.kOrange,
                  size: 60,
                )),
          ),
          SizedBox(
            width: 16,
          ),
          InkWell(
            onTap: () async {
              XFile? res =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (res != null) {
                Get.back();
                File? file = await ImageCropper.cropImage(
                    sourcePath: res.path,
                    aspectRatioPresets: [
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio3x2,
                      CropAspectRatioPreset.original,
                      CropAspectRatioPreset.ratio4x3,
                      CropAspectRatioPreset.ratio16x9
                    ],
                    androidUiSettings: AndroidUiSettings(
                        toolbarTitle: 'Cropper',
                        toolbarColor: Colors.deepOrange,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: true),
                    iosUiSettings: IOSUiSettings(
                        minimumAspectRatio: 1.0,
                        aspectRatioLockEnabled: false));
                authController.profileUploading.value = true;
                if (file != null) {
                  await uploadProfile(file.path).then((value) async {
                    getMe(isFromProfileUpdate: true);
                    await Future.delayed(Duration(seconds: 3));
                    //await authController.refreshProfile();
                    authController.profileUploading.value = false;
                  });
                }
              }
            },
            child: SizedBox(
              height: 60,
              child: Icon(
                Icons.add_photo_alternate_outlined,
                color: AppColors.kOrange,
                size: 60,
              ),
            ),
          ),
        ],
      ),
    ),
  ));
}
