import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../controller/location_controller.dart';
import '../controller/network_controller.dart';
import '../generated/assets.dart';
import '../model/auth/login_model.dart';
import '../model/auth/user_basic_details_model.dart';
import '../routes/routes.dart';
import '../utils/app_colors.dart';
import '../utils/permission_handler.dart';
import '../utils/string_constants.dart';
import '../widgets/constant_widgets.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  NetworkController networkController = Get.put(NetworkController(), permanent: true);
  LocationController locationController = Get.put(LocationController(), permanent: true);
  LoginModel loginModel = LoginModel();
  UserBasicDetailsModel userBasicDetailsModel = UserBasicDetailsModel();
  late AnimationController animationController;
  double containerHeight = 150;
  double containerWidth = 150;

  @override
  void initState() {
    super.initState();
    loginModel = getStoredLoginDetails();
    userBasicDetailsModel = getStoredUserBasicDetails();
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    captureLocation();
    super.didChangeDependencies();
  }

  Future<void> captureLocation() async {
    await Future.delayed(Duration.zero);
    if (context.mounted) {
      bool? isShowDialog = GetStorage().read(isAppInstallKey);
      if (isShowDialog != null && isShowDialog == true) {
      } else {
        await showInitialPermissionDialog(context);
      }
      locationController.checkLocationServiceStatusPeriodically();
      animationController.forward();
      animationController.addListener(() async {
        if (animationController.isCompleted) {
          animationController.dispose();
          if (isInternetAvailable.value) {
            captureIpAddress();
          } else {
            await Get.toNamed(Routes.NO_INTERNET_CONNECTION_SCREEN);
            captureIpAddress();
          }
        }
      });
    }
  }

  // Get ip address
  Future<void> captureIpAddress() async {
    try {
      http.Response response = await http.get(Uri.parse('https://ipinfo.io/json')).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          String ip = jsonDecode(response.body)['ip'] ?? '';
          ipAddress = ip.isNotEmpty ? ip : '192.168.0.123';
          log('\x1B[35m[IP] => $ipAddress\x1B[0m');
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      getToken();
      startTime();
    }
  }

  // Get fcm token for notification
  getToken() async {
    if (context.mounted) {
      await PermissionHandlerPermissionService.handleNotificationPermission(context);
      final fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint('[FCM Token] => $fcmToken');
    }
  }

  startTime() async {
    if (loginModel.accessToken != null && loginModel.accessToken!.isNotEmpty) {
      bool isTokenExpired = JwtDecoder.isExpired(loginModel.accessToken!);
      if (isTokenExpired == true) {
        isTokenValid.value = false;
        Timer(const Duration(seconds: 1), () {
          Get.offNamed(Routes.AUTH_SCREEN);
          errorSnackBar(message: 'Your session has expired!');
        });
      } else {
        isTokenValid.value = true;
        int expirationTime = JwtDecoder.getExpirationDate(loginModel.accessToken!).millisecondsSinceEpoch;
        int currentTime = DateTime.now().millisecondsSinceEpoch;
        Duration duration = Duration(milliseconds: expirationTime - currentTime);
        log('Token expired in ${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m ${duration.inSeconds % 60}s');
        if (userBasicDetailsModel.userTypeCode != null && userBasicDetailsModel.userTypeCode! == 'RT') {
          // Retailer dashboard
          Timer(const Duration(seconds: 1), () {
            Get.offNamed(
              Routes.RETAILER_DASHBOARD_SCREEN,
              arguments: true,
            );
          });
        } else if (userBasicDetailsModel.userTypeCode != null && userBasicDetailsModel.userTypeCode! == 'AD') {
          // Distributor dashboard
          Timer(const Duration(seconds: 1), () {
            Get.offNamed(
              Routes.DISTRIBUTOR_DASHBOARD_SCREEN,
              arguments: true,
            );
          });
        } else if (userBasicDetailsModel.userTypeCode != null && userBasicDetailsModel.userTypeCode! == 'MD') {
          // Distributor dashboard
          Timer(const Duration(seconds: 1), () {
            Get.offNamed(
              Routes.DISTRIBUTOR_DASHBOARD_SCREEN,
              arguments: true,
            );
          });
        } else {
          Timer(const Duration(seconds: 1), () {
            Get.offNamed(Routes.AUTH_SCREEN);
          });
        }
      }
    } else {
      Timer(const Duration(seconds: 1), () {
        Get.offNamed(Routes.AUTH_SCREEN);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: Container(
        color: ColorsForApp.whiteColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: animationController.value,
                          child: child,
                        );
                      },
                      child: Image.asset(Assets.imagesLogo),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
