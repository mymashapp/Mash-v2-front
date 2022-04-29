import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mash_flutter/constants/app_colors.dart';
import 'package:mash_flutter/controllers/event_controller.dart';
import 'package:mash_flutter/models/category.dart';
import 'package:mash_flutter/views/base/app_button.dart';
import 'package:mash_flutter/views/base/app_text_field.dart';

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  static const timeSelection = ['Today', 'Tomorrow', 'Set Date'];

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
            Column(
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
                            timeSelection.length,
                            (index) => DropdownMenuItem(
                              child: Text(timeSelection[index]),
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
                              lastDate:
                                  DateTime.now().add(const Duration(days: 14)),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Container(
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
                  child: const Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 50,
                    color: AppColor.orange,
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  onPressed: () {
                    controller.createCard();
                    /*if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();

                      final interests =
                          _controller.interests.where((e) => e.isSelected).toList();
                      if (interests.length < 3) {
                        showErrorSnackBar(
                          'Minimum 3 interest is required',
                          'Please add at least 3 interest to your profile',
                        );
                        return;
                      }

                      _controller.updateUserData(fromBackground: true);
                    }*/
                  },
                  text: 'Create Event',
                ),
                const SizedBox(height: 20),
              ],
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
          ],
        ),
      ),
    );
  }
}
