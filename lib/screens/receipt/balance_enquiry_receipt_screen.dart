import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import '../../controller/receipt_controller.dart';
import '../../model/aeps/balance_enquiry_model.dart';
import '../../utils/app_colors.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_scaffold.dart';

class BalanceEnquiryReceiptScreen extends StatefulWidget {
  const BalanceEnquiryReceiptScreen({super.key});

  @override
  State<BalanceEnquiryReceiptScreen> createState() => _BalanceEnquiryReceiptScreenState();
}

class _BalanceEnquiryReceiptScreenState extends State<BalanceEnquiryReceiptScreen> {
  final ReceiptController receiptController = Get.find();
  BalanceEnquiryModel data = Get.arguments;
  late PdfController pdfController;
  RxBool receiptResult = false.obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      receiptResult.value = await receiptController.getReceiptForBalanceEnquiry(
        params: data.toJson(),
        isLoaderShow: false,
      );
      if (receiptResult.value == true) {
        bool result = await generatePdfFromHtml(receiptController.generatedReceipt.value);
        if (result == true) {
          pdfController = PdfController(
            document: PdfDocument.openFile(receiptController.generatedPdfFilePath.value),
          );
          receiptController.isPdfLoad.value = true;
          dismissProgressIndicator();
        } else {
          dismissProgressIndicator();
        }
      } else {
        receiptController.isPdfLoad.value = false;
        dismissProgressIndicator();
        Get.back();
        errorSnackBar(message: 'Receipt not found');
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  Future<bool> generatePdfFromHtml(String data) async {
    try {
      final htmlContent = "'''$data'''";
      Directory tempDir = await getApplicationDocumentsDirectory();
      final targetPath = tempDir.path;
      final targetFileName = "${DateTime.now().millisecondsSinceEpoch}";
      final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(htmlContent, targetPath, targetFileName).timeout(
        const Duration(seconds: 30),
      );
      receiptController.generatedPdfFilePath.value = generatedPdfFile.path;
      if (receiptController.generatedPdfFilePath.value.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<void> deletePDFFromCache() async {
    final file = File(receiptController.generatedPdfFilePath.value);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<void> dispose() async {
    if (receiptResult.value == true) {
      pdfController.dispose();
    }
    receiptController.isPdfLoad.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await deletePDFFromCache();
        return true;
      },
      child: CustomScaffold(
        title: 'Receipt',
        isShowLeadingIcon: true,
        onBackIconTap: () async {
          await deletePDFFromCache();
          Get.back();
        },
        action: [
          Obx(
            () => receiptController.isPdfLoad.value
                // Share receipt
                ? GestureDetector(
                    onTap: () {
                      Share.shareFiles(
                        [receiptController.generatedPdfFilePath.value],
                        text: 'Transaction Receipt',
                      );
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(
                          Icons.share_rounded,
                          color: ColorsForApp.lightBlackColor,
                        ),
                      ),
                    ),
                  )
                // // Download receipt
                // GestureDetector(
                //     child: Center(
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 20),
                //         child: Icon(
                //           Icons.download_rounded,
                //           color: ColorsForApp.blackColor,
                //         ),
                //       ),
                //     ),
                //     onTap: () async {
                //       var permission = await PermissionHandlerPermissionService.handleStoragePermission(context);
                //       if (permission == true) {
                //         await receiptController.downloadPdf();
                //       }
                //     },
                //   )
                : Container(),
          ),
        ],
        mainBody: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Obx(
            () => receiptController.isPdfLoad.value == true
                ? PdfView(
                    builders: PdfViewBuilders<DefaultBuilderOptions>(
                      options: const DefaultBuilderOptions(),
                      documentLoaderBuilder: (_) => const SizedBox(),
                      pageLoaderBuilder: (_) => const SizedBox(),
                      pageBuilder: pageBuilder,
                    ),
                    controller: pdfController,
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions pageBuilder(
    BuildContext context,
    Future<PdfPageImage> pageImage,
    int index,
    PdfDocument document,
  ) {
    return PhotoViewGalleryPageOptions(
      imageProvider: PdfPageImageProvider(
        pageImage,
        index,
        document.id,
      ),
      basePosition: Alignment.topCenter,
      filterQuality: FilterQuality.high,
      tightMode: true,
      minScale: PhotoViewComputedScale.contained * 1,
      maxScale: PhotoViewComputedScale.contained * 2,
      initialScale: PhotoViewComputedScale.contained * 1.0,
      heroAttributes: PhotoViewHeroAttributes(tag: '${document.id}-$index'),
    );
  }
}
