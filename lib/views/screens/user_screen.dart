import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mash_flutter/constants/app_colors.dart';
import 'package:mash_flutter/controllers/auth_controller.dart';
import 'package:mash_flutter/utils/global_function.dart';

import 'settings/settings_screen.dart';

class UserTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 1, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();

    super.onClose();
  }
}

class UserScreen extends StatelessWidget {
  UserScreen({Key? key}) : super(key: key);

  final _controller = AuthController.instance;
  final ImagePicker _imagePicker = ImagePicker();
  final ImageCropper _imageCropper = ImageCropper();

  @override
  Widget build(BuildContext context) {
    final UserTabController _userTabcontroller = Get.put(UserTabController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 120,
        leading: const Center(
          child: Text(
            'My Profile',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: AuthController.instance.signOut,
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const SettingsScreen());
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: _headerSliverBuilder,
        body: Column(
          children: [
            TabBar(
              controller: _userTabcontroller.tabController,
              indicatorColor: AppColor.orange,
              labelColor: AppColor.orange,
              physics: const NeverScrollableScrollPhysics(),
              tabs: const [
                Tab(text: 'Media'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _userTabcontroller.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 3.0,
                      crossAxisSpacing: 3.0,
                    ),
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl:
                            'https://www.industrialempathy.com/img/remote/ZiClJf-1920w.jpg',
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _headerSliverBuilder(BuildContext context, bool value) {
    return [
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 230,
              padding: const EdgeInsets.only(bottom: 16),
              child: Stack(
                children: [
                  Container(
                    height: 165,
                    color: AppColor.lightOrange,
                    alignment: Alignment.center,
                    child: Obx(
                      () => _controller.newCoverUploading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.orange,
                              ),
                            )
                          : _controller.coverImageUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: _controller.coverImageUrl.value,
                                  fit: BoxFit.contain,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.orange,
                                    ),
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      'https://www.industrialempathy.com/img/remote/ZiClJf-1920w.jpg',
                                  fit: BoxFit.contain,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.orange,
                                    ),
                                  ),
                                ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () => _showImagePickerDialog(isForCover: true),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(right: 10, bottom: 60),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.black54,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: InkWell(
                      onTap: () => _showImagePickerDialog(),
                      child: Container(
                        height: 100,
                        width: 100,
                        margin: const EdgeInsets.only(left: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.shadowColor,
                              offset: const Offset(2, 2),
                              blurRadius: 6,
                            )
                          ],
                          border: Border.all(color: AppColor.white, width: 3.5),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Obx(
                              () => _controller.newProfileUploading.value
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColor.orange,
                                      ),
                                    )
                                  : _controller.profileImageUrl.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              _controller.profileImageUrl.value,
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              const Center(
                                            child: CircularProgressIndicator(
                                              color: AppColor.orange,
                                            ),
                                          ),
                                        )
                                      : CachedNetworkImage(
                                          imageUrl:
                                              'https://www.industrialempathy.com/img/remote/ZiClJf-1920w.jpg',
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              const Center(
                                            child: CircularProgressIndicator(
                                              color: AppColor.orange,
                                            ),
                                          ),
                                        ),
                            )),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14.0, bottom: 14.0),
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _controller.isCovidVaccinated.value == false
                                ? const SizedBox()
                                : InkWell(
                                    onTap: () {
                                      Get.dialog(Dialog(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(
                                                Icons.warning,
                                                color: AppColor.orange,
                                                size: 40,
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                "Covid Vaccinated sticker is self-reported and not independently verified by Mash App. We can't guarantee that a member is vaccinated or can't transmit the COVID-19 virus.",
                                                style: TextStyle(
                                                  color: AppColor.orange,
                                                  fontSize: 16,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(4.0),
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF27AE60)
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.favorite,
                                            size: 17,
                                            color: Color(0xFF27AE60),
                                          ),
                                          SizedBox(width: 6.0),
                                          Text(
                                            'I\'m vaccinated',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                final interests =
                    _controller.interests.where((e) => e.isSelected).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _controller.userName.value +
                              ', ' +
                              ageStringFrom(_controller.dob.value),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_controller
                            .locationController.value.text.isNotEmpty)
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                          ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _controller.locationController.value.text,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Obx(
                      () => _controller.ft.value != 0
                          ? Row(
                              children: [
                                const Text(
                                  'Height: ',
                                  style: TextStyle(
                                    color: Color(0xFF565656),
                                  ),
                                ),
                                Text(
                                  '${_controller.ft.value},${_controller.inches.value} Ft.',
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            )
                          : const SizedBox(),
                    ),
                    const SizedBox(height: 5),
                    Obx(
                      () => _controller.university.value.isNotEmpty
                          ? Row(
                              children: [
                                const Text(
                                  'University: ',
                                  style: TextStyle(
                                    color: Color(0xFF565656),
                                  ),
                                ),
                                Text(
                                  _controller.university.value,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            )
                          : const SizedBox(),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text('Interests: '),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(
                              min(3, interests.length),
                              (index) => Container(
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(interests[index].name!),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _controller.bioDetails.value,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 10),
            Container(height: 0.3, color: Colors.blueGrey),
          ],
        ),
      ),
    ];
  }

  Future<void> _cropImage(String filePath, {bool isForCover = false}) async {
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

    if (isForCover) {
      // Assign profile image to controller for updating widget
      _controller.newCoverImage.value = file;
      // Upload image
      _controller.uploadCoverImage();
    } else {
      // Assign profile image to controller for updating widget
      _controller.newProfileImage.value = file;
      // Upload image
      _controller.uploadProfileImage();
    }
  }

  _showImagePickerDialog({bool isForCover = false}) {
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
                    await _cropImage(xFile.path, isForCover: isForCover);
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
                    await _cropImage(xFile.path, isForCover: isForCover);
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
}
