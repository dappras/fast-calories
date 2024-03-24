import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:fast_calories/routes/route_name.dart';
import 'package:fast_calories/utils/color.dart';
import 'package:fast_calories/utils/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tflite_v2/tflite_v2.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final LocalStorage storage = LocalStorage('fast-calories');
  var http = HttpService();

  File? file;
  var _recognitions;
  var v = "";
  var base64Image = "";

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      file = File(returnedImage!.path);
    });

    Uint8List _bytes = await File(returnedImage!.path).readAsBytes();
    String _base64String = base64.encode(_bytes);
    setState(() {
      base64Image = _base64String;
    });

    detectimage(file!);
    print(File(returnedImage!.path));
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      file = File(returnedImage!.path);
    });

    Uint8List _bytes = await File(returnedImage!.path).readAsBytes();
    String _base64String = base64.encode(_bytes);
    setState(() {
      base64Image = _base64String;
    });

    detectimage(file!);
    print(File(returnedImage!.path));
  }

  Future detectimage(File image) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
      v = recognitions.toString();
    });

    if (_recognitions[0]['confidence'] < 1) {
      Get.back();
    } else {
      String stringInput = _recognitions[0]['label'];

      List<String> kata = stringInput.split(' ');

      String foodIndex = kata.length > 0 ? kata[0] : '';
      String food = kata.length > 1 ? kata[1] : '';

      var calorie = 0;
      if (foodIndex == '4') {
        calorie = Random().nextInt(3000 - 1500 + 1) + 1500;
      } else if (foodIndex == '1') {
        calorie = Random().nextInt(700 - 250 + 1) + 250;
      } else if (foodIndex == '2') {
        calorie = Random().nextInt(350 - 200 + 1) + 200;
      } else if (foodIndex == '3') {
        calorie = Random().nextInt(380 - 170 + 1) + 170;
      } else if (foodIndex == '5') {
        calorie = Random().nextInt(400 - 270 + 1) + 270;
      } else if (foodIndex == '0') {
        calorie = Random().nextInt(135 - 270 + 1) + 87;
      }

      var bodyStoreCalorie = {
        "foodName": food,
        "image": base64Image,
        "calorie": calorie
      };

      actionStoreCalorie(bodyStoreCalorie);
    }
  }

  Future<dynamic> bottomSheetScan(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(vertical: height * 0.04),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        height: height * 0.18,
        width: width,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                _pickImageFromCamera();
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: height * 0.015),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Take a Picture",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  )),
            ),
            InkWell(
              onTap: () {
                _pickImageFromGallery();
              },
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.crop_original_rounded),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Add Picture From Gallery",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: "assets/model-tflite/fast-food.tflite",
      labels: "assets/model-tflite/labels.txt",
    );
  }

  Future actionStoreCalorie(data) async {
    var body = data;

    await http.post('calorie/store-calorie', body: body).then((res) {
      Get.back();
      Get.offAllNamed(RouteName.homePage);
    }).catchError((e) {
      print("Error getting data user");
      print(e);
    });
  }

  @override
  void initState() {
    loadmodel().then((value) {
      setState(() {});
    });
    getUser();
    super.initState();
  }

  Future getUser() async {
    await http.post('user/get-user').then((res) {
      if (res['success']) {
        setState(() {
          name.text = res['data']['name'];
          email.text = res['data']['email'];
        });
      }
    }).catchError((e) {
      print("Error getting data user");
      print(e);
    });
  }

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
                          controller: name,
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
                          controller: email,
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
                        onTap: () async {
                          await storage.clear();
                          Get.offAllNamed(RouteName.welcomePage);
                        },
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
            onTap: () {
              bottomSheetScan(context);
            },
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
