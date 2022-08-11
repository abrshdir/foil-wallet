import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:flutter/services.dart';

import 'styles/AppTheme.dart';

class QRCodeReader extends StatefulWidget {
  /// mode=1 => login screen
  ///
  /// mode=2 => scan QR for put the code into TextField via action button.
  ///
  /// How to get scanned code:
  ///
  /// final result = await Navigator.push(
  ////    context,
  ///     MaterialPageRoute(builder: (context) => SelectionScreen()),
  /// );
  ///
  final int mode;
  Function(String str)? onRead;

  QRCodeReader({
    this.onRead,
    Key? key,
    this.mode = 2,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeReaderState();
}

class _QRCodeReaderState extends State<QRCodeReader> {
  var qrText = "";
  var flashState = false;
  var cameraState = false;
  bool returned = false;
  QRViewController? controller;

  _QRCodeReaderState();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return SafeArea(
        bottom: false,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(children: <Widget>[
              QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: AppColors.active,
                  borderRadius: 20,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 280,
                ),
              ),
              Positioned(
                bottom: 80,
                right: 0,
                left: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          if (controller != null) {
                            controller?.toggleFlash();
                            if (flashState) {
                              setState(() {
                                flashState = false;
                              });
                            } else {
                              setState(() {
                                flashState = true;
                              });
                            }
                          }
                        },
                        icon: Icon(
                          flashState ? Icons.flash_on : Icons.flash_off,
                          size: 30,
                          color: AppColors.active,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          if (controller != null) {
                            controller?.flipCamera();
                            if (cameraState) {
                              setState(() {
                                cameraState = false;
                              });
                            } else {
                              setState(() {
                                cameraState = true;
                              });
                            }
                          }
                        },
                        icon: Icon(
                          cameraState ? Icons.camera_rear : Icons.camera_front,
                          size: 30,
                          color: AppColors.active,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ])));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (widget.mode == 1) {
        if (!this.returned) {
          this.returned = true;
          widget.onRead?.call(scanData.code);
        }
        // Navigator.of(context).pushNamedAndRemoveUntil ("/wallet",  (Route route) => false, arguments: qrText,);
      } else if (widget.mode == 2) {
        if (!this.returned) {
          Navigator.of(context).pop(scanData.code);

          this.returned = true;
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
