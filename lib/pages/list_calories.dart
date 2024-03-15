import 'package:fast_calories/utils/color.dart';
import 'package:flutter/material.dart';

class ListCaloriePage extends StatelessWidget {
  const ListCaloriePage({super.key});

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
                for (int i = 0; i < 6; i++)
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
                            child: Image.asset(
                              'assets/images/beef.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Steak A5",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "400 Kkal",
                              style: TextStyle(
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
