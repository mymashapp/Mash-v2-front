import 'package:firebase_database/firebase_database.dart';

Future<String> getProfile(int? userId) async {
  final dataSnapshot = await FirebaseDatabase.instance
      .reference()
      .child('users')
      .child(userId!.toString())
      .once();

  if (dataSnapshot.exists)
    return dataSnapshot.value['profile_pic'] ??
        "https://mbevivino.files.wordpress.com/2011/08/silhouette_orange.jpg";

  return "https://mbevivino.files.wordpress.com/2011/08/silhouette_orange.jpg";

  /*String url = await FirebaseStorage.instance
      .ref('users/$userId/thumbnails/profile_pic_300x300.png')
      // .ref('users/$userId/thumbnails/profile_pic_300x300.png')
      .getDownloadURL()
      .catchError((e) {
    return "https://mbevivino.files.wordpress.com/2011/08/silhouette_orange.jpg";
  });
  url = url.length == 0 ? "" : url;
  return url;*/
}

Future<String> getCoverPhoto(int? userId) async {
  final dataSnapshot = await FirebaseDatabase.instance
      .reference()
      .child('users')
      .child(userId!.toString())
      .once();

  if (dataSnapshot.exists)
    return dataSnapshot.value['cover_pic'] ??
        "https://mbevivino.files.wordpress.com/2011/08/silhouette_orange.jpg";

  return "https://mbevivino.files.wordpress.com/2011/08/silhouette_orange.jpg";

  /*String url = await FirebaseStorage.instance
      .ref('users/$userId/thumbnails/cover_pic_300x300.png')
      // .ref('users/$userId/thumbnails/profile_pic_300x300.png')
      .getDownloadURL()
      .catchError((e) {
    return "https://mbevivino.files.wordpress.com/2011/08/silhouette_orange.jpg";
  });
  url = url.length == 0 ? "" : url;
  return url;*/
}
