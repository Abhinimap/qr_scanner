import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:qr_attendance/constants/app_exceptions.dart';
import 'package:qr_attendance/constants/constants.dart';
import 'package:qr_attendance/constants/result.dart';
import 'package:qr_attendance/presentation/models/otp_verified_response_model.dart';

class AppLocalStorage {
  // Private constructor
  AppLocalStorage._internal();

  // Singleton instance
  static final AppLocalStorage _instance = AppLocalStorage._internal();

  // Factory constructor that returns the singleton instance
  factory AppLocalStorage() {
    return _instance;
  }

  // Singleton instance of the Hive box
  Box? _box;

  // User Box
  Box? _userBox;

  // Initialize and open the Hive box if not already opened
  Future<void> initHiveBox(
      {required String boxName, required String dir}) async {
    Hive.init(dir);
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox(boxName);
      _userBox = await Hive.openBox(Constants.userBoxName);
    }
  }

  // Dummy/default name for the Hive box
  static const String _defaultBoxName = 'defaultBox';

  // Asynchronous getter for the Hive box instance
  Future<Box> get box async {
    // Initialize the box if it's not already opened
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox(_defaultBoxName);
    }
    return _box!;
  }

  Future<Box> get userBox async {
    // Initialize the userBox if it's not already opened
    if (_userBox == null || !_userBox!.isOpen) {
      _userBox = await Hive.openBox(_defaultBoxName);
    }
    return _userBox!;
  }

  /// Store Api Access Token
  /// Access Token Should be received from APi
  Future<Result<bool>> storeAccessToken({String accessToken = 'data'}) async {
    try {
      await (await box).put('token', accessToken);
      return Success(true);
    } catch (e) {
      return Error(AppException(errorMessage: 'Something went wrong \n $e'));
    }
  }

  /// Get Access Token for Api Call
  Future<Result<String>> getAccessToken() async {
    try {
      return Success((await (await box).get('token')).toString());
    } catch (e) {
      return Error(
          AppException(errorMessage: 'Unable to get access token : $e'));
    }
  }

  /// update user status when login and logout Event occurs
  Future<Result<bool>> updateUserLoggedInStatus(
      {bool isLoggedIn = false}) async {
    try {
      await (await box).put('isLoggedIn', isLoggedIn);
      return Success(true);
    } catch (e) {
      return Error(AppException(errorMessage: '$e'));
    }
  }

  /// get User LoggedIn status for Easy Access of Application to user
  Future<Result<bool>> isUserLoggedIn() async {
    try {
      final result = await (await box).get('isLoggedIn') as bool;
      return Success(result);
    } catch (e) {
      return Error(AppException(errorMessage: '$e'));
    }
  }

  /// Store User Info when OTP is verified
  Future<Result> storeUserInfo(OtpVerifiedResponseModel userInfo) async {
    try {
      await (await userBox)
          .put(Constants.verifiedUserInfo, json.encode(userInfo.toJson()));

      await storeAccessToken(accessToken: userInfo.accesstoken);
      await updateUserLoggedInStatus(isLoggedIn: true);
      return Success(true);
    } catch (e) {
      return Error(LocalStorageException(message: '$e'));
    }
  }

  /// fetch User Info when OTP is verified
  Future<Result> fetchUserVerifiedInfo() async {
    try {
      final result = await (await userBox).get(Constants.verifiedUserInfo);
      return Success(result);
    } catch (e) {
      return Error(LocalStorageException(message: '$e'));
    }
  }
}
