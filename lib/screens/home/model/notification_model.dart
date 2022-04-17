// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.notification,
    this.data,
    this.time,
  });

  String? notification;
  Data? data;
  int? time;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        notification:
            json["notification"] == null ? null : json["notification"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        time: json["time"] == null ? null : json["time"],
      );

  Map<String, dynamic> toJson() => {
        "notification": notification == null ? null : notification,
        "data": data == null ? null : data!.toJson(),
        "time": time == null ? null : time,
      };
}

class Data {
  Data({
    this.messageId,
    this.joinedPerson,
    this.chatId,
    this.type,
    this.eventImage,
    this.eventName,
  });

  String? messageId;
  String? joinedPerson;
  String? chatId;
  String? type;
  String? eventImage;
  String? eventName;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        messageId: json["messageId"] == null ? null : json["messageId"],
        joinedPerson:
            json["joined_person"] == null ? null : json["joined_person"],
        chatId: json["chat_id"] == null ? null : json["chat_id"],
        type: json["type"] == null ? null : json["type"],
        eventImage: json["eventImage"] == null ? null : json["eventImage"],
        eventName: json["eventName"] == null ? null : json["eventName"],
      );

  Map<String, dynamic> toJson() => {
        "messageId": messageId == null ? null : messageId,
        "joined_person": joinedPerson == null ? null : joinedPerson,
        "chat_id": chatId == null ? null : chatId,
        "type": type == null ? null : type,
        "eventImage": eventImage == null ? null : eventImage,
        "eventName": eventName == null ? null : eventName,
      };
}
