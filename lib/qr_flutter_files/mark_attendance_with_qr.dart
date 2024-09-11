import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MarkAttendanceWithQr{

  Future<Widget> showQrFromData({required String? qrData})async{
    if(qrData==null){
      return const SizedBox();
    }
    return Future.value(QrImageView(data: qrData,size: 200,
      errorStateBuilder: (cxt, err) {
        return  const Center(
          child: Text(
            'Uh oh! Something went wrong...',
            textAlign: TextAlign.center,
          ),
        );
      },
    ));
  }
}