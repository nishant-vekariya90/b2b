import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/permission_handler.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../controller/retailer/chargeback_controller.dart';

class ChargebackDocumentsScreen extends StatefulWidget {
  const ChargebackDocumentsScreen({super.key});

  @override
  State<ChargebackDocumentsScreen> createState() => _ChargebackDocumentsScreenState();
}

class _ChargebackDocumentsScreenState extends State<ChargebackDocumentsScreen> {

  ChargebackController chargebackController = Get.find();
  final GlobalKey<FormState> documentFormKey = GlobalKey<FormState>();
  final String uniqueId = Get.arguments;

  @override
  void initState() {
    super.initState();
      callAPI();
  }

  //"8f66d61b-73e6-4985-a9cc-ca191e94d926"

  Future<void> callAPI() async {
    await chargebackController.getChargebackDocApi(isLoaderShow: true,uniqueId:uniqueId);
  }

  @override
  void dispose() {
    super.dispose();
    chargebackController.finalDocsStepObjList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 16.h,
      title: 'Chargeback Document',
      isShowLeadingIcon: true,
      mainBody: Obx(
          ()=> chargebackController.chargeBackDocList.isEmpty
            ? notFoundText(text: 'No data found')
            : RefreshIndicator(
          onRefresh: () async {
            isLoading.value = true;
            await Future.delayed(const Duration(seconds: 1), () async {
              await chargebackController.getChargebackDocApi(isLoaderShow: false, uniqueId: uniqueId);
            });
            isLoading.value = false;
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w).add(EdgeInsets.only(top: 1.h)),
            child:Form(
                      key: documentFormKey,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: chargebackController.chargeBackDocList.length,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.all(2.w),
                        itemBuilder: (context, index) {
                          RxString documentFile = ''.obs;
                          documentFile.value = chargebackController.chargeBackDocList[index].documentPath??"";
                          return Obx(
                                () => customCard(
                                  child: Padding(
                                    padding: EdgeInsets.all(2.h),
                                    child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                    Text(
                                      chargebackController.chargeBackDocList[index].name!,
                                      style: TextHelper.size15,
                                    ),
                                    height(2.h),
                                    // Document slip
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: 'Upload document',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w400,
                                          color: ColorsForApp.blackColor,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                              color: ColorsForApp.errorColor,
                                              fontSize: 10.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    height(5),
                                    Text(
                                      'Document slip in jpg, png, jpeg format with maximum 6MB can be uploaded.',
                                      style: TextHelper.size12.copyWith(
                                        color: ColorsForApp.errorColor,
                                      ),
                                    ),
                                    height(10),
                                                                chargebackController.chargeBackDocList[index].file.value.path.isNotEmpty
                                                                    ? SizedBox(
                                                                  height: 21.5.w,
                                                                  width: 21.5.w,
                                                                  child: Stack(
                                                                    alignment: Alignment.bottomLeft,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap: () async {
                                                                          OpenResult openResult = await OpenFile.open(chargebackController.chargeBackDocList[index].file.value.path);
                                                                          if (openResult.type != ResultType.done) {
                                                                            errorSnackBar(message: openResult.message);
                                                                          }
                                                                        },
                                                                        child: Container(
                                                                          height: 20.w,
                                                                          width: 20.w,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            border: Border.all(
                                                                              width: 1,
                                                                              color: ColorsForApp.greyColor.withOpacity(0.7),
                                                                            ),
                                                                          ),
                                                                          child: ClipRRect(
                                                                            borderRadius: BorderRadius.circular(9),
                                                                            child: Image.file(
                                                                              chargebackController.chargeBackDocList[index].file.value,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 0,
                                                                        right: 0,
                                                                        child: InkWell(
                                                                          onTap: () {
                                                                            chargebackController.chargeBackDocList[index].file.value = File('');
                                                                          },
                                                                          child: Container(
                                                                            height: 6.w,
                                                                            width: 6.w,
                                                                            alignment: Alignment.center,
                                                                            decoration: BoxDecoration(
                                                                              color: ColorsForApp.grayScale200,
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child: Icon(
                                                                              Icons.delete_rounded,
                                                                              color: ColorsForApp.errorColor,
                                                                              size: 4.5.w,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ) :
                                                                documentFile.value.isNotEmpty ?
                                                                SizedBox(
                                                                  height: 21.5.w,
                                                                  width: 21.5.w,
                                                                  child: Stack(
                                                                    alignment: Alignment.bottomLeft,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap: () async {
                                                                          openUrl(url: documentFile.value);
                                                                        },
                                                                        child: Container(
                                                                          height: 20.w,
                                                                          width: 20.w,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            border: Border.all(
                                                                              width: 1,
                                                                              color: ColorsForApp.greyColor.withOpacity(0.7),
                                                                            ),
                                                                          ),
                                                                          child: ClipRRect(
                                                                            borderRadius: BorderRadius.circular(9),
                                                                            child: Image.network(documentFile.value),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 0,
                                                                        right: 0,
                                                                        child: InkWell(
                                                                          onTap: () {
                                                                            documentFile.value = '';
                                                                          },
                                                                          child: Container(
                                                                            height: 6.w,
                                                                            width: 6.w,
                                                                            alignment: Alignment.center,
                                                                            decoration: BoxDecoration(
                                                                              color: ColorsForApp.grayScale200,
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child: Icon(
                                                                              Icons.delete_rounded,
                                                                              color: ColorsForApp.errorColor,
                                                                              size: 4.5.w,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ):
                                                                Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            imageSourceDialog(context,chargebackController.chargeBackDocList[index].uniqueID!,chargebackController.chargeBackDocList[index].reason!,index);
                                          },
                                          child: Container(
                                            width: 100,
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              border: Border.all(
                                                color: ColorsForApp.primaryColor,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  color: ColorsForApp.primaryColor,
                                                  size: 20,
                                                ),
                                                width(5),
                                                Text(
                                                  'Upload',
                                                  style: TextHelper.size14.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: ColorsForApp.primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                                              ],
                                    ),
                                  ),
                                ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Divider(color: Colors.grey.withOpacity(0.5)),
                              height(1.h),
                            ],
                          );
                        },
                      )),

          ),
        ),
      ),
      floatingActionButton:Obx(
        ()=> chargebackController.chargeBackDocList.isNotEmpty?
        FloatingActionButton.extended(
          backgroundColor: ColorsForApp.primaryColor,
            onPressed: () async{
            RxInt flag = 0.obs;
             for(int i = 0 ; i < chargebackController.chargeBackDocList.length; i++){
               if(chargebackController.chargeBackDocList[i].file.value.path.isEmpty){
                 flag.value = 1;
               }
              }
             if(flag.value == 0){
              bool result = await chargebackController.uploadDocumentsApi();
              if(result){
                chargebackController.getChargebackDocApi(uniqueId: uniqueId);
              }
             }else{
               errorSnackBar(message: "Please upload all documents");
             }
            },
          label: Text('Submit',style: TextHelper.size14.copyWith(color: ColorsForApp.whiteColor),),
        ):
        const SizedBox.shrink(),
      ),
    );
  }

// Image source dialog
  Future<dynamic> imageSourceDialog(BuildContext context, String uniqueId, String reason, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          title: Text(
            'Select image source',
            style: TextHelper.size20.copyWith(
              fontFamily: mediumGoogleSansFont,
            ),
          ),
          content: Text(
            'Capture a photo or choose from your phone for quick processing.',
            style: TextHelper.size14.copyWith(
              color: ColorsForApp.blackColor.withOpacity(0.7),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    try {
                      File capturedFile = File(await captureImage());
                      if (capturedFile.path.isNotEmpty) {
                        int fileSize = capturedFile.lengthSync();
                        int maxAllowedSize = 6 * 1024 * 1024;
                        if (fileSize > maxAllowedSize) {
                          errorSnackBar(message: 'File size should be less than 6 MB');
                        } else {
                          chargebackController.chargeBackDocList[index].file.value = capturedFile;
                          Map object = {
                            "unqId": uniqueId,
                            "documentPathFileBytesFormat": extension(capturedFile.path),
                            "documentPathFileBytes": await convertFileToBase64(capturedFile),
                            "fileName": basename(capturedFile.path),
                            "reason": reason,
                          };
                          //before add check if already exit or not if exit then update that map otherwise add.
                          int finalObjIndex = chargebackController.finalDocsStepObjList.indexWhere((element) => element['param'] == uniqueId);
                          if (finalObjIndex != -1) {
                            chargebackController.finalDocsStepObjList[finalObjIndex] = {
                              "unqId": uniqueId,
                              "documentPathFileBytesFormat": extension(capturedFile.path),
                              "documentPathFileBytes": await convertFileToBase64(capturedFile),
                              "fileName": basename(capturedFile.path),
                              "reason": reason,
                            };
                          } else {
                            chargebackController.finalDocsStepObjList.add(object);
                          }
                        }
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                  splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                  highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                  child: Text(
                    'Take photo',
                    style: TextHelper.size14.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.primaryColorBlue,
                    ),
                  ),
                ),
                width(4.w),
                InkWell(
                  onTap: () async {
                    await PermissionHandlerPermissionService.handlePhotosPermission(context).then(
                          (photoPermission) async {
                        if (photoPermission == true) {
                          Get.back();
                          try {
                            await openFilePicker(fileType: FileType.custom).then(
                                  (pickedFile) async {
                                if (pickedFile != null && pickedFile.path != '' && pickedFile.path.isNotEmpty) {
                                  await convertFileToBase64(pickedFile).then(
                                        (base64Img) async {
                                      int fileSize = pickedFile.lengthSync();
                                      int maxAllowedSize = 6 * 1024 * 1024;
                                      if (fileSize > maxAllowedSize) {
                                        errorSnackBar(message: 'File size should be less than 6 MB');
                                      } else {
                                        chargebackController.chargeBackDocList[index].file.value = pickedFile;
                                        Map object = {
                                          "unqId": uniqueId,
                                          "fileName": basename(pickedFile.path),
                                          "documentPathFileBytesFormat": extension(pickedFile.path),
                                          "documentPathFileBytes": await convertFileToBase64(pickedFile),
                                          "reason": reason,
                                        };
                                        //before add check if already exit or not if exit then update that map otherwise add.
                                        int finalObjIndex = chargebackController.finalDocsStepObjList.indexWhere((element) => element['param'] == uniqueId);
                                        if (finalObjIndex != -1) {
                                          chargebackController.finalDocsStepObjList[finalObjIndex] = {
                                            "unqId": uniqueId,
                                            "fileName": basename(pickedFile.path),
                                            "documentPathFileBytesFormat": extension(pickedFile.path),
                                            "documentPathFileBytes": await convertFileToBase64(pickedFile),
                                            "reason": reason,
                                          };
                                        } else {
                                          chargebackController.finalDocsStepObjList.add(object);
                                        }
                                      }
                                      setState(() {});
                                    },
                                  );
                                }
                              },
                            );
                          } catch (e) {
                            if (kDebugMode) {
                              print("cc : $e");
                            }
                          }
                        }
                      },
                    );
                  },
                  splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                  highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                  child: Text(
                    'Choose from phone',
                    style: TextHelper.size14.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.primaryColorBlue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
