import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mash_flutter/controllers/auth_controller.dart';
import 'package:mash_flutter/views/base/app_button.dart';
import 'package:mash_flutter/views/base/app_loader.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = AuthController.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                    'Verification Code sent to +1 ${controller.phoneNumberController.value.text}'),
                const SizedBox(height: 20),
                PinCodeTextField(
                  appContext: context,
                  controller: controller.smsCodeController.value,
                  length: 6,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.orange,
                    selectedColor: Colors.orange,
                    selectedFillColor: Colors.orange,
                    borderWidth: 0,
                    errorBorderColor: Colors.red,
                  ),
                  enableActiveFill: true,
                  onCompleted: (code) {
                    FocusScope.of(context).unfocus();
                    controller.signInWithPhoneCredential();
                  },
                  onChanged: (value) {},
                ),
                const Spacer(),
                AppButton(
                  onPressed: () {
                    if (controller.smsCodeController.value.text.length == 6) {
                      FocusScope.of(context).unfocus();
                      controller.signInWithPhoneCredential();
                    }
                  },
                  text: 'Continue',
                ),
              ],
            ),
          ),
          Obx(
            () =>
                controller.loading.value ? const AppLoader() : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
