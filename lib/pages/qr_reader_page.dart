import 'dart:convert';
import 'dart:io';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/models/producto.dart';
import 'package:frontend_mobile/pages/producto_page.dart';
import 'package:frontend_mobile/services/api.dart';
import 'package:frontend_mobile/widgets/menu_drawer.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:dio/dio.dart';

class QrReaderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QrReaderPageState();
}

class _QrReaderPageState extends State<QrReaderPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MenuWidget(),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // if (result != null)
                  //   Text(' Data: ${result!.code}')
                  // else
                  //   Text('Scan '),
                  Text('Scan '),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Container(
                      //   margin: EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //       onPressed: () async {
                      //         await controller?.toggleFlash();
                      //         setState(() {});
                      //       },
                      //       child: FutureBuilder(
                      //         future: controller?.getFlashStatus(),
                      //         builder: (context, snapshot) {
                      //           return Text('Flash: ${snapshot.data}');
                      //         },
                      //       )),
                      // ),
                      // Container(
                      //   margin: EdgeInsets.all(8),
                      //   child: ElevatedButton(
                      //       onPressed: () async {
                      //         await controller?.flipCamera();
                      //         setState(() {});
                      //       },
                      //       child: FutureBuilder(
                      //         future: controller?.getCameraInfo(),
                      //         builder: (context, snapshot) {
                      //           if (snapshot.data != null) {
                      //             return Text(
                      //                 'Camera facing ${describeEnum(snapshot.data!)}');
                      //           } else {
                      //             return Text('loading');
                      //           }
                      //         },
                      //       )),
                      // )
                    ],
                  ),
                  Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // children: <Widget>[
                      //   Container(
                      //     margin: EdgeInsets.all(8),
                      //     child: ElevatedButton(
                      //       onPressed: () async {
                      //         await controller?.pauseCamera();
                      //       },
                      //       child: Text('pause', style: TextStyle(fontSize: 20)),
                      //     ),
                      //   ),
                      //   Container(
                      //     margin: EdgeInsets.all(8),
                      //     child: ElevatedButton(
                      //       onPressed: () async {
                      //         await controller?.resumeCamera();
                      //       },
                      //       child: Text('resume', style: TextStyle(fontSize: 20)),
                      //     ),
                      //   )
                      // ],
                      ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    // setState(() {
    //   this.controller = controller;
    // });
    bool scanned = false;
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        if (!scanned) {
          scanned = true;
          result = scanData;
          dynamic id;
          Response response;

          var dio = Dio();

          // var response = await Dio().post(
          //     "http://192.168.0.109:4001/api/producto/pedir",
          //     data: {"id": widget.id});
          // var response = await dio.post(
          //     'http://192.168.0.109:4001/api/producto/pedir',
          //     data: {id: "60ad9324b0743a2ce87466f4"});
          response = await dio
              .post('${urlApi}/api/producto/pedir', data: {'id': result!.code});
          final jsonResponse = json.decode(response.toString());
          // print("2");
          dynamic data = new Producto.fromJson(jsonResponse);
          if (data.ok == false) {
            scanned = false;
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProductoPage(
                  producto: data,
                ),
              ),
            );
          }
          // print(data);
          // return data;
          // response = await dio.post(
          //     'http://192.168.0.109:4001/api/producto/pedir',
          //     data: {'id': result!.code});

        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

















































// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QrReaderPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _QrReaderPageState();
// }

// class _QrReaderPageState extends State<QrReaderPage> {
//   Barcode? result;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

//   // In order to get hot reload to work we need to pause the camera if the platform
//   // is android, or resume the camera if the platform is iOS.
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Expanded(flex: 4, child: _buildQrView(context)),
//           Expanded(
//             flex: 1,
//             child: FittedBox(
//               fit: BoxFit.contain,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   if (result != null)
//                     Text(
//                         'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
//                   else
//                     Text('Scan '),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       // Container(
//                       //   margin: EdgeInsets.all(8),
//                       //   child: ElevatedButton(
//                       //       onPressed: () async {
//                       //         await controller?.toggleFlash();
//                       //         setState(() {});
//                       //       },
//                       //       child: FutureBuilder(
//                       //         future: controller?.getFlashStatus(),
//                       //         builder: (context, snapshot) {
//                       //           return Text('Flash: ${snapshot.data}');
//                       //         },
//                       //       )),
//                       // ),
//                       // Container(
//                       //   margin: EdgeInsets.all(8),
//                       //   child: ElevatedButton(
//                       //       onPressed: () async {
//                       //         await controller?.flipCamera();
//                       //         setState(() {});
//                       //       },
//                       //       child: FutureBuilder(
//                       //         future: controller?.getCameraInfo(),
//                       //         builder: (context, snapshot) {
//                       //           if (snapshot.data != null) {
//                       //             return Text(
//                       //                 'Camera facing ${describeEnum(snapshot.data!)}');
//                       //           } else {
//                       //             return Text('loading');
//                       //           }
//                       //         },
//                       //       )),
//                       // )
//                     ],
//                   ),
//                   Row(
//                       // mainAxisAlignment: MainAxisAlignment.center,
//                       // crossAxisAlignment: CrossAxisAlignment.center,
//                       // children: <Widget>[
//                       //   Container(
//                       //     margin: EdgeInsets.all(8),
//                       //     child: ElevatedButton(
//                       //       onPressed: () async {
//                       //         await controller?.pauseCamera();
//                       //       },
//                       //       child: Text('pause', style: TextStyle(fontSize: 20)),
//                       //     ),
//                       //   ),
//                       //   Container(
//                       //     margin: EdgeInsets.all(8),
//                       //     child: ElevatedButton(
//                       //       onPressed: () async {
//                       //         await controller?.resumeCamera();
//                       //       },
//                       //       child: Text('resume', style: TextStyle(fontSize: 20)),
//                       //     ),
//                       //   )
//                       // ],
//                       ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildQrView(BuildContext context) {
//     // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//             MediaQuery.of(context).size.height < 400)
//         ? 250.0
//         : 300.0;
//     // To ensure the Scanner view is properly sizes after rotation
//     // we need to listen for Flutter SizeChanged notification and update controller
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//           borderColor: Colors.red,
//           borderRadius: 10,
//           borderLength: 30,
//           borderWidth: 10,
//           cutOutSize: scanArea),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
