import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mash/Utilities/utilities.dart';
import 'package:mash/configs/app_colors.dart';
import 'package:mash/main.dart';
import 'package:mash/screens/auth/sign_in%20_screen.dart';
import 'package:mash/screens/auth/widget/profile_uploading_dialog.dart';
import 'package:mash/screens/feed_view/API/get_collection.dart';
import 'package:mash/screens/feed_view/add_mesh_page.dart';
import 'package:mash/screens/feed_view/controller/mash_controller.dart';
import 'package:mash/screens/feed_view/models/post_model.dart';
import 'package:mash/screens/profile_view/controller/profile_controller.dart';
import 'package:mash/screens/profile_view/create_post.dart';
import 'package:mash/screens/profile_view/profile_tab.dart';
import 'package:mash/widgets/blur_loader.dart';
import 'package:mash/widgets/spacers.dart';
import 'package:mash/screens/feed_view/tabs/friends.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:shared_preferences/shared_preferences.dart';

import 'API/get_profile.dart';
import 'API/upload_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  ProfileController profileController = Get.put(ProfileController());
  MashController _mashController = Get.put(MashController());

  FirebaseAuth auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.reference();
  List<PostModel> list = <PostModel>[];
  Image? image;
  bool isImageUploaded = false;
  bool isImageLoaded = false;
  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Media'),
    // Tab(text: 'Mash NFT Collection'),
  ];
  late TabController _tabController;

  final _imagePicker = ImagePicker();

  // Color
  static const _green = Color(0xFF27AE60);
  static const _text = Color(0xFF565656);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      setState(() {
        isImageLoaded = true;
      });
      // await loadImageFromPrefs();
    });
    _tabController = TabController(vsync: this, length: tabs.length);
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 120,
        leading: Center(
          child: const Text(
            'My Profile',
            style: TextStyle(
              color: AppColors.kOrange,
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => Friends());
              },
              icon: Icon(
                Icons.people,
                color: AppColors.kOrange,
              )),
          IconButton(
            onPressed: () {
              authController.bottomIndex.value = 0;
              authController.fullName.value.text = "";
              authController.profileUrl.value = "";
              authController.coverUrl.value = "";
              final box = GetStorage();
              box.remove('accessToken');
              box.remove('refreshToken');
              box.remove('fcmToken');
              box.remove('uuid');
              // box.erase();
              auth.signOut();
              Get.deleteAll();
              Get.offAll(() => SignIn());
            },
            icon: Icon(
              Icons.logout_outlined,
              color: Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () {
              authController.fullName.value.text =
                  authController.user.value.name ?? "";
              authController.height.value.text = "";
              // authController.user.value.height == null
              //     ? ""
              //     : authController.user.value.height.toString();
              // if (authController.user.value.height != null &&
              //     authController.user.value.height != 0) {
              //   authController.ft.value = int.parse(
              //       authController.user.value.height.toString().split(".")[0]);
              //   authController.inches.value = int.parse(
              //       authController.user.value.height.toString().split(".")[1]);
              // }
              // authController.school.value.text =
              //     authController.user.value.school ?? "";
              Get.to(() => ProfileTab());
            },
            icon: Image.asset('assets/icons/setting.png'),
          ),
          const SizedBox(width: 14)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        child: Icon(Icons.add),
        backgroundColor: AppColors.kOrange,
        onPressed: () {
          if (_tabController.index == 0) {
            Get.to(() => CreatePost());
          } else {
            Get.dialog(Dialog(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        Get.back();
                        XFile? res = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        if (res != null) {
                          // image = File(res.path);
                          // setState(() {});
                          Get.to(() => AddMeshPage(
                                file: File(res.path),
                              ));
                        } else {
                          print("NOT");
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              height: 60,
                              child: Icon(
                                Icons.camera,
                                color: AppColors.kOrange,
                                size: 60,
                              )),
                          Text(
                            "Camera",
                            style: GoogleFonts.sourceSansPro(
                                color: AppColors.kOrange, fontSize: 16.sp),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    InkWell(
                      onTap: () async {
                        Get.back();

                        XFile? res = await ImagePicker().pickImage(
                            source: ImageSource.gallery, imageQuality: 10);
                        if (res != null) {
                          File imageFile = File(res.path);
                          String filename = res.name;
                          var image =
                              imageLib.decodeImage(imageFile.readAsBytesSync());
                          image = imageLib.copyResize(image!, width: 600);

                          Map imageFileMap = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhotoFilterSelector(
                                appBarColor: AppColors.kOrange,
                                title: Text("Photo Filter"),
                                filters: presetFiltersList,
                                image: image!,
                                filename: filename,
                                loader:
                                    Center(child: CircularProgressIndicator()),
                                fit: BoxFit.contain,
                              ),
                            ),
                          );

                          if (imageFileMap.containsKey("image_filtered")) {
                            imageFile = imageFileMap['image_filtered'];
                            Get.to(() => AddMeshPage(
                                  file: File(imageFile.path),
                                ));
                          }
                        } else {
                          print("NOT");
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              height: 60,
                              child: Icon(
                                Icons.collections_outlined,
                                color: AppColors.kOrange,
                                size: 60,
                              )),
                          Text(
                            "Gallery",
                            style: GoogleFonts.sourceSansPro(
                                color: AppColors.kOrange, fontSize: 16.sp),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
          }
        },
      ),
      body: Obx(
        () => authController.profileLoading.value
            ? loading()
            : NestedScrollView(
                headerSliverBuilder: (context, value) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            height: 230.h,
                            padding: EdgeInsets.only(bottom: 16),
                            child: Stack(
                              children: [
                                Container(
                                  height: 165.h,
                                  width: Get.width,
                                  alignment: Alignment.bottomRight,
                                  color: AppColors.lightOrange,
                                  child: Obx(() {
                                    return (authController
                                            .coverPhotoUploading.value)
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.kOrange,
                                            ),
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: authController
                                                        .coverUrl.value.length >
                                                    1
                                                ? authController.coverUrl.value
                                                : "https://www.industrialempathy.com/img/remote/ZiClJf-1920w.jpg",
                                            fit: (authController
                                                        .coverUrl.value.length >
                                                    1)
                                                ? BoxFit.cover
                                                : BoxFit.contain,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 165.h,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.kOrange,
                                              ),
                                            ),
                                          );
                                  }),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: () => pickImage(),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(
                                          right: 10, bottom: 50),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.black54,
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          profileUploadingDialog();
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 18.w),
                                          height: 100.h,
                                          width: 100.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.shadowColor,
                                                offset: Offset(2, 2),
                                                blurRadius: 6,
                                              )
                                            ],
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 3.5),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(500.r),
                                            child: Obx(
                                              () => authController
                                                      .profileUploading.value
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                AppColors
                                                                    .kOrange),
                                                      ),
                                                    )
                                                  : FancyShimmerImage(
                                                      imageUrl: authController
                                                                  .profileUrl
                                                                  .value
                                                                  .length >
                                                              1
                                                          ? authController
                                                              .profileUrl.value
                                                          : "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                                                      shimmerBaseColor:
                                                          Colors.white,
                                                      shimmerHighlightColor:
                                                          AppColors.lightOrange,
                                                      shimmerBackColor:
                                                          AppColors.lightOrange,
                                                      boxFit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 14.0, bottom: 14.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        //TODO:UNCOMMENT
                                        // authController.user.value
                                        //             .vaccinationStatus ==
                                        //         0
                                        //     ? SizedBox()
                                        //     : InkWell(
                                        //         onTap: () {
                                        //           Get.dialog(Dialog(
                                        //             child: Padding(
                                        //               padding:
                                        //                   EdgeInsets.all(16.0),
                                        //               child: Column(
                                        //                 mainAxisSize:
                                        //                     MainAxisSize.min,
                                        //                 children: [
                                        //                   Icon(
                                        //                     Icons.warning,
                                        //                     color: AppColors
                                        //                         .kOrange,
                                        //                     size: 40,
                                        //                   ),
                                        //                   const SizedBox(
                                        //                       height: 16),
                                        //                   const Text(
                                        //                     "Covid Vaccinated sticker is self-reported and not independently verified by Mash App. We can't guarantee that a member is vaccinated or can't transmit the COVID-19 virus.",
                                        //                     style: TextStyle(
                                        //                       color: AppColors
                                        //                           .kOrange,
                                        //                       fontSize: 16,
                                        //                     ),
                                        //                   )
                                        //                 ],
                                        //               ),
                                        //             ),
                                        //           ));
                                        //         },
                                        //         child: Container(
                                        //           margin:
                                        //               const EdgeInsets.all(4.0),
                                        //           padding:
                                        //               const EdgeInsets.all(4.0),
                                        //           decoration: BoxDecoration(
                                        //             color:
                                        //                 _green.withOpacity(0.2),
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     5.r),
                                        //           ),
                                        //           child: Row(
                                        //             children: [
                                        //               Icon(
                                        //                 Icons.favorite,
                                        //                 size: 17,
                                        //                 color: _green,
                                        //               ),
                                        //               const SizedBox(
                                        //                   width: 6.0),
                                        //               const Text(
                                        //                 'I\'m vaccinated',
                                        //                 style: TextStyle(
                                        //                   fontSize: 15,
                                        //                   color: Colors.black,
                                        //                 ),
                                        //               )
                                        //             ],
                                        //           ),
                                        //         ),
                                        //       ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ///TODO:UNCOMMENT
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${authController.user.value.name}, ${authController.user.value.dateOfBirth == null ? "" : authController.newDateOfBirth}",
                                      style: GoogleFonts.sourceSansPro(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    // if (authController
                                    //         .user.value.userBasicExtra !=
                                    //     null)
                                    //   Row(
                                    //     children: [
                                    //       Image.asset(
                                    //         'assets/icons/map.png',
                                    //         height: 16,
                                    //         width: 16,
                                    //       ),
                                    //       const SizedBox(width: 4),
                                    //       Text(
                                    //         authController.user.value
                                    //                 .userBasicExtra!.location ??
                                    //             "",
                                    //         style: GoogleFonts.sourceSansPro(
                                    //           fontSize: 16.sp,
                                    //           color: _text,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // const SizedBox(height: 4.0),
                                        // if (authController.user.value.height !=
                                        //     null)
                                        //   Row(
                                        //     children: [
                                        //       Text(
                                        //         'Height:',
                                        //         style:
                                        //             GoogleFonts.sourceSansPro(
                                        //           fontSize: 14.sp,
                                        //           color: _text,
                                        //         ),
                                        //       ),
                                        //       const SizedBox(width: 5.0),
                                        //       Text(
                                        //         "${authController.user.value.height} ft.",
                                        //         style:
                                        //             GoogleFonts.sourceSansPro(
                                        //           fontSize: 14.sp,
                                        //           color: Colors.black,
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // const SizedBox(height: 4.0),
                                        // if (authController.user.value.school !=
                                        //     null)
                                        //   Row(
                                        //     children: [
                                        //       Text(
                                        //         'College:',
                                        //         style:
                                        //             GoogleFonts.sourceSansPro(
                                        //           fontSize: 14.sp,
                                        //           color: _text,
                                        //         ),
                                        //       ),
                                        //       const SizedBox(width: 5.0),
                                        //       Text(
                                        //         "${authController.user.value.school}",
                                        //         style:
                                        //             GoogleFonts.sourceSansPro(
                                        //           fontSize: 14.sp,
                                        //           color: Colors.black,
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // const SizedBox(height: 5.0),
                                        if (!isNullEmptyOrFalse(authController
                                            .user.value.interests!.length))
                                          Row(
                                            children: [
                                              Text(
                                                'Interests:',
                                                style:
                                                    GoogleFonts.sourceSansPro(
                                                  fontSize: 14.sp,
                                                  color: _text,
                                                ),
                                              ),
                                              for (int i = 0;
                                                  i <
                                                      authController.user.value
                                                          .interests!.length;
                                                  i++)
                                                Row(
                                                  children: [
                                                    const SizedBox(width: 5.0),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green
                                                            .withOpacity(0.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.r),
                                                      ),
                                                      child: Text(
                                                          "${authController.user.value.interests![i].interestName}"),
                                                    ),
                                                  ],
                                                )
                                            ],
                                          ),
                                      ],
                                    ),
                                    // ElevatedButton(
                                    //   onPressed: () {
                                    //     Get.to(() => Friends());
                                    //   },
                                    //   child: const Text("Friends"),
                                    //   style: ElevatedButton.styleFrom(
                                    //     primary: AppColors.kOrange,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          y16,
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       // if (authController.isAgeSelected.value)
                          //       Text(
                          //         "Age Range : ${authController.minAge.value.toStringAsFixed(2)} - ${authController.maxAge.value.toStringAsFixed(2)}",
                          //         style:
                          //             GoogleFonts.sourceSansPro(fontSize: 16),
                          //       ),
                          //       // if (authController.groupNo.value != "")
                          //       Text(
                          //         "Group Size : ${authController.groupNo.value}",
                          //         style:
                          //             GoogleFonts.sourceSansPro(fontSize: 16),
                          //       ),
                          //       if (authController.genderPre.value != "")
                          //         Text(
                          //           "Gender : ${authController.genderPre.value}",
                          //           style:
                          //               GoogleFonts.sourceSansPro(fontSize: 16),
                          //         ),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            height: 0.3,
                            color: Colors.blueGrey,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ];
                },
                body: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.kOrange,
                      labelColor: AppColors.kOrange,
                      physics: NeverScrollableScrollPhysics(),
                      tabs: tabs,
                      onTap: (index) {
                        if (index == 1) {
                          getCollection(authController.user.value.id!);
                        }
                      },
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          StreamBuilder(
                            stream: databaseRef
                                .child("global_sharing")
                                .orderByChild("user_id")
                                .equalTo(authController.user.value.id)
                                // .orderByChild("timestamp")
                                .onValue,
                            builder: (context, AsyncSnapshot<Event> snap) {
                              if (snap.hasData) {
                                DataSnapshot dataValues = snap.data!.snapshot;
                                if (dataValues.value != null) {
                                  Map<dynamic, dynamic> values =
                                      dataValues.value;
                                  list.clear();
                                  values.forEach((key, values) {
                                    list.insert(0,
                                        postModelFromJson(jsonEncode(values)));
                                  });
                                }

                                return list.isEmpty
                                    ? Container()
                                    : _imageGrid(list);
                              } else {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 44),
                                  child: SizedBox(),
                                );
                              }
                            },
                          ),
                          // Obx(
                          //   () => _mashController.loading.value
                          //       ? Padding(
                          //           padding: const EdgeInsets.symmetric(
                          //               vertical: 44),
                          //           child: loading(),
                          //         )
                          //       : GridView.builder(
                          //           physics: NeverScrollableScrollPhysics(),
                          //           itemCount: _mashController
                          //               .ownMashCollection.length,
                          //           gridDelegate:
                          //               SliverGridDelegateWithFixedCrossAxisCount(
                          //             crossAxisCount: 3,
                          //             mainAxisSpacing: 3.0,
                          //             crossAxisSpacing: 3.0,
                          //           ),
                          //           itemBuilder: (context, index) {
                          //             return GestureDetector(
                          //               onTap: () {
                          //                 Get.to(
                          //                   () => AddMeshPage(
                          //                       mashModel: _mashController
                          //                           .ownMashCollection[index]),
                          //                 );
                          //               },
                          //               child: Stack(
                          //                 children: [
                          //                   CachedNetworkImage(
                          //                     imageUrl: _mashController
                          //                         .ownMashCollection[index]
                          //                         .fileName!,
                          //                     placeholder: (context, url) =>
                          //                         Center(
                          //                       child: SizedBox(
                          //                         height: 20,
                          //                         width: 20,
                          //                         child:
                          //                             CircularProgressIndicator(),
                          //                       ),
                          //                     ),
                          //                     imageBuilder:
                          //                         (context, imageProvider) =>
                          //                             Container(
                          //                       decoration: BoxDecoration(
                          //                         image: DecorationImage(
                          //                           image: imageProvider,
                          //                           fit: BoxFit.cover,
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     errorWidget:
                          //                         (context, url, error) =>
                          //                             Icon(Icons.error),
                          //                     fit: BoxFit.cover,
                          //                   ),
                          //                   Positioned(
                          //                     right: 4,
                          //                     top: 4,
                          //                     child: _mashController
                          //                                 .ownMashCollection[
                          //                                     index]
                          //                                 .approve ==
                          //                             1
                          //                         ? Icon(
                          //                             Icons.verified,
                          //                             color: Colors.green,
                          //                           )
                          //                         : Transform.rotate(
                          //                             angle: pi / 4,
                          //                             child: Icon(
                          //                               Icons.add_circle,
                          //                               color: Colors.red,
                          //                             ),
                          //                           ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             );
                          //           },
                          //         ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  pickImage() async {
    debugPrint("Start");
    try {
      XFile? xFile = await _imagePicker.pickImage(source: ImageSource.gallery);

      debugPrint("Start - 1");

      if (xFile != null) {
        debugPrint("Start - 2");
        File? file = await ImageCropper.cropImage(
          sourcePath: xFile.path,
          compressQuality: 100,
          maxHeight: 1000,
          maxWidth: 1000,
          aspectRatio: CropAspectRatio(ratioX: 7, ratioY: 3),
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
            cropGridRowCount: 3,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
          ),
          /*iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
        ),*/
        );

        debugPrint("Start - 3");
        if (file != null) {
          debugPrint("Start - 4");
          isImageUploaded = true;
          image = Image.file(
            file,
            fit: BoxFit.fill,
            width: Get.width,
          );

          authController.coverPhotoUploading.value = true;

          await uploadCoverPhoto(file.path).then((value) async {
            getMe(isFromProfileUpdate: true);
            await Future.delayed(Duration(seconds: 3));
            // await authController.refreshCoverPhoto();
          });
          authController.coverPhotoUploading.value = false;
          setState(() {});
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Image not picked...")));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  loadImageFromPrefs() async {
    setState(() {
      isImageLoaded = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imageKeyValue = prefs.getString(IMAGE_KEY);
    if (imageKeyValue != null) {
      final imageString = await ImageSharedPrefs.loadImageFromPrefs();
      setState(() {
        if (imageString == null) {
          isImageUploaded = false;
        } else {
          isImageUploaded = true;
          image =
              ImageSharedPrefs.imageFrom64BaseString(imageString, Get.width);
        }
      });
    }
    setState(() {
      isImageLoaded = false;
    });
  }

  Widget _imageGrid(List<PostModel> list) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 3.0,
        crossAxisSpacing: 3.0,
      ),
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: list[index].imgUrl!,
          placeholder: (context, url) => Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        );
      },
    );
  }
}

bool isNullEmptyOrFalse(dynamic o) {
  if (o is Map<String, dynamic> || o is List<dynamic>) {
    return o == null || o.length == 0;
  }
  return o == null || false == o || "" == o;
}
