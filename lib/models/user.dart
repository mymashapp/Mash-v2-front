class User {
  User({
    this.id,
    this.uid,
    this.name,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.bio,
    this.isNew,
    this.preferenceAgeTo,
    this.preferenceAgeFrom,
    this.preferenceGroupOf,
    this.preferenceGender,
    this.interests,
    this.pictures,
    this.selectedInterestIds,
    this.uploadedPictures,
    this.university,
    this.location,
    this.height,
    this.isVaccinated,
  });

  int? id;
  String? uid;
  String? name;
  String? email;
  DateTime? dateOfBirth;
  int? gender;
  String? bio;
  bool? isNew;
  int? preferenceAgeTo;
  int? preferenceAgeFrom;
  int? preferenceGroupOf;
  int? preferenceGender;
  List<Interest>? interests;
  List<Picture>? pictures;
  List<int>? selectedInterestIds;
  List<Picture>? uploadedPictures;
  String? university;
  String? location;
  int? height;
  bool? isVaccinated;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        dateOfBirth: DateTime.parse(json["dateOfBirth"]),
        gender: json["gender"],
        bio: json["bio"],
        isNew: json["isNew"],
        preferenceAgeTo: json["preferenceAgeTo"],
        preferenceAgeFrom: json["preferenceAgeFrom"],
        preferenceGroupOf: json["preferenceGroupOf"],
        preferenceGender: json["preferenceGender"],
        interests: List<Interest>.from(
            json["interests"].map((x) => Interest.fromJson(x))),
        pictures: List<Picture>.from(
            json["pictures"].map((x) => Picture.fromJson(x))),
        selectedInterestIds:
            List<int>.from(json["selectedInterestIds"].map((x) => x)),
        uploadedPictures: List<Picture>.from(
            json["uploadedPictures"].map((x) => Picture.fromJson(x))),
        university: json['university'],
        location: json['location'],
        height: json['height'],
        isVaccinated: json['isVaccinated'],
      );

  Map<String, dynamic> toJson() => {
        "id": id!,
        "uid": uid!,
        "name": name!,
        "email": email!,
        "dateOfBirth": dateOfBirth!.toIso8601String(),
        "gender": gender!,
        "bio": bio ?? "",
        "isNew": isNew!,
        "preferenceAgeTo": preferenceAgeTo!,
        "preferenceAgeFrom": preferenceAgeFrom!,
        "preferenceGroupOf": preferenceGroupOf!,
        "preferenceGender": preferenceGender!,
        "interests": interests == null
            ? []
            : List<dynamic>.from(interests!.map((x) => x.toJson())),
        "pictures": pictures == null
            ? []
            : List<dynamic>.from(pictures!.map((x) => x.toJson())),
        "selectedInterestIds":
            List<dynamic>.from(selectedInterestIds!.map((x) => x)),
        "uploadedPictures": uploadedPictures == null
            ? []
            : List<dynamic>.from(uploadedPictures!.map((x) => x.toJson())),
        "university": university,
        "location": location,
        "height": height,
        "isVaccinated": isVaccinated,
      };
}

class Interest {
  Interest({
    this.userId,
    this.interestId,
    this.interestName,
  });

  int? userId;
  int? interestId;
  String? interestName;

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
        userId: json["userId"],
        interestId: json["interestId"],
        interestName: json["interestName"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId!,
        "interestId": interestId!,
        "interestName": interestName!,
      };
}

class Picture {
  Picture({
    this.userId,
    this.pictureUrl,
    this.pictureType,
  });

  int? userId;
  String? pictureUrl;
  int? pictureType;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        userId: json["userId"],
        pictureUrl: json["pictureUrl"],
        pictureType: json["pictureType"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId!,
        "pictureUrl": pictureUrl!,
        "pictureType": pictureType!,
      };
}
