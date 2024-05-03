import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../../../controller/retailer/scan_and_pay_controller.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../widgets/custom_scaffold.dart';

class ScanAndPayScreen extends StatefulWidget {
  const ScanAndPayScreen({super.key});

  @override
  State<ScanAndPayScreen> createState() => _ScanAndPayScreenState();
}

class _ScanAndPayScreenState extends State<ScanAndPayScreen> {
  final ScanAndPayController scanAndPayController = Get.find();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController qrViewController;
  Barcode? result;

  @override
  void dispose() {
    qrViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Scan & Pay',
      isShowLeadingIcon: true,
      action: [
        Obx(
          () => IconButton(
            onPressed: () async {
              qrViewController.toggleFlash();
              scanAndPayController.isFlashOn.value = (await qrViewController.getFlashStatus()) ?? false;
            },
            icon: Icon(
              scanAndPayController.isFlashOn.value == true ? Icons.flashlight_off_rounded : Icons.flashlight_on_rounded,
              color: ColorsForApp.lightBlackColor,
            ),
          ),
        ),
      ],
      mainBody: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: QRView(
          key: qrKey,
          overlay: QrScannerOverlayShape(
            borderRadius: 10,
            borderLength: 50,
            borderWidth: 10,
            borderColor: ColorsForApp.primaryColor,
          ),
          onQRViewCreated: (QRViewController controller) async {
            qrViewController = controller;
            scanAndPayController.isFlashOn.value = (await qrViewController.getFlashStatus()) ?? false;
            qrViewController.scannedDataStream.listen((Barcode barcode) async {
              if (barcode.code != null && barcode.code!.isNotEmpty) {
                bool result = scanAndPayController.parseScanedData(barcode.code.toString());
                if (result == true) {
                  qrViewController.pauseCamera();
                  await Get.toNamed(Routes.PAY_SCREEN);
                  qrViewController.resumeCamera();
                }
              }
            });
          },
        ),
      ),
    );
  }
}
