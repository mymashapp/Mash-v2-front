import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mash_flutter/constants/app_colors.dart';
import 'package:mash_flutter/controllers/auth_controller.dart';
import 'package:mash_flutter/utils/error.dart';
import 'package:mash_flutter/views/base/app_button.dart';
import 'package:mash_flutter/views/base/app_loader.dart';
import 'package:mash_flutter/views/base/app_text_field.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _controller = AuthController.instance;

  @override
  Widget build(BuildContext context) {
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  controller: _controller.nameController.value,
                  hintText: 'Your full name',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    FocusScope.of(context).unfocus();

                    DateTime? dateTime = await showDatePicker(
                      context: context,
                      initialDate: _controller.dob.value,
                      firstDate: DateTime(1950),
                      lastDate:
                          DateTime.now().subtract(const Duration(days: 6570)),
                    );

                    if (dateTime != null) _controller.dob.value = dateTime;
                  },
                  child: Container(
                    height: 55,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.orange, width: 1),
                    ),
                    child: Obx(() => Text(
                          DateFormat("MM/dd/yyyy")
                              .format(_controller.dob.value),
                        )),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    focusedBorder: border,
                    enabledBorder: border,
                    border: border,
                    isDense: true,
                    hintText: 'Select gender',
                    fillColor: Theme.of(context).cardColor,
                    filled: true,
                  ),
                  value: _controller.selectedGender.value,
                  isExpanded: true,
                  hint: const Text('Select your Gender'),
                  items: AuthController.genders
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: _controller.selectGender,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _controller.bioController.value,
                  maxLines: 6,
                  hintText: 'Enter your Bio',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _controller.locationController.value,
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
                  onFieldSubmitted: _controller.autoCompleteSearch,
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (_) => Material(
                        color: Colors.white,
                        child: Container(
                          height: 150,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: CupertinoPicker(
                                  backgroundColor: Colors.white,
                                  itemExtent: 30,
                                  scrollController: FixedExtentScrollController(
                                      initialItem: _controller.ft.value - 1),
                                  children: List.generate(
                                      10, (index) => Text('${index + 1}')),
                                  onSelectedItemChanged: (value) {
                                    _controller.ft.value = value + 1;
                                  },
                                ),
                              ),
                              const Text(
                                'Ft',
                                style: TextStyle(fontSize: 18),
                              ),
                              Expanded(
                                child: CupertinoPicker(
                                  backgroundColor: Colors.white,
                                  itemExtent: 30,
                                  scrollController: FixedExtentScrollController(
                                      initialItem:
                                          _controller.inches.value - 1),
                                  children: List.generate(
                                      11, (index) => Text('${index + 1}')),
                                  onSelectedItemChanged: (value) {
                                    _controller.inches.value = value + 1;
                                  },
                                ),
                              ),
                              const Text(
                                'Inch',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 55,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.orange),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Height',
                          style: TextStyle(fontSize: 16),
                        ),
                        Obx(
                          () => Text(
                            _controller.ft.value == 0
                                ? 'Set Height'
                                : "${_controller.ft.value}ft ${_controller.inches.value}\"",
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColor.orange,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _controller.universityController.value,
                  hintText: 'University',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _selectInterests(context);
                  },
                  child: Container(
                    height: 55,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.orange),
                    ),
                    child: const Text(
                      'Select Top 3 Interests',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _showSelectedInterests(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: _controller.isCovidVaccinated.value,
                        onChanged: (value) {
                          _controller.isCovidVaccinated.value = value!;
                        },
                        fillColor: MaterialStateProperty.all(Colors.orange),
                      ),
                    ),
                    const Text(
                      'Covid Vaccinated',
                      style: TextStyle(color: Colors.orange, fontSize: 16),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Text(
                    "Covid Vaccinated sticker is self-reported and not independently verified by Mash App. We can't guarantee that a member is vaccinated or can't transmit the COVID-19 virus.",
                    style: TextStyle(color: Colors.orange, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 32),
                /*InkWell(
                  onTap: () {
                    launch("https://mymashapp.com/deleteprofile.html");
                  },
                  child: const Text(
                    "Disconnect facebook profile",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                const Text(
                  "(If you linked your facebook account*)",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 20),*/
                AppButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      FocusScope.of(context).unfocus();

                      final interests = _controller.interests
                          .where((e) => e.isSelected)
                          .toList();
                      if (interests.length < 3) {
                        showErrorSnackBar(
                          'Minimum 3 interest is required',
                          'Please add at least 3 interest to your profile',
                        );
                        return;
                      }

                      _controller.updateUserData();
                      // _controller.update();
                    }
                  },
                  text: 'Submit',
                ),
              ],
            ),
          ),
          Obx(
            () => _controller.predictions.isEmpty
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
                            _controller.locationController.value.text =
                                _controller.predictions[index].description ??
                                    '';
                            _controller.predictions.clear();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xff6d8dad).withOpacity(0.25),
                                  offset: const Offset(3, 3),
                                  blurRadius: 10,
                                )
                              ],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                                _controller.predictions[index].description ??
                                    ''),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: _controller.predictions.length,
                    ),
                  ),
          ),
          Obx(
            () => _controller.loading.value
                ? const AppLoader()
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  void _selectInterests(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Obx(
            () => Wrap(
              spacing: 10,
              children: List.generate(
                _controller.interests.length,
                (index) => InkWell(
                  onTap: () => _controller.selectInterest(index),
                  child: Chip(
                    backgroundColor: _controller.interests[index].isSelected
                        ? AppColor.orange
                        : null,
                    label: Text(_controller.interests[index].name!),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _showSelectedInterests() => Obx(() {
        final interests =
            _controller.interests.where((e) => e.isSelected).toList();

        if (interests.isNotEmpty) {
          return Wrap(
            spacing: 10,
            children: List.generate(
              interests.length,
              (index) => InkWell(
                onTap: () => _controller.removeInterest(interests[index]),
                child: Chip(
                  backgroundColor:
                      interests[index].isSelected ? AppColor.orange : null,
                  label: Text(interests[index].name!),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text(
              'No Interest Added',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      });
}
