import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:http/http.dart' as http;
import 'package:mash/configs/base_url.dart';
import 'package:mash/main.dart';
import 'package:mash/noti/notification_model.dart';
import 'package:mash/screens/auth/API/get_profile_picture.dart';
import 'package:mash/screens/auth/API/refresh_token.dart';
import 'package:mash/screens/auth/introduce_your_self.dart';
import 'package:mash/screens/auth/location_screen.dart';
import 'package:mash/screens/auth/mobile_number_screen.dart';
import 'package:mash/screens/auth/models/user_post_apple_model.dart';
import 'package:mash/screens/auth/models/user_post_data_model.dart';
import 'package:mash/screens/home/home_screen.dart';
import 'package:mash/screens/profile_view/API/upload_profile.dart';
import 'package:mash/screens/profile_view/models/intrest_model.dart';
import 'package:mash/screens/profile_view/models/profile_model.dart';
import 'package:mash/widgets/error_snackbar.dart';

import '../../../configs/app_colors.dart';
import '../models/user_get_data_model.dart';

class AuthController extends GetxController with SingleGetTickerProviderMixin {
  Rx<TextEditingController> fullName = TextEditingController().obs;
  Rx<TextEditingController> height = TextEditingController().obs;
  Rx<TextEditingController> school = TextEditingController().obs;
  Rx<TextEditingController> interest = TextEditingController().obs;
  Rx<TextEditingController> mobileNumber = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> bioController = TextEditingController().obs;
  TextEditingController otpNumber = TextEditingController();
  Rx<TextEditingController> pinPutController = TextEditingController().obs;
  RxString otpCode = ''.obs;
  RxString countryCode = ''.obs;
  Rx<DateTime> dob = DateTime.now().subtract(Duration(days: 6570)).obs;
  Rx<String>? newDateOfBirth;
  RxString gender = "Male".obs;
  RxString groupNo = "".obs;
  RxString genderFinal = "".obs;
  List<Interest> intrestDataForIntroduce = [];
  RxString genderPre = "Male".obs;
  RxString pronoun = "He/Him/His".obs;
  RxString firebaseToken = "".obs;
  RxBool loading = false.obs;
  RxBool profileLoading = true.obs;
  RxDouble lat = 0.0.obs;
  RxDouble lon = 0.0.obs;
  RxInt ft = 0.obs;
  RxInt inches = 0.obs;
  RxBool readOnlyEmail = false.obs;
  RxBool logged = false.obs;
  RxString accessToken = "".obs;
  RxString refreshToken = "".obs;
  Rx<DataUser> user = DataUser().obs;
  RxString profileUrl = "".obs;
  RxString coverUrl = "".obs;
  RxString apiMessage = "".obs;
  RxBool profileUploading = false.obs;
  RxBool coverPhotoUploading = false.obs;
  RxBool covidVaccinated = false.obs;
  RxList<Interest> interestList = <Interest>[].obs;
  RxList<String> userMedia = <String>[].obs;
  RxDouble distance = 1.0.obs;
  RxDouble minAge = 18.0.obs;
  RxBool isAgeSelected = false.obs;
  RxDouble maxAge = 65.0.obs;
  Rx<TextEditingController> location = TextEditingController().obs;
  RxList<AutocompletePrediction> pred = <AutocompletePrediction>[].obs;
  RxBool showLocation = false.obs;
  RxList<Marker> friendsMarker = <Marker>[].obs;
  RxInt swipeStatus = 2.obs;
  RxString swipeId = "0".obs;
  RxBool isLocationEnabled = true.obs;
  RxInt bottomIndex = 0.obs;
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;

  late Rx<TabController> feedTabController =
      TabController(length: 2, vsync: this).obs;
  late Rx<TabController> friendController =
      TabController(length: 2, vsync: this).obs;
  late Rx<TabController> discoverController =
      TabController(length: 2, vsync: this).obs;

  refreshProfile() async {
    authController.profileUrl.value =
        await getProfile(authController.user.value.id);
    print("PROFILE URL ::: ${authController.profileUrl.value}");
  }

  refreshCoverPhoto() async {
    ///TODO
    authController.coverUrl.value =
        await getCoverPhoto(authController.user.value.id);
    print("COVER URL ::: ${authController.coverUrl.value}");
  }

  checkAuth() async {
    final box = GetStorage();
    if (box.read("uuid") != null) {
      logged.value = true;
      accessToken.value = box.read("accessToken");
      refreshToken.value = box.read("refreshToken");
    } else {
      FirebaseAuth.instance.signOut();
      logged.value = false;
    }
  }

