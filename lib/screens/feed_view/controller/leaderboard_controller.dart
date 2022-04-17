import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mash/screens/feed_view/models/friend_location_model.dart';
import 'package:mash/screens/feed_view/models/friend_only_pics.dart';
import 'package:mash/screens/feed_view/models/leaderboard_user_model.dart';

class LeaderBoardController extends GetxController {
  RxBool loading = false.obs;
  RxList<LUser> leaderBoardUser = <LUser>[].obs;
  RxInt selectedTab = 0.obs;
  RxList<FriendPhoto> friendPics = <FriendPhoto>[].obs;
  RxList<FriendLocation> friendLocation = <FriendLocation>[].obs;
  RxSet<Marker> markers = Set<Marker>().obs;
  RxInt selectedUserId = 0000.obs;
  RxInt selectEveryone = 0.obs;
  RxBool reportOpen = false.obs;
  RxString picId = "".obs;
}
