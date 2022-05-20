import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mash_flutter/constants/app_colors.dart';
import 'package:mash_flutter/controllers/preference_controller.dart';
import 'package:mash_flutter/views/base/app_button.dart';

class PreferenceScreen extends GetWidget<PreferenceController> {
  const PreferenceScreen({Key? key}) : super(key: key);

  static const List<String> genderList = ['Man', 'Woman', 'Both'];
  static const List<String> groupList = ['Group of 2', 'Group of 3'];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PreferenceController>(
      init: PreferenceController(),
      builder: (controller) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                child: Obx(
                  () => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Age'),
                          Text(
                              '${controller.minAge.value.toInt()} - ${controller.maxAge.value.toInt()}'),
                        ],
                      ),
                      RangeSlider(
                        values: RangeValues(
                            controller.minAge.value, controller.maxAge.value),
                        onChanged: (value) {
                          if (value.start < value.end &&
                              (value.end - value.start >= 3)) {
                            controller.minAge.value = value.start;
                            controller.maxAge.value = value.end;
                            controller.isAgeSelected.value = true;
                          }
                        },
                        inactiveColor: Colors.grey,
                        activeColor: AppColor.orange,
                        min: 18,
                        max: 65,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Group preference',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: groupList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Obx(
                    () => Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: controller.groupNoPref.value == groupList[index]
                            ? AppColor.orange
                            : Colors.transparent,
                        border: Border.all(
                          color:
                              controller.groupNoPref.value == groupList[index]
                                  ? AppColor.orange
                                  : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            controller.groupNoPref.value = groupList[index];
                            if (controller.groupNoPref.value == "Group of 3") {
                              controller.genderPref.value = "Both";
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  groupList[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: controller.groupNoPref.value ==
                                            groupList[index]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                controller.groupNoPref.value == groupList[index]
                                    ? const Icon(
                                        Icons.task_alt_outlined,
                                        color: Colors.white,
                                        size: 24,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Gender preference',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: genderList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Obx(
                    () => Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: controller.genderPref.value == genderList[index]
                            ? AppColor.orange
                            : Colors.transparent,
                        border: Border.all(
                          color:
                              controller.genderPref.value == genderList[index]
                                  ? AppColor.orange
                                  : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            if (controller.groupNoPref.value != "Group of 3") {
                              controller.genderPref.value = genderList[index];
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  genderList[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: controller.genderPref.value ==
                                            genderList[index]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                controller.genderPref.value == genderList[index]
                                    ? const Icon(
                                        Icons.task_alt_outlined,
                                        color: Colors.white,
                                        size: 24,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 25),
              AppButton(
                onPressed: () {
                  controller.updateUserData();
                },
                text: 'Accept Changes',
              ),
            ],
          ),
        );
      },
    );
  }
}