  getIntrestData() async {
    var headers = {'accept': '*/*'};
    var request = http.Request(
        'GET', Uri.parse('${WebApi.baseUrlNew}/api/User/GetAllInterests'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var resp = await http.Response.fromStream(response);
      List data = jsonDecode(resp.body) as List;
      intrestDataForIntroduce.clear();
      List<InterestModel> intrestData =
          data.map((e) => InterestModel.fromJson(e)).toList();
      intrestData.forEach((element) {
        intrestDataForIntroduce.add(
          Interest(
              title: element.name!.obs,
              bgColor: Colors.white.obs,
              borderColor: AppColors.kOrange.obs,
              isSelected: false.obs,
              id: element.id!),
        );
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  loginMethod(String fT, bool link, String loginMethod, {String? uuid}) async {
    firebaseToken.value = fT;
    print(fT);

    authController.loading.value = true;
    // var response = await http.get(
    //   Uri.parse(
    //       "http://uttamughareja-001-site4.ftempurl.com/api/User/GetUserByUid?uid=hJOhGjn4yvSsy7mVxPDA2uljUun3"),
    // );//hJOhGjn4yvSsy7mVxPDA2uljUun3
    var headers = {'accept': '*/*'};
    var request = http.Request('GET',
        Uri.parse('${WebApi.baseUrlNew}/api/User/GetUserByUid?uid=${uuid}'));

    request.headers.addAll(headers);

    http.StreamedResponse re = await request.send();

    if (re.statusCode == 200) {
      logged.value = true;
      getIntrestData();
      authController.loading.value = false;

      var resp = await http.Response.fromStream(re);
      var data = jsonDecode(resp.body);

      final box = GetStorage();
      box.write("uuid", data["data"]["uid"]);
      box.write("userId", data["data"]["id"]);
      if (data["data"]["isNew"] == true) {
        box.write("userId", data["data"]["id"]);

        Get.to(() => IntroduceYourSelf(
              loginMethod: loginMethod,
            ));
      } else {
        // Get.to(() => IntroduceYourSelf(
        //       loginMethod: loginMethod,
        //     ));
        refreshTokenService();
        Get.to(() => HomeScreen());
      }
    } else {
      authController.loading.value = false;

      errorSnackBar("Something went wrong", "Please try again later");
    }

    // authController.loading.value = false;
    // print("Status Code ::: ${response.statusCode}");
    // print("Response ::: ${response.body}");
    // if (response.statusCode == 200) {
    //   var data = jsonDecode(response.body);
    //   if (data["success"] == -1) {
    //     if (link) {
    //       Get.to(() => MobileNumberScreen(
    //             link: link,
    //           ));
    //     } else {
    //       if (loginMethod == "apple") {
    //         //authController.signUpMethod(null, "apple");
    //         // Get.to(() => IntroduceYourSelf(
    //         //       loginMethod: loginMethod,
    //         //     ));
    //       } else {
    //         Get.to(() => IntroduceYourSelf(
    //               loginMethod: loginMethod,
    //             ));
    //       }
    //     }
    //   } else {
    //     final box = GetStorage();
    //     box.write("accessToken", data["accessToken"]);
    //     box.write("refreshToken", data["refressToken"]);
    //     FirebaseAuth.instance
    //         .signInWithCustomToken(data["firebaseCustomToken"]);
    //     authController.checkAuth();
    //     refreshTokenService();
    //     Get.to(() => HomeScreen());
    //   }
    // } else {
    //   // errorSnackBar("Something went wrong", "Please try again later");
    //   ///ToDo:UNCOMMENT
    //   Get.to(() => IntroduceYourSelf(
    //         loginMethod: loginMethod,
    //       ));
    // }
  }

  signUpMethod(File? file, String loginMethod) async {
    final box = GetStorage();
    UserPostDataModel userPostDataModel = UserPostDataModel(
        userData: UserData(
            fullName: fullName.value.text,
            dobTimestamp: dob.value.millisecondsSinceEpoch ~/ 1000,
            email: "test123@gmail.com", //emailController.value.text,
            phone: int.parse("1${mobileNumber.value.text}"),
            gender: gender.value[0]),
        firebaseToken: firebaseToken.value);
    UserPostAppleDataModel userPostAppleDataModel = UserPostAppleDataModel(
        userData: UserAppleData(
            fullName: fullName.value.text,
            dobTimestamp: dob.value.millisecondsSinceEpoch ~/ 1000,
            email: "test123@gmail.com", // emailController.value.text,
            gender: gender.value[0]),
        firebaseToken: firebaseToken.value);
    print(userPostDataModel.toJson());
    authController.loading.value = true;
    var response = await http.post(Uri.parse(WebApi.baseUrl + WebApi.signUpUrl),
        headers: {'Content-Type': 'application/json'},
        body: loginMethod == "apple" || loginMethod == "facebook"
            ? jsonEncode(userPostAppleDataModel.toJson())
            : jsonEncode(userPostDataModel.toJson()));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201) {
      var data = jsonDecode(response.body);
      box.write("accessToken", data["accessToken"]);
      box.write("refreshToken", data["refressToken"]);
      FirebaseAuth.instance.signInWithCustomToken(data["firebaseCustomToken"]);
      authController.checkAuth();
      await refreshTokenService();
      if (file != null) {
        await uploadProfile(file.path).then((value) async {
          await Future.delayed(Duration(seconds: 3));
          await authController.refreshProfile();
          authController.profileUploading.value = false;
        });
      }
      authController.loading.value = false;
      Get.to(() => LocationEnable());
    } else {
      errorSnackBar("Something went wrong", "Please try again!");

      Get.to(() => LocationEnable());
    }
  }

  @override
  void onInit() {
    checkAuth();
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    if (logged.value) {
      refreshTokenService();
    }
    // TODO: implement onReady
    super.onReady();
  }
}

class InterestModel {
  String? name;
  int? displayOrder;
  int? id;

  InterestModel({this.name, this.displayOrder, this.id});

  InterestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    displayOrder = json['displayOrder'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['displayOrder'] = this.displayOrder;
    data['id'] = this.id;
    return data;
  }
}
