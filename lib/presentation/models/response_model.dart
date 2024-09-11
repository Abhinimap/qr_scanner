import 'package:qr_attendance/presentation/models/otp_verified_response_model.dart';

class ResponseModel {
  int statuscode;
  int responsecode;
  String message;
  String error;
  List<OtpVerifiedResponseModel> finalmap;

  // Constructor with named parameters and default values
  ResponseModel({
    this.statuscode = 0,
    this.responsecode = 0,
    this.message = '',
    this.error = '',
    List<OtpVerifiedResponseModel>? finalmap,
  }) : finalmap = finalmap ?? []; // Default empty list if null

  // Factory method to create an instance from a JSON map
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      statuscode: json['statuscode'] ?? 0,
      responsecode: json['responsecode'] ?? 0,
      message: json['message'] ?? '',
      error: json['error'] ?? '',
      finalmap: (json['finalmap'] as List<dynamic>?)
              ?.map((e) =>
                  OtpVerifiedResponseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [], // Convert to list of FinalMap, default to empty list if null
    );
  }

  // Method to convert the instance back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'statuscode': statuscode,
      'responsecode': responsecode,
      'message': message,
      'error': error,
      'finalmap': finalmap.map((e) => e.toJson()).toList(),
    };
  }
}
