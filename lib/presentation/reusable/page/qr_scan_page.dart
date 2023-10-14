import 'dart:async';

import 'package:cengli/utils/utils.dart';
import 'package:cengli/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});
  static const String routeName = '/scan_qr_page';

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  StreamSubscription? _scanSubscription;
  bool hasPopped = false;

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: primaryGreen600,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    _scanSubscription = controller.scannedDataStream.listen((scanData) {
      if (!hasPopped) {
        hasPopped = true;
        Navigator.of(context).pop(scanData.code);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      showToast("No Persmission");
    }
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const CircleAvatar(
                      radius: 15,
                      backgroundColor: KxColors.neutral200,
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: KxColors.neutral700,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await controller?.flipCamera();
                      setState(() {});
                    },
                    child: const Icon(CupertinoIcons.camera_rotate_fill,
                        color: Colors.white),
                  )
                ],
              ).padding(const EdgeInsets.symmetric(horizontal: 16)),
            )),
        body: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              minHeight: MediaQuery.of(context).size.height * 0.3),
          child: _buildQrView(context),
        ));
  }
}
