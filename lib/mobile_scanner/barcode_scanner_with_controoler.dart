import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_attendance/data/firebase/firestore_data.dart';
// import 'package:qr_attendance/constants/result.dart' a;
import 'package:qr_attendance/mobile_scanner/button_widget.dart';
import 'package:qr_attendance/mobile_scanner/error_widget.dart';
import 'package:qr_attendance/presentation/models/barcode_model.dart';

class BarcodeScannerWithController extends StatefulWidget {
  const BarcodeScannerWithController({super.key});

  @override
  State<BarcodeScannerWithController> createState() =>
      _BarcodeScannerWithControllerState();
}

class _BarcodeScannerWithControllerState
    extends State<BarcodeScannerWithController> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
    autoStart: false,
    torchEnabled: false,
    useNewCameraSelector: true,
    facing: kDebugMode ? CameraFacing.back : CameraFacing.front,
  );

  Barcode? _barcode;
  StreamSubscription<Object?>? _subscription;

  Widget _buildBarcode(Barcode? value, BuildContext context) {
    // if(value!=null ) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text('Please fill data to generate respective BarCode')));
    // }
    if (value != null && value.displayValue != null) {
      //call mark attendance api
    }
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  actions: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                  content: Text(value.displayValue ?? ''),
                ));
      },
      child: Text(
        value.displayValue ?? 'No display value.',
        overflow: TextOverflow.fade,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  bool shouldCallApi = true;
  bool apiRunning = false;

  @override
  void initState() {
    super.initState();
    controller.stop();
    WidgetsBinding.instance.addObserver(this);

    _subscription = controller.barcodes.listen(_handleBarcode);
    // debugPrint("starting camera");
    controller.value.isRunning ? unawaited(controller.stop()) : null;
    unawaited(controller.start());
  }

  @override
  Widget build(BuildContext context) {
    final siz = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(title: const Text('With controller')),
      backgroundColor: Colors.white,
      body: SizedBox(
        height: siz.height,
        width: siz.width,
        child: Column(
          children: [
            SizedBox(
              height: siz.height * 0.8,
              width: siz.width * 0.9,
              child: Stack(
                children: [
                  MobileScanner(
                    controller: controller,
                    errorBuilder: (context, error, child) {
                      return ScannerErrorWidget(error: error);
                    },
                    fit: BoxFit.contain,
                    onDetect: (barcode) async {
                      final List<QrIdModel> barList = [];
                      for (var b in barcode.barcodes) {
                        barList.add(QrIdModel(
                            inTime: DateTime.now(),
                            isQrExist: false,
                            qridcode: b.displayValue ?? ''));
                      }
                      if (shouldCallApi && !apiRunning) {
                        setState(() {
                          apiRunning = true;
                        });
                        final res = AppFirebaseStore.markAttendance(
                            barcode.barcodes.firstOrNull?.displayValue ?? '');
                        res.listen((onData) {
                          setState(() {
                            shouldCallApi = onData;
                            apiRunning = false;
                          });
                        });
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: 100,
                      color: Colors.black.withOpacity(0.4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          StartStopMobileScannerButton(controller: controller),
                          Expanded(
                              child: Center(
                                  child: _buildBarcode(_barcode, context))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
  }
}
