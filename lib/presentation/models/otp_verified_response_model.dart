class OtpVerifiedResponseModel {
  int userid;
  String user;
  String usermobileno;
  String usertype;
  List<dynamic> assignmodule;
  String accesstoken;

  // Constructor with named parameters and default values
  OtpVerifiedResponseModel({
    this.userid = 0,
    this.user = '',
    this.usermobileno = '',
    this.usertype = '',
    List<dynamic>? assignmodule,
    this.accesstoken = '',
  }) : assignmodule = assignmodule ?? []; // Default empty list if null

  // Factory method to create an instance from a JSON map
  factory OtpVerifiedResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpVerifiedResponseModel(
      userid: json['userid'] ?? 0,
      user: json['user'] ?? '',
      usermobileno: json['usermobileno'] ?? '',
      usertype: json['usertype'] ?? '',
      assignmodule: json['assignmodule'] ?? [], // Default to empty list if null
      accesstoken: json['accesstoken'] ?? '',
    );
  }

  // Method to convert the instance back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'user': user,
      'usermobileno': usermobileno,
      'usertype': usertype,
      'assignmodule': assignmodule,
      'accesstoken': accesstoken,
    };
  }
}
