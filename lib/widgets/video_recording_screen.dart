import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import '../utils/string_constants.dart';
import 'button.dart';
import 'custom_scaffold.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  List<CameraDescription> cameras = Get.arguments[0];
  String name = Get.arguments[1];
  late CameraController cameraController;
  late Timer? countdownTimer;
  RxInt videoDuration = 0.obs;
  RxBool isRearCameraSelected = true.obs;
  RxBool isShowStartButton = true.obs;
  RxBool isShowStopButton = false.obs;
  RxInt minSeconds = 14.obs;
  RxInt remainingSeconds = 30.obs;
  RxBool isRecordingDone = false.obs;
  RxString videoPath = ''.obs;
  late VideoPlayerController videoPlayerController;
  RxBool isPlaying = false.obs;

  @override
  void initState() {
    super.initState();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Timer logic
    });
    videoPlayerController = VideoPlayerController.file(File(''));
    initCamera(cameras[0]);
  }

  Timer? playTimer;
  RxInt playDuration = 0.obs;

  void startPlayTimer() {
    playTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (playDuration.value < videoPlayerController.value.duration.inSeconds) {
        playDuration.value++;
      } else {
        timer.cancel();
      }
    });
  }

  void stopPlayTimer() {
    playTimer?.cancel();
    playDuration.value = 0;
  }

  Future initCamera(CameraDescription cameraDescription) async {
    cameraController = CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  Future startVideoRecording() async {
    if (!cameraController.value.isInitialized) {
      return null;
    }
    if (cameraController.value.isRecordingVideo) {
      return null;
    }
    stopPlayTimer();
    try {
      await cameraController.startVideoRecording();
      videoDuration.value = 0;
      isShowStartButton.value = false;
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
          if (minSeconds.value > 0 && isShowStopButton.value == false) {
            minSeconds.value--;
          } else {
            isShowStopButton.value = true;
          }
        } else {
          // If the remaining time is up, stop video recording.
          stopVideoRecording();
          timer.cancel(); // Cancel the countdown timer.
        }
      });
    } on CameraException catch (e) {
      debugPrint('Error occurred while starting video recording: $e');
      return null;
    }
  }

  Future stopVideoRecording() async {
    if (!cameraController.value.isRecordingVideo) {
      return null;
    }
    try {
      XFile videoFile = await cameraController.stopVideoRecording();
      if (countdownTimer != null) {
        countdownTimer?.cancel();
      }
      isRecordingDone.value = true;
      isShowStartButton.value = true;
      isShowStopButton.value = false;
      videoPath.value = videoFile.path;
      videoPlayerController = VideoPlayerController.file(File(videoPath.value))
        ..initialize().then((_) {
          setState(() {});
        });
      videoPlayerController.addListener(() {
        if (videoPlayerController.value.position == videoPlayerController.value.duration) {
          isPlaying.value = false;
        }
      });
    } on CameraException catch (e) {
      debugPrint('Error occurred while stopping video recording: $e');
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return '$formattedMinutes:$formattedSeconds';
  }

  @override
  void dispose() {
    cameraController.dispose();
    countdownTimer?.cancel();
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScaffold(
        isShowLeadingIcon: true,
        title: isRecordingDone.value == true ? 'View Recording' : 'Record Video',
        mainBody: Obx(
          () => isRecordingDone.value == true
              // Video preview
              ? Stack(
                  children: [
                    // Video player view
                    videoPlayerController.value.isInitialized
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: videoPlayerController.value.aspectRatio,
                                  child: VideoPlayer(videoPlayerController),
                                ),
                                Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      /*if (isPlaying.value) {
                                        videoPlayerController.pause();
                                        isPlaying.value = false;
                                      } else {
                                        videoPlayerController.play();
                                        isPlaying.value = true;
                                      }*/
                                      if (isPlaying.value) {
                                        videoPlayerController.pause();
                                        isPlaying.value = false;
                                        stopPlayTimer();
                                      } else {
                                        videoPlayerController.play();
                                        isPlaying.value = true;
                                        startPlayTimer();
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(2.w),
                                      decoration: BoxDecoration(
                                        color: ColorsForApp.whiteColor.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Icon(
                                        isPlaying.value ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                        color: ColorsForApp.lightBlackColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    // Bottom menu
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 14.h,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          color: Colors.black,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /*Container(
                              height: 3.h,
                              width: 15.w,
                              decoration: BoxDecoration(
                                color: ColorsForApp.whiteColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              alignment: Alignment.center,
                              child: Obx(
                                    () => Text(
                                  formatTime(playDuration.value),
                                  style: TextHelper.size14.copyWith(
                                    fontFamily: mediumFont,
                                  ),
                                ),
                              ),
                            ),*/
                            // Decline
                            GestureDetector(
                              onTap: () {
                                videoDuration.value = 0;
                                isShowStartButton.value = true;
                                isShowStopButton.value = false;
                                minSeconds.value = 14;
                                remainingSeconds.value = 30;
                                isRecordingDone.value = false;
                                videoPath.value = '';
                                isPlaying.value = false;
                                videoPlayerController.dispose();
                              },
                              child: Container(
                                height: 14.w,
                                width: 14.w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorsForApp.grayScale500,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: ColorsForApp.whiteColor,
                                ),
                              ),
                            ),
                            // Accept
                            GestureDetector(
                              onTap: () {
                                Get.back(result: videoPath.value);
                              },
                              child: Container(
                                height: 14.w,
                                width: 14.w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorsForApp.grayScale500,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Icon(
                                  Icons.done_rounded,
                                  color: ColorsForApp.whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              // Video recording
              : Stack(
                  children: [
                    // Camera view
                    cameraController.value.isInitialized
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: CameraPreview(cameraController),
                          )
                        : Container(
                            color: Colors.black,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                    // Instruction
                    Container(
                      width: 100.w,
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ColorsForApp.greyColor.withOpacity(0.4),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Start video with given requirement',
                            style: TextHelper.size16.copyWith(
                              fontFamily: mediumGoogleSansFont,
                              color: ColorsForApp.lightBlackColor,
                            ),
                          ),
                          height(15),
                          Text(
                            '1. Hello, I am $name.',
                            style: TextHelper.size13.copyWith(
                              fontFamily: mediumGoogleSansFont,
                              color: ColorsForApp.errorColor,
                            ),
                          ),
                          height(5),
                          Text(
                            '2. I am verifying my document for $appName.',
                            style: TextHelper.size13.copyWith(
                              fontFamily: mediumGoogleSansFont,
                              color: ColorsForApp.errorColor,
                            ),
                          ),
                          height(5),
                          Text(
                            '3. Show aadhaar card visible to camera.',
                            style: TextHelper.size13.copyWith(
                              fontFamily: mediumGoogleSansFont,
                              color: ColorsForApp.errorColor,
                            ),
                          ),
                          height(5),
                          Text(
                            '4. Show pan card visible to camera.',
                            style: TextHelper.size13.copyWith(
                              fontFamily: mediumGoogleSansFont,
                              color: ColorsForApp.errorColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bottom menu
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 14.h,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          color: Colors.black,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Video timer
                            Container(
                              height: 3.h,
                              width: 15.w,
                              decoration: BoxDecoration(
                                color: ColorsForApp.whiteColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              alignment: Alignment.center,
                              child: Obx(
                                () => Text(
                                  formatTime(remainingSeconds.value),
                                  style: TextHelper.size14.copyWith(
                                    fontFamily: mediumGoogleSansFont,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            // Start/Stop recording
                            Obx(
                              () => Opacity(
                                opacity: isShowStartButton.value == false && isShowStopButton.value == false ? 0 : 1,
                                child: GestureDetector(
                                  onTap: () {
                                    isShowStartButton.value == true
                                        ? startVideoRecording()
                                        : isShowStopButton.value == true
                                            ? stopVideoRecording()
                                            : null;
                                  },
                                  child: Container(
                                    height: 14.w,
                                    width: 14.w,
                                    decoration: BoxDecoration(
                                      color: ColorsForApp.whiteColor,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 5.w,
                                      width: 5.w,
                                      decoration: BoxDecoration(
                                        color: isShowStartButton.value ? ColorsForApp.errorColor : ColorsForApp.grayScale500,
                                        borderRadius: isShowStartButton.value ? BorderRadius.circular(100) : BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            // Flip camera
                            Obx(
                              () => Opacity(
                                opacity: isShowStartButton.value == true ? 1 : 0,
                                child: GestureDetector(
                                  onTap: () {
                                    if (isShowStartButton.value == true) {
                                      isRearCameraSelected.value = !isRearCameraSelected.value;
                                      initCamera(cameras[isRearCameraSelected.value ? 0 : 1]);
                                    }
                                  },
                                  child: Container(
                                    height: 10.w,
                                    width: 10.w,
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
                              ),
                            ),
                          ],
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
