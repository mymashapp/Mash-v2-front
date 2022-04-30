import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mash_flutter/constants/app_colors.dart';
import 'package:mash_flutter/controllers/event_controller.dart';
import 'package:mash_flutter/models/category.dart';
import 'package:mash_flutter/utils/error.dart';
import 'package:mash_flutter/views/base/app_button.dart';
import 'package:mash_flutter/views/base/app_loader.dart';
import 'package:mash_flutter/views/base/app_text_field.dart';

class CreateEventScreen extends StatelessWidget {
  CreateEventScreen({Key? key}) : super(key: key);

  static const _timeSelection = ['Today', 'Tomorrow', 'Set Date'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  final ImageCropper _imageCropper = ImageCropper();

  @override
  Widget build(BuildContext context) {
    EventController controller = Get.put(EventController());

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColor.orange,
      ),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: AppColor.red,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(
                    controller: controller.nameController.value,
                    hintText: 'Event Name',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.locationController.value,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Location',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                      errorBorder: errorBorder,
                      focusedErrorBorder: errorBorder,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required';
                      }

                      return null;
                    },
                    onFieldSubmitted: controller.autoCompleteSearch,
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Category',
                        style: TextStyle(
                          color: AppColor.orange,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.shadowColor,
                              offset: const Offset(3, 3),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Obx(
                          () => DropdownButton<Category>(
                            isExpanded: true,
                            hint: const Text('Category'),
                            value: controller.selectedCategory.value.id == null
                                ? null
                                : controller.selectedCategory.value,
                            onChanged: controller.onCategoryChanged,
                            underline: const SizedBox(),
                            items: List.generate(
                              controller.categories.length,
                              (index) => DropdownMenuItem(
                                child: Text(controller
                                        .categories[index].name?.capitalize ??
                                    ''),
                                value: controller.categories[index],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Time',
                        style: TextStyle(
                          color: AppColor.orange,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.shadowColor,
                              offset: const Offset(3, 3),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Obx(
                          () => DropdownButton<int>(
                            isExpanded: true,
                            hint: const Text('Category'),
                            value: controller.selectedTime.value,
                            onChanged: (value) {
                              controller.selectedTime.value = value!;
                            },
                            underline: const SizedBox(),
                            items: List.generate(
                              _timeSelection.length,
                              (index) => DropdownMenuItem(
                                child: Text(_timeSelection[index]),
                                value: index,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Obx(
                    () => controller.selectedTime.value == 2
                        ? InkWell(
                            onTap: () async {
                              DateTime? date = await showDatePicker(
                                context: context,
                                initialDate:
                                    DateTime.now().add(const Duration(days: 2)),
                                firstDate:
                                    DateTime.now().add(const Duration(days: 2)),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 14)),
                              );

                              if (date != null) {
                                controller.eventDate.value = date;
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.shadowColor,
                                      offset: const Offset(3, 3),
                                      blurRadius: 10,
                                    )
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Select Date',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    DateFormat('dd MMM yyyy')
                                        .format(controller.eventDate.value),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColor.orange,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      _showImagePickerDialog();
                    },
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.shadowColor,
                            offset: const Offset(4, 4),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Obx(
                        () => controller.eventImage.value == null
                            ? const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 50,
                                color: AppColor.orange,
                              )
                            : Image.file(controller.eventImage.value!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();

                        if (controller.selectedCategory.value.id == null) {
                          showErrorSnackBar('Error', 'Please select category');
                        } else if (controller.eventImage.value == null) {
                          showErrorSnackBar(
                              'Error', 'Please choose event image');
                        } else {
                          controller.createCard();
                        }
                      }
                    },
                    text: 'Create Event',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Obx(
              () => controller.predictions.isEmpty
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.all(16),
                      margin:
                          const EdgeInsets.only(top: 260, left: 16, right: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(4, 4),
                            blurRadius: 24,
                          )
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              controller.locationController.value.text =
                                  controller.predictions[index].description ??
                                      '';
                              controller.selectedLocation =
                                  controller.predictions[index];
                              controller.predictions.clear();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff6d8dad)
                                        .withOpacity(0.25),
                                    offset: const Offset(3, 3),
                                    blurRadius: 10,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                  controller.predictions[index].description ??
                                      ''),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: controller.predictions.length,
                      ),
                    ),
            ),
            Obx(
              () => controller.loading.value
                  ? const AppLoader()
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  _showImagePickerDialog() {
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
                    await _cropImage(xFile.path);
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
                    await _cropImage(xFile.path);
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

  Future<void> _cropImage(String filePath) async {
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
    EventController.instance.eventImage.value = file;
  }
}
