import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mash/configs/base_url.dart';
import 'package:mash/main.dart';
import 'package:mash/noti/set_fcm_token.dart';
import 'package:mash/screens/auth/models/user_get_data_model.dart';
import 'package:mash/screens/auth/models/user_post_data_model.dart';
import 'package:mash/screens/profile_view/models/profile_model.dart';
import 'package:mash/screens/profile_view/profile_view.dart';

import '../../../configs/app_colors.dart';
import '../../../widgets/error_snackbar.dart';
import '../../auth/introduce_your_self.dart';
import '../models/intrest_model.dart';

getProfileDetails() async {
  authController.loading.value = true;
  // var response = await http.get(
  //   Uri.parse(
  //       "http://uttamughareja-001-site4.ftempurl.com/api/User/GetUserByUid?uid=hJOhGjn4yvSsy7mVxPDA2uljUun3"),
  // );
  var headers = {'accept': '*/*'};
  final box = GetStorage();
  String uuid = box.read("uuid");
  var request = http.Request('GET',
      Uri.parse('${WebApi.baseUrlNew}/api/User/GetUserByUid?uid=${uuid}'));

  request.headers.addAll(headers);

  http.StreamedResponse re = await request.send();

  if (re.statusCode == 200) {
    http.ByteStream stream = await re.stream;
    authController.profileLoading.value = false;

    var resp = await http.Response.fromStream(re);
    UserDataModel userDataModel = UserDataModel.fromJson(jsonDecode(resp.body));
    DataUser apiUser = userDataModel.data!;
    authController.user.value = apiUser;
    //authController.covidVaccinated.value = apiUser.vaccinationStatus == 1;
    //authController.dob.value = apiUser.dateOfBirth!;
    if (apiUser.preferenceGender != null) {
      //authController.location.value.text = apiUser.userBasicExtra!.location!;
      apiUser.interests!.forEach((element) {
        authController.interestList.value.add(Interest(
            title: element.interestName!.obs,
            bgColor: Colors.white.obs,
            borderColor: AppColors.kOrange.obs,
            isSelected: false.obs,
            id: element.id!));
      });
      // authController.interestList.value = apiUser.interests!;
    }
    //authController.distance.value = apiUser.distance!.toDouble();
    if (apiUser.preferenceAgeFrom != null && apiUser.preferenceAgeTo != null) {
      authController.minAge.value = apiUser.preferenceAgeFrom!.toDouble();
      authController.maxAge.value = apiUser.preferenceAgeTo!.toDouble();
    }
    authController.gender.value = apiUser.gender == 0
        ? "Male"
        : apiUser.gender == 1
            ? "Female"
            : "Non-Binary";
    //authController.showLocation.value = apiUser.showLocation == 1;
    authController.genderPre.value = apiUser.preferenceGender == 0
        ? "Man"
        : apiUser.preferenceGender == 1
            ? "Woman"
            : "Both";
    setFcmToken();

    authController.refreshProfile();
    authController.refreshCoverPhoto();
  } else {
    authController.profileLoading.value = false;

    errorSnackBar("Something went wrong", "Please try again later");
  }

  // authController.profileLoading.value = true;
  // var response = await http.get(WebApi.getProfile,
  //     headers: {"Authorization": "Bearer ${authController.accessToken.value}"});
  // authController.profileLoading.value = false;
  // print("USER ::: ${response.statusCode}");
  // print("USER ::: ${response.body}");
}

getMe({bool isFromProfileUpdate = false}) async {
  if (!isFromProfileUpdate) {
    authController.profileLoading.value = true;
  }
  final box = GetStorage();
  String uuid = box.read("uuid");
  var headers = {'accept': '*/*'};
  var request = http.Request('GET',
      Uri.parse('${WebApi.baseUrlNew}/api/User/GetUserByUid?uid=${uuid}'));

  request.headers.addAll(headers);

  http.StreamedResponse re = await request.send();

  if (re.statusCode == 200) {
    http.ByteStream stream = await re.stream;

    var resp = await http.Response.fromStream(re);
    UserDataModel userDataModel = UserDataModel.fromJson(jsonDecode(resp.body));
    DataUser apiUser = userDataModel.data!;
    authController.user.value = apiUser;
    if (!isFromProfileUpdate) {
      authController.profileLoading.value = false;
    }

    //authController.covidVaccinated.value = apiUser.vaccinationStatus == 1;
//2022-04-15T15:17:57.008
    try {
      DateTime newDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss")
          .parse(apiUser.dateOfBirth.toString());
      authController.newDateOfBirth =
          DateFormat("dd-MM-yyyy").format(newDate).obs;
    } catch (e) {
      print(e);
    }

    if (!isNullEmptyOrFalse(apiUser.pictures)) {
      apiUser.pictures?.forEach((element) {
        if (element.pictureType == 1) {
          if (!isNullEmptyOrFalse(element.url)) {
            authController.profileUrl.value =
                WebApi.baseUrlNew + "/" + element.url.toString();
          }
        }
        if (element.pictureType == 2) {
          if (!isNullEmptyOrFalse(element.url)) {
            authController.coverUrl.value =
                WebApi.baseUrlNew + "/" + element.url.toString();
          }
        }
      });
    }
    authController.profileUploading.value = false;
    if (apiUser.interests != null) {
      //authController.location.value.text = apiUser.userBasicExtra!.location!;
      apiUser.interests!.forEach((element) {
        authController.interestList.value.add(Interest(
            title: element.interestName!.obs,
            bgColor: Colors.white.obs,
            borderColor: AppColors.kOrange.obs,
            isSelected: false.obs,
            id: element.id!));
      });
      print(authController.interestList.value);
      // authController.interestList.value = apiUser.interests!;
    }
    //authController.distance.value = apiUser.distance!.toDouble();
    if (apiUser.preferenceAgeFrom != null && apiUser.preferenceAgeTo != null) {
      authController.minAge.value = apiUser.preferenceAgeFrom!.toDouble();
      authController.maxAge.value = (apiUser.preferenceAgeTo == 0)
          ? 32.0
          : apiUser.preferenceAgeTo!.toDouble();
    }
    authController.gender.value = apiUser.gender == 0
        ? "Male"
        : apiUser.gender == 1
            ? "Female"
            : "Non-Binary";
    //authController.showLocation.value = apiUser.showLocation == 1;
    authController.genderPre.value = apiUser.preferenceGender == 0
        ? "Man"
        : apiUser.preferenceGender == 1
            ? "Woman"
            : "Both";
    setFcmToken();

    // authController.refreshProfile();
    // authController.refreshCoverPhoto();
  } else {
    if (!isFromProfileUpdate) {
      authController.profileLoading.value = false;
    }

    errorSnackBar("Something went wrong", "Please try again later");
  }
}
