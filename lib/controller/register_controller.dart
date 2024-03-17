import 'dart:developer';
import 'package:fast_calories/utils/http_services.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';

class RegisterController extends GetxController {
  var http = HttpService();
  final LocalStorage storage = LocalStorage('fast-calories');
  var responseRegister = {
    "success": false,
    "msg": "Failed to login",
  }.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future actionRegister(email, name, password) async {
    var body = {
      "email": email,
      "name": name,
      "password": password,
    };

    var registerHit = await http.post('user/register', body: body).then((res) {
      return res;
    }).catchError((e) {
      log("Error getting data user");
      print(e);
    });

    if (registerHit.isNotEmpty) {
      return registerHit;
    }

    return responseRegister;
  }
}
