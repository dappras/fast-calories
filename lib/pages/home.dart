import 'package:fast_calories/utils/color.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

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
                Wrap(
                  spacing: 12,
                  runSpacing: 18,
                  children: [
                    for (int i = 0; i < 6; i++)
                      Container(
                        width: width * 0.40,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          color: Color(ColorWay.colorCard1),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: width * 0.22 * 0.72,
                              child: Image.asset('assets/images/logo.png',
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 14,
                              ),
                              child: Text(
                                "Sliced Meat",
                                style: TextStyle(
                                  color: Color(ColorWay.gray),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 8,
                              ),
                              child: Text(
                                "700 Kkal",
                                style: TextStyle(
                                  color: Color(ColorWay.black),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
