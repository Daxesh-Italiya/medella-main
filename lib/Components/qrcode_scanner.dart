/*
import 'package:flutter/material.dart';

import 'const_details.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQR extends StatefulWidget {
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {

 final qrKey=GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
 @override
 void dispose() {
   controller?.dispose();
   super.dispose();
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR Code"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Message displayed over here


          ],
        ),
      ),
    );
  }
 Widget buildQrView(BuildContext context)=>QRView(
   key:qrKey,
   onQRViewCreated:onQRViewCreated,
 );
  void onQRViewCreated(QRViewController controller){
    setState(() {
      this.controller = controller;
    });
  }
}*/

