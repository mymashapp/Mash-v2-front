import 'dart:convert';
import 'dart:io' as IO;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mash/screens/auth/models/user_get_data_model.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/app_textfield.dart';
import '../../../main.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/blur_loader.dart';
import '../../../widgets/error_snackbar.dart';
import '../../../widgets/spacers.dart';
import '../../configs/base_url.dart';
import '../profile_view/models/intrest_model.dart';
import 'API/refresh_token.dart';
import 'location_screen.dart';

List<String> genders = ["Male", "Female"];
// List<String> genders = ["Male", "Female", "Non-Binary"];

class IntroduceYourSelf extends StatefulWidget {
  final String loginMethod;

  const IntroduceYourSelf({Key? key, required this.loginMethod})
      : super(key: key);

  @override
  _IntroduceYourSelfState createState() => _IntroduceYourSelfState();
}

class _IntroduceYourSelfState extends State<IntroduceYourSelf> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? res;
  File? profile;
  List<Interest> selectedInterest = [];
  @override
  Widget build(BuildContext context) {
    List<String> genderList = ["Man", "Woman", "Both"];
    List<String> genderFinalList = ["Man", "Woman", "Both"];
    List<String> groupList = [
      "Group of 2",
      "Group of 3",
    ];

    List<Interest> interestList = authController.intrestDataForIntroduce;

    List<Widget> interestWidget() {
      List<Widget> interests = [];
      for (int i = 0; i < interestList.length; i++) {
        Widget interest = Obx(() {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: FilterChip(
              label: Text(interestList[i].title.value),
              backgroundColor: interestList[i].bgColor.value,
              side: BorderSide(
                color: interestList[i].borderColor.value,
              ),
              avatarBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              onSelected: (bool value) {
                setState(() {
                  interestList[i].isSelected.value = value;
                  if (value == true) {
                    if (selectedInterest.length < 3) {
                      interestList[i].borderColor = Colors.transparent.obs;
                      interestList[i].bgColor = AppColors.kOrange.obs;
                      selectedInterest.add(interestList[i]);
                    } else {
                      interestList[i].isSelected.value = false;

                      errorSnackBar("Only 3 Interests are Allowed.",
                          "Please remove other interest to add new.");
                    }
                  } else {
                    interestList[i].bgColor = Colors.white.obs;
                    interestList[i].borderColor = AppColors.kOrange.obs;
                    selectedInterest.remove(interestList[i].title.value);
                  }
                });
              },
              showCheckmark: false,
              selected: interestList[i].isSelected.value,
              selectedColor: AppColors.kOrange,
            ),
          );
        });
        interests.add(interest);
      }
      return interests;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Introduce Yourself",
          style: GoogleFonts.sourceSansPro(
              fontSize: 20.sp, color: AppColors.kOrange),
        ),
      ),
      body: Stack(
        children: [
          Obx(() {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    y32,
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        profile != null
                            ? Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.shadowColor,
                                          blurRadius: 60,
                                          offset: Offset(4, 24))
                                    ],
                                    image: DecorationImage(
                                        image: FileImage(File(profile!.path)),
                                        fit: BoxFit.cover),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.kOrange, width: 4)),
                              )
                            : Image.asset("assets/person_icon.png"),
                        InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            Get.dialog(Dialog(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        res = await ImagePicker().pickImage(
                                            source: ImageSource.camera);
                                        if (res != null) {
                                          Get.back();

                                          profile =
                                              await ImageCropper.cropImage(
                                                  sourcePath: res!.path,
                                                  aspectRatioPresets: [
                                                    CropAspectRatioPreset
                                                        .square,
                                                    CropAspectRatioPreset
                                                        .ratio3x2,
                                                    CropAspectRatioPreset
                                                        .original,
                                                    CropAspectRatioPreset
                                                        .ratio4x3,
                                                    CropAspectRatioPreset
                                                        .ratio16x9
                                                  ],
                                                  androidUiSettings:
                                                      AndroidUiSettings(
                                                          toolbarTitle:
                                                              'Cropper',
                                                          toolbarColor:
                                                              Colors.deepOrange,
                                                          toolbarWidgetColor:
                                                              Colors.white,
                                                          initAspectRatio:
                                                              CropAspectRatioPreset
                                                                  .original,
                                                          lockAspectRatio:
                                                              false),
                                                  iosUiSettings: IOSUiSettings(
                                                    minimumAspectRatio: 1.0,
                                                  ));
                                        }
                                        setState(() {});
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
                                        res = await ImagePicker().pickImage(
                                            source: ImageSource.gallery);
                                        if (res != null) {
                                          Get.back();
                                          profile =
                                              await ImageCropper.cropImage(
                                                  sourcePath: res!.path,
                                                  aspectRatioPresets: [
                                                    CropAspectRatioPreset
                                                        .square,
                                                    CropAspectRatioPreset
                                                        .ratio3x2,
                                                    CropAspectRatioPreset
                                                        .original,
                                                    CropAspectRatioPreset
                                                        .ratio4x3,
                                                    CropAspectRatioPreset
                                                        .ratio16x9
                                                  ],
                                                  androidUiSettings:
                                                      AndroidUiSettings(
                                                          toolbarTitle:
                                                              'Cropper',
                                                          toolbarColor:
                                                              Colors.deepOrange,
                                                          toolbarWidgetColor:
                                                              Colors.white,
                                                          initAspectRatio:
                                                              CropAspectRatioPreset
                                                                  .original,
                                                          lockAspectRatio:
                                                              false),
                                                  iosUiSettings: IOSUiSettings(
                                                    minimumAspectRatio: 1.0,
                                                  ));
                                        }
                                        setState(() {});
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
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.kOrange, width: 3)),
                            child: Icon(
                              Icons.add,
                              color: AppColors.kOrange,
                            ),
                          ),
                        )
                      ],
                    ),
                    y32,
                    Obx(() => appTextField(
                        hintText: "Your full name",
                        isFromSelf: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Required";
                          }
                        },
                        controller: authController.fullName.value)),
                    // y16,
                    // appTextField(
                    //     controller: authController.emailController.value,
                    //     hintText: "Enter your email",
                    //     validator: (value) {
                    //       if (value!.isEmpty) {
                    //         return "Required";
                    //       } else if (!GetUtils.isEmail(value)) {
                    //         return "Invalid email address";
                    //       }
                    //     },
                    //     readOnly: authController.readOnlyEmail.value),
                    y16,
                    InkWell(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: authController.dob.value,
                            firstDate: DateTime(1950),
                            lastDate:
                                DateTime.now().subtract(Duration(days: 6570)));
                        if (pickedDate != null) {
                          authController.dob.value = pickedDate;
                        }
                      },
                      child: Obx(() => Container(
                            alignment: Alignment.centerLeft,
                            height: 55,
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: AppColors.kOrange,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Enter your Date of Birth",
                                  style:
                                      GoogleFonts.sourceSansPro(fontSize: 16),
                                ),
                                Text(
                                  DateFormat("MM/dd/yyyy")
                                      .format(authController.dob.value)
                                      .toString(),
                                  style:
                                      GoogleFonts.sourceSansPro(fontSize: 16),
                                )
                              ],
                            ),
                          )),
                    ),
                    y16,
                    Obx(
                      () => Container(
                        height: 55,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.kOrange,
                          ),
                        ),
                        child: DropdownButton<String>(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          isExpanded: true,
                          value: authController.gender.value.isEmpty
                              ? null
                              : authController.gender.value,
                          hint: Text("Select your Gender"),
                          onChanged: (value) {
                            authController.gender.value = value!;
                          },
                          underline: SizedBox(),
                          items: List.generate(
                            genders.length,
                            (index) => DropdownMenuItem(
                              child: Text(
                                genders[index],
                                style: GoogleFonts.sourceSansPro(),
                              ),
                              value: genders[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                    y16,
                    appTextField(
                      controller: authController.emailController.value,
                      hintText: "Enter your email",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required";
                        } else if (!GetUtils.isEmail(value)) {
                          return "Invalid email address";
                        }
                      },
                      readOnly: authController.readOnlyEmail.value,
                    ),
                    y16,
                    appTextField(
                      controller: authController.bioController.value,
                      hintText: "Enter your Bio",
                      maxLine: 6,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required";
                        } else {
                          return null;
                        }
                      },
                    ),
                    y16,
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        for (int i = 0; i < interestList.length; i++) {
                          authController.interestList.forEach((element) {
                            if (element == interestList[i].title.value) {
                              setState(() {
                                interestList[i].isSelected.value = true;
                                selectedInterest.add(interestList[i]);
                              });
                            }
                          });
                        }
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Wrap(
                                      spacing: 10,
                                      children: interestWidget(),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: AppColors.kOrange,
                                        ),
                                        onPressed: () {
                                          if (selectedInterest.length < 3) {
                                            errorSnackBar(
                                                "Minimum 3 interest is required",
                                                "Please add at least 3 interest to your profile");
                                          } else {
                                            authController.interestList.value =
                                                selectedInterest;
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text("Submit")),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Container(
                        width: Get.width,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.kOrange),
                        ),
                        child: Text(
                          "Select Top 3 Interests",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    y16,
                    InkWell(
                        onTap: () {
                          for (int i = 0; i < interestList.length; i++) {
                            authController.interestList.forEach((element) {
                              if (element == interestList[i].title.value) {
                                setState(() {
                                  interestList[i].isSelected.value = true;
                                  selectedInterest.add(interestList[i]);
                                });
                              }
                            });
                          }
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Wrap(
                                        spacing: 10,
                                        children: interestWidget(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: AppColors.kOrange,
                                          ),
                                          onPressed: () {
                                            if (selectedInterest.length < 3) {
                                              errorSnackBar(
                                                  "Minimum 3 interest is required",
                                                  "Please add at least 3 interest to your profile");
                                            } else {
                                              authController.interestList
                                                  .value = selectedInterest;
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text("Submit")),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Center(child: Text("Add interest"))),
                    authController.interestList.length == 0
                        ? Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: Text("No Interest Added")),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Wrap(
                              runAlignment: WrapAlignment.start,
                              spacing: 10,
                              runSpacing: 10,
                              children: List.generate(
                                  authController.interestList.length,
                                  (index) => Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: AppColors.kOrange,
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              authController
                                                  .interestList[index].title
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                authController.interestList
                                                    .remove(authController
                                                        .interestList[index]);
                                                // authController.interestList
                                                //     .remove(authController
                                                //         .interestList[index]);
                                              },
                                              child: Icon(
                                                Icons.close,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                            ),
                          ),
                    y16,
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState2) => AlertDialog(
                                  insetPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  content: Container(
                                    width: 300.w,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Preferences",
                                          style: GoogleFonts.sourceSansPro(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1)),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Age",
                                                    style: GoogleFonts
                                                        .sourceSansPro(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  Text(
                                                    "${authController.minAge.value.toInt()} - ${authController.maxAge.value.toInt()}",
                                                    style: GoogleFonts
                                                        .sourceSansPro(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  )
                                                ],
                                              ),
                                              RangeSlider(
                                                values: RangeValues(
                                                    authController.minAge.value,
                                                    authController
                                                        .maxAge.value),
                                                onChanged: (v) {
                                                  if (v.start < v.end &&
                                                      (v.end - v.start >= 3)) {
                                                    authController
                                                        .minAge.value = v.start;
                                                    authController
                                                        .maxAge.value = v.end;
                                                    authController.isAgeSelected
                                                        .value = true;
                                                  }

                                                  setState2(() {});
                                                },
                                                inactiveColor: Colors.grey,
                                                activeColor: AppColors.kOrange,
                                                min: 18,
                                                max: 65,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Obx(() {
                                          return Container(
                                            height: 55,
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                color: AppColors.kOrange,
                                              ),
                                            ),
                                            child: DropdownButton<String>(
                                              // onTap: () {
                                              //   FocusScope.of(context).unfocus();
                                              //
                                              // },
                                              isExpanded: true,
                                              value: authController
                                                      .genderFinal.value.isEmpty
                                                  ? null
                                                  : authController
                                                      .genderFinal.value,
                                              hint: Text("Select Gender"),
                                              onChanged: (value) {
                                                authController
                                                    .genderFinal.value = value!;
                                                setState2(() {});
                                              },
                                              underline: SizedBox(),
                                              items: List.generate(
                                                genderFinalList.length,
                                                (index) => DropdownMenuItem(
                                                  child: Text(
                                                    genderFinalList[index],
                                                    style: GoogleFonts
                                                        .sourceSansPro(),
                                                  ),
                                                  value: genderFinalList[index],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Obx(() {
                                          return Container(
                                            height: 55,
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                color: AppColors.kOrange,
                                              ),
                                            ),
                                            child: DropdownButton<String>(
                                              // onTap: () {
                                              //   FocusScope.of(context).unfocus();
                                              //
                                              // },
                                              isExpanded: true,
                                              value: authController
                                                      .groupNo.value.isEmpty
                                                  ? null
                                                  : authController
                                                      .groupNo.value,
                                              hint: Text("Select Group"),
                                              onChanged: (value) {
                                                authController.groupNo.value =
                                                    value!;
                                                setState2(() {});
                                              },
                                              underline: SizedBox(),
                                              items: List.generate(
                                                groupList.length,
                                                (index) => DropdownMenuItem(
                                                  child: Text(
                                                    groupList[index],
                                                    style: GoogleFonts
                                                        .sourceSansPro(),
                                                  ),
                                                  value: groupList[index],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 55,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.kOrange,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Add Preferences",
                              style: GoogleFonts.sourceSansPro(fontSize: 16),
                            ),
                            // Text(
                            //   DateFormat("MM/dd/yyyy")
                            //       .format(authController.dob.value)
                            //       .toString(),
                            //   style: GoogleFonts.sourceSansPro(fontSize: 16),
                            // )
                          ],
                        ),
                      ),
                    ),
                    (authController.isAgeSelected.value ||
                            authController.groupNo.value != "" ||
                            authController.genderPre.value != "")
                        ? y16
                        : SizedBox(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // alignment: WrapAlignment.start,
                      children: [
                        if (authController.isAgeSelected.value)
                          Text(
                            "Age Range : ${authController.minAge.value.round().toStringAsFixed(2)} - ${authController.maxAge.value.round().toStringAsFixed(2)}",
                            style: GoogleFonts.sourceSansPro(fontSize: 16),
                          ),
                        if (authController.groupNo.value != "")
                          Text(
                            "Group Size : ${authController.groupNo.value}",
                            style: GoogleFonts.sourceSansPro(fontSize: 16),
                          ),
                        if (authController.genderPre.value != "")
                          Text(
                            "Gender : ${authController.genderPre.value}",
                            style: GoogleFonts.sourceSansPro(fontSize: 16),
                          ),
                      ],
                    ),
                    y16,

                    // Obx(() => Container(
                    //       height: 55,
                    //       alignment: Alignment.centerLeft,
                    //       padding: EdgeInsets.symmetric(horizontal: 10.w),
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(8.r),
                    //         border: Border.all(
                    //           color: AppColors.kOrange,
                    //         ),
                    //       ),
                    //       child: DropdownButton<String>(
                    //         isExpanded: true,
                    //         value: authController.pronoun.value,
                    //         onChanged: (value) {
                    //           authController.pronoun.value = value!;
                    //         },
                    //         underline: SizedBox(),
                    //         items: List.generate(
                    //           pronouns.length,
                    //           (index) => DropdownMenuItem(
                    //             child: Text(
                    //               pronouns[index],
                    //               style: GoogleFonts.sourceSansPro(),
                    //             ),
                    //             value: pronouns[index],
                    //           ),
                    //         ),
                    //       ),
                    //     )),
                    // SizedBox(
                    //   height: Get.height / 4.4,
                    // ),
                    appButton(
                      onTap: () async {
                        FocusScope.of(context).unfocus();

                        if (_formKey.currentState!.validate()) {
                          final box = GetStorage();

                          // UserDataModel user = UserDataModel();
                          DataUser userData = DataUser();
                          userData.uid = box.read("uuid");
                          // userData.uid = "hJOhGjn4yvSsy7mVxPDA2uljUun3";
                          userData.id = box.read("userId");
                          userData.name = authController.fullName.value.text;
                          userData.email =
                              authController.emailController.value.text;
                          userData.email =
                              authController.emailController.value.text;
                          userData.isNew = true;
                          userData.dateOfBirth =
                              authController.dob.value.toIso8601String();
                          List<Interests> list = [];
                          List<int> listOfId = [];
                          selectedInterest.forEach((element) {
                            list.add(Interests(
                                interestId: element.id,
                                interestName: element.title.value));
                            listOfId.add(element.id);
                          });
                          userData.interests = list;
                          userData.selectedInterestIds = listOfId;
                          userData.profilePictureId = 0;
                          userData.gender =
                              authController.gender.value == "Male"
                                  ? 1
                                  : authController.gender.value == "Female"
                                      ? 2
                                      : 3;
                          userData.preferenceGroupOf =
                              authController.genderPre.value == "Male"
                                  ? 1
                                  : authController.genderPre.value == "Female"
                                      ? 2
                                      : 3;
                          userData.preferenceGroupOf =
                              authController.gender.value == "Group of 2"
                                  ? 2
                                  : 3;
                          userData.bio =
                              authController.bioController.value.text;
                          userData.preferenceAgeTo =
                              authController.maxAge.toInt();
                          userData.preferenceAgeFrom =
                              authController.minAge.toInt();
                          authController.loading.value = true;
                          userData.dateOfBirth =
                              authController.dob.value.toIso8601String();
                          if (profile != null) {
                            final bytes = await profile?.readAsBytes();
                            final b64img = base64.encode(bytes!);
                            //final bytes = profile?.readAsBytesSync();
                            String base64Image =
                                "data:image/png;base64," + b64img;

                            Pictures p =
                                Pictures(pictureType: 1, url: base64Image);
                            userData.uploadedPictures = [p];
                            userData.pictures = [
                              Pictures(pictureType: 1, url: "")
                            ];
                          }
                          //  user.data = userData;

                          var headers = {
                            'accept': '*/*',
                            'Content-Type': 'application/json'
                          };
                          var request = http.Request(
                              'PUT',
                              Uri.parse(
                                  '${WebApi.baseUrlNew}/api/User/Update'));
                          request.body = json.encode(userData.toJson());

                          request.headers.addAll(headers);

                          http.StreamedResponse response = await request.send();
                          authController.loading.value = false;

                          if (response.statusCode == 200) {
                            print(await response.stream.bytesToString());
                            Get.to(() => LocationEnable());
                            refreshTokenService();
                          } else {
                            print(response.reasonPhrase);
                          }

                          // await FirebaseAuth.instance.currentUser!
                          //     .linkWithCredential(EmailAuthProvider.credential(
                          //         email:
                          //             authController.emailController.value.text,
                          //         password: "123456"))
                          //     .catchError((e) {
                          //   errorSnackBar("Email is already in use.",
                          //       "Please try using different email");
                          //   print("ERROR ::: $e");
                          // });
                          // authController.firebaseToken.value = await FirebaseAuth
                          //     .instance.currentUser!
                          //     .getIdToken();
                          // authController.signUpMethod(
                          //     profile, widget.loginMethod);
                          // // Get.to(() => LocationEnable());
                          // authController.signUpMethod(
                          //     profile, widget.loginMethod);

                        }
                      },
                      buttonBgColor: AppColors.kOrange,
                      buttonName: "NEXT",
                      textColor: Colors.white,
                    ),
                    y32
                  ],
                ),
              ),
            );
          }),
          Obx(() => authController.loading.value ? blurLoader() : SizedBox())
        ],
      ),
    );
  }
}
