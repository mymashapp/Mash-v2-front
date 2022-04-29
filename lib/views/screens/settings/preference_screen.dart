import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mash_flutter/constants/app_colors.dart';
import 'package:mash_flutter/controllers/auth_controller.dart';
import 'package:mash_flutter/views/base/app_button.dart';

class PreferenceScreen extends StatelessWidget {
  const PreferenceScreen({Key? key}) : super(key: key);

  static const List<String> genderList = ['Man', 'Woman', 'Both'];

  @override
  Widget build(BuildContext context) {
    final _controller = AuthController.instance;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                          '${_controller.minAge.value.toInt()} - ${_controller.maxAge.value.toInt()}'),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(
                        _controller.minAge.value, _controller.maxAge.value),
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
              ),
            ),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: genderList.length,
            itemBuilder: (BuildContext context, int index) {
              return Obx(() => Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: _controller.genderPref.value == genderList[index]
                          ? AppColor.orange
                          : Colors.transparent,
                      border: Border.all(
                        color: _controller.genderPref.value == genderList[index]
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
                          _controller.genderPref.value = genderList[index];
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
                                  color: _controller.genderPref.value ==
                                          genderList[index]
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              _controller.genderPref.value == genderList[index]
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
                  ));
            },
          ),
          const SizedBox(height: 25),
          AppButton(
            onPressed: () {
              _controller.updateUserData();
            },
            text: 'Accept Changes',
          ),
        ],
      ),
    );
  }
}
