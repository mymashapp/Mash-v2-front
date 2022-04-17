import 'dart:convert';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mash/configs/app_colors.dart';
import 'package:mash/configs/app_data.dart';
import 'package:mash/main.dart';
import 'package:mash/screens/auth/API/get_profile_picture.dart';
import 'package:mash/screens/feed_view/API/add_comment.dart';
import 'package:mash/screens/feed_view/API/block_user.dart';
import 'package:mash/screens/feed_view/API/comment_on_private_pic.dart';
import 'package:mash/screens/feed_view/API/get_friend_photos.dart';
import 'package:mash/screens/feed_view/API/like_on_private_pic.dart';
import 'package:mash/screens/feed_view/API/like_service.dart';
import 'package:mash/screens/feed_view/API/report_post.dart';
import 'package:mash/screens/feed_view/comment_page.dart';
import 'package:mash/screens/feed_view/controller/leaderboard_controller.dart';
import 'package:mash/screens/feed_view/models/friend_only_pics.dart';
import 'package:mash/screens/feed_view/models/friend_post_model.dart';
import 'package:mash/screens/feed_view/models/post_model.dart';
import 'package:mash/screens/profile_view/models/other_user_profile2.dart';
import 'package:mash/screens/profile_view/other_user_profile.dart';
import 'package:mash/widgets/blur_loader.dart';
import 'package:mash/widgets/error_snackbar.dart';
import 'package:mash/widgets/loading_circular_image.dart';
import 'package:mash/widgets/time_ago.dart';
import 'package:shimmer/shimmer.dart';

class Discover extends StatefulWidget {
  const Discover({Key? key}) : super(key: key);

  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> with TickerProviderStateMixin {
  List<String> tabs = ["All", "Friends"];
  LeaderBoardController leaderBoardController =
      Get.put(LeaderBoardController());
  GetStorage box = GetStorage();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 45,
                margin: EdgeInsets.only(bottom: 8.0),
                color: Colors.white,
                child: TabBar(
                  controller: authController.discoverController.value,
                  labelColor: AppColors.kOrange,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.kOrange.withOpacity(0.5),
                  ),
                  onTap: (index) {
                    if (index == 1) {
                      getFriendOnlyPics();
                    }
                  },
                  tabs: List.generate(
                    tabs.length,
                    (index) => Tab(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("${tabs[index]}"),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: authController.discoverController.value,
                  children: [
                    EveryonePage(),
                    FriendOnlyPage(),
                  ],
                ),
              )
            ],
          ),
          Obx(() => leaderBoardController.reportOpen.value
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.white54,
                  ),
                )
              : SizedBox()),
          Obx(
            () => AnimatedPositioned(
              bottom: leaderBoardController.reportOpen.value
                  ? 0
                  : -Get.height / 1.7,
              left: 0,
              child: Container(
                height: Get.height / 1.7,
                width: Get.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, -10),
                          blurRadius: 24)
                    ],
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            "Report",
                            style: TextStyle(
                                color: AppColors.kOrange,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              leaderBoardController.reportOpen.value = false;
                            },
                            icon: Icon(
                              Icons.close,
                              color: AppColors.kOrange,
                            )),
                      ],
                    ),
                    Divider(color: AppColors.kOrange),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Why are you reporting this post?",
                        style:
                            TextStyle(color: AppColors.kOrange, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Text(
                        "Your report is anonymous, except if you're reporting an intellectual property infringement. If someone is in immediate danger, call the local emergency services - don't wait.",
                        style: TextStyle(color: AppColors.kOrange),
                      ),
                    ),
                    Divider(
                      color: AppColors.kOrange,
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            reportPost(reportListPost[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  reportListPost[index],
                                  style: TextStyle(
                                      color: AppColors.kOrange, fontSize: 16),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: AppColors.kOrange,
                                )
                              ],
                            ),
                          ),
                        ),
                        separatorBuilder: (context, index) => Divider(
                          color: AppColors.lightOrange,
                          height: 20,
                        ),
                        itemCount: reportListPost.length,
                      ),
                    )
                  ],
                ),
              ),
              duration: Duration(milliseconds: 300),
            ),
          )
        ],
      ),
    );
  }
}

