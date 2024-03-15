import 'package:fast_calories/utils/color.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Edit Profile"),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  left: width * 0.08, right: width * 0.08, top: height * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(1000))),
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
                            onTap: () {},
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Save Changes",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
