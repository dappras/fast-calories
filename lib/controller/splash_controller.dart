import 'dart:async';
import 'package:fast_calories/routes/route_name.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';

class SplashController extends GetxController {
  final LocalStorage storage = LocalStorage('fast-calories');

  @override
  void onInit() {
    var duration = const Duration(seconds: 3);
    Timer(duration, () {
      if (storage.getItem("token") != null) {
        if (storage.getItem("roles") != null && storage.getItem("roles") == 1) {
          Get.offAllNamed(RouteName.homePageAdmin);
        } else {
          Get.offAllNamed(RouteName.homePage);
        }
      } else {
        Get.offAllNamed(RouteName.welcomePage);
      }
    });
    super.onInit();
  }
}
