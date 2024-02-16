import 'package:fast_calories/pages/home.dart';
import 'package:fast_calories/pages/login.dart';
import 'package:fast_calories/pages/welcome.dart';
import 'package:fast_calories/routes/route_name.dart';
import 'package:get/get.dart';

class AppRoute {
  static final pages = [
    GetPage(name: RouteName.homePage, page: () => const Homepage()),
    GetPage(name: RouteName.welcomePage, page: () => const WelcomePage()),
    GetPage(name: RouteName.loginPage, page: () => const LoginPage())
  ];
}
