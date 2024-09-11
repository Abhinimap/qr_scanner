import 'package:flutter/material.dart';
import 'package:qr_attendance/qr_flutter_files/mark_attendance_with_qr.dart';

class QrFlutterPage extends StatefulWidget {
  const QrFlutterPage({super.key});

  @override
  State<QrFlutterPage> createState() => _QrFlutterPageState();
}

class _QrFlutterPageState extends State<QrFlutterPage> {

  String? qrData;

  final qrDataController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    qrDataController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Generate QR'),centerTitle: true,),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
        
            TextField(
        onChanged: (v){
        
        },
              onEditingComplete: (){
          if(qrDataController.text.trim().isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill data to generate respective BarCode')));
          return;
          }
          setState(() {
        qrData = qrDataController.text;
          });
              },
              controller: qrDataController,
              decoration: InputDecoration(
                label: Text('Enter Qr data'),
                  border: OutlineInputBorder(),contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 8)),
            ),
        
            ElevatedButton(onPressed: (){
              setState(() {
                qrData=qrDataController.text;
              });
            }  , child: Text("show qr code")),
        
            FutureBuilder<Widget>(future:MarkAttendanceWithQr().showQrFromData(qrData: qrData) , builder: (context,data){
              if(data.connectionState==ConnectionState.waiting){
                return const CircularProgressIndicator();
              }
             else if(data.connectionState==ConnectionState.done){
                return data.data !=null ? data.data! :const SizedBox();
              }
             else{
               return const SizedBox();
              }
            }),
        
        
        
        
          ],
        ),
      ),
    );
  }
}
