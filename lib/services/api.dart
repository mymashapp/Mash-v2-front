// ignore_for_file: constant_identifier_names

class Api {
  static const String BASE_URL = 'https://backend.mymashapp.com/api/';

  static const String GET_USER_BY_UID = 'User/GetUserByUid/';
  static const String USER_UPDATE = 'User/Update/';
  static const String USER_UPDATE_PICTURE = 'User/UpdatePictures';

  static const String GET_ALL_INTERESTS = 'Interest/GetAllInterests/';

  static const String GET_CARDS = 'Card/GetCards';
  static const String CREATE_CARD = 'Card/Create';

  static const String GET_CATEGORY = 'Category/GetAllCategory';
}

/*public enum PictureType
{
    ProfilePicture = 1,
    Cover = 2,
    Media = 3
}

public enum Gender
{
    Male = 1,
    Female = 2,
    Other = 3
}

public enum GroupType
{
    Two = 2,
    Three = 3,
}

public enum CardType
{
    Yelp = 1,
    Own = 2,
    Airbnb = 3,
    Groupon = 4
}

public enum SwipeType
{
    Left = 0,
    Right = 1
}*/