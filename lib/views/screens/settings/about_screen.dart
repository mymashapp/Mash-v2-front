import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  static const _icons = [
    Icons.favorite,
    Icons.remove_red_eye_outlined,
    Icons.sticky_note_2_outlined,
    Icons.info,
  ];

  static const _titles = [
    'Vision And Mission',
    'Privacy Policy',
    'Terms and Conditions',
    'About Mash',
  ];

  void _showDialog(String title, String message) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            switch (index) {
              case 0:
                _showDialog(
                  'Vision And Mission',
                  'To become the go-to platform to meet your next best friend',
                );

                break;
              case 1:
                launch("https://mymashapp.com/Privacy_Policy.html");

                break;
              case 2:
                launch("https://mymashapp.com/Terms.html");

                break;
              case 3:
                _showDialog(
                  'About Mash',
                  'Mash is a swipe-based mobile application that facilitates in-person meetups.',
                );

                break;
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff6d8dad).withOpacity(0.25),
                  offset: const Offset(3, 3),
                  blurRadius: 6,
                )
              ],
            ),
            child: Row(
              children: [
                Icon(
                  _icons[index],
                  color: Colors.orange,
                ),
                const SizedBox(width: 10),
                Text(_titles[index]),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: _icons.length,
    );
  }
}
