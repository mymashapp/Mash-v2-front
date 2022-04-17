import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mash/configs/app_textfield.dart';
import 'package:mash/screens/auth/API/get_profile_picture.dart';
import 'package:mash/screens/feed_view/payment_view.dart';
import 'package:mash/widgets/app_button.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:mash/configs/app_colors.dart';
import 'package:mash/screens/feed_view/controller/mash_controller.dart';
import 'package:mash/widgets/loading_circular_image.dart';
import 'package:mash/widgets/time_ago.dart';
import 'package:url_launcher/url_launcher.dart';

import 'add_mesh_page.dart';
import 'models/mash_model.dart';
import 'wallet_page.dart';

class MeshPage extends StatelessWidget {
  MeshPage({Key? key}) : super(key: key);

  // Color
  static const _green = Color(0xFF27AE60);
  static const _text = Color(0xFF565656);
  static const _gray = Color(0xFF8A8A8A);

  final MashController controller = Get.put(MashController());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /*Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.all(3),
            padding: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(
                color: AppColors.kOrange,
                width: 2.0, // Underline thickness
              ),
            )),
            child: const Text(
              'Mash NFT Collection',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.kOrange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),*/
        // Positioned(
        //   right: 10,
        //   child: GestureDetector(
        //     onTap: () {
        //       Get.to(() => WalletPage());
        //     },
        //     child: Container(
        //       padding: const EdgeInsets.all(4),
        //       margin: const EdgeInsets.all(3),
        //       decoration: BoxDecoration(
        //         color: AppColors.kOrange.withOpacity(0.5),
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //       child: Row(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           const SizedBox(width: 5),
        //           //Image.asset('assets/icons/mesh_nft.png'),
        //           Image.asset('assets/ETH.png', width: 15, height: 15),
        //           //SvgPicture.asset("assets/eth.svg"),
        //           const SizedBox(width: 4),
        //           const Text(
        //             'Payout Details',
        //             style: TextStyle(
        //               fontSize: 16,
        //               color: AppColors.kOrange,
        //               fontWeight: FontWeight.w500,
        //             ),
        //           ),
        //           const SizedBox(width: 5),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        Obx(() => Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.mashCollection.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildCard(
                      controller.mashCollection[index], index, controller);
                },
              ),
            )),
        Positioned(
          bottom: 15,
          right: 15,
          child: FloatingActionButton(
            elevation: 0,
            onPressed: () {
              if (false) {
                Get.to(PaymentPage());
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
                              var image = imageLib
                                  .decodeImage(imageFile.readAsBytesSync());
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
                                    loader: Center(
                                        child: CircularProgressIndicator()),
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
            child: Icon(
              Icons.add,
              size: 26,
            ),
            backgroundColor: AppColors.kOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(MashModel mashModel, int index, MashController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FutureBuilder<String>(
                future: getProfile(mashModel.userId),
                builder: (context, snap) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: loadingCircularImage(snap.hasData ? snap.data! : "",
                        Get.width > 600 ? 15 : 22),
                  );
                },
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mashModel.fullName ?? "",
                    style: GoogleFonts.sourceSansPro(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "${timeAgo(mashModel.createdAt ?? DateTime.now())}",
                    style: GoogleFonts.sourceSansPro(
                      color: _text,
                    ),
                  )
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: Get.context!,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      builder: (context) {
                        return getReportSheet(
                            controller: controller, index: index);
                      });
                },
                child: Icon(
                  Icons.flag,
                  color: AppColors.kOrange,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                          text: "https://opensea.io/collection/mashandmeet"))
                      .then((_) {
                    ScaffoldMessenger.of(Get.context!).showSnackBar(
                        SnackBar(content: Text("Link copied to clipboard")));
                  });
                  // launch("https://opensea.io/collection/mashandmeet");
                  // if (mashModel.link != null) {
                  //   launch(mashModel.link!);
                  // }
                },
                child: const Text("Copy link"),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.kOrange,
                ),
              ),
              SizedBox(width: 8.0),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            height: Get.height / 2.25,
            color: AppColors.lightOrange,
            child: loadingImage(mashModel.fileName ?? ""),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mashModel.nftName ?? "",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
                Spacer(),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     Row(
                //       children: [
                //         Image.asset('assets/ETH.png', width: 15, height: 15),
                //         //Image.asset('assets/icons/mesh_nft.png'),
                //         //SvgPicture.asset("assets/eth.svg"),
                //         SizedBox(width: 5),
                //         Text(
                //           "Price - ${mashModel.price ?? 0} POLY",
                //           style: TextStyle(
                //             color: _text,
                //             fontSize: 17,
                //           ),
                //         ),
                //       ],
                //     ),
                //     ObxValue<RxDouble>(
                //         (rate) => Text(
                //               "\$" +
                //                   "${(rate.value * (mashModel.price ?? 0)).toPrecision(4)}",
                //               style: TextStyle(
                //                 color: Color(0xFFB5B5B5),
                //                 fontSize: 15,
                //               ),
                //             ),
                //         controller.rate)
                //   ],
                // ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 1.74,
            color: Color(0xFFF8F8F8),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              mashModel.description ?? "",
              style: TextStyle(
                color: _text,
                fontSize: 17,
              ),
            ),
          )
        ],
      ),
    );
  }
}

