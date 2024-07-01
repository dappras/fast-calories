import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:fast_calories/controller/home_controller.dart';
import 'package:fast_calories/routes/route_name.dart';
import 'package:fast_calories/utils/color.dart';
import 'package:fast_calories/utils/http_services.dart';
import 'package:fast_calories/utils/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:http/http.dart' as https;

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var homeCont = Get.put(HomeController());
  var http = HttpService();
  var listCalorie = {};
  bool isLoading = false;

  File? file;
  var _recognitions;
  var v = "";
  var base64Image = "";

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
    setState(() {
      isLoading = true;
    });

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
    print("tes hasil ${_recognitions}");

    if (_recognitions[0]['confidence'] < 0.92) {
      Get.back();
      setState(() {
        isLoading = false;
      });
    } else {
      String stringInput = _recognitions[0]['label'];

      List<String> kata = stringInput.split(' ');

      String foodIndex = kata.length > 0 ? kata[0] : '';
      String food = kata.length > 1 ? kata[1] : '';

      if (foodIndex == '4' ||
          foodIndex == '1' ||
          foodIndex == '2' ||
          foodIndex == '6' ||
          foodIndex == '7' ||
          foodIndex == '0') {
        var calorie = 0;
        if (foodIndex == '6') {
          calorie = Random().nextInt(3000 - 1500 + 1) + 1500;
        } else if (foodIndex == '1') {
          calorie = Random().nextInt(700 - 250 + 1) + 250;
        } else if (foodIndex == '2') {
          calorie = Random().nextInt(350 - 200 + 1) + 200;
        } else if (foodIndex == '4') {
          calorie = Random().nextInt(380 - 170 + 1) + 170;
        } else if (foodIndex == '7') {
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
      } else {
        Get.back();
        setState(() {
          isLoading = false;
        });
      }
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

  Future<Uint8List> _downloadImage(String url) async {
    final response = await https.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<Uint8List> createCaloriePdf() async {
    final pdf = pw.Document();

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final netImage = [];

    for (var i = 0; i < listCalorie['calorieAll'].length; i++) {
      final imageBytes =
          await _downloadImage(listCalorie['calorieAll'][i]['image']);
      netImage.add(pw.MemoryImage(imageBytes));
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: pw.EdgeInsets.symmetric(horizontal: 16),
            child: pw.Container(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Summary Calorie",
                      style: pw.TextStyle(
                        fontSize: 25,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center),
                  pw.SizedBox(height: height * 0.05),
                  for (int i = 0; i < listCalorie['calorieAll'].length; i++)
                    pw.Padding(
                      padding:
                          pw.EdgeInsets.symmetric(vertical: height * 0.015),
                      child: pw.Row(
                        children: [
                          pw.Container(
                            decoration: const pw.BoxDecoration(
                              borderRadius:
                                  pw.BorderRadius.all(pw.Radius.circular(1000)),
                            ),
                            height: height * 0.1,
                            width: width * 0.2,
                            child: pw.ClipRRect(
                              horizontalRadius: 1000,
                              verticalRadius: 1000,
                              child: pw.Image(
                                netImage[i],
                                fit: pw.BoxFit.cover,
                              ),
                            ),
                          ),
                          pw.SizedBox(
                            width: 24,
                          ),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                listCalorie['calorieAll'][i]['foodName'],
                                style: const pw.TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              pw.SizedBox(
                                height: 6,
                              ),
                              pw.Text(
                                "${listCalorie['calorieAll'][i]['calorie']} Kkal",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  void initState() {
    getCalorie();
    loadmodel().then((value) {
      setState(() {});
    });
    super.initState();
  }

  Future getCalorie() async {
    var body = {
      "limit": 5,
    };

    setState(() {
      isLoading = true;
    });

    await http.post('calorie/get-calorie', body: body).then((res) {
      if (res['success']) {
        if (res['data'].length > 0) {
          setState(() {
            listCalorie = res['data'];
          });
        }
      }
    }).catchError((e) {
      print("Error getting calorie");
      print(e);
    });

    setState(() {
      isLoading = false;
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: "assets/model-tflite/fast-calories.tflite",
      labels: "assets/model-tflite/labels.txt",
    );
  }

  Future actionStoreCalorie(data) async {
    var body = data;

    await http.post('calorie/store-calorie', body: body).then((res) {
      Get.back();
      getCalorie();
    }).catchError((e) {
      print("Error getting data user");
      print(e);
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    var selectedIndex = 0;

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
      child: LoadingFallback(
        isLoading: isLoading,
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Obx(
                () => Text(
                  "Hii ${homeCont.name.value}!!",
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              )),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width * 0.6,
                  padding: EdgeInsets.only(
                      bottom: height * 0.05, top: height * 0.013),
                  child: const Text(
                    "Find out the calories in your fast foods.",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: height * 0.03),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: height * 0.02),
                  decoration: BoxDecoration(
                    color: const Color(ColorWay.colorCard1),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // warna bayangan
                        spreadRadius: 4, // radius bayangan yang menyebar
                        blurRadius: 7, // radius blur bayangan
                        offset: const Offset(0, 3), // offset bayangan
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: height * 0.02),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Total Calories",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              Icons.bar_chart_outlined,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Today",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Obx(
                                () => Text(homeCont.summaryCalorie.isNotEmpty
                                    ? "${homeCont.summaryCalorie['calorieToday']} Kkal"
                                    : ""),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "This Week",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Obx(
                                () => Text(homeCont.summaryCalorie.isNotEmpty
                                    ? "${homeCont.summaryCalorie['calorieWeek']} Kkal"
                                    : ""),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "This Month",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Obx(
                                () => Text(homeCont.summaryCalorie.isNotEmpty
                                    ? "${homeCont.summaryCalorie['calorieAll']} Kkal"
                                    : ""),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const TabBar(
                  // Konfigurasi tab
                  tabs: [
                    Tab(text: 'Today'),
                    Tab(text: 'This Week'),
                    Tab(text: 'All'),
                  ],
                  labelColor: Color(ColorWay.primary),
                  indicatorColor: Color(ColorWay.primary),
                ),
                Expanded(
                  child: TabBarView(
                    // Isi dari setiap tab
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () async {
                                      final data = await createCaloriePdf();
                                      await Printing.sharePdf(
                                          bytes: data,
                                          filename: 'summary_calorie.pdf');
                                    },
                                    child: const Icon(
                                      Icons.download_for_offline,
                                      color: Color(ColorWay.gray),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Wrap(
                                  spacing: 12,
                                  runSpacing: 18,
                                  children: [
                                    for (int i = 0;
                                        i <
                                            (listCalorie.isNotEmpty
                                                ? listCalorie['calorieToday']
                                                    .length
                                                : 0);
                                        i++)
                                      Container(
                                        width: width * 0.40,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 16),
                                        decoration: const BoxDecoration(
                                          color: Color(ColorWay.colorCard1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: width * 0.22 * 0.72,
                                              child: Center(
                                                child: Container(
                                                  height: width * 0.22 * 0.72,
                                                  decoration: const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  1000))),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                1000)),
                                                    child: Image.network(
                                                      listCalorie.isNotEmpty
                                                          ? listCalorie[
                                                                  'calorieToday']
                                                              [i]['image']
                                                          : "",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 14,
                                              ),
                                              child: Text(
                                                  listCalorie.isNotEmpty
                                                      ? listCalorie[
                                                              'calorieToday'][i]
                                                          ['foodName']
                                                      : "",
                                                  style: const TextStyle(
                                                    color: Color(ColorWay.gray),
                                                    fontSize: 16,
                                                  )),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 8,
                                              ),
                                              child: Text(
                                                listCalorie.isNotEmpty
                                                    ? "${listCalorie['calorieToday'][i]['calorie']} Kkal"
                                                    : "",
                                                style: const TextStyle(
                                                  color: Color(ColorWay.black),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (listCalorie.isNotEmpty &&
                                        listCalorie['calorieToday'].length > 0)
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed(RouteName.listCaloriePage,
                                              arguments: ["today"]);
                                        },
                                        child: Container(
                                          height: height * 0.2,
                                          width: width * 0.40,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 16),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              border: Border.all(
                                                color: const Color(
                                                    ColorWay.primary),
                                                width: 1,
                                              )),
                                          child: const Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "See More",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
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
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () async {
                                      final data = await createCaloriePdf();
                                      await Printing.sharePdf(
                                          bytes: data,
                                          filename: 'summary_calorie.pdf');
                                    },
                                    child: const Icon(
                                      Icons.download_for_offline,
                                      color: Color(ColorWay.gray),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Wrap(
                                  spacing: 12,
                                  runSpacing: 18,
                                  children: [
                                    for (int i = 0;
                                        i <
                                            (listCalorie.isNotEmpty
                                                ? listCalorie['calorieWeek']
                                                    .length
                                                : 0);
                                        i++)
                                      Container(
                                        width: width * 0.40,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 16),
                                        decoration: const BoxDecoration(
                                          color: Color(ColorWay.colorCard1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: width * 0.22 * 0.72,
                                              child: Center(
                                                child: Container(
                                                  height: width * 0.22 * 0.72,
                                                  decoration: const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  1000))),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                1000)),
                                                    child: Image.network(
                                                      listCalorie.isNotEmpty
                                                          ? listCalorie[
                                                                  'calorieWeek']
                                                              [i]['image']
                                                          : "",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 14,
                                              ),
                                              child: Text(
                                                  listCalorie.isNotEmpty
                                                      ? listCalorie[
                                                              'calorieWeek'][i]
                                                          ['foodName']
                                                      : "",
                                                  style: const TextStyle(
                                                    color: Color(ColorWay.gray),
                                                    fontSize: 16,
                                                  )),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 8,
                                              ),
                                              child: Text(
                                                listCalorie.isNotEmpty
                                                    ? "${listCalorie['calorieWeek'][i]['calorie']} Kkal"
                                                    : "",
                                                style: const TextStyle(
                                                  color: Color(ColorWay.black),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (listCalorie.isNotEmpty &&
                                        listCalorie['calorieWeek'].length > 0)
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed(RouteName.listCaloriePage,
                                              arguments: ["week"]);
                                        },
                                        child: Container(
                                          height: height * 0.2,
                                          width: width * 0.40,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 16),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              border: Border.all(
                                                color: const Color(
                                                    ColorWay.primary),
                                                width: 1,
                                              )),
                                          child: const Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "See More",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
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
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () async {
                                      final data = await createCaloriePdf();
                                      await Printing.sharePdf(
                                          bytes: data,
                                          filename: 'summary_calorie.pdf');
                                    },
                                    child: const Icon(
                                      Icons.download_for_offline,
                                      color: Color(ColorWay.gray),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Wrap(
                                  spacing: 12,
                                  runSpacing: 18,
                                  children: [
                                    for (int i = 0;
                                        i <
                                            (listCalorie.isNotEmpty
                                                ? listCalorie['calorieAll']
                                                    .length
                                                : 0);
                                        i++)
                                      Container(
                                        width: width * 0.40,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 16),
                                        decoration: const BoxDecoration(
                                          color: Color(ColorWay.colorCard1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: width * 0.22 * 0.72,
                                              child: Center(
                                                child: Container(
                                                  height: width * 0.22 * 0.72,
                                                  decoration: const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  1000))),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                1000)),
                                                    child: Image.network(
                                                      listCalorie.isNotEmpty
                                                          ? listCalorie[
                                                                  'calorieAll']
                                                              [i]['image']
                                                          : "",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 14,
                                              ),
                                              child: Text(
                                                  listCalorie.isNotEmpty
                                                      ? listCalorie[
                                                              'calorieAll'][i]
                                                          ['foodName']
                                                      : "",
                                                  style: const TextStyle(
                                                    color: Color(ColorWay.gray),
                                                    fontSize: 16,
                                                  )),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 8,
                                              ),
                                              child: Text(
                                                listCalorie.isNotEmpty
                                                    ? "${listCalorie['calorieAll'][i]['calorie']} Kkal"
                                                    : "",
                                                style: const TextStyle(
                                                  color: Color(ColorWay.black),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (listCalorie.isNotEmpty &&
                                        listCalorie['calorieAll'].length > 0)
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed(RouteName.listCaloriePage,
                                              arguments: ["all"]);
                                        },
                                        child: Container(
                                          height: height * 0.2,
                                          width: width * 0.40,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 16),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              border: Border.all(
                                                color: const Color(
                                                    ColorWay.primary),
                                                width: 1,
                                              )),
                                          child: const Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "See More",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
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
                    ],
                  ),
                ),
              ],
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
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
      ),
    );
  }
}
