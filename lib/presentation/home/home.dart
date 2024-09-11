import 'package:error_handeler_flutter/error_handeler_flutter.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance/constants/constants.dart';
import 'package:qr_attendance/mobile_scanner/barcode_scanner_with_controoler.dart';
import 'package:qr_attendance/qr_flutter_files/qr_flutter_preview.dart';

import '../utils/temp.dart';

class MyHome extends StatefulWidget {
  MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<Text> _texts = [
    Text(
      Constants.markAttendance,
      textAlign: TextAlign.center,
      style: Constants.cardTextStyle,
    ),
    Text(
      Constants.knowYourPoints,
      textAlign: TextAlign.center,
      style: Constants.cardTextStyle,
    ),
    Text(
      Constants.faciliies,
      textAlign: TextAlign.center,
      style: Constants.cardTextStyle,
    ),
    Text(
      Constants.nps,
      textAlign: TextAlign.center,
      style: Constants.cardTextStyle,
    )
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = Constants.getScreenSize.height;
    final _width = Constants.getScreenSize.width;

    CustomSnackbar().init(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Go with QR'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Temp()));
                },
                icon: Icon(
                  Icons.logout_outlined,
                ))
          ],
          backgroundColor: Colors.lightBlueAccent.withOpacity(0.3),
        ),
        body: Container(
          height: _height,
          width: _width,
          color: Colors.white,
          // decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.lightBlueAccent.withOpacity(0.3),Colors.white],begin: Alignment.bottomRight,end: Alignment.topLeft,stops: [
          //   0.05,0.9
          // ]),),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (index == 3) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QrFlutterPage()));
                      return;
                    }
                    if (index == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BarcodeScannerWithController()));
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BarcodeScannerWithController()));
                  },
                  child: Card(
                    borderOnForeground: false,
                    elevation: 2,
                    color: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.lightBlueAccent.withOpacity(0.2),
                              Colors.white
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.circular(
                              15), // Ensure the corners match the Card's radius
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Image.asset(
                                  'assets/attendance.png',
                                  height: _height * 0.1,
                                  width: _width * 0.2,
                                ),
                              ),
                              _texts[index],
                            ],
                          ),
                        )),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
