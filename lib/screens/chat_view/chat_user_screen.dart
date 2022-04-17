// import 'package:firebase_core/firebase_core.dart';

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:mash/configs/app_colors.dart';
import 'package:mash/main.dart';
import 'package:mash/screens/auth/API/get_profile_picture.dart';
import 'package:mash/screens/chat_view/API/chat_opened.dart';
import 'package:mash/screens/chat_view/API/get_chat_users.dart';
import 'package:mash/screens/chat_view/chat_view.dart';
import 'package:mash/screens/chat_view/controller/chat_controller.dart';
import 'package:mash/screens/chat_view/models/chat_users_model.dart';
import 'package:mash/screens/chat_view/models/direct_chat_model.dart';
import 'package:mash/screens/home/API/get_user_from_chat_id.dart';
import 'package:mash/screens/home/controller/home_controller.dart';
import 'package:mash/screens/home/model/user_list_model.dart';
import 'package:mash/widgets/blur_loader.dart';
import 'package:mash/widgets/loading_circular_image.dart';
import 'package:mash/widgets/shimmer_loader.dart';
import 'package:mash/widgets/spacers.dart';
import 'package:mash/widgets/user_profile.dart';

class ChatUserScreen extends StatefulWidget {
  const ChatUserScreen({Key? key}) : super(key: key);

