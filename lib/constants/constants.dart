import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {
  static Size _screenSize() {
    FlutterView _view = WidgetsBinding.instance.platformDispatcher.views.first;
    return _view.physicalSize;
  }

  static Size get getScreenSize {
    return _screenSize();
  }

  static const String userBoxName = 'user';
  static const String verifiedUserInfo = 'otpVerifiedUserInfo';
  static const String markAttendance = 'उपस्थिति अंकित करें';
  static const String knowYourPoints = 'अपने अंक जानें';
  static const String faciliies = 'सुविधाएँ';
  static const String nps = 'NPS';
  static TextStyle cardTextStyle =
      TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400);
}
