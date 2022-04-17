// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

List<NotificationModel> notificationModelFromJson(String str) =>
    List<NotificationModel>.from(
        json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
  NotificationModel({
    this.title,
    this.messageId,
    this.message,
    this.data,
    this.read,
  });

  String? title;
  String? messageId;
  String? message;
  String? data;
  bool? read;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        title: json["title"],
        messageId: json["message_id"],
        message: json["message"],
        data: json["data"],
        read: json["read"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "message_id": messageId,
        "message": message,
        "data": data,
        "read": read,
      };
}
