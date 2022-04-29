import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mash_flutter/controllers/auth_controller.dart';
import 'package:mash_flutter/views/screens/auth/phone_number_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authController = AuthController.instance;

    return Scaffold(
      body: Stack(
        children: [
          const _SignInSlideImages(),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            width: Get.width,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 45, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/mash_logo.png',
                    width: Get.width / 1.5,
                  ),
                ),
                const Spacer(),
                _termsCondition(),
                const SizedBox(height: 10),
                _SignInButton(
                  onPressed: _authController.signInWithApple,
                  svgIcon: 'assets/svgs/apple.svg',
                  text: 'Sign in with Apple',
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                ),
                const SizedBox(height: 10),
                _SignInButton(
                  onPressed: _authController.signInWithFacebook,
                  svgIcon: 'assets/svgs/facebook.svg',
                  text: 'Sign in with Facebook',
                  backgroundColor: Colors.blue,
                ),
                const SizedBox(height: 10),
                _SignInButton(
                  onPressed: () {
                    Get.to(() => PhoneNumberScreen());
                  },
                  iconData: Icons.phone_iphone,
                  text: 'Sign in with Phone',
                  backgroundColor: Colors.orange,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Terms & Conditions
  Widget _termsCondition() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            const TextSpan(text: 'By tapping Sign In, you agree to our '),
            TextSpan(
              text: ' Privacy Policy',
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  launch('https://mymashapp.com/Privacy_Policy.html');
                },
              style: const TextStyle(
                color: Colors.orange,
              ),
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Terms & Conditions. ',
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  launch('https://mymashapp.com/Terms.html');
                },
              style: const TextStyle(
                color: Colors.orange,
              ),
            ),
          ],
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

// App Button
class _SignInButton extends StatelessWidget {
  const _SignInButton({
    Key? key,
    required this.onPressed,
    this.iconData,
    this.svgIcon,
    required this.text,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final IconData? iconData;
  final String? svgIcon;
  final String text;

  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      height: 50,
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          children: [
            Expanded(
              child: iconData != null
                  ? Icon(
                      iconData,
                      color: Colors.white,
                    )
                  : SvgPicture.asset(svgIcon!),
            ),
            Expanded(
              flex: 2,
              child: Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                ),
              ),
            )
          ],
        ),
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

// Slide Images
class _SignInSlideImages extends StatefulWidget {
  const _SignInSlideImages({Key? key}) : super(key: key);

  @override
  State<_SignInSlideImages> createState() => _SignInSlideImagesState();
}

class _SignInSlideImagesState extends State<_SignInSlideImages> {
  int _currentIndex = 0;
  late Timer _timer;

  static const List<String> _images = [
    "assets/images/splash/splash1.jpg",
    "assets/images/splash/splash2.jpg",
    "assets/images/splash/splash3.jpg",
    "assets/images/splash/splash4.jpg",
    "assets/images/splash/splash5.jpg",
    "assets/images/splash/splash6.jpg",
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        if (_currentIndex + 1 == _images.length) {
          _currentIndex = 0;
        } else {
          _currentIndex += 1;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 2400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Image.asset(
        _images[_currentIndex],
        fit: BoxFit.cover,
        height: Get.height,
        width: Get.width,
        key: ValueKey(_currentIndex),
      ),
    );
  }
}
