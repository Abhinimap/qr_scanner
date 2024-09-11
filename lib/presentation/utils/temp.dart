import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../main.dart';

class Temp extends StatefulWidget {
  const Temp({super.key});

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, ind) {
            return SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: QrImageView(data: users[ind]),
              ),
            );
          },
        ));
  }
}
