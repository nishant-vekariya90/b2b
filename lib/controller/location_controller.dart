import 'dart:async';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import '../routes/routes.dart';
import '../utils/permission_handler.dart';
import '../utils/string_constants.dart';
import '../widgets/constant_widgets.dart';

class LocationController extends GetxController {
  final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  StreamSubscription<Position>? positionStreamSubscription;
  StreamSubscription<ServiceStatus>? serviceStatusStreamSubscription;
  LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.low,
    distanceFilter: 100,
  );

  @override
  void onClose() {
    serviceStatusStreamSubscription?.cancel();
    positionStreamSubscription?.cancel();
    super.onClose();
  }

  Future<void> checkLocationServiceStatusPeriodically() async {
    await checkServicePermission();
    if (isGPSAvailable.value == true) {
      await checkLocationPermission();
      callLocationStreamSubscription();
    }
    callServiceStreamSubscription();
    while (true) {
      checkServicePermission();
      await Future.delayed(const Duration(minutes: 1));
    }
  }

  // For check GPS on or off
  Future<void> callServiceStreamSubscription() async {
    serviceStatusStreamSubscription = geolocatorPlatform.getServiceStatusStream().listen((ServiceStatus serviceStatus) async {
      try {
        if (serviceStatus == ServiceStatus.enabled) {
          isGPSAvailable.value = true;
          log('🌍 => 🟢');
        } else if (serviceStatus == ServiceStatus.disabled) {
          isGPSAvailable.value = false;
          log('🌍 => 🔴');
        } else {
          throw Exception('Location Error, Try after sometime!');
        }
        if (isGPSAvailable.value) {
          await checkLocationPermission();
        } else {
          Get.toNamed(Routes.NO_LOCATION_PERMISSION_SCREEN);
        }
      } catch (e) {
        errorSnackBar(message: e.toString());
      }
    });
  }

  // For get lat long
  Future<void> callLocationStreamSubscription() async {
    positionStreamSubscription?.cancel();
    positionStreamSubscription = geolocatorPlatform.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      latitude = position.latitude.toStringAsFixed(6);
      longitude = position.longitude.toStringAsFixed(6);
      log('\x1B[35m[Lat] => $latitude\x1B[0m');
      log('\x1B[35m[Long] => $longitude\x1B[0m');
    });
  }

  // Check GPS service permission
  Future<void> checkServicePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      isGPSAvailable.value = true;
    } else {
      isGPSAvailable.value = false;
      Get.toNamed(Routes.NO_LOCATION_PERMISSION_SCREEN);
    }
  }

  // Check location permission
  Future<void> checkLocationPermission() async {
    try {
      LocationPermission locationPermission = await geolocatorPlatform.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        isLocationAvailable.value = false;
        LocationPermission requestedPermission = await geolocatorPlatform.requestPermission();
        if (requestedPermission == LocationPermission.always || requestedPermission == LocationPermission.whileInUse) {
          isLocationAvailable.value = true;
        } else if (requestedPermission == LocationPermission.denied) {
          isLocationAvailable.value = false;
          throw Exception('Location Permission Denied!');
        } else if (requestedPermission == LocationPermission.deniedForever) {
          isLocationAvailable.value = false;
          await permissionDialog(
            Get.context!,
            title: 'Location Permission',
            subTitle: 'Location permission should be granted to use this feature, would you like to go to app settings to give location permission?',
            onTap: () async {
              Get.back();
              await ph.openAppSettings();
              checkLocationPermission();
            },
          );
        }
      } else if (locationPermission == LocationPermission.always || locationPermission == LocationPermission.whileInUse) {
        isLocationAvailable.value = true;
      }
      if (isLocationAvailable.value == true) {
        await callLocationStreamSubscription();
        Get.back();
      }
    } catch (e) {
      errorSnackBar(message: e.toString());
    }
  }
}
