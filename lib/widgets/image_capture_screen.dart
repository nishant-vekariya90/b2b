import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_editor/image_editor.dart';
import 'package:sizer/sizer.dart';
import '../utils/app_colors.dart';
import 'button.dart';
import 'custom_scaffold.dart';

class ImageCaptureScreen extends StatefulWidget {
  const ImageCaptureScreen({super.key});

  @override
  State<ImageCaptureScreen> createState() => _ImageCaptureScreenState();
}

class _ImageCaptureScreenState extends State<ImageCaptureScreen> {
  List<CameraDescription> cameras = Get.arguments;
  late CameraController cameraController;
  RxBool isRearCameraSelected = true.obs;
  RxBool isImageCaptured = false.obs;
  RxString imagePath = ''.obs;

  @override
  void initState() {
    super.initState();
    initCamera(cameras[0]);
  }

  Future initCamera(CameraDescription cameraDescription) async {
    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.veryHigh,
      enableAudio: false,
    );
    try {
      await cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint('Camera error $e');
    }
  }

  Future<String> captureImage() async {
    if (!cameraController.value.isInitialized) {
      return '';
    }

    try {
      XFile xFile = await cameraController.takePicture();
      if (xFile.path.isNotEmpty && xFile.path != '') {
        if (cameras[isRearCameraSelected.value ? 0 : 1].lensDirection == CameraLensDirection.front) {
          var file = File(xFile.path);
          Uint8List? imageBytes = await file.readAsBytes();
          final ImageEditorOption option = ImageEditorOption();
          option.addOption(const FlipOption(horizontal: true));
          imageBytes = await ImageEditor.editImage(image: imageBytes, imageEditorOption: option);
          await file.delete();
          await file.writeAsBytes(imageBytes!.toList());
        }
        isImageCaptured.value = true;
        return xFile.path;
      } else {
        isImageCaptured.value = false;
        return '';
      }
    } on CameraException catch (e) {
      debugPrint('Error occurred while capture image: $e');
      return '';
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScaffold(
        isShowLeadingIcon: true,
        title: isImageCaptured.value == true ? 'View Image' : 'Capture Image',
        mainBody: isImageCaptured.value == true
            ? // Image view
            ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.file(
                  File(imagePath.value),
                  fit: BoxFit.cover,
                ),
              )
            : // Camera view
            cameraController.value.isInitialized
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: CameraPreview(cameraController),
                  )
                : Container(
                    color: Colors.transparent,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorsForApp.primaryColor,
                      ),
                    ),
                  ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          color: Colors.black,
          child: isImageCaptured.value == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Decline
                    GestureDetector(
                      onTap: () async {
                        isImageCaptured.value = false;
                        imagePath.value = '';
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorsForApp.grayScale500.withOpacity(0.3),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.close_rounded,
                          size: 35,
                          color: ColorsForApp.whiteColor,
                        ),
                      ),
                    ),
                    // Accept
                    GestureDetector(
                      onTap: () async {
                        Get.back(result: imagePath.value);
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorsForApp.whiteColor,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.done_rounded,
                          size: 35,
                          color: ColorsForApp.lightBlackColor,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    width(50),
                    const Spacer(),
                    // Capture image
                    GestureDetector(
                      onTap: () async {
                        imagePath.value = await captureImage();
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorsForApp.grayScale500.withOpacity(0.3),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorsForApp.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Flip camera
                    GestureDetector(
                      onTap: () {
                        isRearCameraSelected.value = !isRearCameraSelected.value;
                        initCamera(cameras[isRearCameraSelected.value ? 0 : 1]);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorsForApp.grayScale500,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          Icons.flip_camera_ios_rounded,
                          color: ColorsForApp.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