  @override
  _ChatUserScreenState createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen>
    with SingleTickerProviderStateMixin {
  // late TabController tabController;
  final databaseRef = FirebaseDatabase.instance.reference();
  ScrollController scrollController = ScrollController();
  ChatController chatController = Get.put(ChatController());

  @override
  void initState() {
    chatController.count.value = 0;
    chatController.chatUserList.clear();
    chatController.direct.clear();
    chatController.currentPage.value = 1;
    chatController.lastPage.value = false;
    openBox();
    getChatUsers();
    getPrivateChatUsers();
    scrollController
      ..addListener(() {
        var triggerFetchMoreSize =
            0.9 * scrollController.position.maxScrollExtent;
        if (scrollController.position.pixels > triggerFetchMoreSize &&
            !chatController.bottomLoader.value) {
          if (!chatController.lastPage.value) {
            chatController.bottomLoader.value = true;
            if (chatController.currentTab.value == 0) {
              getChatUsers();
            } else {
              getPrivateChatUsers();
            }
          }
        }
      });
    super.initState();
    // tabController = TabController(length: 2, vsync: this);
  }

  openBox() async {
    // print(chatController.box.read('deleteList'));
    // chatController.deleteList = chatController.box.read('deleteList') ?? [];
    if (chatController.box.read('deleteList') != null) {
      chatController.deleteList = chatController.box.read('deleteList');
    } else {
      chatController.deleteList = [].obs;
    }
    if (chatController.box.read("deleteGroupList") != null) {
      chatController.deleteGroupList =
          chatController.box.read('deleteGroupList');
    } else {
      chatController.deleteGroupList = [].obs;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: Get.width,
            height: 80,
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              //     boxShadow: [
              //   BoxShadow(
              //       color: AppColors.shadowColor,
              //       offset: Offset(2, 2),
              //       blurRadius: 10)
              // ]
            ),
            padding: EdgeInsets.only(top: 50),
            child: Text(
              "Messages",
              style: GoogleFonts.sourceSansPro(
                  fontSize: 22,
                  color: AppColors.kOrange,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8),
              textAlign: TextAlign.center,
            )
            // TabBar(
            //     indicatorColor: AppColors.kOrange,
            //     physics: BouncingScrollPhysics(),
            //     controller: tabController,
            //     onTap: (index) {
            //       chatController.currentTab.value = index;
            //
            //       if (index == 0) {
            //         chatController.currentPage.value = 1;
            //         chatController.chatUserList.clear();
            //         getChatUsers();
            //       } else {
            //         chatController.currentPage.value = 1;
            //         chatController.direct.clear();
            //         getPrivateChatUsers();
            //       }
            //     },
            //     tabs: [
            //       Container(
            //           alignment: Alignment.center,
            //           height: 40,
            //           child: Text(
            //             "Mash",
            //             style: GoogleFonts.sourceSansPro(
            //               fontSize: 18,
            //               color: AppColors.kOrange,
            //             ),
            //             textAlign: TextAlign.center,
            //           )),
            //       Container(
            //           alignment: Alignment.center,
            //           height: 40,
            //           child: Text("Direct",
            //               style: GoogleFonts.sourceSansPro(
            //                   fontSize: 18, color: AppColors.kOrange),
            //               textAlign: TextAlign.center)),
            //     ]),
            ),
        Divider(
          thickness: 2,
          indent: 20,
          endIndent: 20,
          color: AppColors.kOrange,
        ),
        Expanded(
          child: Obx(
            () => chatController.loading.value &&
                    !chatController.bottomLoader.value
                ? loading()
                : (chatController.chatUserList.length > 0 ||
                        chatController.direct.length > 0)
                    ? ListView.separated(
                        controller: scrollController,
                        physics: BouncingScrollPhysics(),
                        separatorBuilder: (context, i) {
                          return y16;
                        },
                        padding: EdgeInsets.all(16),
                        itemCount: chatController.chatUserList.length +
                            chatController.direct.length,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          print(chatController.chatUserList.length +
                              chatController.direct.length);
                          if (i == 0) {
                            chatController.count.value = 0;
                          }
                          if (i < chatController.chatUserList.length) {
                            ChatUsersModel chatUser =
                                chatController.chatUserList[i];
                            return Column(
                              children: [
                                ChatCard(
                                  chatUsersModel: chatUser,
                                  chatController: chatController,
                                ),
                                chatController.bottomLoader.value &&
                                        chatController.chatUserList.length -
                                                1 ==
                                            i
                                    ? loading()
                                    : SizedBox()
                              ],
                            );
                          } else {
                            Direct chatUser = chatController
                                .direct[chatController.count.value++];
                            chatController.count.value = 0;
                            return Column(
                              children: [
                                ChatCard2(
                                  chatUsersModel: chatUser,
                                  chatController: chatController,
                                ),
                                chatController.bottomLoader.value &&
                                        chatController.chatUserList.length -
                                                1 ==
                                            i
                                    ? loading()
                                    : SizedBox()
                              ],
                            );
                          }
                        })
                    : Center(
                        child: Text(
                          "No Chats",
                          style: GoogleFonts.sourceSansPro(
                              fontSize: 20, color: AppColors.kOrange),
                        ),
                      ),
          ),
        ),
        // Expanded(
        //   child: TabBarView(
        //       physics: NeverScrollableScrollPhysics(),
        //       controller: tabController,
        //       children: [
        //         Obx(
        //           () => chatController.loading.value &&
        //                   !chatController.bottomLoader.value
        //               ? loading()
        //               : chatController.chatUserList.length > 0
        //                   ? ListView.separated(
        //                       controller: scrollController,
        //                       physics: BouncingScrollPhysics(),
        //                       separatorBuilder: (context, i) {
        //                         return y16;
        //                       },
        //                       padding: EdgeInsets.all(16),
        //                       itemCount: chatController.chatUserList.length,
        //                       shrinkWrap: true,
        //                       itemBuilder: (context, i) {
        //                         ChatUsersModel chatUser =
        //                             chatController.chatUserList[i];
        //                         return Column(
        //                           children: [
        //                             ChatCard(chatUsersModel: chatUser),
        //                             chatController.bottomLoader.value &&
        //                                     chatController.chatUserList.length -
        //                                             1 ==
        //                                         i
        //                                 ? loading()
        //                                 : SizedBox()
        //                           ],
        //                         );
        //                       })
        //                   : Center(
        //                       child: Text(
        //                         "No Chats",
        //                         style: GoogleFonts.sourceSansPro(
        //                             fontSize: 20, color: AppColors.kOrange),
        //                       ),
        //                     ),
        //         ),
        //         Obx(
        //           () => chatController.loading.value &&
        //                   !chatController.bottomLoader.value
        //               ? loading()
        //               : chatController.direct.length > 0
        //                   ? ListView.separated(
        //                       controller: scrollController,
        //                       physics: BouncingScrollPhysics(),
        //                       separatorBuilder: (context, i) {
        //                         return y16;
        //                       },
        //                       padding: EdgeInsets.all(16),
        //                       itemCount: chatController.direct.length,
        //                       shrinkWrap: true,
        //                       itemBuilder: (context, i) {
        //                         Direct chatUser = chatController.direct[i];
        //                         return Column(
        //                           children: [
        //                             ChatCard2(chatUsersModel: chatUser),
        //                             chatController.bottomLoader.value &&
        //                                     chatController.chatUserList.length -
        //                                             1 ==
        //                                         i
        //                                 ? loading()
        //                                 : SizedBox()
        //                           ],
        //                         );
        //                       })
        //                   : Center(
        //                       child: Text(
        //                         "No Chats",
        //                         style: GoogleFonts.sourceSansPro(
        //                             fontSize: 20, color: AppColors.kOrange),
        //                       ),
        //                     ),
        //         ),
        //       ]),
        // ),
      ],
    );
  }

  // Widget chatCardLoading() {
  //   return ListView.separated(
  //       physics: NeverScrollableScrollPhysics(),
  //       separatorBuilder: (context, i) {
  //         return y16;
  //       },
  //       padding: EdgeInsets.all(16),
  //       itemCount: 10,
  //       shrinkWrap: true,
  //       itemBuilder: (context, i) {
  //         return singleLoader();
  //       });
  // }
}

