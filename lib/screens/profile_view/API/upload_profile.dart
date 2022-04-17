import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mash/main.dart';
import 'package:http/http.dart' as http;
import '../../../configs/base_url.dart';
import '../../auth/models/user_get_data_model.dart';

Future<void> uploadProfile(String filePath, {int pictureType = 1}) async {
  print("START");
  final box = GetStorage();
  File file = File(filePath);
  int userId = authController.user.value.id!;
  if (file != null) {
    final bytes = await file.readAsBytes();
    final b64img = base64.encode(bytes);
    //final bytes = profile?.readAsBytesSync();
    String base64Image = "data:image/png;base64," + b64img;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'PUT', Uri.parse('${WebApi.baseUrlNew}/api/User/UpdatePictures'));

    Pictures p =
        Pictures(pictureType: 1, url: b64img, userId: box.read("userId"));
    request.body = json.encode([
      {
        "userId": box.read("userId"),
        "pictureUrl": base64Image,
        "pictureType": 1
      }
    ]);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var resp = await http.Response.fromStream(response);
      var data = jsonDecode(resp.body);
      print(data);
    } else {
      print(response.reasonPhrase);
    }
  }

  // try {
  //   final snapshot = await FirebaseStorage.instance
  //       .ref('users/$userId/${DateTime.now().millisecond}_profile_pic.png')
  //       .putFile(file);
  //
  //   final imageUrl = await snapshot.ref.getDownloadURL();
  //
  //   await FirebaseDatabase.instance
  //       .reference()
  //       .child('users')
  //       .child(userId.toString())
  //       .child('profile_pic')
  //       .set(imageUrl);
  // } on FirebaseException catch (e) {
  //   print("ERROR ::: ${e.toString()}");
  //   // e.g, e.code == 'canceled'
  // }
  // print("END");
}

Future<void> uploadCoverPhoto(String filePath) async {
  print("START");
  File file = File(filePath);
  int userId = authController.user.value.id!;
  final box = GetStorage();
  if (file != null) {
    final bytes = await file.readAsBytes();
    final b64img = base64.encode(bytes);
    //final bytes = profile?.readAsBytesSync();
    String base64Image = "data:image/png;base64," + b64img;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'PUT', Uri.parse('${WebApi.baseUrlNew}/api/User/UpdatePictures'));

    request.body = json.encode([
      {
        "userId": box.read("userId"),
        "pictureUrl": base64Image,
        "pictureType": 2
      }
    ]);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var resp = await http.Response.fromStream(response);
      var data = jsonDecode(resp.body);
      print(data);
    } else {
      print(response.reasonPhrase);
    }
  }
}
