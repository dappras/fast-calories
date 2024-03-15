import 'package:fast_calories/routes/route_name.dart';
import 'package:fast_calories/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    var selectedIndex = 2;

    onItemTapped(var index) {
      if (index == 1) {}
      if (index == 0) {
        Get.offNamed(RouteName.homePage);
      }
      if (index == 2) {
        Get.offNamed(RouteName.profilePage);
      }
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                left: width * 0.08, right: width * 0.08, top: height * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(1000))),
                    height: MediaQuery.of(context).size.height * 0.12,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(1000)),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.06),
                  padding: EdgeInsets.only(
                      left: width * 0.06,
                      right: width * 0.06,
                      bottom: height * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // warna bayangan
                        spreadRadius: 4, // radius bayangan yang menyebar
                        blurRadius: 7, // radius blur bayangan
                        offset: const Offset(0, 3), // offset bayangan
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.025),
                        child: TextFormField(
                          initialValue: "daffa.rasyid",
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: "Username",
                            prefixIcon: Icon(Icons.person_2_rounded),
                            prefixIconColor: Color(ColorWay.primary),
                            fillColor: Color(ColorWay.primary),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.025),
                        child: TextFormField(
                          initialValue: "daffa.naufan@gmail.com",
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.mail_outline),
                            prefixIconColor: Color(ColorWay.primary),
                            fillColor: Color(ColorWay.primary),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02),
                        child: TextFormField(
                          readOnly: true,
                          obscureText: true,
                          initialValue: "12345678",
                          decoration: const InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock_open_outlined),
                            prefixIconColor: Color(ColorWay.primary),
                            fillColor: Color(ColorWay.primary),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.04),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(RouteName.editProfilePage);
                          },
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Edit",
                                style: TextStyle(
                                  color: Color(ColorWay.primary),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Color(ColorWay.primary),
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: height * 0.03,
                      left: width * 0.1,
                      right: width * 0.1,
                      bottom: height * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // warna bayangan
                        spreadRadius: 4, // radius bayangan yang menyebar
                        blurRadius: 7, // radius blur bayangan
                        offset: const Offset(0, 3), // offset bayangan
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Icon(
                              Icons.logout_outlined,
                              color: Color(ColorWay.primary),
                              size: 22,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "Log Out",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(),
              // icon: Icon(Icons.home),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedItemColor: const Color(ColorWay.primary),
          currentIndex: selectedIndex,
          onTap: onItemTapped,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(200)),
          child: InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(ColorWay.primary),
                  borderRadius: BorderRadius.circular(200)),
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.all(14),
              child: const Icon(
                Icons.qr_code_scanner,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
