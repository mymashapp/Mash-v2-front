import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mash/configs/app_colors.dart';

import 'controller/mash_controller.dart';

class PaymentPage extends GetView<MashController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "One-Time Fee",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kOrange),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // AspectRatio(
              //     aspectRatio: 4 / 3,
              //     child: Container(
              //         alignment: Alignment.center,
              //         decoration: BoxDecoration(
              //             color: AppColors.kBlue,
              //             border: Border.all(color: Colors.grey, width: 2),
              //             borderRadius: BorderRadius.circular(15)),
              //         margin: EdgeInsets.symmetric(),
              //         child: Text(
              //           'NFTs',
              //           style: TextStyle(
              //               fontSize: 20,
              //               fontWeight: FontWeight.w600,
              //               color: Colors.white),
              //         ))).marginSymmetric(
              //     horizontal: Get.width * 0.15, vertical: Get.width * 0.15),

              CarouselSlider(
                  carouselController: controller.carouselController,
                  options: CarouselOptions(
                      aspectRatio: 4 / 3,
                      viewportFraction: 0.8,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        controller.sliderIndex.value = index;
                      }),
                  items: controller.sliderImages
                      .map((image) => Image.asset(
                            "$image",
                            fit: BoxFit.cover,
                          ))
                      .toList()),

              SizedBox(
                height: 15,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    List.generate(controller.sliderImages.length, (index) {
                  return GestureDetector(
                    onTap: () =>
                        controller.carouselController.animateToPage(index),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                              .withOpacity(controller.sliderIndex.value == index
                                  ? 0.9
                                  : 0.4)),
                    ),
                  );
                }).toList(),
              ),

              // Container(
              //   margin: EdgeInsets.symmetric(vertical: 15),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(
              //         Icons.circle,
              //         color: Colors.black,
              //       ),
              //       SizedBox(
              //         width: 15,
              //       ),
              //       Icon(
              //         Icons.circle,
              //         color: Colors.black,
              //       ),
              //       SizedBox(
              //         width: 15,
              //       ),
              //       Icon(
              //         Icons.circle,
              //         color: Colors.black,
              //       ),
              //     ],
              //   ),
              // ),

              SizedBox(
                height: 20,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    'Pay a One-Time fee of \$0.99 to mint your NFTs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  )),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Purchase"),
                style: ElevatedButton.styleFrom(
                    primary: AppColors.kOrange,
                    minimumSize: Size(Get.width * 0.75, 50)),
              ),
            ],
          ),
        ));
  }
}
