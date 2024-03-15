import 'package:fast_calories/pages/edit_profile.dart';
import 'package:fast_calories/pages/home.dart';
import 'package:fast_calories/pages/login.dart';
import 'package:fast_calories/pages/profile.dart';
import 'package:fast_calories/pages/signup.dart';
import 'package:fast_calories/pages/welcome.dart';
import 'package:fast_calories/routes/route_name.dart';
import 'package:get/get.dart';

class AppRoute {
  static final pages = [
    GetPage(name: RouteName.homePage, page: () => const Homepage()),
    GetPage(name: RouteName.profilePage, page: () => const ProfilePage()),
    GetPage(
        name: RouteName.editProfilePage, page: () => const EditProfilePage()),
    GetPage(name: RouteName.welcomePage, page: () => const WelcomePage()),
    GetPage(name: RouteName.loginPage, page: () => const LoginPage()),
    GetPage(name: RouteName.signupPage, page: () => const SignupPage())
  ];
}
