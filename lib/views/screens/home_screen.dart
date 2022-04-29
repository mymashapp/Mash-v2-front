import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mash_flutter/constants/app_colors.dart';
import 'package:mash_flutter/controllers/card_controller.dart';
import 'package:mash_flutter/views/screens/home/event_card_widget.dart';
import 'package:share_plus/share_plus.dart';

import 'home/create_event_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CardController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.to(() => const CreateEventScreen());
          },
          icon: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: AppColor.orange,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(Icons.add),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Share.share(
                  "https://apps.apple.com/us/app/mash-fun-meetups-new-friends/id1590373585");
            },
            icon: const Icon(
              Icons.share,
              color: AppColor.orange,
              size: 28,
            ),
          ),
          IconButton(
            onPressed: () {
              Share.share(
                  "https://apps.apple.com/us/app/mash-fun-meetups-new-friends/id1590373585");
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColor.orange,
              size: 34,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Obx(
        () => controller.cards.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/searching.json',
                    width: Get.width,
                  ),
                  Lottie.asset(
                    'assets/animations/searching.json',
                    width: Get.width,
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Fetching Experiences around you...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColor.orange,
                        ),
                      ),
                    ),
                  )
                ],
              )
            : Stack(
                children: List.generate(
                  controller.cards.length,
                  (index) => Swipable(
                    animationDuration: 300,
                    verticalSwipe: false,
                    threshold: 0.3,
                    child: EventCardWidget(
                      cardModel: controller.cards[index],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