class ChatCard extends StatefulWidget {
  final ChatUsersModel chatUsersModel;
  final ChatController chatController;
  const ChatCard(
      {Key? key, required this.chatUsersModel, required this.chatController})
      : super(key: key);

  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final databaseRef = FirebaseDatabase.instance.reference();
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor,
                offset: Offset(2, 2),
                blurRadius: 8)
          ],
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.lightOrange),
      child: Material(
        color: Colors.transparent,
        child: FutureBuilder<List<UserOfMashList>>(
            future: getUsersFromChatId(widget.chatUsersModel.chatMainId!),
            builder: (context, userSnaps) {
              return InkWell(
                splashColor: AppColors.kOrange.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12.r),
                onTap: () {
                  chatOpenedService(widget.chatUsersModel.chatMainId!);
                  userSnaps.data!.forEach((element) async {
                    String url = await getProfile(element.chatMainUsersId);
                    homeController.userOfMashList.add(element);
                    homeController.userProfile
                        .addIf(true, element.chatMainUsersId!, url);
                  });
                  Get.to(() => ChatView(
                        messageId: widget.chatUsersModel.chatMainId!,
                        eventName: widget.chatUsersModel.eventExtra?.name ?? "",
                        event: true,
                        eventImage:
                            widget.chatUsersModel.eventExtra?.imageUrl ?? "",
                      ));
                },
                child: Container(
                  child: FutureBuilder(
                      future: databaseRef
                          .child("messages")
                          .child(widget.chatUsersModel.chatMainId!)
                          .child("msgs")
                          .orderByChild("timestamp")
                          .once(),
                      builder: (context, AsyncSnapshot snap) {
                        if (snap.hasData) {
                          DataSnapshot data = snap.data;
                          Map<String, dynamic>? dataMap =
                              jsonDecode(jsonEncode(data.value));
                          debugPrint("Chat data $dataMap");
                          return Dismissible(
                            key: Key(
                                widget.chatUsersModel.chatMainId.toString()),
                            onDismissed: (direction) {
                              widget.chatController.deleteGroupList
                                  .add(widget.chatUsersModel.chatMainId);
                              widget.chatController.box.write("deleteGroupList",
                                  widget.chatController.deleteGroupList);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Chat Deleted.")),
                              );
                            },
                            secondaryBackground: Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Icon(Icons.delete, color: Colors.white),
                                    Text('Delete',
                                        style: TextStyle(color: Colors.white)),
                                    SizedBox(
                                      width: 40,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              decoration: BoxDecoration(
                                  color: Colors.red.shade300,
                                  borderRadius: BorderRadius.circular(12.r)),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  loadingCircularImage(widget.chatUsersModel
                                          .eventExtra?.imageUrl ??
                                      ""),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.chatUsersModel.eventExtra
                                                  ?.name ??
                                              "",
                                          style: GoogleFonts.sourceSansPro(
                                            fontSize: 18,
                                            color: AppColors.kOrange,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        userSnaps.hasData
                                            ? Wrap(
                                                spacing: 5,
                                                runSpacing: 5,
                                                children: List.generate(
                                                    userSnaps.data!.length,
                                                    (index) {
                                                  String name = "";
                                                  List<String> temp1 = userSnaps
                                                      .data![index].fullName!
                                                      .split(" ");
                                                  if (temp1.length == 1) {
                                                    name = userSnaps
                                                        .data![index].fullName!;
                                                  } else {
                                                    name =
                                                        "${userSnaps.data![index].fullName!.split(" ")[0]} ${userSnaps.data![index].fullName!.split(" ")[1][0]}.";
                                                  }
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 7,
                                                            vertical: 3),
                                                    decoration: BoxDecoration(
                                                        color: AppColors.kOrange
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40)),
                                                    child: Text(
                                                      name,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  );
                                                }),
                                              )
                                            : Wrap(
                                                spacing: 5,
                                                runSpacing: 5,
                                                children: List.generate(
                                                    3,
                                                    (index) =>
                                                        shimmerLoadingCard(
                                                            height: 18,
                                                            radius: 40,
                                                            width: 60)),
                                              ),
                                        dataMap != null
                                            ? Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(dataMap
                                                    .values.last["text"]),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                  dataMap != null
                                      ? dataMap.values.last["user_id"] !=
                                              authController.user.value.id
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  color: AppColors.kBlue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 5),
                                              child: Text(
                                                "Your Move",
                                                style:
                                                    GoogleFonts.sourceSansPro(
                                                        color: Colors.white),
                                              ),
                                            )
                                          : SizedBox()
                                      : SizedBox()
                                ],
                              ),
                            ),
                          );
                        } else {
                          return singleLoader();
                        }
                      }),
                ),
              );
            }),
      ),
    );
  }
}

