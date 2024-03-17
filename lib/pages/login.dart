import 'package:fast_calories/controller/login_controller.dart';
import 'package:fast_calories/routes/route_name.dart';
import 'package:fast_calories/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var loginCont = Get.put(LoginController());

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: height * 0.1, bottom: height * 0.06),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: width * 0.2,
                    ),
                  ),
                ),
                const Text(
                  "Log IN",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  width: width * 0.75,
                  child: const Text(
                    "Let’s sign in to your account and start your calorie management",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(ColorWay.gray),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: height * 0.035),
                  child: TextField(
                    controller: email,
                    decoration: const InputDecoration(
                      hintText: "Enter your Email",
                      fillColor: Color(ColorWay.gray),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: height * 0.012),
                  child: TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      fillColor: Color(ColorWay.gray),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (email.text.isNotEmpty && password.text.isNotEmpty) {
                      var resLogin = await loginCont.actionLogin(
                          email.text, password.text);
                      if (resLogin['success']) {
                        Get.toNamed(RouteName.homePage);
                      }
                    }
                  },
                  child: Container(
                    width: width,
                    margin: EdgeInsets.only(top: height * 0.075),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        color: Color(ColorWay.primary)),
                    child: const Center(
                      child: Text(
                        "Sign IN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: width * 0.40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      InkWell(
                        onTap: () {
                          Get.toNamed(RouteName.signupPage);
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color(ColorWay.primary),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
