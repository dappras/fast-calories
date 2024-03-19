import 'dart:developer';
import 'package:fast_calories/utils/http_services.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var name = "".obs;
  var email = "".obs;
  var http = HttpService();

  @override
  void onInit() async {
    await getUser();
    super.onInit();
  }

  Future getUser() async {
    await http.post('user/get-user').then((res) {
      if (res['success']) {
        name.value = res['data']['name'];
        email.value = res['data']['email'];
      }
    }).catchError((e) {
      log("Error getting data user");
      print(e);
    });
  }
}
