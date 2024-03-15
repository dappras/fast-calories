import 'package:fast_calories/routes/route_name.dart';
import 'package:fast_calories/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

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
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            "Hii Daffa Rasyid!!",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width * 0.6,
                padding:
                    EdgeInsets.only(bottom: height * 0.05, top: height * 0.013),
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
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Today",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text("200 kkal"),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "This Week",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text("340 kkal"),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "This Month",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text("1000 kkal"),
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
                        padding: EdgeInsets.symmetric(vertical: height * 0.04),
                        child: Center(
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 18,
                            children: [
                              for (int i = 0; i < 6; i++)
                                Container(
                                  width: width * 0.40,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                  decoration: const BoxDecoration(
                                    color: Color(ColorWay.colorCard1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: width * 0.22 * 0.72,
                                        child: Image.asset(
                                            'assets/images/logo.png',
                                            fit: BoxFit.cover),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                          top: 14,
                                        ),
                                        child: const Text(
                                          "Sliced Meat",
                                          style: TextStyle(
                                            color: Color(ColorWay.gray),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                          top: 8,
                                        ),
                                        child: const Text(
                                          "700 Kkal",
                                          style: TextStyle(
                                            color: Color(ColorWay.black),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Container(
                                height: height * 0.18,
                                width: width * 0.40,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 16),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    border: Border.all(
                                      color: const Color(ColorWay.primary),
                                      width: 1,
                                    )),
                                child: const Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Center(child: Text('Isi Tab 2')),
                    const Center(child: Text('Isi Tab 3')),
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
