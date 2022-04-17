import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mash/configs/app_colors.dart';
import 'package:mash/configs/app_textfield.dart';
import 'package:mash/screens/feed_view/models/mash_model.dart';
import 'package:mash/widgets/app_button.dart';
import 'package:mash/widgets/blur_loader.dart';
import 'package:mash/widgets/loading_circular_image.dart';

import '../../main.dart';
import 'API/add_collection.dart';
import 'API/get_collection.dart';
import 'controller/mash_controller.dart';

class AddMeshPage extends StatelessWidget {
  AddMeshPage({Key? key, this.file, this.mashModel}) : super(key: key);

  final File? file;
  final MashModel? mashModel;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final MashController _controller = Get.find();

  Future<void> _addMash(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "NFT under review. You will get notified once approved to be listed on OpenSea.",
                    style: TextStyle(fontSize: 20, color: AppColors.kOrange),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.kOrange,
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await addCollection(
                        file!,
                        name: _nameController.text,
                        description: _descriptionController.text,
                        price: "0", //_priceController.text,
                      );
                      getCollection(authController.user.value.id!);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: Text(
                        "Ok",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mashModel != null) {
      _descriptionController.text = mashModel!.description ?? "";
      _nameController.text = mashModel!.nftName ?? "";
      _priceController.text = (mashModel!.price ?? 0).toString();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: 131,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              const Text(
                "NFT Minting",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 336 / 332,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: file != null
                        ? Image.file(
                            file!,
                            fit: BoxFit.cover,
                          )
                        : loadingImage(mashModel!.fileName ?? ""),
                  ),
                ),
                const SizedBox(height: 15),
                appTextField(
                  controller: _descriptionController,
                  hintText: "Description",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Description Required";
                    }
                  },
                ),
                const SizedBox(height: 20),
                appTextField(
                  controller: _nameController,
                  hintText: "NFT Name",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "NFT name Description Required";
                    }
                  },
                ),

                const SizedBox(height: 80),
                // appTextField(
                //   controller: _priceController,
                //   textInputType: TextInputType.numberWithOptions(decimal: true),
                //   hintText: "Buy price (POLY)",
                //   onChanged: (val) {
                //     _controller.onPriceChange(val);
                //   },
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return "Buy price (POLY) Required";
                //     }
                //   },
                // ),
                // ObxValue<RxDouble>(
                //     (finalPrice) => Container(
                //         alignment: Alignment.centerLeft,
                //         child: Text(
                //           "\$${finalPrice.value.toPrecision(4)}",
                //           style: TextStyle(
                //             color: Color(0xFFB5B5B5),
                //             fontSize: 15,
                //           ),
                //           textAlign: TextAlign.left,
                //         )).marginOnly(top: 2, left: 2),
                //     _controller.finalPrice),
                const SizedBox(height: 30),
                if (mashModel == null)
                  Obx(() => _controller.loading.value
                      ? loading()
                      : appButton(
                          onTap: () => _addMash(context),
                          buttonBgColor: AppColors.kOrange,
                          textColor: Colors.white,
                          buttonName: "List on OpenSea",
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
