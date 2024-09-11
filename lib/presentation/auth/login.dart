import 'dart:async';
import 'dart:convert';

import 'package:error_handeler_flutter/error_handeler_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import '../utils/encry';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qr_attendance/constants/network_constants.dart';
import 'package:qr_attendance/datasource/local/local.dart';
import 'package:qr_attendance/presentation/home/home.dart';
import 'package:qr_attendance/presentation/models/response_model.dart';

class ResponsiveLoginPage extends StatefulWidget {
  @override
  _ResponsiveLoginPageState createState() => _ResponsiveLoginPageState();
}

class _ResponsiveLoginPageState extends State<ResponsiveLoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _showOtpField = false;
  bool _isOtpButtonDisabled = true;
  //
  // Future<void> _getOtp() async {
  //   if (kDebugMode) {
  //     Navigator.push(context,
  //         MaterialPageRoute(builder: (context) => ResponsiveLoginPage()));
  //   }
  //   // Trigger your API call here
  //   final url = '${NetworkConstants.baseUrl}${NetworkConstants.otp}';
  //   print('url is  :$url');
  //
  //   final res = await ErrorHandelerFlutter().post(url,
  //       timeout: 20,
  //       body: json.encode({
  //         "payload": {"otptype": "GEN", "mobileno": '9326434841', "val": ""}
  //       }));
  //   switch (res) {
  //     case Success(value: dynamic v):
  //       setState(() {
  //         _showOtpField = true;
  //       });
  //       break;
  //     case Failure(error: ErrorResponse res):
  //       setState(() {
  //         _showOtpField = false;
  //       });
  //       debugPrint(
  //           "Failed to send OTP : \n ${res.errorResponseHolder.defaultMessage} ");
  //       CustomSnackbar().showCustomSnackbar(
  //           mesg:
  //               "Failed to send OTP : \n  ${res.errorResponseHolder.defaultMessage}");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    CustomSnackbar().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.lightBlueAccent.withOpacity(0.3),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double height = constraints.maxHeight;
          double width = constraints.maxWidth;
          bool isTallScreen =
              height > 1000; // Assuming 1000 as a threshold for tall screens

          return Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, // 5% padding from the sides
              ),
              constraints: BoxConstraints(
                maxWidth: 600,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: isTallScreen
                            ? height * 0.1
                            : 20), // Adds more space on tall screens
                    if (!_showOtpField)
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: isTallScreen ? 32 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (_showOtpField)
                      Text(
                        'Enter OTP',
                        style: TextStyle(
                          fontSize: isTallScreen ? 32 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SizedBox(height: isTallScreen ? 40 : 20),
                    if (!_showOtpField) _buildPhoneNumberField(),

                    if (_showOtpField) _buildOtpField(),
                    if (_showOtpField)
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _showOtpField = false;
                              _isOtpButtonDisabled = true;
                            });
                          },
                          child: Text("Go to Login")),

                    SizedBox(
                        height: isTallScreen
                            ? height * 0.3
                            : 20), // More space at the bottom for tall screens
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: InputDecoration(
              labelText: 'Enter Number',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                // Enable Get OTP button only if 10 digits are entered
                _isOtpButtonDisabled = value.length != 10;
              });
            },
          ),
        ),
        SizedBox(width: 10),
        if (!_isOtpButtonDisabled)
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text('Get OTP'),
          ),
      ],
    );
  }

  Timer? timer;
  Future<void> _verifyOTP(String otp) async {
    if (timer != null && timer!.isActive) {
      // timer!.cancel();
      CustomSnackbar().showCustomSnackbar(
          mesg: 'An Api call is running,please wait until it finishes..');
      return;
    } else if (timer == null || !((timer?.isActive) ?? false)) {
      timer = Timer(Duration(seconds: 3), () {});
    }

    final url = '${NetworkConstants.baseUrl}${NetworkConstants.otp}';
    print('url is  :$url');

    final res = await ErrorHandelerFlutter().post(url,
        body: json.encode({
          "payload": {"otptype": "VAL", "mobileno": '9326434841', "otpval": otp}
        }));
    switch (res) {
      case Success(value: dynamic v):
        final resp = ResponseModel.fromJson(json.decode(v));
        if (resp.statuscode == 200 || resp.statuscode == 201) {
          CustomSnackbar()
              .showCustomSnackbar(mesg: 'OTP Verified Successfully');

          if (resp.finalmap.isNotEmpty) {
            await AppLocalStorage().storeUserInfo(resp.finalmap.first);
          }

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyHome()));
        } else {
          debugPrint("Failed to verify OTP : \n ${resp.message} ");
          CustomSnackbar().showCustomSnackbar(
              mesg: "Failed to verify OTP : \n  ${resp.message}");
        }
        break;
      case Failure(error: ErrorResponse res):
        debugPrint(
            "Failed to verify OTP : \n ${res.errorResponseHolder.defaultMessage} ");
        CustomSnackbar().showCustomSnackbar(
            mesg:
                "Failed to verify OTP : \n  ${res.errorResponseHolder.defaultMessage}");
    }
  }

  Widget _buildOtpField() {
    return FractionallySizedBox(
      widthFactor: 0.9, // Adjust width factor for tall screens
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: Colors.white,
          selectedFillColor: Colors.lightBlueAccent.withOpacity(0.3),
          inactiveFillColor: Colors.white,
        ),
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        enableActiveFill: true,
        controller: _otpController,
        onCompleted: (v) {
          print("Completed OTP: $v");
          _verifyOTP(v);
        },
        onChanged: (value) {
          print(value);
        },
        beforeTextPaste: (text) {
          return true;
        },
      ),
    );
  }
}
