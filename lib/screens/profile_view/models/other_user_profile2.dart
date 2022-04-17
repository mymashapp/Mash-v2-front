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
import 'package:mash/API_handler/api_base_handler.dart';
import 'package:mash/Utilities/utilities.dart';
import 'package:mash/configs/app_colors.dart';
import 'package:mash/configs/base_url.dart';
import 'package:mash/screens/auth/API/get_profile_picture.dart';
import 'package:mash/screens/auth/widget/profile_uploading_dialog.dart';
import 'package:mash/screens/chat_view/API/add_friend.dart';
import 'package:mash/screens/chat_view/models/other_user_model.dart';
import 'package:mash/screens/feed_view/API/block_user.dart';
import 'package:mash/screens/feed_view/API/get_collection.dart';
import 'package:mash/screens/feed_view/API/get_friends_list.dart';
import 'package:mash/screens/feed_view/add_mesh_page.dart';
import 'package:mash/screens/feed_view/controller/mash_controller.dart';
import 'package:mash/screens/feed_view/models/post_model.dart';
import 'package:mash/screens/profile_view/controller/profile_controller.dart';
import 'package:mash/widgets/blur_loader.dart';
import 'package:mash/widgets/error_snackbar.dart';
import 'package:mash/widgets/spacers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final int userId;
  final String userName;
  final bool alreadyFriend;
  const OtherUserProfileScreen(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.alreadyFriend})
      : super(key: key);

  @override
  _OtherUserProfileScreenState createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen>
    with SingleTickerProviderStateMixin {
  ProfileController profileController = Get.put(ProfileController());
  MashController _mashController = Get.put(MashController());
  FirebaseAuth auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.reference();
  List<PostModel> list = <PostModel>[];
  GetStorage box = GetStorage();
  List blockedId = [];
  Image? image;
  bool isImageUploaded = false;
  bool isImageLoaded = false;
  bool isFriend = false;
  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Media'),
    // Tab(text: 'Mash NFT Collection'),
  ];
  late TabController _tabController;
  // Color
  static const _green = Color(0xFF27AE60);
  static const _text = Color(0xFF565656);
  void initState() {
    if (box.read("blockedId") != null) {
      blockedId = box.read("blockedId");
    } else {
      blockedId = [];
    }
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      isFriend = await checkFriend(widget.userId);
      setState(() {});
      print("ans:====" + (await checkFriend(widget.userId)).toString());
      // setState(() {
      //   isImageLoaded = true;
      // });
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
      appBar: AppBar(
        title: Text(widget.userName),
        backgroundColor: AppColors.kOrange,
        actions: [
          InkWell(
            onTap: () {
              blockedId.add(widget.userId);
              box.write("blockedId", blockedId);
              Get.back();
              appSnackBar("User is successfully blocked.",
                  "User was blocked Now you can't see their activity");
            },
            child: Container(
              height: 20,
              width: 65,
              margin: EdgeInsets.only(right: 10, top: 15, bottom: 12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              alignment: Alignment.center,
              child: Text(
                "Block",
                style: TextStyle(
                    color: AppColors.kOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => authController.profileLoading.value
            ? loading()
            : FutureBuilder<OtherUser>(
                future: getOtherProfileDetails2(widget.userId.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return NestedScrollView(
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
                                          child: (isImageLoaded)
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: AppColors.kOrange,
                                                  ),
                                                )
                                              : (!isImageUploaded)
                                                  ? Image.network(
                                                      "https://www.industrialempathy.com/img/remote/ZiClJf-1920w.jpg",
                                                      fit: BoxFit.fitWidth,
                                                      width: Get.width,
                                                    )
                                                  : image),
                                      // Align(
                                      //   alignment: Alignment.bottomRight,
                                      //   child: InkWell(
                                      //     onTap: () async {
                                      //       await pickImage(
                                      //           ImageSource.gallery);
                                      //     },
                                      //     child: Container(
                                      //       padding: EdgeInsets.all(5),
                                      //       margin: EdgeInsets.only(
                                      //           right: 10, bottom: 50),
                                      //       decoration: BoxDecoration(
                                      //         borderRadius:
                                      //             BorderRadius.circular(100),
                                      //         color: Colors.black54,
                                      //       ),
                                      //       child: Icon(
                                      //         Icons.edit,
                                      //         size: 18,
                                      //         color: Colors.white,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(left: 18.w),
                                              height: 100.h,
                                              width: 100.h,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        AppColors.shadowColor,
                                                    offset: Offset(2, 2),
                                                    blurRadius: 6,
                                                  )
                                                ],
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 3),
                                              ),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          500.r),
                                                  child: FutureBuilder<String>(
                                                      future: getProfile(
                                                          widget.userId),
                                                      builder:
                                                          (context, urlSnap) {
                                                        return FancyShimmerImage(
                                                          imageUrl: urlSnap
                                                                  .hasData
                                                              ? urlSnap.data!
                                                              : "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                                                          shimmerBaseColor:
                                                              Colors.white,
                                                          shimmerHighlightColor:
                                                              AppColors
                                                                  .lightOrange,
                                                          shimmerBackColor:
                                                              AppColors
                                                                  .lightOrange,
                                                          boxFit: BoxFit.cover,
                                                        );
                                                      })),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              snapshot.data!
                                                          .vaccinationStatus ==
                                                      0
                                                  ? SizedBox()
                                                  : InkWell(
                                                      onTap: () {
                                                        Get.dialog(Dialog(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Icon(
                                                                  Icons.warning,
                                                                  color: AppColors
                                                                      .kOrange,
                                                                  size: 40,
                                                                ),
                                                                const SizedBox(
                                                                    height: 16),
                                                                const Text(
                                                                  "Covid Vaccinated sticker is self-reported and not independently verified by Mash App. We can't guarantee that a member is vaccinated or can't transmit the COVID-19 virus.",
                                                                  style:
                                                                      TextStyle(
                                                                    color: AppColors
                                                                        .kOrange,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ));
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .all(4.0),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _green
                                                              .withOpacity(0.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.r),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.favorite,
                                                              size: 17,
                                                              color: _green,
                                                            ),
                                                            const SizedBox(
                                                                width: 6.0),
                                                            const Text(
                                                              'I\'m vaccinated',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
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
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "${snapshot.data!.fullName} ${DateTime.now().difference(snapshot.data!.dob!).inDays ~/ 365}",
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
                                          //         snapshot.data!
                                          //                     .userBasicExtra ==
                                          //                 null
                                          //             ? "No location"
                                          //             : snapshot
                                          //                 .data!
                                          //                 .userBasicExtra!
                                          //                 .location!,
                                          //         style:
                                          //             GoogleFonts.sourceSansPro(
                                          //           fontSize: 16.sp,
                                          //           color: _text,
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          Spacer(),
                                          Visibility(
                                            visible: (isFriend == false),
                                            child: InkWell(
                                              onTap: () {
                                                addFriend(
                                                    snapshot.data!.userId!);
                                                setState(() {
                                                  isFriend = true;
                                                });
                                              },
                                              child: Icon(
                                                Icons.person_add,
                                                size: 25,
                                                color: AppColors.kOrange,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 6),
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
                                              const SizedBox(height: 4.0),
                                              // if (authController
                                              //         .user.value.height !=
                                              //     null)
                                              if (authController.user.value !=
                                                  null)
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Height:',
                                                      style: GoogleFonts
                                                          .sourceSansPro(
                                                        fontSize: 14.sp,
                                                        color: _text,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5.0),
                                                    Text(
                                                      snapshot.data!.height ==
                                                              null
                                                          ? "No Height"
                                                          : snapshot
                                                                  .data!.height
                                                                  .toString() +
                                                              " ft.",
                                                      style: GoogleFonts
                                                          .sourceSansPro(
                                                        fontSize: 14.sp,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              const SizedBox(height: 4.0),
                                              // if (authController
                                              //         .user.value.school !=
                                              //     null)
                                              if (authController.user.value !=
                                                  null)
                                                Row(
                                                  children: [
                                                    Text(
                                                      'College:',
                                                      style: GoogleFonts
                                                          .sourceSansPro(
                                                        fontSize: 14.sp,
                                                        color: _text,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5.0),
                                                    Text(
                                                      "${snapshot.data!.school ?? "No School"}",
                                                      style: GoogleFonts
                                                          .sourceSansPro(
                                                        fontSize: 14.sp,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              const SizedBox(height: 5.0),
                                              if (snapshot
                                                      .data!.userBasicExtra !=
                                                  null)
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Interests:',
                                                      style: GoogleFonts
                                                          .sourceSansPro(
                                                        fontSize: 14.sp,
                                                        color: _text,
                                                      ),
                                                    ),
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
                                                          "${snapshot.data!.userBasicExtra!.interests![0]}"),
                                                    ),
                                                    SizedBox(width: 8.w),
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
                                                          "${snapshot.data!.userBasicExtra!.interests![1]}"),
                                                    ),
                                                    SizedBox(width: 8.w),
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
                                                          "${snapshot.data!.userBasicExtra!.interests![2]}"),
                                                    ),
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
                                getCollection(widget.userId);
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
                                      .equalTo(widget.userId)
                                      // .orderByChild("timestamp")
                                      .onValue,
                                  builder:
                                      (context, AsyncSnapshot<Event> snap) {
                                    if (snap.hasData) {
                                      DataSnapshot dataValues =
                                          snap.data!.snapshot;
                                      if (dataValues.value != null) {
                                        Map<dynamic, dynamic> values =
                                            dataValues.value;
                                        list.clear();
                                        values.forEach((key, values) {
                                          list.insert(
                                              0,
                                              postModelFromJson(
                                                  jsonEncode(values)));
                                        });
                                      }

                                      return list.isEmpty
                                          ? Container()
                                          : _imageGrid(list);
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 44),
                                        child: loading(),
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
                                //           physics:
                                //               NeverScrollableScrollPhysics(),
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
                                //                               .ownMashCollection[
                                //                           index]),
                                //                 );
                                //               },
                                //               child: Stack(
                                //                 children: [
                                //                   CachedNetworkImage(
                                //                     imageUrl: _mashController
                                //                         .ownMashCollection[
                                //                             index]
                                //                         .fileName!,
                                //                     placeholder:
                                //                         (context, url) =>
                                //                             Center(
                                //                       child: SizedBox(
                                //                         height: 20,
                                //                         width: 20,
                                //                         child:
                                //                             CircularProgressIndicator(),
                                //                       ),
                                //                     ),
                                //                     imageBuilder: (context,
                                //                             imageProvider) =>
                                //                         Container(
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
                    );
                  } else {
                    return loading();
                  }
                },
              ),
      ),
    );
  }

  // pickImage(ImageSource source) async {
  //   final _image = await ImagePicker().pickImage(source: source);
  //
  //   if (_image != null) {
  //     File? file = await ImageCropper.cropImage(
  //         sourcePath: _image.path,
  //         compressQuality: 100,
  //         maxHeight: 1000,
  //         maxWidth: 1000,
  //         aspectRatio: CropAspectRatio(ratioX: 5, ratioY: 5),
  //         aspectRatioPresets: [
  //           CropAspectRatioPreset.square,
  //           CropAspectRatioPreset.ratio3x2,
  //           CropAspectRatioPreset.original,
  //           CropAspectRatioPreset.ratio4x3,
  //           CropAspectRatioPreset.ratio16x9
  //         ],
  //         androidUiSettings: AndroidUiSettings(
  //             toolbarTitle: 'Cropper',
  //             toolbarColor: Colors.deepOrange,
  //             toolbarWidgetColor: Colors.white,
  //             cropGridColumnCount: 9,
  //             cropGridRowCount: 9,
  //             initAspectRatio: CropAspectRatioPreset.original,
  //             lockAspectRatio: false),
  //         iosUiSettings: IOSUiSettings(
  //           minimumAspectRatio: 1.0,
  //         )).catchError((error) {
  //       print(error.toString());
  //     });
  //     setState(() {
  //       isImageUploaded = true;
  //       image = Image.file(
  //         file!,
  //         fit: BoxFit.fill,
  //         width: Get.width,
  //       );
  //     });
  //     ImageSharedPrefs.saveImageToPrefs(
  //         ImageSharedPrefs.base64String(file!.readAsBytesSync()));
  //   } else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text("Image not picked...")));
  //   }
  // }
  //
  // loadImageFromPrefs() async {
  //   setState(() {
  //     isImageLoaded = true;
  //   });
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final imageKeyValue = prefs.getString(IMAGE_KEY);
  //   if (imageKeyValue != null) {
  //     final imageString = await ImageSharedPrefs.loadImageFromPrefs();
  //     setState(() {
  //       if (imageString == null) {
  //         isImageUploaded = false;
  //       } else {
  //         isImageUploaded = true;
  //         image =
  //             ImageSharedPrefs.imageFrom64BaseString(imageString, Get.width);
  //       }
  //     });
  //   }
  //   setState(() {
  //     isImageLoaded = false;
  //   });
  // }

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

Future<OtherUser> getOtherProfileDetails2(String userId) async {
  var response = await ApiBaseHelper.get(
      WebApi.getOtherProfile + "?user_id=$userId", true);
  print("OTHER USER ::: ${response.statusCode}");
  print("OTHER USER ::: ${response.body}");
  if (response.statusCode == 200) {
    try {
      otherUserModelFromJson(response.body);
    } catch (e) {
      print(e.toString());
    }
    OtherUser user = otherUserModelFromJson(response.body).data!;
    print(user.fullName);
    return user;
  } else {
    errorSnackBar("Something went wrong", "Please try again");
    return OtherUser();
  }
}
