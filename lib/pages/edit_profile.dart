import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:fast_calories/routes/route_name.dart';
import 'package:fast_calories/utils/color.dart';
import 'package:fast_calories/utils/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  var http = HttpService();

  File? file;
  var v = "";
  var base64Image = "";

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  dynamic image;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future getUser() async {
    await http.post('user/get-user').then((res) {
      if (res['success']) {
        print("ini profile ${res}");
        setState(() {
          name.text = res['data']['name'];
          email.text = res['data']['email'];
          image = res['data']['imageProfile'];
        });
      }
    }).catchError((e) {
      print("Error getting data user");
      print(e);
    });
  }

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

    Get.back();
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

    Get.back();
  }

  Future actionEdit() async {
    var body = {
      "email": email.text,
      "name": name.text,
    };

    if (password.text != "") {
      body['password'] = password.text;
    }

    if (base64Image != "") {
      body['image'] = base64Image;
    }

    print("ini body $body");

    await http.post('user/edit-user', body: body).then((res) {
      print("ini res ${res}");
      if (res['success']) {
        Get.offAndToNamed(RouteName.profilePage);
      }
    }).catchError((e) {
      log("Error getting data user");
      print(e);
    });
  }

  Future<dynamic> bottomSheetImage(BuildContext context) {
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
                      width: MediaQuery.of(context).size.height * 0.12,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(1000)),
                        child: file != null
                            ? Image.file(
                                file!,
                                fit: BoxFit.cover,
                              )
                            : image != null
                                ? Image.network(
                                    image,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.cover,
                                  ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          bottomSheetImage(context);
                        },
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Edit Profile Picture",
                              style: TextStyle(
                                color: Color(ColorWay.primary),
                                fontSize: 16,
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
                            controller: password,
                            obscureText: true,
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
                              if (email.text.isNotEmpty &&
                                  name.text.isNotEmpty) {
                                actionEdit();
                              }
                            },
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
