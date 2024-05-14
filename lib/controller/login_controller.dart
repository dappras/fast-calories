import 'dart:developer';
import 'package:fast_calories/utils/http_services.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';

class LoginController extends GetxController {
  var http = HttpService();
  final LocalStorage storage = LocalStorage('fast-calories');
  var responseLogin = {
    "success": false,
    "msg": "Failed to login",
  }.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future actionLogin(email, password) async {
    var body = {
      "email": email,
      "password": password,
    };

    var loginHit = await http.post('user/login', body: body).then((res) {
      if (res['success']) {
        storage.setItem("token", res['token']);
        if (res['user']['roles'] == null) {
          storage.setItem("roles", 0);
        } else {
          storage.setItem("roles", (res['user']['roles']));
        }
      }
      return res;
    }).catchError((e) {
      log("Error getting data user");
      print(e);
    });

    if (loginHit.isNotEmpty) {
      return loginHit;
    }

    return responseLogin;
  }
}
