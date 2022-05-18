import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mash_flutter/constants/app_colors.dart';
import 'package:mash_flutter/views/screens/chat_screen.dart';

class ChatUserListScreen extends StatelessWidget {
  const ChatUserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        itemCount: 9,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Get.to(() => const ChatScreen());
            },
            child: const ChartItemWidget(),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16.0);
        },
      ),
    );
  }
}

class ChartItemWidget extends StatelessWidget {
  const ChartItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: AppColor.lightOrange,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor,
            offset: const Offset(2, 2),
            blurRadius: 8,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('HG'),
                  ),
                ),
              ),
              const SizedBox(width: 5.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('User Name'),
                    /*Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColor.orange.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Text('Name'),
                    ),*/
                    const Padding(
                      padding: EdgeInsets.only(left: 1.0),
                      child: Text('Message Text Message Text Message'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
