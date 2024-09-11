import 'dart:async';
import 'dart:convert';

import 'package:error_handeler_flutter/error_handeler_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_attendance/constants/network_constants.dart';
// import 'package:qr_attendance/constants/result.dart' a;
import 'package:qr_attendance/mobile_scanner/button_widget.dart';
import 'package:qr_attendance/mobile_scanner/error_widget.dart';
import 'package:qr_attendance/presentation/models/barcode_model.dart';

import '../constants/constants.dart';

class KnowYourPointsQrScanner extends StatefulWidget {
  const KnowYourPointsQrScanner({super.key});

  @override
  State<KnowYourPointsQrScanner> createState() =>
      _KnowYourPointsQrScannerState();
}

class _KnowYourPointsQrScannerState extends State<KnowYourPointsQrScanner>
    with WidgetsBindingObserver {
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
    //TODO: call inductions api

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
                  content: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(value.displayValue ?? ''),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.knowYourPoints),
      ),
      backgroundColor: Colors.black,
      body: Stack(
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
              final result = await ErrorHandelerFlutter().post(
                  '${NetworkConstants.baseUrl}${NetworkConstants.safetyInductionStatus}',
                  body: json.encode({
                    "payload": {
                      "supervisiorid": 0,
                      "qrcodelist": barList.map((e) => e.toJson()).toList()
                    }
                  }));

              switch (result) {
                case Success(value: dynamic v):
                  debugPrint('success  marking attendance : $v');

                  break;
                case Failure(error: ErrorResponse err):
                  debugPrint(
                      'error while marking attendance : ${err.errorHandelerFlutterEnum.name}');
                  break;
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
                      child: Center(child: _buildBarcode(_barcode, context))),
                ],
              ),
            ),
          ),
        ],
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