Widget singleLoader() {
  return Container(
    decoration: BoxDecoration(
        color: AppColors.lightOrange,
        borderRadius: BorderRadius.circular(12.r)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        shimmerLoadingCard(height: 40, width: 40, radius: 120.r),
        SizedBox(
          width: 10,
        ),
        shimmerLoadingCard(height: 40, width: 40, radius: 120.r),
        SizedBox(
          width: 5,
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            shimmerLoadingCard(height: 15),
            SizedBox(
              height: 5,
            ),
            shimmerLoadingCard(height: 10)
          ],
        )),
        SizedBox(
          width: 5,
        ),
        shimmerLoadingCard(height: 30, width: 70)
      ],
    ),
  );
}

class ChatCard2 extends StatefulWidget {
  final Direct chatUsersModel;
  final ChatController chatController;
  const ChatCard2(
      {Key? key, required this.chatUsersModel, required this.chatController})
      : super(key: key);

  @override
  _ChatCard2State createState() => _ChatCard2State();
}

class _ChatCard2State extends State<ChatCard2> {
  final databaseRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseDatabase.instance
        .reference()
        .child("messages")
        .child(widget.chatUsersModel.usersFriendsListChatId!);
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor,
                offset: Offset(2, 2),
                blurRadius: 8)
          ],
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.lightOrange),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: AppColors.kOrange.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            chatOpenedService(widget.chatUsersModel.usersFriendsListChatId!);
            Get.to(() => ChatView(
                  messageId: widget.chatUsersModel.usersFriendsListChatId!,
                  eventName: widget.chatUsersModel.fullName!,
                  event: false,
                  status: widget.chatUsersModel.usersFriendsListStatus!,
                  eventImage:
                      widget.chatUsersModel.usersFriendsListFriendId.toString(),
                ));
          },
          child: Container(
            child: FutureBuilder(
                future: databaseRef
                    .child("messages")
                    .child(widget.chatUsersModel.usersFriendsListChatId!)
                    .child("msgs")
                    .orderByChild("timestamp")
                    .once(),
                builder: (context, AsyncSnapshot snap) {
                  if (snap.hasData) {
                    DataSnapshot data = snap.data;
                    Map<String, dynamic>? dataMap =
                        jsonDecode(jsonEncode(data.value));
                    return Dismissible(
                      key: Key(widget.chatUsersModel.usersFriendsListFriendId
                          .toString()),
                      onDismissed: (direction) {
                        widget.chatController.deleteList.add(
                            widget.chatUsersModel.usersFriendsListFriendId);
                        widget.chatController.box.write(
                            "deleteList", widget.chatController.deleteList);
                        databaseRef
                            .child("messages")
                            .child(
                                widget.chatUsersModel.usersFriendsListChatId!)
                            .child("msgs")
                            .child(data.key!)
                            .remove();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Chat Deleted.")),
                        );
                      },
                      secondaryBackground: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Icon(Icons.delete, color: Colors.white),
                              Text('Delete',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(
                                width: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        decoration: BoxDecoration(
                            color: Colors.red.shade300,
                            borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            userProfile(
                                widget.chatUsersModel.usersFriendsListFriendId
                                    .toString(),
                                Get.width > 600 ? 12 : 20),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.chatUsersModel.fullName!,
                                    style: GoogleFonts.sourceSansPro(
                                      fontSize: 18,
                                      color: AppColors.kOrange,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  dataMap == null
                                      ? SizedBox()
                                      : Text(dataMap.values.last["type"] ==
                                              "event"
                                          ? "Shared an event"
                                          : dataMap.values.last["type"] ==
                                                      "groupon" ||
                                                  dataMap.values.last["type"] ==
                                                      "airbnb"
                                              ? "Shared on coupon"
                                              : dataMap.values.last["text"])
                                ],
                              ),
                            ),
                            dataMap != null
                                ? dataMap.values.last["user_id"] !=
                                        authController.user.value.id
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.kBlue,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 5),
                                        child: Text(
                                          "Your Move",
                                          style: GoogleFonts.sourceSansPro(
                                              color: Colors.white),
                                        ),
                                      )
                                    : SizedBox()
                                : SizedBox()
                          ],
                        ),
                      ),
                    );
                  } else {
                    return singleLoader();
                  }
                }),
          ),
        ),
      ),
    );
  }
}