class EveryonePage extends StatefulWidget {
  const EveryonePage({Key? key}) : super(key: key);

  @override
  _EveryonePageState createState() => _EveryonePageState();
}

class _EveryonePageState extends State<EveryonePage> {
  final databaseRef = FirebaseDatabase.instance.reference();
  List<PostModel> list = <PostModel>[];
  List<TextEditingController> txtList = <TextEditingController>[];
  LeaderBoardController leaderBoardController =
      Get.put(LeaderBoardController());
  GetStorage box = GetStorage();
  static const _text = Color(0xFF565656);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          databaseRef.child("global_sharing").orderByChild("timestamp").onValue,
      builder: (context, AsyncSnapshot<Event> snap) {
        if (snap.hasData) {
          DataSnapshot dataValues = snap.data!.snapshot;
          if (dataValues.value != null) {
            Map<dynamic, dynamic> values = dataValues.value;
            list.clear();
            values.forEach((key, values) {
              PostModel postModel = postModelFromJson(jsonEncode(values));
              if (postModel.reports == null) {
                list.insert(0, postModelFromJson(jsonEncode(values)));
                txtList.add(TextEditingController());
              } else if (!postModel.reports!.keys
                  .contains(authController.user.value.id.toString())) {
                list.insert(0, postModelFromJson(jsonEncode(values)));
                txtList.add(TextEditingController());
              }
            });
          }
          return list.length == 0
              ? SizedBox()
              : ListView.separated(
                  separatorBuilder: (ctx, index) {
                    return Divider(
                      color: AppColors.lightOrange,
                    );
                  },
                  physics: BouncingScrollPhysics(),
                  itemCount: list.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, i) {
                    PostModel postModel = list[i];
                    return Container(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (authController.user.value.id !=
                                        postModel.userId) {
                                      int count = 0;
                                      List blockedId = [];
                                      if (box.read("blockedId") != null) {
                                        blockedId = box.read("blockedId");
                                        blockedId.forEach((element) {
                                          if (postModel.userId! == element) {
                                            count++;
                                          }
                                        });
                                        if (count != 0) {
                                          appSnackBar("User is blocked.",
                                              "User was blocked by you.");
                                        } else {
                                          Get.to(() => OtherUserProfileScreen(
                                                userName: postModel.userName!,
                                                userId: postModel.userId!,
                                                alreadyFriend: false,
                                              ));
                                        }
                                      } else {
                                        Get.to(() => OtherUserProfileScreen(
                                              userName: postModel.userName!,
                                              userId: postModel.userId!,
                                              alreadyFriend: false,
                                            ));
                                      }

                                      // Get.to(() => OtherUserProfileScreen(
                                      //       userName: postModel.userName!,
                                      //       userId: postModel.userId!,
                                      //       alreadyFriend: false,
                                      //     ));
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      FutureBuilder<String>(
                                        future: getProfile(postModel.userId),
                                        builder: (context, snap) {
                                          return loadingCircularImage(
                                              snap.hasData ? snap.data! : "",
                                              Get.width > 600 ? 15 : 22);
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${postModel.userName}",
                                            style: GoogleFonts.sourceSansPro(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "${timeAgo(DateTime.fromMillisecondsSinceEpoch(postModel.timestamp!))}",
                                            style: GoogleFonts.sourceSansPro(
                                              color: _text,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                authController.user.value.id == postModel.userId
                                    ? SizedBox()
                                    : PopupMenuButton(
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: AppColors.kOrange,
                                        ),
                                        onSelected: (val) {
                                          print(val);
                                          if (val == 0) {
                                            leaderBoardController.picId.value =
                                                postModel.id!;
                                            leaderBoardController
                                                .reportOpen.value = true;
                                          } else {
                                            blockUser(postModel.userId!).then(
                                                (value) => appSnackBar(
                                                    "User is successfully blocked.",
                                                    "User was blocked Now you can't see their activity"));
                                          }
                                        },
                                        itemBuilder: (context) {
                                          return List.generate(2, (index) {
                                            return PopupMenuItem(
                                              value: index,
                                              child: Text(
                                                index == 0
                                                    ? 'Report Post'
                                                    : 'Block User',
                                                style: TextStyle(
                                                    color: AppColors.kOrange),
                                              ),
                                            );
                                          });
                                        },
                                      )
                              ],
                            ),
                          ),
                          Container(
                            height: Get.height / 2.2,
                            color: AppColors.lightOrange,
                            child: loadingImage(postModel.imgUrl!),
                          ),
                          postModel.desc == null
                              ? const SizedBox(height: 10)
                              : Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 10, bottom: 10),
                                  child: Text(
                                    postModel.desc!,
                                    style: GoogleFonts.sourceSansPro(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (postModel.likes == null) {
                                      giveLike(postModel.id);
                                    } else {
                                      if (postModel.likes!.keys.contains(
                                          authController.user.value.id
                                              .toString())) {
                                        removeLike(postModel.id);
                                      } else {
                                        giveLike(postModel.id);
                                      }
                                    }
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        postModel.likes == null
                                            ? Icons.favorite_border
                                            : postModel.likes!.keys.contains(
                                                    authController.user.value.id
                                                        .toString())
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                        color: Colors.red,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text(
                                        postModel.likeCount == null
                                            ? "0"
                                            : postModel.likeCount.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    if (postModel.comments != null) {
                                      Get.to(
                                        () => CommentPage(
                                          comments: postModel.comments!.values,
                                          postId: postModel.id!,
                                          private: false,
                                        ),
                                      );
                                    } else {
                                      errorSnackBar("No comments available",
                                          "There is no comments available right now.");
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset('assets/icons/comment.png'),
                                      const SizedBox(width: 5.0),
                                      Text(
                                        postModel.comments == null
                                            ? "0"
                                            : postModel.comments!.values.length
                                                .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                    child: TextField(
                                  controller: txtList[i],
                                  onSubmitted: (value) {
                                    if (txtList[i].text.length > 0) {
                                      addComment(txtList[i].text, postModel.id!)
                                          .then((value) => txtList[i].clear());
                                    }
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    hintText: "Add comment",
                                    hintStyle: GoogleFonts.sourceSansPro(),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: AppColors.kOrange)),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: AppColors.kOrange)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: AppColors.kOrange)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: AppColors.kOrange)),
                                  ),
                                )),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    if (txtList[i].text.length > 0) {
                                      addComment(txtList[i].text, postModel.id!)
                                          .then((value) => txtList[i].clear());
                                    }
                                  },
                                  child: Icon(
                                    Icons.send,
                                    color: AppColors.kOrange,
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  });
        } else {
          return loading();
        }
      },
    );
  }
}

