import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:mash_flutter/models/interest.dart';
import 'package:mash_flutter/models/user.dart' as app;
import 'package:mash_flutter/services/api.dart';
import 'package:mash_flutter/services/api_client.dart';
import 'package:mash_flutter/utils/error.dart';
import 'package:mash_flutter/views/screens/auth/introduce_your_self.dart';
import 'package:mash_flutter/views/screens/auth/sign_in_screen.dart';
import 'package:mash_flutter/views/screens/tab_bar_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../views/screens/auth/verify_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  // Api client (update as dependecy injection)
  final ApiClient _client = Get.find();

  late Rx<User?> firebaseUser;
  final RxBool isUserLogIn = false.obs;

  final FirebaseAuth auth = FirebaseAuth.instance;

  // Introduce your self
  static const List<String> genders = ['Male', 'Female'];
  final Rx<File?> profileImage = Rx<File?>(null);
  final Rx<File?> coverImage = Rx<File?>(null);
  final Rx<File?> mediaImage = Rx<File?>(null);
  final RxList<File> mediaImages = <File>[].obs;
  final Rx<TextEditingController> nameController = TextEditingController().obs;
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<TextEditingController> bioController = TextEditingController().obs;
  final Rx<TextEditingController> locationController =
      TextEditingController().obs;
  final Rx<TextEditingController> universityController =
      TextEditingController().obs;
  final Rx<TextEditingController> coverImageController =
      TextEditingController().obs;
  final Rx<TextEditingController> mediaImageController =
      TextEditingController().obs;
  final Rx<DateTime> dob =
      DateTime.now().subtract(const Duration(days: 6570)).obs;
  final RxString selectedGender = 'Male'.obs;
  final RxBool isReadOnlyEmail = false.obs;

  // Location prediction
  final RxList<AutocompletePrediction> predictions =
      <AutocompletePrediction>[].obs;

  final RxInt ft = 0.obs;
  final RxInt inches = 0.obs;

  // final RxList<Interest> interestList = Interest.interestList.obs;
  final RxList<Interest> interests = <Interest>[].obs;

  // List<Interest> get selectedInterestList =>
  //     interestList.where((e) => e.isSelected).toList();

  final RxBool loading = false.obs;

  // Sign in with phone number
  final Rx<TextEditingController> phoneNumberController =
      TextEditingController().obs;
  final Rx<TextEditingController> smsCodeController =
      TextEditingController().obs;
  String? _verificationId;

  // Our user
  app.User? user;

  // Preferences
  final RxBool isAgeSelected = false.obs;
  final Rx<String> genderPref = "".obs;
  final Rx<String> groupNoPref = "".obs;
  final RxDouble minAge = 18.0.obs;
  final RxDouble maxAge = 65.0.obs;

  // Profile image & Conver image
  final Rx<File?> newProfileImage = Rx<File?>(null);
  final RxBool newProfileUploading = false.obs;
  final Rx<File?> newCoverImage = Rx<File?>(null);
  final RxBool newCoverUploading = false.obs;
  final RxString profileImageUrl = ''.obs;
  final RxString coverImageUrl = ''.obs;
  final Rx<File?> newmediaImage = Rx<File?>(null);
  final RxList<app.Picture> mediaImageUrls = <app.Picture>[].obs;

  final RxString userName = ''.obs;
  final RxString bioDetails = ''.obs;
  final RxString university = ''.obs;
  final RxBool isCovidVaccinated = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (auth.currentUser != null) fetchUserDetails(auth.currentUser!.uid);
  }

  @override
  void onReady() {
    super.onReady();

    getAllInterests();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());

    ever(firebaseUser, _handleAuthChanged);
  }

  _handleAuthChanged(User? user) {
    if (user != null) {
      // User logged in
      // Get.offAll(() => const SignInScreen());
      isUserLogIn.value = true;
    } else {
      // User not logged in
      // Get.offAll(() => const SignInScreen());
      isUserLogIn.value = false;
    }
  }

  void selectGender(String? gender) {
    selectedGender.value = gender!;
  }

  void autoCompleteSearch(String? location) async {
    if (location != null && location.trim().isNotEmpty) {
      GooglePlace googlePlace =
          GooglePlace('AIzaSyArgtGCvxqhaW-EdFHnSeI4vTANeGvRFTg');
      predictions.clear();
      final response = await googlePlace.autocomplete.get(location);

      predictions.assignAll(response!.predictions!);
    } else {
      predictions.clear();
    }
  }

  // Sign in with phone number
  Future<void> signInWithPhone() async {
    final phoneNumber = "+1" + phoneNumberController.value.text;

    try {
      loading.value = true;

      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          loading.value = false;

          if (e.code == 'invalid-phone-number') {
            showErrorSnackBar(
              'Phone Number Invalid',
              'Please Check Your Phone Number.',
            );
          } else if (e.code == "too-many-requests") {
            showErrorSnackBar(
              'Too many requests',
              'We have blocked all requests from this device due to unusual activity. Try again later',
            );
          }

          debugPrint('Phone Auth Error ${e.code}');
        },
        codeSent: (String verificationId, int? resendToken) {
          loading.value = false;
          debugPrint(
              'Verification ID = $verificationId and Token $resendToken');
          _verificationId = verificationId;
          Get.to(() => const VerifyScreen());
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          loading.value = false;
          debugPrint('Verification ID' + verificationId);
        },
      );
    } catch (e) {
      loading.value = false;
      debugPrint(e.toString());
    }
  }

  void signInWithPhoneCredential() async {
    try {
      loading.value = true;

      UserCredential userCredential =
          await auth.signInWithCredential(PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCodeController.value.text,
      ));

      smsCodeController.value.clear();
      final token = await userCredential.user!.getIdToken();
      debugPrint('Firebase Token $token');

      loading.value = false;

      final uid = userCredential.user?.uid;
      fetchUserDetails(uid!, isForRoute: true);
    } catch (e) {
      loading.value = false;
      debugPrint(e.toString());
      showErrorSnackBar(
        'Invalid OTP',
        'Please provide right OTP',
      );
    }
  }

  // Sign in with Facebook
  void signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      nameController.value.text = userCredential.user!.displayName ?? '';
      emailController.value.text =
          userCredential.additionalUserInfo!.profile!['email'];
      isReadOnlyEmail.value =
          userCredential.additionalUserInfo!.profile!['email'].length > 0;

      fetchUserDetails(userCredential.user!.uid, isForRoute: true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        showErrorSnackBar(
          'Account exists',
          'Please check your account credential it\'s link with same.',
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Sign in with Apple
  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    const List<AppleIDAuthorizationScopes> scopes = [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ];

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: scopes,
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    final userCredential = await auth.signInWithCredential(oauthCredential);

    emailController.value.text = userCredential.user!.email ??
        userCredential.user!.providerData.first.email ??
        '';
    nameController.value.text = userCredential.user!.displayName ?? '';
    isReadOnlyEmail.value = true;

    fetchUserDetails(userCredential.user!.uid, isForRoute: true);
  }

  /// Get user by UID
  /// Check if user already in system or not
  void fetchUserDetails(String uid, {bool isForRoute = false}) async {
    loading.value = true;

    final response = await _client.getData(Api.GET_USER_BY_UID + '?uid=$uid');

    loading.value = false;

    final result = jsonDecode(response);

    if (result['isSucceeded'] == true) {
      final _user = app.User.fromJson(result['data']);
      user = _user;

      debugPrint('${_user.uid}');

      // Store user id
      Get.find<SharedPreferences>().setInt('USER_ID', _user.id!);

      // Fill controller and value to display in user screen
      nameController.value.text = _user.name!;
      if (_user.dateOfBirth!.year != 0001) {
        dob.value = _user.dateOfBirth!;
      }
      selectedGender.value = _user.gender == 1 ? 'Male' : 'Female';
      bioController.value.text = _user.bio!;
      locationController.value.text = _user.location ?? '';
      universityController.value.text = _user.university ?? '';

      List<String> selectedInterestNames =
          _user.interests!.map((e) => e.interestName!).toList();

      for (Interest interest in interests) {
        if (selectedInterestNames.contains(interest.name)) {
          interest.isSelected = true;
        }
      }

      if (user!.pictures != null && user!.pictures!.isNotEmpty) {
        final profileIndex =
            _user.pictures!.indexWhere((element) => element.pictureType == 1);

        if (profileIndex != -1) {
          profileImageUrl.value = 'https://backend.mymashapp.com/' +
              _user.pictures![profileIndex].pictureUrl!;
        }

        final coverIndex =
            _user.pictures!.indexWhere((element) => element.pictureType == 2);
        if (coverIndex != -1) {
          coverImageUrl.value = 'https://backend.mymashapp.com/' +
              _user.pictures![coverIndex].pictureUrl!;
        }

        final _mediaImages = _user.pictures!
            .where((element) => element.pictureType == 3)
            .toList();

        debugPrint('Media Images Lenght ==> ${_mediaImages.length}');

        mediaImageUrls.value = _mediaImages;
      }

      userName.value = user!.name!;
      bioDetails.value = user!.bio!;
      genderPref.value = user!.preferenceGender == 1
          ? 'Man'
          : user!.preferenceGender == 2
              ? 'Woman'
              : 'Both';
      groupNoPref.value =
          user!.preferenceGroupOf == 2 ? 'Group of 2' : 'Group of 3';

      if (user!.preferenceAgeFrom == 0) {
        minAge.value = 18.0;
      } else {
        minAge.value = user!.preferenceAgeFrom!.toDouble();
      }

      if (user!.preferenceAgeFrom == 0) {
        maxAge.value = 65.0;
      } else {
        maxAge.value = user!.preferenceAgeTo!.toDouble();
      }

      university.value = user!.university ?? '';
      isCovidVaccinated.value = user!.isVaccinated ?? false;

      if (isForRoute) {
        if (_user.isNew!) {
          Get.offAll(() => IntroduceYourSelf());
        } else {
          Get.offAll(() => const TabBarScreen());
        }
      }
    } else {
      showErrorSnackBar('Error', result['message']);
    }
  }

  // Put your data in to introduce your self
  void updateUserData({bool fromBackground = false}) async {
    if (user == null) return;

    loading.value = true;

    app.User _userInput = app.User();

    userName.value = nameController.value.text;
    bioDetails.value = bioController.value.text;
    university.value = universityController.value.text;

    _userInput.uid = user!.uid;
    _userInput.id = user!.id;
    _userInput.name = nameController.value.text;

    _userInput.dateOfBirth = dob.value;
    _userInput.gender = selectedGender.value == 'Male' ? 1 : 2;
    _userInput.bio = bioController.value.text;
    _userInput.isNew = true;

    _userInput.university = universityController.value.text;
    _userInput.location = locationController.value.text;
    _userInput.height = double.parse('${ft.value}.${inches.value}').toInt();
    _userInput.isVaccinated = isCovidVaccinated.value;

    _userInput.selectedInterestIds =
        interests.where((e) => e.isSelected).map((p) => p.id!).toSet().toList();

    if (fromBackground) {
      _userInput.email = emailController.value.text;
      _userInput.preferenceAgeTo = maxAge.toInt();
      _userInput.preferenceAgeFrom = minAge.toInt();
      _userInput.preferenceGroupOf = groupNoPref.value == 'Group of 2' ? 2 : 3;
      _userInput.preferenceGender = genderPref.value == 'Man'
          ? 1
          : genderPref.value == 'Woman'
              ? 2
              : 3;
    } else {
      _userInput.email = user!.email;
      _userInput.preferenceAgeTo = maxAge.toInt();
      _userInput.preferenceAgeFrom = minAge.toInt();
      _userInput.preferenceGroupOf = groupNoPref.value == 'Group of 2' ? 2 : 3;
      _userInput.preferenceGender = genderPref.value == 'Man'
          ? 1
          : genderPref.value == 'Woman'
              ? 2
              : 3;
    }

    _userInput.uploadedPictures = [];

    if (profileImage.value != null) {
      // convert profile image to base64
      final bytes = await profileImage.value!.readAsBytes();
      final base64String = base64.encode(bytes);

      String base64Image = 'data:image/png;base64,' + base64String;

      _userInput.uploadedPictures!.add(app.Picture(
          pictureType: 1, pictureUrl: base64Image, userId: user!.id));
    }

    if (coverImage.value != null) {
      // convert profile image to base64
      final bytes = await coverImage.value!.readAsBytes();
      final base64String = base64.encode(bytes);

      String base64Image = 'data:image/png;base64,' + base64String;

      _userInput.uploadedPictures!.add(app.Picture(
          pictureType: 2, pictureUrl: base64Image, userId: user!.id));
    }

    /*if (mediaImage.value != null) {
      // convert profile image to base64
      final bytes = await mediaImage.value!.readAsBytes();
      final base64String = base64.encode(bytes);

      String base64Image = 'data:image/png;base64,' + base64String;

      _userInput.uploadedPictures!.add(app.Picture(
          pictureType: 3, pictureUrl: base64Image, userId: user!.id));
    }*/

    if (mediaImages.isNotEmpty) {
      for (File media in mediaImages) {
        final bytes = await media.readAsBytes();
        final base64String = base64.encode(bytes);

        String base64Image = 'data:image/png;base64,' + base64String;

        _userInput.uploadedPictures!.add(app.Picture(
            pictureType: 3, pictureUrl: base64Image, userId: user!.id));
      }
    }

    _userInput.interests = [];
    _userInput.pictures = [];

    await _client.putData(Api.USER_UPDATE, _userInput.toJson());
    // remove old data from media images
    mediaImages.clear();

    fetchUserDetails(user!.uid!);

    loading.value = false;

    if (fromBackground) {
      Get.offAll(() => const TabBarScreen());
    } else {
      showSuccessSnackBar('Success', 'Details success fully updated');
    }
  }

  // Sign out
  void signOut() async {
    await auth.signOut();
    await Get.find<SharedPreferences>().clear();

    phoneNumberController.value.clear();

    Get.offAll(() => const SignInScreen());
  }

  void onPrefGenderChanged(String? gender) {
    genderPref.value = gender!;
  }

  void onPrefGroupChanged(String? group) {
    if (group == 'Group of 3') {
      genderPref.value = 'Both';
    }
    groupNoPref.value = group!;
  }

  void getAllInterests() async {
    final response = await _client.getData(Api.GET_ALL_INTERESTS);

    final _interests = List<Interest>.from(
        json.decode(response).map((x) => Interest.fromJson(x)));

    interests.assignAll(_interests);
  }

  void selectInterest(int index) {
    debugPrint('$index');

    if (interests[index].isSelected) {
      interests[index].isSelected = false;
    } else {
      final length = interests.where((e) => e.isSelected).toList().length;
      if (length >= 3) {
        showErrorSnackBar(
          'Error',
          'Choose maximum 3 interest to your profile',
        );
        return;
      }
      interests[index].isSelected = true;
    }

    // interests[index].isSelected = !interests[index].isSelected;
    interests.refresh();
  }

  void removeInterest(Interest interest) {
    final index = interests.indexWhere((element) => element.id == interest.id);

    interests[index].isSelected = false;
    interests.refresh();
  }

  // Upload profile image
  void uploadProfileImage() async {
    newProfileUploading.value = true;

    final bytes = await newProfileImage.value!.readAsBytes();
    final base64String = base64.encode(bytes);

    String base64Image = 'data:image/png;base64,' + base64String;

    final json = [
      {"userId": user!.id!, "pictureUrl": base64Image, "pictureType": 1}
    ];

    await _client.putData(Api.USER_UPDATE_PICTURE, json);
    fetchUserDetails(user!.uid!);

    newProfileUploading.value = false;
  }

  // Upload cover image
  void uploadCoverImage() async {
    newCoverUploading.value = true;

    final bytes = await newCoverImage.value!.readAsBytes();
    final base64String = base64.encode(bytes);

    String base64Image = 'data:image/png;base64,' + base64String;

    final json = [
      {"userId": user!.id!, "pictureUrl": base64Image, "pictureType": 2}
    ];

    await _client.putData(Api.USER_UPDATE_PICTURE, json);
    fetchUserDetails(user!.uid!);

    newCoverUploading.value = false;
  }

  void uploadMediaImage() async {
    final bytes = await newmediaImage.value!.readAsBytes();
    final base64String = base64.encode(bytes);

    String base64Image = 'data:image/png;base64,' + base64String;

    final json = [
      {"userId": user!.id!, "pictureUrl": base64Image, "pictureType": 3}
    ];

    await _client.putData(Api.USER_UPDATE_PICTURE, json);
    fetchUserDetails(user!.uid!);
  }

  void deleteMedia(int id) async {
    final json = [id];

    await _client.postData(Api.USER_UPDATE_PICTURE, json);
  }
}
