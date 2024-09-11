import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class StartStopMobileScannerButton extends StatelessWidget {
  const StartStopMobileScannerButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        // if (!state.isInitialized || !state.isRunning) {
        return Row(
          children: [
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.play_arrow),
              iconSize: 32.0,
              onPressed: () async {
                await controller.start();
              },
            ),
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.stop),
              iconSize: 32.0,
              onPressed: () async {
                await controller.stop();
              },
            )
          ],
        );
      },
    );
  }
}
