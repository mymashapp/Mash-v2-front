import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mash/configs/app_colors.dart';
import 'package:mash/configs/app_textfield.dart';
import 'package:mash/widgets/app_button.dart';
import 'package:mash/widgets/blur_loader.dart';

import 'API/add_wallet.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  static const List<String> type = [
    "Crypto Wallet",
    "Bank Statement",
    "Venmo",
    "Cash App",
  ];

  String _selectedType = "Crypto Wallet";
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _walletAddressController =
      TextEditingController();
  final TextEditingController _routingNumberController =
      TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _venmoIDController = TextEditingController();
  final TextEditingController _cashAppIDController = TextEditingController();

  Future<void> _addWallet() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      bool value = await addWallet({
        "wallet_address": _walletAddressController.text,
        "routing_number": _routingNumberController.text,
        "account_number": _accountNumberController.text,
        "ven_no_id": _venmoIDController.text,
        "cash_app_id": _cashAppIDController.text,
      });

      setState(() {
        _isLoading = false;
      });

      if (value) Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: Transform(
          transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
          child: Text(
            "Payout Details",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
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
                const SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: AppColors.kOrange),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedType,
                    hint: Text("Select wallet type"),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                    underline: SizedBox(),
                    items: List.generate(
                      type.length,
                      (index) => DropdownMenuItem(
                        child: Text(
                          type[index],
                          style: GoogleFonts.sourceSansPro(),
                        ),
                        value: type[index],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildField(),
                const SizedBox(height: 30),
                _isLoading
                    ? loading()
                    : appButton(
                        onTap: _addWallet,
                        buttonBgColor: AppColors.kOrange,
                        textColor: Colors.white,
                        buttonName: "Submit",
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField() {
    switch (_selectedType) {
      case "Crypto Wallet":
        return Column(
          children: [
            appTextField(
              controller: _walletAddressController,
              hintText: "Wallet Address",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Wallet Address Required";
                }
              },
            ),
          ],
        );

      case "Bank Statement":
        return Column(
          children: [
            appTextField(
              controller: _routingNumberController,
              hintText: "Routing Number",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Routing Number Required";
                }
              },
            ),
            const SizedBox(height: 20),
            appTextField(
              controller: _accountNumberController,
              hintText: "Account Number",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Account Number Required";
                }
              },
            ),
          ],
        );

      case "Venmo":
        return Column(
          children: [
            appTextField(
              controller: _venmoIDController,
              hintText: "Venmo ID",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Venmo ID Required";
                }
              },
            ),
          ],
        );

      case "Cash App":
        return Column(
          children: [
            appTextField(
              controller: _cashAppIDController,
              hintText: "Cash App ID",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Cash App ID Required";
                }
              },
            ),
          ],
        );

      default:
        return Container();
    }
  }
}
