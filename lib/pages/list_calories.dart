import 'dart:developer';

import 'package:fast_calories/utils/color.dart';
import 'package:fast_calories/utils/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListCaloriePage extends StatefulWidget {
  const ListCaloriePage({super.key});

  @override
  State<ListCaloriePage> createState() => _ListCaloriePageState();
}

class _ListCaloriePageState extends State<ListCaloriePage> {
  var http = HttpService();
  var listCalorie = [];

  @override
  void initState() {
    getCalorie();
    super.initState();
  }

  Future getCalorie() async {
    await http.post('calorie/get-calorie').then((res) {
      if (res['success']) {
        if (res['data'].length > 0) {
          if (Get.arguments[0] == "today") {
            setState(() {
              listCalorie = res['data']['calorieToday'];
            });
          }
          if (Get.arguments[0] == "week") {
            setState(() {
              listCalorie = res['data']['calorieWeek'];
            });
          }
          if (Get.arguments[0] == "all") {
            setState(() {
              listCalorie = res['data']['calorieAll'];
            });
          }
        }
      }
    }).catchError((e) {
      log("Error getting calorie");
      print(e);
    });
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
          title: const Text(
            "List Calories",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.08, vertical: height * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < listCalorie.length; i++)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.015),
                    child: Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(1000)),
                          ),
                          height: height * 0.1,
                          width: width * 0.2,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(1000)),
                            child: Image.network(
                              listCalorie[i]['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listCalorie[i]['foodName'],
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              "${listCalorie[i]['calorie']} Kkal",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(ColorWay.gray),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
