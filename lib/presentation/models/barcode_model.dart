class QrIdModel {
  DateTime? inTime; // Nullable DateTime
  String qridcode; // Non-nullable String
  bool isQrExist; // Non-nullable boolean

  // Constructor with named parameters and default values
  QrIdModel({
    this.inTime, // Nullable, so no default needed
    this.qridcode = '', // Default empty string
    this.isQrExist = false, // Default false
  });

  // Method to convert the instance back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'intimedatetime':
          inTime?.toIso8601String(), // Convert DateTime to ISO string
      'qrcode': qridcode,
      'isQrExist': isQrExist,
    };
  }
}
