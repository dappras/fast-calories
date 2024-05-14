import 'package:fast_calories/controller/home_controller.dart';
import 'package:fast_calories/routes/route_name.dart';
import 'package:fast_calories/utils/color.dart';
import 'package:fast_calories/utils/http_services.dart';
import 'package:fast_calories/utils/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomepageAdmin extends StatefulWidget {
  const HomepageAdmin({super.key});

  @override
  State<HomepageAdmin> createState() => _HomepageAdminState();
}

class _HomepageAdminState extends State<HomepageAdmin> {
  var homeCont = Get.put(HomeController());
  var http = HttpService();
  var listUser = [];
  bool isLoading = false;

  @override
  void initState() {
    getAllUser();
    super.initState();
  }

  Future getAllUser() async {
    setState(() {
      isLoading = true;
    });

    await http.post('user/get-all-user').then((res) {
      print(res);
      if (res['success']) {
        if (res['data'].length > 0) {
          setState(() {
            listUser = res['data'];
          });
          print(res['data']);
        }
      }
    }).catchError((e) {
      print("Error getting all user");
      print(e);
    });

    setState(() {
      isLoading = false;
    });
  }

  Future deleteUser(id) async {
    setState(() {
      isLoading = true;
    });

    var body = {
      "id": id,
    };

    print(body);

    await http.post('user/delete-user', body: body).then((res) {
      print("res delete");
      print(res);
      if (res['success']) {
        getAllUser();
      }
    }).catchError((e) {
      print("Error getting all user");
      print(e.message);
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
      if (index == 0) {
        Get.offNamed(RouteName.homePageAdmin);
      }
      if (index == 1) {
        Get.offNamed(RouteName.profileAdminPage);
      }
    }

    return LoadingFallback(
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
                padding:
                    EdgeInsets.only(bottom: height * 0.05, top: height * 0.013),
                child: const Text(
                  "Check all the user that registered.",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (listUser.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: width * 0.6),
                    child: const Text("THERE IS NO REGISTERED USER!!"),
                  ),
                ),
              for (int i = 0; i < listUser.length; i++)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                              child: listUser[i]['imageProfile'] != null
                                  ? Image.network(
                                      listUser[i]['imageProfile'],
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/logo.png',
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
                                listUser[i]['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                "${listUser[i]['email']}",
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
                      InkWell(
                        onTap: () {
                          deleteUser(listUser[i]["id"]);
                        },
                        child: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Color(ColorWay.black),
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedItemColor: const Color(ColorWay.primary),
          currentIndex: selectedIndex,
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
