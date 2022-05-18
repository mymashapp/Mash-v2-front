class CardModel {
  CardModel({
    this.name,
    this.alias,
    this.pictureUrl,
    this.url,
    this.reviewCount,
    this.rating,
    this.phoneNo,
    this.address,
    this.zipCode,
    this.latitude,
    this.longitude,
    this.category,
    this.subCategories,
    this.pictures,
    this.dateUtc,
    this.cardType,
    this.swipeCount,
    this.id,
  });

  String? name;
  String? alias;
  String? pictureUrl;
  String? url;
  int? reviewCount;
  double? rating;
  String? phoneNo;
  String? address;
  String? zipCode;
  double? latitude;
  double? longitude;
  String? category;
  List<String>? subCategories;
  List<String>? pictures;
  DateTime? dateUtc;
  CardType? cardType;
  int? swipeCount;
  int? id;

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
        name: json["name"],
        alias: json["alias"],
        pictureUrl: json["pictureUrl"],
        url: json["url"],
        reviewCount: json["reviewCount"],
        rating: json["rating"] != null ? json["rating"].toDouble() : 0,
        phoneNo: json["phoneNo"],
        address: json["address"],
        zipCode: json["zipCode"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        category: json["category"],
        subCategories: List<String>.from(json["subCategories"].map((x) => x)),
        pictures: List<String>.from(json["pictures"].map((x) => x)),
        dateUtc: DateTime.parse(json["dateUtc"]),
        cardType: (json["cardType"] as int).cardType,
        swipeCount: json["swipeCount"] ?? 0,
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "alias": alias,
        "pictureUrl": pictureUrl,
        "url": url,
        "reviewCount": reviewCount,
        "rating": rating,
        "phoneNo": phoneNo,
        "address": address,
        "zipCode": zipCode,
        "latitude": latitude,
        "longitude": longitude,
        "category": category,
        "subCategories": List<dynamic>.from(subCategories!.map((x) => x)),
        "pictures": List<dynamic>.from(pictures!.map((x) => x)),
        "dateUtc": dateUtc!.toIso8601String(),
        "cardType": cardType!.value,
        "id": id,
      };
}

enum CardType {
  yelp, // 1
  own, // 2
  airbnb, // 3
  groupon, // 4
}

extension CardTypeExtension on CardType {
  int get value {
    switch (this) {
      case CardType.yelp:
        return 1;
      case CardType.own:
        return 2;
      case CardType.airbnb:
        return 3;
      case CardType.groupon:
        return 4;
    }
  }
}

extension CardTypeValueExtension on int {
  CardType get cardType {
    switch (this) {
      case 1:
        return CardType.yelp;
      case 2:
        return CardType.own;
      case 3:
        return CardType.airbnb;
      case 4:
        return CardType.groupon;
      default:
        return CardType.own;
    }
  }
}

enum SwipeType {
  left, //  0,
  right // 1
}
