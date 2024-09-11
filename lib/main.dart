import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_attendance/datasource/local/local.dart';
import 'package:qr_attendance/firebase_options.dart';
import 'package:qr_attendance/presentation/home/home.dart';

final users = [
  'RNOadcVyICfbBDUGCWP5ujTNPj62',
  '3Dg4XJhwzsS4radsegaxWrETAka2',
  'IwVh7ydbk4NKhd5X0xrKgTYXY4X2'
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Get the app's document directory

  final appDocDir = await getApplicationDocumentsDirectory();
  AppLocalStorage().initHiveBox(boxName: 'qrApp', dir: appDocDir.path);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((onValue) {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mobile Scanner Example',
        home: MyHome(),
      ),
    );
  });
}
