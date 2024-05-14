import 'package:fast_calories/pages/edit_profile.dart';
import 'package:fast_calories/pages/home.dart';
import 'package:fast_calories/pages/home_admin.dart';
import 'package:fast_calories/pages/list_calories.dart';
import 'package:fast_calories/pages/login.dart';
import 'package:fast_calories/pages/profile.dart';
import 'package:fast_calories/pages/profile_admin.dart';
import 'package:fast_calories/pages/signup.dart';
import 'package:fast_calories/pages/welcome.dart';
import 'package:fast_calories/routes/route_name.dart';
import 'package:get/get.dart';

class AppRoute {
  static final pages = [
    GetPage(name: RouteName.homePage, page: () => const Homepage()),
    GetPage(name: RouteName.homePageAdmin, page: () => const HomepageAdmin()),
    GetPage(name: RouteName.profilePage, page: () => const ProfilePage()),
    GetPage(
        name: RouteName.profileAdminPage, page: () => const ProfileAdminPage()),
    GetPage(
        name: RouteName.editProfilePage, page: () => const EditProfilePage()),
    GetPage(name: RouteName.welcomePage, page: () => const WelcomePage()),
    GetPage(name: RouteName.loginPage, page: () => const LoginPage()),
    GetPage(name: RouteName.signupPage, page: () => const SignupPage()),
    GetPage(
        name: RouteName.listCaloriePage, page: () => const ListCaloriePage()),
  ];
}
