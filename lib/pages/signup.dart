import 'package:fast_calories/routes/route_name.dart';
import 'package:fast_calories/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  width: width * 0.75,
                  child: const Text(
                    "Let’s sign up to your account and start your calorie management",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(ColorWay.gray),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: height * 0.035),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Enter your Email",
                      fillColor: Color(ColorWay.gray),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: height * 0.012),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Enter your Name",
                      fillColor: Color(ColorWay.gray),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: height * 0.012),
                  child: const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      fillColor: Color(ColorWay.gray),
                    ),
                  ),
                ),
                Container(
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
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: width * 0.25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      InkWell(
                        onTap: () {
                          Get.toNamed(RouteName.loginPage);
                        },
                        child: const Text(
                          "Sign In",
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
