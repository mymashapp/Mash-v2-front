import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mash/configs/app_colors.dart';
import 'package:mash/main.dart';
import 'package:mash/noti/notification_handler_service.dart';
import 'package:mash/screens/home/model/notification_model.dart';
import 'package:mash/widgets/blur_loader.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final databaseRef = FirebaseDatabase.instance.reference();
  List<NotificationModel> notificationList = <NotificationModel>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kOrange,
          title: Text("Notifications"),
        ),
        body: StreamBuilder(
          stream: databaseRef
              .child("notifications/${authController.user.value.id}")
              .orderByChild("timestamp")
              .limitToFirst(15)
              .onValue,
          builder: (BuildContext context, AsyncSnapshot<Event> snap) {
            if (snap.hasData) {
              notificationList.clear();
              DataSnapshot dataValues = snap.data!.snapshot;
              if (dataValues.value != null) {
                Map<dynamic, dynamic> values = dataValues.value;
                values.forEach((key, value) {
                  notificationList
                      .add(notificationModelFromJson(jsonEncode(value)));
                });
              }
              return notificationList.isEmpty
                  ? Center(
                      child: Text(
                        "No Notifications",
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 20,
                          color: AppColors.kOrange,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(16),
                      itemCount: notificationList.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            print(notificationList[index].data!.type);
                            Get.back();
                            handleNoti(RemoteMessage(
                                data: notificationList[index].data!.toJson()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(4, 4),
                                      blurRadius: 10)
                                ],
                                color: Colors.white),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Icon(
                                    Icons.notifications,
                                    color: AppColors.kOrange,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    notificationList[index].notification!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(10)),
                                  child: Image.network(
                                    notificationList[index].data!.eventImage!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
            } else {
              return loading();
            }
          },
        ));
  }
}
