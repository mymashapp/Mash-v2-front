import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mash_flutter/constants/app_colors.dart';
import 'package:mash_flutter/controllers/auth_controller.dart';
import 'package:mash_flutter/utils/error.dart';
import 'package:mash_flutter/views/base/app_button.dart';
import 'package:mash_flutter/views/base/app_loader.dart';
import 'package:mash_flutter/views/base/app_text_field.dart';

class IntroduceYourSelf extends StatelessWidget {
  IntroduceYourSelf({Key? key}) : super(key: key);

  final AuthController _controller = AuthController.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  final ImageCropper _imageCropper = ImageCropper();

  static const List<String> _genderList = ["Man", "Woman", "Both"];
  static const List<String> _groupList = ["Group of 2", "Group of 3"];

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColor.orange,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Introduce Yourself'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Obx(() {
                        if (_controller.profileImage.value != null) {
                          return Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xff6d8dad).withOpacity(0.25),
                                  blurRadius: 60,
                                  offset: const Offset(4, 24),
                                ),
                              ],
                              image: DecorationImage(
                                image:
                                    FileImage(_controller.profileImage.value!),
                                fit: BoxFit.cover,
                              ),
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.orange, width: 4),
                            ),
                          );
                        } else {
                          return Image.asset("assets/images/person_icon.png");
                        }
                      }),
                      InkWell(
                        onTap: () {
                          _showImagePickerDialog(1);
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.orange, width: 3),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    controller: _controller.nameController.value,
                    hintText: 'Your full name',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      FocusScope.of(context).unfocus();

                      DateTime? dateTime = await showDatePicker(
                        context: context,
                        initialDate: _controller.dob.value,
                        firstDate: DateTime(1950),
                        lastDate:
                            DateTime.now().subtract(const Duration(days: 6570)),
                      );

                      if (dateTime != null) _controller.dob.value = dateTime;
                    },
                    child: Container(
                      height: 55,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColor.orange, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Enter your Date of Birth'),
                          Obx(() => Text(
                                DateFormat("MM/dd/yyyy")
                                    .format(_controller.dob.value),
                              )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      focusedBorder: border,
                      enabledBorder: border,
                      border: border,
                      isDense: true,
                      hintText: 'Select gender',
                      fillColor: Theme.of(context).cardColor,
                      filled: true,
                    ),
                    value: _controller.selectedGender.value,
                    isExpanded: true,
                    hint: const Text('Select your Gender'),
                    items: AuthController.genders
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: _controller.selectGender,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _controller.emailController.value,
                    readOnly: _controller.isReadOnlyEmail.value,
                    hintText: 'Enter your email',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required';
                      } else if (!GetUtils.isEmail(value)) {
                        return 'Invalid email address';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _controller.bioController.value,
                    maxLines: 6,
                    hintText: 'Enter your Bio',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _selectInterests(context);
                    },
                    child: Container(
                      height: 55,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColor.orange),
                      ),
                      child: const Text(
                        'Select Top 3 Interests',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _showSelectedInterests(),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _addPreferences(context);
                    },
                    child: Container(
                      height: 55,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColor.orange),
                      ),
                      child: const Text(
                        'Add Preferences',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _showPreferences(),
                  /*const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _showImagePickerDialog(2);
                    },
                    child: Obx(
                      () => AbsorbPointer(
                        child: AppTextField(
                          controller: _controller.coverImageController.value,
                          readOnly: true,
                          focusNode: null,
                          hintText: 'Upload cover image',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Required';
                            }

                            return null;
                          },
                        ),
                      ),
                    ),
                  ),*/
                  const SizedBox(height: 20),
                  Container(
                    height: 100.0,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            List<XFile>? files = await _imagePicker
                                .pickMultiImage(imageQuality: 70);
                            if (files != null) {
                              _controller.mediaImages.addAll(
                                  files.map((e) => File(e.path)).toList());
                            }
                          },
                          child: Container(
                            height: 80.0,
                            width: 80.0,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.0)),
                              color: AppColor.lightOrange,
                            ),
                            child: const Icon(
                              Icons.add_photo_alternate_outlined,
                              color: Colors.orange,
                              size: 25,
                            ),
                          ),
                        ),
                        const SizedBox(width: 1.0),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.0)),
                              color: AppColor.lightOrange,
                            ),
                            child: Obx(
                              () => _controller.mediaImages.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'Please select minimum three media images',
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: _controller.mediaImages.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 5.0),
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: RepaintBoundary(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image(
                                                  image: FileImage(_controller
                                                      .mediaImages[index]),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _showImagePickerDialog(3);
                    },
                    child: Obx(
                      () => AbsorbPointer(
                        child: AppTextField(
                          controller: _controller.mediaImageController.value,
                          readOnly: true,
                          focusNode: null,
                          hintText: 'Upload media image',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Required';
                            }

                            return null;
                          },
                        ),
                      ),
                    ),
                  ),*/
                  const SizedBox(height: 32),
                  AppButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();

                        final interests = _controller.interests
                            .where((e) => e.isSelected)
                            .toList();
                        if (interests.length > 3) {
                          showErrorSnackBar(
                            'Maximum 3 interest is required',
                            'Please add maximum 3 interest to your profile',
                          );
                          return;
                        } else if (_controller.mediaImages.length < 3) {
                          showErrorSnackBar(
                            'Minimum 3 media images is required',
                            'Please add at least 3 media images to your profile',
                          );
                          return;
                        }

                        _controller.updateUserData(fromBackground: true);
                      }
                    },
                    text: 'NEXT',
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Obx(
            () => _controller.loading.value
                ? const AppLoader()
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  void _addPreferences(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Preferences',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Obx(() => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Age'),
                              Text(
                                  '${_controller.minAge.value.toInt()} - ${_controller.maxAge.value.toInt()}'),
                            ],
                          ),
                          RangeSlider(
                            values: RangeValues(_controller.minAge.value,
                                _controller.maxAge.value),
                            onChanged: (value) {
                              if (value.start < value.end &&
                                  (value.end - value.start >= 3)) {
                                _controller.minAge.value = value.start;
                                _controller.maxAge.value = value.end;
                                _controller.isAgeSelected.value = true;
                              }
                            },
                            inactiveColor: Colors.grey,
                            activeColor: AppColor.orange,
                            min: 18,
                            max: 65,
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 55,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColor.orange,
                    ),
                  ),
                  child: Obx(
                    () => DropdownButton<String>(
                      value: _controller.genderPref.value.isEmpty
                          ? null
                          : _controller.genderPref.value,
                      items: _genderList
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      isExpanded: true,
                      hint: const Text('Select Gender'),
                      underline: const SizedBox(),
                      onChanged: _controller.groupNoPref.value == 'Group of 3'
                          ? null
                          : _controller.onPrefGenderChanged,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 55,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColor.orange,
                    ),
                  ),
                  child: Obx(
                    () => DropdownButton<String>(
                      value: _controller.groupNoPref.value.isEmpty
                          ? null
                          : _controller.groupNoPref.value,
                      items: _groupList
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      isExpanded: true,
                      hint: const Text('Select Group'),
                      underline: const SizedBox(),
                      onChanged: _controller.onPrefGroupChanged,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _showPreferences() => Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_controller.isAgeSelected.value)
            Text(
              'Group Size : ${_controller.minAge.value.round().toStringAsFixed(2)} - ${_controller.maxAge.value.round().toStringAsFixed(2)}',
            ),
          if (_controller.groupNoPref.isNotEmpty)
            Text(
              'Group Size : ${_controller.groupNoPref.value}',
            ),
          if (_controller.genderPref.isNotEmpty)
            Text(
              'Gender : ${_controller.genderPref.value}',
            ),
        ],
      ));

  void _selectInterests(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Obx(
            () => Wrap(
              spacing: 10,
              children: List.generate(
                _controller.interests.length,
                (index) => InkWell(
                  onTap: () => _controller.selectInterest(index),
                  child: Chip(
                    backgroundColor: _controller.interests[index].isSelected
                        ? AppColor.orange
                        : null,
                    label: Text(_controller.interests[index].name!),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _showSelectedInterests() => Obx(() {
        final interests =
            _controller.interests.where((e) => e.isSelected).toList();

        if (interests.isNotEmpty) {
          return Wrap(
            spacing: 10,
            children: List.generate(
              interests.length,
              (index) => InkWell(
                onTap: () => _controller.removeInterest(interests[index]),
                child: Chip(
                  backgroundColor:
                      interests[index].isSelected ? AppColor.orange : null,
                  label: Text(interests[index].name!),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text(
              'No Interest Added',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      });

  _showImagePickerDialog(int pictureType) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () async {
                  final xFile =
                      await _imagePicker.pickImage(source: ImageSource.camera);
                  if (xFile != null) {
                    Get.back();
                    await _cropImage(xFile.path, pictureType);
                  }
                },
                child: const SizedBox(
                  height: 60,
                  child: Icon(
                    Icons.camera,
                    color: Colors.orange,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(width: 64),
              InkWell(
                onTap: () async {
                  final xFile =
                      await _imagePicker.pickImage(source: ImageSource.gallery);
                  if (xFile != null) {
                    Get.back();
                    await _cropImage(xFile.path, pictureType);
                  }
                },
                child: const SizedBox(
                  height: 60,
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    color: Colors.orange,
                    size: 60,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage(String filePath, int pictureType) async {
    final file = await _imageCropper.cropImage(
      sourcePath: filePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: const IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );

    // Assign profile image to controller for updating widget
    if (pictureType == 1) {
      _controller.profileImage.value = file;
    } else if (pictureType == 2) {
      _controller.coverImage.value = file;
      _controller.coverImageController.value.text = basename(filePath);
    } else {
      _controller.mediaImage.value = file;
      _controller.mediaImageController.value.text = basename(filePath);
    }
  }
}
