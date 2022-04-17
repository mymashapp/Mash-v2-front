// To parse this JSON data, do
//
//     final mashModel = mashModelFromJson(jsonString);

import 'dart:convert';

List<MashModel> mashModelFromJson(String str) =>
    List<MashModel>.from(json.decode(str).map((x) => MashModel.fromJson(x)));

class MashModel {
  MashModel(
      {this.collectionId,
      this.userId,
      this.fileName,
      this.nftName,
      this.description,
      this.price,
      this.approve,
      this.createdAt,
      this.fullName,
      this.link});

  int? collectionId;
  int? userId;
  String? fileName;
  String? nftName;
  String? description;
  double? price;
  int? approve;
  DateTime? createdAt;
  String? fullName;
  String? link;

  factory MashModel.fromJson(Map<String, dynamic> json) => MashModel(
        collectionId:
            json["collection_id"] == null ? null : json["collection_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        fileName: json["file_name"] == null ? null : json["file_name"],
        nftName: json["nft_name"] == null ? null : json["nft_name"],
        description: json["description"] == null ? null : json["description"],
        price: json["price"] == null ? null : json["price"].toDouble(),
        approve: json["approve"] == null ? null : json["approve"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        fullName: json["full_name"] == null ? null : json["full_name"],
        link: json["link"] == null ? null : json["link"],
      );
}
