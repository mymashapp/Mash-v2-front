class UserDataModel {
  DataUser? data;
  bool? isSucceeded;
  int? id;
  String? additionalData;
  String? message;
  int? resultType;

  UserDataModel(
      {this.data,
      this.isSucceeded,
      this.id,
      this.additionalData,
      this.message,
      this.resultType});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new DataUser.fromJson(json['data']) : null;
    isSucceeded = json['isSucceeded'];
    id = json['id'];
    additionalData = json['additionalData'];
    message = json['message'];
    resultType = json['resultType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.isSucceeded != null) {
      data['isSucceeded'] = this.isSucceeded;
    }
    if (this.id != null) {
      data['id'] = this.id;
    }
    if (this.additionalData != null) {
      data['additionalData'] = this.additionalData;
    }
    if (this.message != null) {
      data['message'] = this.message;
    }
    if (this.resultType != null) {
      data['resultType'] = this.resultType;
    }

    return data;
  }
}

class DataUser {
  String? uid;
  String? name;
  String? email;
  String? dateOfBirth;
  int? profilePictureId;
  int? gender;
  String? bio;
  bool? isNew;
  String? profilePictureUrl;
  int? preferenceAgeTo;
  int? preferenceAgeFrom;
  int? preferenceGroupOf;
  int? preferenceGender;
  List<Interests>? interests;
  List<Pictures>? pictures;
  List<Pictures>? uploadedPictures;
  List<int>? selectedInterestIds;
  List<String>? picturesBase64;
  int? id;

  DataUser(
      {this.uid,
      this.name,
      this.email,
      this.dateOfBirth,
      this.profilePictureId,
      this.gender,
      this.bio,
      this.uploadedPictures,
      this.isNew,
      this.profilePictureUrl,
      this.preferenceAgeTo,
      this.preferenceAgeFrom,
      this.preferenceGroupOf,
      this.preferenceGender,
      this.interests,
      this.pictures,
      this.selectedInterestIds,
      this.picturesBase64,
      this.id});

  DataUser.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    dateOfBirth = json['dateOfBirth'];
    profilePictureId = json['profilePictureId'];
    gender = json['gender'];
    bio = json['bio'];
    isNew = json['isNew'];
    profilePictureUrl = json['profilePictureUrl'];
    preferenceAgeTo = json['preferenceAgeTo'];
    preferenceAgeFrom = json['preferenceAgeFrom'];
    preferenceGroupOf = json['preferenceGroupOf'];
    preferenceGender = json['preferenceGender'];
    if (json['interests'] != null) {
      interests = <Interests>[];
      json['interests'].forEach((v) {
        interests!.add(new Interests.fromJson(v));
      });
    }
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures!.add(new Pictures.fromJson(v));
      });
    }
    if (json['uploadedPictures'] != null) {
      uploadedPictures = <Pictures>[];
      json['uploadedPictures'].forEach((v) {
        uploadedPictures!.add(new Pictures.fromJson(v));
      });
    }
    if (json['selectedInterestIds'] != null) {
      selectedInterestIds = <int>[];
      json['selectedInterestIds'].forEach((v) {
        selectedInterestIds!.add((v));
      });
    }
    if (json['picturesBase64'] != null) {
      picturesBase64 = <String>[];
      json['picturesBase64'].forEach((v) {
        picturesBase64!.add((v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uid != null) {
      data['uid'] = this.uid;
    }
    if (this.name != null) {
      data['name'] = this.name;
    }
    if (this.email != null) {
      data['email'] = this.email;
    }
    if (this.dateOfBirth != null) {
      data['dateOfBirth'] = this.dateOfBirth;
    }
    if (this.gender != null) {
      data['gender'] = this.gender;
    }
    if (this.bio != null) {
      data['bio'] = this.bio;
    }

    if (this.isNew != null) {
      data['isNew'] = this.isNew;
    }
    if (this.preferenceAgeTo != null) {
      data['preferenceAgeTo'] = this.preferenceAgeTo;
    }
    if (this.preferenceAgeFrom != null) {
      data['preferenceAgeFrom'] = this.preferenceAgeFrom;
    }
    if (this.preferenceGroupOf != null) {
      data['preferenceGroupOf'] = this.preferenceGroupOf;
    }
    if (this.preferenceGender != null) {
      data['preferenceGender'] = this.preferenceGender;
    }

    if (this.interests != null) {
      data['interests'] = this.interests!.map((v) => v.toJson()).toList();
    }
    if (this.pictures != null) {
      data['pictures'] = this.pictures!.map((v) => v.toJson()).toList();
    }
    if (this.uploadedPictures != null) {
      data['uploadedPictures'] =
          this.uploadedPictures!.map((v) => v.toJson()).toList();
    }
    if (this.selectedInterestIds != null) {
      data['selectedInterestIds'] =
          this.selectedInterestIds!.map((v) => v).toList();
    }
    if (this.picturesBase64 != null) {
      data['picturesBase64'] = this.picturesBase64!.map((v) => v).toList();
    }
    data['id'] = this.id;
    return data;
  }
}

class Interests {
  int? userId;
  int? interestId;
  String? interestName;
  int? id;

  Interests({this.userId, this.interestId, this.interestName, this.id});

  Interests.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    interestId = json['interestId'];
    interestName = json['interestName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['userId'] = this.userId;
    data['interestId'] = this.interestId;
    data['interestName'] = this.interestName;
    //  data['id'] = this.id;
    return data;
  }
}

class Pictures {
  int? userId;
  String? url;
  int? id;
  int? pictureType;

  Pictures({this.userId, this.url, this.id, this.pictureType});

  Pictures.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    url = json['pictureUrl'] ?? "";
    // id = json['id']?"";
    pictureType = json['pictureType'] ?? 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //  data['userId'] = this.userId;
    data['pictureUrl'] = this.url;
    //data['id'] = this.id;
    data['pictureType'] = this.pictureType;
    return data;
  }
}
