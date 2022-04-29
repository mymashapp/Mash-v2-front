import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mash_flutter/controllers/auth_controller.dart';
import 'package:mash_flutter/views/base/app_button.dart';
import 'package:mash_flutter/views/base/app_loader.dart';

class PhoneNumberScreen extends StatelessWidget {
  PhoneNumberScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _authController = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Number'),
      ),
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 16.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _authController.phoneNumberController.value,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: SizedBox(
                        width: 90,
                        child: CountryCodePicker(
                          padding: const EdgeInsets.all(0),
                          initialSelection: 'US',
                          enabled: false,
                          alignLeft: true,
                        ),
                      ),
                      hintText: 'Enter your phone number',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                const Text('We will send a text for verification code.'),
                const Spacer(),
                AppButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      await _authController.signInWithPhone();
                    }
                  },
                  text: 'Continue',
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Obx(
            () => _authController.loading.value
                ? const AppLoader()
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