Container getReportSheet(
    {required MashController controller, required int index}) {
  GetStorage box = GetStorage();
  List<dynamic> reportUser = [];
  if (box.read("reportUser") != null) {
    reportUser = box.read("reportUser");
  }
  return Container(
    child: Obx(() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.black87,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Report this item",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Reason",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text(
                      controller.reportReason.value,
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    dropdownColor: Colors.black87,
                    items: <String>[
                      'Fake collection or possible scam',
                      'Explicit and sensitive content',
                      'Spam',
                      'Might be stolen',
                      "Other"
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      controller.reportReason.value = val!;
                    },
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Additional Comments ",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
                  child: appTextField(
                      maxLine: 5,
                      textColor: Colors.white,
                      fillColor: Colors.black87,
                      hintText:
                          "Explain why are you concerned about this item"),
                ),
                SizedBox(height: 30),
                appButton(
                    buttonBgColor: AppColors.kOrange,
                    textColor: Colors.white,
                    buttonName: "Report and Block",
                    onTap: () {
                      if (controller.reportReason.value ==
                          "Please select reason") {
                        Get.snackbar(
                            "Report and Block", "Please select reason.",
                            backgroundColor: Colors.red);
                      } else {
                        reportUser.add(controller.mashCollection[index].userId);
                        box.write("reportUser", reportUser);
                        controller.mashCollection.removeAt(index);
                        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
                            content: Text(
                                "This item has been reported and blocked successfully.")));

                        Get.back();
                        controller.mashCollection.forEach((element) {
                          if (element.userId ==
                              controller.mashCollection[index].userId) {
                            controller.mashCollection.remove(element);
                          }
                        });
                      }
                    }),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      );
    }),
  );
}
/*
return Container(
                                            padding: EdgeInsets.only(bottom: 16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          FutureBuilder<String>(
                                                            future: getProfile(postModel.userId),
                                                            builder: (context, snap) {
                                                              return loadingCircularImage(
                                                                  snap.hasData ? snap.data! : "",
                                                                  Get.width > 600 ? 15 : 22);
                                                            },
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                "${postModel.userName}",
                                                                style: GoogleFonts.sourceSansPro(
                                                                  color: Colors.black,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                              Text(
                                                                "${timeAgo(DateTime.fromMillisecondsSinceEpoch(postModel.timestamp!))}",
                                                                style: GoogleFonts.sourceSansPro(
                                                                  color: _text,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: Get.height / 2.2,
                                                  color: AppColors.lightOrange,
                                                  child: loadingImage(postModel.imgUrl!),
                                                ),
                                                postModel.desc == null
                                                    ? const SizedBox(height: 10)
                                                    : Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 10, left: 10, bottom: 10),
                                                        child: Text(
                                                          postModel.desc!,
                                                          style: GoogleFonts.sourceSansPro(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w600),
                                                        ),
                                                      ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          if (postModel.likes == null) {
                                                            giveLike(postModel.id);
                                                          } else {
                                                            if (postModel.likes!.keys.contains(
                                                                authController.user.value.userId
                                                                    .toString())) {
                                                              removeLike(postModel.id);
                                                            } else {
                                                              giveLike(postModel.id);
                                                            }
                                                          }
                                                        },
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            Icon(
                                                              postModel.likes == null
                                                                  ? Icons.favorite_border
                                                                  : postModel.likes!.keys.contains(
                                                                          authController
                                                                              .user.value.userId
                                                                              .toString())
                                                                      ? Icons.favorite
                                                                      : Icons.favorite_border,
                                                              color: Colors.red,
                                                              size: 22,
                                                            ),
                                                            const SizedBox(width: 5.0),
                                                            Text(
                                                              postModel.likeCount == null
                                                                  ? "0"
                                                                  : postModel.likeCount.toString(),
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 16,
                                                                color: _text,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          if (postModel.comments != null) {
                                                            Get.to(
                                                              () => CommentPage(
                                                                comments:
                                                                    postModel.comments!.values,
                                                                postId: postModel.id!,
                                                                private: false,
                                                              ),
                                                            );
                                                          } else {
                                                            errorSnackBar("No comments available",
                                                                "There is no comments available right now.");
                                                          }
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Image.asset('assets/icons/comment.png'),
                                                            const SizedBox(width: 5.0),
                                                            Text(
                                                              postModel.comments == null
                                                                  ? "0"
                                                                  : postModel
                                                                      .comments!.values.length
                                                                      .toString(),
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 16,
                                                                color: _text,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
 */
