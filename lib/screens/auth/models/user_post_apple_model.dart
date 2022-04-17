// To parse this JSON data, do
//
//     final userPostDataModel = userPostDataModelFromJson(jsonString);

import 'dart:convert';

UserPostAppleDataModel userPostDataModelFromJson(String str) =>
    UserPostAppleDataModel.fromJson(json.decode(str));

String userPostDataModelToJson(UserPostAppleDataModel data) =>
    json.encode(data.toJson());

class UserPostAppleDataModel {
  UserPostAppleDataModel({
    this.userData,
    this.firebaseToken,
  });

  UserAppleData? userData;
  String? firebaseToken;

  factory UserPostAppleDataModel.fromJson(Map<String, dynamic> json) =>
      UserPostAppleDataModel(
        userData: json["user_data"] == null
            ? null
            : UserAppleData.fromJson(json["user_data"]),
        firebaseToken:
            json["firebase_token"] == null ? null : json["firebase_token"],
      );

  Map<String, dynamic> toJson() => {
        "user_data": userData == null ? null : userData!.toJson(),
        "firebase_token": firebaseToken == null ? null : firebaseToken,
      };
}

class UserAppleData {
  UserAppleData({
    this.fullName,
    this.dobTimestamp,
    this.email,
    this.gender,
  });

  String? fullName;
  int? dobTimestamp;
  String? email;
  String? gender;

  factory UserAppleData.fromJson(Map<String, dynamic> json) => UserAppleData(
        fullName: json["full_name"] == null ? null : json["full_name"],
        dobTimestamp:
            json["dob_timestamp"] == null ? null : json["dob_timestamp"],
        email: json["email"] == null ? null : json["email"],
        gender: json["gender"] == null ? null : json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName == null ? null : fullName,
        "dob_timestamp": dobTimestamp == null ? null : dobTimestamp,
        "email": email == null ? null : email,
        "gender": gender == null ? null : gender,
      };
}
