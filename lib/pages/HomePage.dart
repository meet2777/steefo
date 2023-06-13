import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:stefomobileapp/pages/Buyers.dart';

import 'package:stefomobileapp/pages/InventoryPage.dart';
import 'package:stefomobileapp/pages/ProfilePage.dart';
import 'package:stefomobileapp/pages/Withlumpsums.dart';
import 'package:stefomobileapp/ui/common.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:http/http.dart' as http;
import '../Models/order.dart';
import '../Models/user.dart';
import 'LoginPage.dart';
import 'package:image_picker/image_picker.dart';
import 'addItem.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const HomeContent();
    // throw UnimplementedError();
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});
  final selected = 0;
  @override
  State<HomeContent> createState() => _HomePageState(selected);
}

class _HomePageState extends State<HomeContent> {
  var _selected = 0;

  var fabLoc;
  bool editPrice = false;
  TextEditingController newBasePrice = TextEditingController();

  var homeTab;

  _HomePageState(int val) {
    _selected = val;
  }
  File? pickedImage;
  List<File>? imagesFiles = [];

  var user_type;
  void loadusertype() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user_type = await prefs.getString('userType');
  }

  List<User> regReqList = [];
  List<Order> salesOrderList = [];
  List<Order> purchaseOrderList = [];
//load request list length

  String? id3 = "";
  Future<void> loadorderlength() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var m = id3;
    id3 = await prefs.getString('id');

    if (m != id3) {
      final res = await http.post(
        Uri.parse("http://urbanwebmobile.in/steffo/vieworder.php"),
        body: {"id": id3!},
      );
      var responseData = jsonDecode(res.body);
      //print(responseData);

      for (int i = 0; i < responseData["data"].length; i++) {
        Order req = Order();
        req.reciever_id = responseData["data"][i]["supplier_id"];
        req.user_id = responseData["data"][i]["user_id"];
        req.user_mob_num = responseData["data"][i]["mobileNumber"];
        req.user_name = responseData["data"][i]["firstName"] +
            " " +
            responseData["data"][i]["lastName"];
        req.status = responseData["data"][i]["orderStatus"];
        req.party_name = responseData["data"][i]["partyName"];
        req.party_address = responseData["data"][i]["shippingAddress"];
        req.billing_address = responseData["data"][i]["address"];
        req.party_mob_num = responseData["data"][i]["partyMobileNumber"];
        req.loading_type = responseData["data"][i]["loadingType"];
        req.order_date = responseData["data"][i]["createdAt"];
        req.base_price = responseData["data"][i]["basePrice"];
        req.orderType = responseData["data"][i]["orderType"];
        req.order_id = responseData["data"][i]["order_id"].toString();
        //print(req);
        if (req.status != "Rejected") {
          if (id3 == req.user_id) {
            purchaseOrderList.add(req);
          }
          if (id3 == req.reciever_id) {
            salesOrderList.add(req);
          }
        }
      }
      setState(() {});
    }
  }

  var flag = 0;
  getRegReqs() async {
    if (flag == 0) {
      print("enter");
      var test = await http.post(
        Uri.parse(
          'http://urbanwebmobile.in/steffo/getrequests.php',
        ),
      );
      //Navigator.of(context).pushNamed("/home");

      var responseData = jsonDecode(test.body);
      print("enter1");
      print(responseData);
      for (int i = 0; i < responseData['data'].length; i++) {
        print("enter2");
        User u = User();
        u.id = responseData['data'][i]['id'];
        u.firstName = responseData['data'][i]['firstName'];
        u.lastName = responseData['data'][i]['lastName'];
        u.email = responseData['data'][i]['email'];
        u.mobileNumber = responseData['data'][i]['mobileNumber'];
        u.parentId = responseData['data'][i]['parentId'];
        u.userType = responseData['data'][i]['userType'];
        u.userStatus = responseData['data'][i]['userStatus'];
        u.orgName = responseData['data'][i]['orgName'];
        u.gstNumber = responseData['data'][i]['gstNumber'];
        u.panNumber = responseData['data'][i]['panNumber'];
        u.adhNumber = responseData['data'][i]['adhNumber'];
        u.address = responseData['data'][i]['address'];
        regReqList.add(u);
        print("enter3");
      }
      setState(() {});
      flag = 1;
      print("registrationlist${regReqList.length.toString()}");
    }
  }

  @override
  void initState() {
    loadorderlength();
    getRegReqs();
    //  loadrequestlistlength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadusertype();
    return WillPopScope(
      onWillPop: () async {
        if (_selected == 0) {
          // LogoutAlert();
        }
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
          appBar: appbar("Home", () {
            print("Back Pressed");
            Navigator.pop(context);
          }, alert: LogoutAlert),
          backgroundColor: Colors.white,
          body: HomePageBody(),
          floatingActionButton: LayoutBuilder(builder: (context, constraints) {
            if (user_type != "Manufacturer" && isSalesEnabled == "true") {
              //fabLoc = FloatingActionButtonLocation.centerDocked;
              return FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/placeorder');
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                backgroundColor: Colors.grey.shade300,
              );
            } else {
              return Container();
            }
          }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: StylishBottomBar(
            option: AnimatedBarOptions(
              iconSize: 30,
              //barAnimation: BarAnimation.liquid,
              iconStyle: IconStyle.simple,
              opacity: 0.3,
            ),
            items: [
              BottomBarItem(
                icon: const Icon(
                  Icons.home_outlined,
                ),
                title: const Text('Abc'),
                backgroundColor: Colors.red,
                //  selectedColor: Colors.cyanAccent,
                selectedIcon:
                    const Icon(Icons.home_filled, color: Colors.black),
              ),
              BottomBarItem(
                  icon: const Icon(
                    Icons.inventory_2_rounded,
                  ),
                  title: const Text('Safety'),
                  backgroundColor: Colors.orange,
                  selectedIcon: const Icon(Icons.inventory_2_rounded,
                      color: Colors.blueAccent)),
              BottomBarItem(
                  icon: const Icon(
                    Icons.warehouse_rounded,
                  ),
                  title: const Text('Safety'),
                  //  backgroundColor: Colors.orange,
                  selectedIcon: const Icon(Icons.warehouse_rounded,
                      color: Colors.blueAccent)),
              BottomBarItem(
                  icon: const Icon(
                    Icons.person_pin,
                  ),
                  title: const Text('Cabin'),
                  backgroundColor: Colors.purple,
                  selectedIcon:
                      const Icon(Icons.person_pin, color: Colors.blueAccent)),
            ],
            //fabLocation: StylishBarFabLocation.center,
            hasNotch: false,
            currentIndex: _selected,
            onTap: (index) {
              setState(() {
                if (index == 1) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          InventoryPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                }

                if (index == 2) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          buyerspage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                }
                if (index == 3) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          ProfilePage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                }
              });
            },
          )),
    );
    //  throw UnimplementedError();
  }

  String? id = "";
  int currentIndex = 0;
  bool isRes1Loaded = false;
  final List<String> imageList = [];
  var responseData1;
  List<Order> requestList = [];
  List<Order> orderList = [];
  String? isSalesEnabled, basePrice = "0";
  var m;
  Future<void> loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    m = id;
    id = await prefs.getString('id');

    if (m != id) {
      requestList = [];
      orderList = [];
      final res1 = await http
          .post(Uri.parse("http://urbanwebmobile.in/steffo/getsystemdata.php"));
      isRes1Loaded = true;
      responseData1 = jsonDecode(res1.body);

      isSalesEnabled = responseData1['data'][0]['value'];
      basePrice = responseData1['data'][1]['value'];
      print(" $isSalesEnabled and $basePrice");

      final res = await http.post(
        Uri.parse("http://urbanwebmobile.in/steffo/vieworder.php"),
        body: {"id": id!},
      );
      var responseData = jsonDecode(res.body);

      for (int i = 0; i < responseData["data"].length; i++) {
        Order req = Order();
        req.reciever_id = responseData["data"][i]["supplier_id"];
        req.user_id = responseData["data"][i]["user_id"];
        req.user_mob_num = responseData["data"][i]["mobileNumber"];
        req.user_name = responseData["data"][i]["firstName"] +
            " " +
            responseData["data"][i]["lastName"];
        req.status = responseData["data"][i]["orderStatus"];
        req.party_name = responseData["data"][i]["partyName"];
        req.party_address = responseData["data"][i]["shippingAddress"];
        req.party_mob_num = responseData["data"][i]["partyMobileNumber"];
        req.loading_type = responseData["data"][i]["loadingType"];
        req.order_date = responseData["data"][i]["createdAt"];
        req.base_price = responseData["data"][i]["basePrice"];
        req.orderType = responseData["data"][i]["orderType"];
        req.order_id = responseData["data"][i]["order_id"].toString();
        //print(req);
        if (req.status != "Denied" && req.status != "Pending") {
          orderList.add(req);
        }
        if (req.status?.trim() == "Pending" && id == req.reciever_id) {
          requestList.add(req);
          print("Added to req list");
        }
      }
      setState(() {});
    }
  }

  var price = 999;
  bool light = true;
  Widget HomePageBody() {
    loadData();

    // print(NumberFormat.simpleCurrency(locale: 'hi-IN', decimalDigits: 2)
    //     .format(1000000000));
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        //  height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //carousel slider start////////////////////////////////////
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  //  color: Colors.grey.shade200,
                ),
                child: LayoutBuilder(builder: (context, constraints) {
                  if (isRes1Loaded) {
                    print(responseData1['images'].length);
                    if (responseData1['images'].length > 0) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: CarouselSlider.builder(
                          itemCount: responseData1['images'].length,
                          options: CarouselOptions(
                            //  scrollPhysics: BouncingScrollPhysics(),
                            height: 250.0,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            //  aspectRatio: 18 / 11,
                            //  autoPlayCurve: Curves.bounceIn,
                            enableInfiniteScroll: true,

                            autoPlayAnimationDuration:
                                Duration(milliseconds: 300),
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                          ),
                          itemBuilder: (context, i, id) {
                            //for onTap to redirect to another screen
                            return GestureDetector(
                              // onLongPress: () {
                              //   imagePickerOption();
                              // },
                              child: Stack(children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Center(
                                      child: Image.network(
                                          height: 250,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          "http://urbanwebmobile.in/steffo/carousel/" +
                                              responseData1['images'][i]
                                                  ['name']),
                                    )),
                                LayoutBuilder(builder: (context, constraints) {
                                  if (user_type == "Manufacturer") {
                                    return Align(
                                      child: Container(
                                        height: 40,
                                        child: IconButton(
                                            onPressed: () async {
                                              var res1 = await http.post(
                                                  Uri.parse(
                                                      "http://urbanwebmobile.in/steffo/delcar.php"),
                                                  body: {
                                                    "id":
                                                        responseData1['images']
                                                                [i]['id']
                                                            .toString(),
                                                    "name":
                                                        responseData1['images']
                                                            [i]['name'],
                                                  });

                                              responseData1['images']
                                                  .removeAt(i);

                                              setState(() {});
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              size: 25,
                                            ),
                                            color: Colors.black),
                                        margin: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      alignment: Alignment.bottomLeft,
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                                LayoutBuilder(builder: (context, constraints) {
                                  if (user_type == "Manufacturer") {
                                    return Align(
                                      child: Container(
                                        height: 40,
                                        //color: Colors.amber,
                                        child: IconButton(
                                            onPressed: () async {
                                              await pickMultipleImage(
                                                  ImageSource.gallery);

                                              setState(() {
                                                m = id;
                                              });
                                            },
                                            icon: Icon(
                                              size: 25,
                                              Icons.add,
                                              color: Colors.black,
                                            ),
                                            color: Colors.white),
                                        margin: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      alignment: Alignment.bottomRight,
                                    );
                                  } else {
                                    return Container();
                                  }
                                })
                              ]),
                            );
                          },
                        ),
                      );
                    } else if (responseData1['images'].length == 0 &&
                        user_type == "Manufacturer") {
                      return Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        height: 150,
                        width: 500,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          // border: Border.all(
                          //   color: Colors.black,
                          //)
                        ),
                        child: IconButton(
                          onPressed: () {
                            pickMultipleImage(ImageSource.gallery);
                            setState(() {});
                          },
                          icon: Icon(Icons.add_circle_outline_rounded),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return Container();
                  }
                }),
              ),
              SizedBox(
                height: 20,
              ),

              // LayoutBuilder(builder: (context, constraints) {
              //   if (imagesFiles!.length > 0) {
              //     print(responseData1);
              //     return Container(
              //       decoration: BoxDecoration(
              //           color: Colors.grey,
              //           borderRadius: BorderRadius.circular(10)),
              //       child: DotsIndicator(
              //         dotsCount: responseData1['images'].length == 0
              //             ? 1
              //             : responseData1['images'].length,
              //         position: currentIndex.toDouble(),
              //         decorator: DotsDecorator(
              //           spacing: EdgeInsets.all(0),
              //           activeColor: responseData1['images'].length == 0
              //               ? Colors.transparent
              //               : Colors.black,
              //           color: Colors.grey,
              //         ),
              //       ),
              //     );
              //   } else {
              //     return Container();
              //   }
              // }),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 05,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              //carousel end//////////////////////////////////////////////////
              // baserate(),

              //enable sales start
              // LayoutBuilder(builder: (context, constraints) {
              //   if (user_type == "Manufacturer") {
              //     return Column(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         Container(
              //             height: 50,
              //             padding: EdgeInsets.only(left: 10, right: 10),
              //             decoration: BoxDecoration(
              //               color: light
              //                   ? Color(0xFFB6E388)
              //                   : Colors.grey.shade700,
              //               //color: Color(0xFFB6E388),
              //               borderRadius: BorderRadius.circular(10),
              //             ),
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   "Enable Sales",
              //                   style: TextStyle(
              //                       color: light ? Colors.black : Colors.white,
              //                       fontWeight: FontWeight.w700,
              //                       fontSize: 22),
              //                 ),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              // FlutterSwitch(
              //   borderRadius: 15,
              //   showOnOff: true,

              //   //  toggleSize: 50,
              //   onToggle: (bool value) async {
              //     light = value;
              //     setState(() {});
              //     var res = await http.post(
              //         Uri.parse(
              //             "http://urbanwebmobile.in/steffo/setsale.php"),
              //         body: {"status": value.toString()});
              //   },

              //   // This bool value toggles the switch.
              //   value: light,
              //   inactiveColor: Colors.black,
              //   activeColor: Colors.white,
              //   activeToggleColor: Colors.black,
              //   inactiveTextColor: Colors.white,
              //   activeTextColor: Colors.black,
              // )
              //               ],
              //             )),

              //         //enable sales end
              //         //price bar start

              //         SizedBox(
              //           height: light ? 10 : 0,
              //         ),
              //         //price bar end

              //         //admin control button start
              //       ],
              //     );
              //   } else {
              //     return Container();
              //   }
              // }),

              SizedBox(
                height: 10,
              ),
              LayoutBuilder(builder: (context, constraint) {
                if (isSalesEnabled == 'false' && user_type != 'Manufacturer') {
                  print('marketisclose');
                  return Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'Market is closed',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  );
                } else if (isSalesEnabled == 'true' &&
                    user_type != 'Manufacturer') {
                  return Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'Market is open',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
              SizedBox(
                height: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (user_type == "Manufacturer") {
                        return GestureDetector(
                            onTap: () {
                              Get.to(AddItemPage());
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/add-product.png",
                                  height: 60,
                                  width: 60,
                                  //  color: Colors.blueGrey,
                                ),
                                // Icon(
                                //   Icons.settings_sharp,
                                //   color: Colors.blue,
                                //   size: 60,
                                // ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Product Control",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
                              ],
                            ));
                      } else
                        return Padding( padding: EdgeInsets.only(left: 10),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('/orders');
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/images/number-12.png",
                                    height: 60,
                                    width: 60,
                                    //  color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "With Size",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 15),
                                  )
                                ],
                              )),
                        );
                    },
                  ),
                  LayoutBuilder(
                        builder: (context, constraints) {
                          if(user_type== "Manufacture"){
                        return GestureDetector(
                        onTap: () {
                          Get.to(AddItemPage());
                          // Navigator.of(context).pushNamed('/orders');
                        },
                          child: Column(
                          children: [
                            Image.asset(
                              "assets/images/number-12.png",
                              height: 60,
                              width: 60,
                              //  color: Colors.grey,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "With Size",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )
                          ],
                        ));
                          }else {
                            return SizedBox();
                                }
                      }
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  GestureDetector(
                      onTap: () {
                        Get.to(lumpsumsOrdersPage());
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/steel.png",
                            height: 60,
                            width: 60,
                            // color: Color.fromARGB(255, 129, 18, 18),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Lump-sums",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          )
                        ],
                      )),
                  // SizedBox(
                  //   height: 10,
                  // ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              //.......................
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/orderreq');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 13),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/add-friend.png",
                            height: 50,
                            width: 50,
                            // color: Colors.orangeAccent,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Registrations",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          )
                        ],
                      ),
                    )),
                SizedBox(
                  width: 17,
                ),
                GestureDetector(
                    onTap: () {
                      _showmodelbottomsheet();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/price-tag.png",
                            height: 50,
                            width: 50,
                            // color: Colors.orangeAccent,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Price Controls",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          )
                        ],
                      ),
                    )),
                Container(
                  height: 100,
                  width: 100,
                  // color: Colors.amber,
                )
                // GestureDetector(
                //     onTap: () {
                //       _showmodelbottomsheet();
                //     },
                //     child: Text("show sheet")),
                // GestureDetector(
                //   onTap: () {
                //     AlertDialog(actions: [],);
                //   },
                //   child: Text("baserate"),
                // )
              ]),

              SizedBox(
                height: 30,
              )
            ],
          ),
        ));
  }

  Widget baserate() {
    return LayoutBuilder(builder: (context, constraint) {
      // if (light == true) {
      return Container(
        // height: 150,
        child: LayoutBuilder(builder: (context, constraints) {
          if (editPrice == false) {
            return Column(
              mainAxisAlignment: user_type == "Manufacturer"
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                Text(
                  "BASIC RATE PER TON",
                  style: TextStyle(
                      letterSpacing: 2,
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Divider(
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GradientText(
                      colors: [
                        Colors.white,
                        Colors.white,
                        Colors.white60,
                      ],
                      NumberFormat.simpleCurrency(
                              locale: 'hi-IN', decimalDigits: 0)
                          .format(int.parse(basePrice.toString())),
                      style: TextStyle(
                        letterSpacing: 2,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "/-",
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    user_type == "Manufacturer"
                        ? FlutterSwitch(
                            borderRadius: 15,
                            showOnOff: true,

                            //  toggleSize: 50,
                            onToggle: (bool value) async {
                              light = value;
                              setState(() {});
                              var res = await http.post(
                                  Uri.parse(
                                      "http://urbanwebmobile.in/steffo/setsale.php"),
                                  body: {"status": value.toString()});
                            },

                            // This bool value toggles the switch.
                            value: light,
                            inactiveColor: Colors.black,
                            activeColor: Colors.white,
                            activeToggleColor: Colors.black,
                            inactiveTextColor: Colors.white,
                            activeTextColor: Colors.black,
                          )
                        : Container(),
                    LayoutBuilder(builder: (context, constraints) {
                      if (user_type == "Manufacturer") {
                        return Container(
                          // width:
                          //     MediaQuery.of(context).size.width * 0.2,
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                editPrice = true;
                              });
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
                  ],
                )
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: TextFormField(
                    // initialValue: price.toString(),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    controller: newBasePrice,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 4.0),
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width / 3,
                ),
                ElevatedButton(
                    onPressed: () {
                      // print(newBasePrice.text);
                      setState(() {
                        editPrice = false;
                        final numericRegex = RegExp(r'^[0-9]*$');
                        if (numericRegex.hasMatch(newBasePrice.text) &&
                            newBasePrice.text.trim() != "") {
                          price = int.parse(newBasePrice.text);
                          http.post(
                              Uri.parse(
                                  "http://urbanwebmobile.in/steffo/setbaseprice.php"),
                              body: {
                                "basePrice": newBasePrice.text.toString()
                              });
                          basePrice = newBasePrice.text;
                        }
                      });
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black))
              ],
            );
          }
        }),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: light
              ? const Color.fromARGB(255, 61, 119, 148)
              : Colors.blueGrey.shade100,
        ),
        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0),
      );
      // } else {
      //   return Container();
      // }
    });
  }

  void _showmodelbottomsheet() {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      backgroundColor: const Color.fromARGB(255, 61, 119, 148),
      constraints: BoxConstraints.tight(Size.fromHeight(250)),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return LayoutBuilder(builder: (context, constraint) {
            // if (light == true) {
            return Container(
              //  height: 100,
              child: LayoutBuilder(builder: (context, constraints) {
                if (editPrice == false) {
                  return Column(
                    mainAxisAlignment: user_type == "Manufacturer"
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      Text(
                        "BASIC RATE PER TON",
                        style: TextStyle(
                            letterSpacing: 2,
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GradientText(
                            colors: [
                              Colors.white,
                              Colors.white,
                              Colors.white60,
                            ],
                            NumberFormat.simpleCurrency(
                                    locale: 'hi-IN', decimalDigits: 0)
                                .format(int.parse(basePrice.toString())),
                            style: TextStyle(
                              letterSpacing: 2,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "/-",
                            style: TextStyle(color: Colors.white, fontSize: 35),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          user_type == "Manufacturer"
                              ? FlutterSwitch(
                                  borderRadius: 15,
                                  showOnOff: true,

                                  //  toggleSize: 50,
                                  onToggle: (bool value) async {
                                    setState(() {
                                      light = value;
                                    });
                                    var res = await http.post(
                                        Uri.parse(
                                            "http://urbanwebmobile.in/steffo/setsale.php"),
                                        body: {"status": value.toString()});
                                  },

                                  // This bool value toggles the switch.
                                  value: light,
                                  inactiveColor: Colors.black,
                                  activeColor: Colors.white,
                                  activeToggleColor: Colors.black,
                                  inactiveTextColor: Colors.white,
                                  activeTextColor: Colors.black,
                                )
                              : Container(),
                          LayoutBuilder(builder: (context, constraints) {
                            if (user_type == "Manufacturer") {
                              return Container(
                                // width:
                                //     MediaQuery.of(context).size.width * 0.2,
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      editPrice = true;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                        ],
                      )
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: TextFormField(
                          // initialValue: price.toString(),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          controller: newBasePrice,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                          cursorColor: Colors.white,
                          decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 4.0),
                            ),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            // print(newBasePrice.text);
                            setState(() {
                              editPrice = false;
                              final numericRegex = RegExp(r'^[0-9]*$');
                              if (numericRegex.hasMatch(newBasePrice.text) &&
                                  newBasePrice.text.trim() != "") {
                                price = int.parse(newBasePrice.text);
                                http.post(
                                    Uri.parse(
                                        "http://urbanwebmobile.in/steffo/setbaseprice.php"),
                                    body: {
                                      "basePrice": newBasePrice.text.toString()
                                    });
                                basePrice = newBasePrice.text;
                              }
                            });
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black))
                    ],
                  );
                }
              }),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: light
                    ? const Color.fromARGB(255, 61, 119, 148)
                    : Colors.blueGrey.shade100,
              ),
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0),
            );
            // } else {
            //   return Container();
            // }
          });
        });
      },
      // isScrollControlled: true,
      // shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      // builder: (BuildContext context) => DraggableScrollableSheet(
      //     expand: false,
      //     initialChildSize: 0.4,
      //     maxChildSize: 0.9,
      //     minChildSize: 0.32,
      //     builder: (context, scrollcontroller) => baserate()));
    );
  }

  pickMultipleImage(ImageSource source) async {
    try {
      final images = await ImagePicker().pickMultiImage();
      if (images == null) return;
      for (XFile image in images) {
        var imagesTemporary = File(image.path);
        imagesFiles!.add(imagesTemporary);
        var imgBytes = imagesTemporary.readAsBytesSync();
        String baseImage = base64Encode(imgBytes);
        var res = await http.post(
            Uri.parse("http://www.urbanwebmobile.in/steffo/setcarousel.php"),
            body: {"name": image.name, "value": baseImage});

        var picUpRes = jsonDecode(res.body);

        responseData1['images']
            .add({"id": picUpRes['data'], "name": image.name});
      }
      setState(() {});
    } catch (e) {
      print("Image Error");
    }
  }

  LogoutAlert() {
    print("object");
    QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        barrierDismissible: true,
        cancelBtnText: 'Cancel',
        confirmBtnText: 'Yes',
        title: 'Are you sure?',
        text: 'Logout',
        textColor: Colors.red,

        // customAsset: Icon(Icons.login_outlined),
        onConfirmBtnTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.clear();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              ModalRoute.withName(
                  '/') // Replace this with your root screen's route name (usually '/')
              );
        },
        onCancelBtnTap: () {
          Get.back();
        });
  }
}
