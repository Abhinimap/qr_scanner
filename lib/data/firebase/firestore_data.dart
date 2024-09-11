import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:error_handeler_flutter/error_handeler_flutter.dart';
import 'package:flutter/material.dart';
import 'package:qr_attendance/presentation/models/barcode_model.dart';

class AppFirebaseStore {
  static final _fstore = FirebaseFirestore.instance;
  AppFirebaseStore._();

  static Future<QuerySnapshot<Map<String, dynamic>>> get getQrCodes async {
    return await _fstore.collection('qrs').get();
  }

  static Future<void> storeQrCode(QrIdModel qr) async {
    try {
      debugPrint("storing qr to firebase...");
      await _fstore
          .collection('qrs')
          .doc(qr.qridcode)
          .set({"data": qr.qridcode});
    } catch (e) {
      debugPrint("Failed   to store qr on firebase :$e");
    }
  }

  static Future<bool> isQrExists(String qrID) async {
    return (await _fstore
            .collection('qrs')
            .where('data', isEqualTo: qrID)
            .get())
        .docs
        .isNotEmpty;
  }

  static Stream<bool> markAttendance(String uid) async* {
    try {
      debugPrint("storing qr to firebase...");
      if (uid.trim().isEmpty) {
        debugPrint('attendance not marked as uid is empty ');
        yield true;
      }
      yield false;
      final attDocs = await _fstore
          .collection('users')
          .doc(uid)
          .collection('attendance')
          .get();
      final isUserLoggedInToday = attDocs.docs
          .where((e) =>
              (e.id == DateTime.now().toIso8601String().substring(0, 10)))
          .toList()
          .isNotEmpty;
      if (!isUserLoggedInToday) {
        await _fstore
            .collection('users')
            .doc(uid)
            .collection('attendance')
            .doc(DateTime.now().toIso8601String().substring(0, 10))
            .set({
          "in_time": DateTime.now().toIso8601String(),
          "updatedAt": DateTime.now(),
        });
        CustomSnackbar().showCustomSnackbar(mesg: 'Logged In Success');
        yield true;
      } else {
        final inTime_list = attDocs.docs.map((e) async {
          if (e.id == DateTime.now().toIso8601String().substring(0, 10)) {
            final docData = e.data();
            return docData['in_time'] as String;
          }
        }).toList();

        if (inTime_list.isNotEmpty) {
          final parsedInTime = DateTime.tryParse(await inTime_list.first ?? '');
          final diff = parsedInTime == null
              ? null
              : DateTime.now().difference(parsedInTime).inMinutes;
          debugPrint(
              'difference in time : $diff, intime : ${await inTime_list.first}');
          if (diff != null && diff > 10) {
            await _fstore
                .collection('users')
                .doc(uid)
                .collection('attendance')
                .doc(DateTime.now().toIso8601String().substring(0, 10))
                .update({
              'out_time': DateTime.now().toIso8601String(),
              "updatedAt": DateTime.now(),
            });
            CustomSnackbar().showCustomSnackbar(mesg: 'Log out Success');
            debugPrint('Log out Success');
            yield true;
          } else {
            CustomSnackbar().showCustomSnackbar(
                mesg: 'you recently logged in , cant be logout before 10 mins');
            debugPrint(
                'you recently logged in , cant be logout before 10 mins');
            yield true;
          }
        } else {
          CustomSnackbar()
              .showCustomSnackbar(mesg: 'your attendance is not registered');
          debugPrint('your attendance is not registered');
          yield true;
        }
      }
    } catch (e) {
      CustomSnackbar()
          .showCustomSnackbar(mesg: 'Error Occured while marking attendance');

      debugPrint("Failed   to store qr on firebase :$e");
      yield true;
    }
  }
}
