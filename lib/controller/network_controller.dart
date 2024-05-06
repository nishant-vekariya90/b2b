import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';
import '../utils/string_constants.dart';
import '../widgets/constant_widgets.dart';

class NetworkController extends GetxController {
  RxInt connectionStatus = 0.obs;
  Connectivity connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? streamSubscription;

  @override
  void onInit() async {
    super.onInit();
    try {
      List<ConnectivityResult> connectivityResult = await connectivity.checkConnectivity();
      isInternetAvailable.value = connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi) ? true : false;
      callStreamSubscription();
    } on PlatformException catch (e) {
      errorSnackBar(message: e.message);
    }
  }

  @override
  void onClose() {
    streamSubscription?.cancel();
    super.onClose();
  }

  callStreamSubscription() {
    streamSubscription = connectivity.onConnectivityChanged.listen((List<ConnectivityResult> connectivityResult) {
      try {
        if (connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi)) {
          isInternetAvailable.value = true;
          log('🛜 => 🟢');
        } else if (connectivityResult.contains(ConnectivityResult.none)) {
          isInternetAvailable.value = false;
          log('🛜 => 🔴');
          Get.toNamed(Routes.NO_INTERNET_CONNECTION_SCREEN);
        } else {
          throw Exception('Network Error, Try after sometime!');
        }
      } catch (e) {
        errorSnackBar(message: e.toString());
      }
    });
  }
}