class FriendOnlyPage extends StatefulWidget {
  const FriendOnlyPage({Key? key}) : super(key: key);

  @override
  _FriendOnlyPageState createState() => _FriendOnlyPageState();
}

class _FriendOnlyPageState extends State<FriendOnlyPage> {
  final databaseRef = FirebaseDatabase.instance.reference();
  List<FriendPostModel> friendPostList = <FriendPostModel>[];
  LeaderBoardController leaderBoardController =
      Get.put(LeaderBoardController());
  List<TextEditingController> txtList = <TextEditingController>[];
  GetStorage box = GetStorage();
  static const _text = Color(0xFF565656);

  @override
  Widget build(BuildContext context) {
    return Obx(() => leaderBoardController.loading.value
        ? Center(
            child: CircularProgressIndicator(
              color: AppColors.kOrange,
            ),
          )
        : leaderBoardController.friendPics.length == 0
            ? Center(
                child: Text(
                  "No Post",
                  style: TextStyle(color: AppColors.kOrange, fontSize: 18),
                ),
              )
            : ListView.separated(
                separatorBuilder: (ctx, index) {
                  return Divider(
                    color: AppColors.lightOrange,
                  );
                },
                physics: BouncingScrollPhysics(),
                itemCount: leaderBoardController.friendPics.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 16),
                itemBuilder: (context, i) {
                  txtList.insert(i, TextEditingController());
                  FriendPhoto frdPic = leaderBoardController.friendPics[i];
                  return StreamBuilder(
                      stream: databaseRef
                          .child("friends_sharing")
                          .child(frdPic.friendsOnlyImgsId!)
                          .onValue,
                      builder: (context, AsyncSnapshot<Event> snap) {
                        if (snap.hasData) {
                          DataSnapshot dataValues = snap.data!.snapshot;
                          if (dataValues.value != null) {
                            Map<dynamic, dynamic> values = dataValues.value;
                            friendPostList.clear();
                            FriendPostModel friendPostModel =
                                friendPostModelFromJson(jsonEncode(values));
                            if (friendPostModel.reports == null) {
                              friendPostList.add(
                                  friendPostModelFromJson(jsonEncode(values)));
                            } else if (!friendPostModel.reports!.keys.contains(
                                authController.user.value.id.toString())) {
                              friendPostList.add(
                                  friendPostModelFromJson(jsonEncode(values)));
                            }
                          }
                          FriendPostModel postModel = friendPostList.first;
                          return postModel.reports == null
                              ? friendPostCard(frdPic, postModel, i)
                              : postModel.reports!.keys.contains(
                                      authController.user.value.id.toString())
                                  ? friendPostCard(frdPic, postModel, i)
                                  : SizedBox();
                        } else {
                          return Shimmer.fromColors(
                              child: Container(
                                height: 200,
                                width: Get.width,
                              ),
                              baseColor: Colors.white,
                              highlightColor: AppColors.lightOrange);
                        }
                      });
                }));
  }

  Widget friendPostCard(FriendPhoto frdPic, FriendPostModel postModel, int i) {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      // decoration: BoxDecoration(
      //     border: Border.all(
      //         color: AppColors.kOrange),
      //     borderRadius:
      //         BorderRadius.circular(10.r),
      //     color:
      //         AppColors.kOrange.withOpacity(0.1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              if (authController.user.value.id !=
                  frdPic.friendsOnlyImgsUserId) {
                int count = 0;
                List blockedId = [];
                if (box.read("blockedId") != null) {
                  blockedId = box.read("blockedId");
                  blockedId.forEach((element) {
                    if (frdPic.friendsOnlyImgsUserId! == element) {
                      count++;
                    }
                  });
                  if (count != 0) {
                    appSnackBar("User is blocked.", "User was blocked by you.");
                  } else {
                    Get.to(() => OtherUserProfileScreen(
                          userName: frdPic.fullName!,
                          userId: frdPic.friendsOnlyImgsUserId!,
                          alreadyFriend: false,
                        ));
                  }
                } else {
                  Get.to(() => OtherUserProfileScreen(
                        userName: frdPic.fullName!,
                        userId: frdPic.friendsOnlyImgsUserId!,
                        alreadyFriend: false,
                      ));
                }

                // Get.to(() => OtherUserProfileScreen(
                //       userName: frdPic.fullName!,
                //       userId: frdPic.friendsOnlyImgsUserId!,
                //       alreadyFriend: false,
                //     ));
              }
            },
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  FutureBuilder<String>(
                    future: getProfile(frdPic.friendsOnlyImgsUserId),
                    builder: (context, snap) {
                      return loadingCircularImage(
                          snap.hasData ? snap.data! : "", 22);
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${frdPic.fullName}",
                        style: GoogleFonts.sourceSansPro(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${timeAgo(DateTime.fromMillisecondsSinceEpoch(postModel.uploadeAt!))}",
                        style: GoogleFonts.sourceSansPro(
                          color: _text,
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  authController.user.value.id == frdPic.friendsOnlyImgsUserId
                      ? SizedBox()
                      : PopupMenuButton(
                          icon: Icon(
                            Icons.more_horiz,
                            color: AppColors.kOrange,
                          ),
                          onSelected: (val) {
                            print(val);
                            if (val == 0) {
                              leaderBoardController.picId.value =
                                  frdPic.friendsOnlyImgsId!;
                              leaderBoardController.reportOpen.value = true;
                            } else {
                              blockUser(frdPic.friendsOnlyImgsUserId!).then(
                                  (value) => appSnackBar(
                                      "User is successfully blocked.",
                                      "User was blocked Now you can't see their activity"));
                            }
                          },
                          itemBuilder: (context) {
                            return List.generate(2, (index) {
                              return PopupMenuItem(
                                value: index,
                                child: Text(
                                  index == 0 ? 'Report Post' : 'Block User',
                                  style: TextStyle(color: AppColors.kOrange),
                                ),
                              );
                            });
                          },
                        )
                ],
              ),
            ),
          ),
          // Container(
          //   height: 230,
          //   decoration: BoxDecoration(
          //       color: Colors.white,
          //       boxShadow: [
          //         BoxShadow(
          //           color: AppColors.shadowColor,
          //           offset: Offset(3, 3),
          //           blurRadius: 6,
          //         )
          //       ],
          //       image: DecorationImage(
          //           fit: BoxFit.contain,
          //           image: NetworkImage(
          //               postModel.imgUrl!))),
          // ),
          Container(
              color: AppColors.lightOrange,
              child: loadingImage(frdPic.friendsOnlyImgsUrl!)),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    if (postModel.likes == null) {
                      givePrivateLike(frdPic.friendsOnlyImgsId);
                    } else {
                      if (postModel.likes!.keys
                          .contains(authController.user.value.id.toString())) {
                        removePrivateLike(frdPic.friendsOnlyImgsId);
                      } else {
                        givePrivateLike(frdPic.friendsOnlyImgsId);
                      }
                    }
                  },
                  child: Column(
                    children: [
                      Icon(
                        postModel.likes == null
                            ? Icons.thumb_up_outlined
                            : postModel.likes!.keys.contains(
                                    authController.user.value.id.toString())
                                ? Icons.thumb_up_alt
                                : Icons.thumb_up_outlined,
                        color: AppColors.kOrange,
                      ),
                      Text(
                        postModel.likeCount == null
                            ? "0"
                            : postModel.likeCount.toString(),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    if (postModel.comments != null) {
                      Get.to(() => CommentPage(
                            comments: postModel.comments!.values,
                            postId: frdPic.friendsOnlyImgsId!,
                            private: true,
                          ));
                    } else {
                      errorSnackBar("No comments available",
                          "There is no comments available right now.");
                    }
                  },
                  child: Column(
                    children: [
                      Image.asset('assets/icons/comment.png'),
                      Text(
                        postModel.comments == null
                            ? "0"
                            : postModel.comments!.values.length.toString(),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: TextField(
                  controller: txtList[i],
                  onSubmitted: (value) {
                    if (txtList[i].text.length > 0) {
                      addCommentOnPrivatePic(
                              txtList[i].text, frdPic.friendsOnlyImgsId!)
                          .then((value) => txtList[i].clear());
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    hintText: "Add comment",
                    hintStyle: GoogleFonts.sourceSansPro(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: AppColors.kOrange)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: AppColors.kOrange)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: AppColors.kOrange)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: AppColors.kOrange)),
                  ),
                )),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    if (txtList[i].text.length > 0) {
                      addCommentOnPrivatePic(
                              txtList[i].text, frdPic.friendsOnlyImgsId!)
                          .then((value) => txtList[i].clear());
                    }
                  },
                  child: Icon(
                    Icons.send,
                    color: AppColors.kOrange,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
