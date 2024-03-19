import 'dart:developer';
import 'package:fast_calories/utils/http_services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var name = "".obs;
  var summaryCalorie = {}.obs;
  var http = HttpService();

  @override
  void onInit() async {
    await getUser();
    await getSummaryCalorie();
    super.onInit();
  }

  Future getUser() async {
    await http.post('user/get-user').then((res) {
      if (res['success']) {
        name.value = res['data']['name'];
      }
    }).catchError((e) {
      log("Error getting data user");
      print(e);
    });
  }

  Future getSummaryCalorie() async {
    var body = {
      "limit": 5,
    };

    await http.post('calorie/summary-calorie', body: body).then((res) {
      if (res['success']) {
        if (res['data'].length > 0) {
          summaryCalorie.value = res['data'];
        }
      }
    }).catchError((e) {
      log("Error getting calorie");
      print(e);
    });
  }
}
