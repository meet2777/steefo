import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stefomobileapp/Models/lumpsum.dart';
// import 'package:stefomobileapp/Models/order.dart';
import 'package:stefomobileapp/pages/Buyers.dart';
// import 'package:stefomobileapp/pages/DistributorsPage.dart';
import 'package:stefomobileapp/pages/HomePage.dart';
import 'package:stefomobileapp/pages/ProfilePage.dart';
import 'package:stefomobileapp/ui/cards.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../Models/grade.dart';
import '../Models/order.dart';
import '../ui/common.dart';
import 'OrderPage.dart';

class InventoryPage extends StatelessWidget {
  final Order order;
  InventoryPage({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    return InventoryContent(order: order);
  }
}

class InventoryContent extends StatefulWidget {
  InventoryContent({super.key, required this.order});
  final Order order;
  final selected = 0;
  @override
  State<InventoryContent> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryContent> {
  String? id, supplier_id;
  var _selected = 1;
  bool isDataLoaded = false;
  List<Lumpsum> lumpsums = [];
  List<Grade> gradeList = [];
  List<Grade> gradeList1 = [];
  List<Grade> gradeList2 = [];
  List<Order> salesOrderList = [];
  Lumpsum lumpsum = Lumpsum();

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user_id = await prefs.getString('id');

    var res1 = await http
        .post(Uri.parse("http://steefotmtmobile.com/steefo/getgrade.php"));
    var responseData1 = jsonDecode(res1.body);
    for (int i = 0; i < responseData1['data'].length; i++) {
      print("Grade");
      print(responseData1['data'][i]);
      Grade g = Grade();
      g.value = responseData1['data'][i]['gradeName'];
      g.qty = 0;
      gradeList.add(g);

      int middleIndex = (gradeList.length / 2).round();
      gradeList1.clear();
      gradeList2.clear();
      for (int i = 0; i < gradeList.length; i++) {
        if (i < middleIndex) {
          print("Add");
          gradeList1.add(gradeList[i]);
        } else {
          gradeList2.add(gradeList[i]);
        }
      }
    }

    var res = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/getinventory.php"),
        body: {
          "user_id": user_id,
        });
    var responseData = jsonDecode(res.body);
    // var orders = [];
    print(responseData);
    for (int i = 0; i < responseData["data"].length; i++) {
      print(responseData['data'][i]['name']);
      try {
        var ind = gradeList.indexWhere((element) =>
            element.value?.trim() == responseData['data'][i]['name'].trim());
        gradeList[ind].qty = gradeList[ind].qty! +
            double.parse(responseData['data'][i]['qty_left']);
      } catch (e) {
        print(e);
      }
      //print(gradeList[ind].value! + " " + gradeList[ind].qty.toString());
      Lumpsum l = Lumpsum();
      l.order_id = responseData["data"][i]["order_id"];
      l.name = responseData["data"][i]["name"];
      l.qty = responseData["data"][i]["qty"];
      l.qty_left = responseData["data"][i]["qty_left"];
      l.price = responseData["data"][i]["price"];
      l.basePrice = responseData["data"][i]["basePrice"];
      l.status = responseData["data"][i]["orderStatus"];
      l.date = responseData["data"][i]["createdAt"];
      l.partyname = responseData["data"][i]["partyName"];
      lumpsums.add(l);
    }
    isDataLoaded = true;
    setState(() {});

    var m = id;

    if (m != id) {
      final res2 = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/vieworder.php"),
        body: {"id": id},
      );
      var responseData2 = jsonDecode(res2.body);
      print(responseData2);

      for (int i = 0; i < responseData2["data"].length; i++) {
        Order req = Order();
        req.deliveryDate = responseData2["data"][i]["deliveryDate"];
        req.totalPrice = responseData2["data"][i]["totalPrice"];
        req.totalQuantity = responseData2["data"][i]["totalQuantity"];
        req.reciever_id = responseData2["data"][i]["supplier_id"];
        req.user_id = responseData2["data"][i]["user_id"];
        req.orderid = responseData2["data"][i]["orderid"];
        req.user_mob_num = responseData2["data"][i]["mobileNumber"];
        req.org_name = responseData2["data"][i]["orgName"];
        req.userType = responseData2["data"][i]["userType"];
        req.user_name = responseData2["data"][i]["firstName"] +
            " " +
            responseData2["data"][i]["lastName"];
        req.status = responseData2["data"][i]["orderStatus"];
        req.party_name = responseData2["data"][i]["partyName"];
        req.dealerName = responseData2["data"][i]["dealerName"];
        req.consignee_name = responseData2["data"][i]["consigneeName"];
        req.PartygstNumber = responseData2["data"][i]["PartygstNumber"];
        req.gstNumber = responseData2["data"][i]["gstNumber"];
        req.party_address = responseData2["data"][i]["shippingAddress"];
        req.pincode = responseData2["data"][i]["pincode"];
        req.region = responseData2["data"][i]["region"];
        req.billing_address = responseData2["data"][i]["address"];
        req.party_mob_num = responseData2["data"][i]["partyMobileNumber"];
        req.loading_type = responseData2["data"][i]["loadingType"];
        req.paymentTerm = responseData2["data"][i]["paymentTerm"];
        req.qty_left = responseData2["data"][i]["qty_left"];
        req.trans_type = responseData2["data"][i]["transType"];
        req.trailerType = responseData2["data"][i]["trailerType"];
        req.order_date = responseData2["data"][i]["createdAt"];
        req.base_price = responseData2["data"][i]["basePrice"];
        req.orderType = responseData2["data"][i]["orderType"];
        req.orderStatus = responseData2["data"][i]["orderStatus"];
        req.order_id = responseData2["data"][i]["order_id"].toString();
        req.date = responseData2["data"][i]["dateTime"];
        //print(req);
        if (req.status != "Rejected") {
          // if (id == req.user_id) {
          //   purchaseOrderList.add(req);
          // }
          if (id == req.reciever_id) {
            salesOrderList.add(req);
          }
        }
      }
      //  print(salesOrderList);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selected == 0) {
          return true;
        }
        setState(() {
          _selected = 0;
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => HomePage(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        });
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: appbar("Inventory", () {
            Get.to(HomePage());
          }),
          body: LayoutBuilder(builder: (context, constraints) {
            if (isDataLoaded) {
              return InventoryPageBody(context);
              // return InventoryPageBody();
            } else {
              return Container();
            }
          }),
          bottomNavigationBar: StylishBottomBar(
            option: AnimatedBarOptions(
              iconSize: 30,
              barAnimation: BarAnimation.fade,
              //barAnimation: BarAnimation.liquid,
              iconStyle: IconStyle.simple,
              opacity: 0.3,
            ),

            items: [
              BottomBarItem(
                icon: const Icon(
                  Icons.home_filled,
                ),
                title: const Text('Abc'),
                backgroundColor: Colors.grey,
                selectedIcon:
                    const Icon(Icons.home_filled, color: Colors.blueAccent),
              ),
              BottomBarItem(
                  icon: const Icon(
                    Icons.inventory_2_rounded,
                  ),
                  title: const Text('Safety'),
                  backgroundColor: Colors.grey,
                  selectedIcon:
                      const Icon(Icons.inventory, color: Colors.black)),
              BottomBarItem(
                  icon: const Icon(
                    Icons.warehouse_rounded,
                  ),
                  title: const Text('Safety'),
                  selectedIcon: const Icon(Icons.warehouse_rounded,
                      color: Colors.blueAccent)),
              BottomBarItem(
                  icon: const Icon(
                    Icons.person_pin,
                  ),
                  title: const Text('Cabin'),
                  backgroundColor: Colors.grey,
                  selectedIcon:
                      const Icon(Icons.person_pin, color: Colors.blueAccent)),
            ],
            //fabLocation: StylishBarFabLocation.center,
            hasNotch: false,
            currentIndex: _selected,
            onTap: (index) {
              setState(() {
                if (index == 0) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          HomePage(),
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
  }

  Widget InventoryPageBody(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          // SizedBox(
          //   height: 10,
          // ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                // color: Colors.white,
                // color : Color(0xffEB6440),
                // color : Color(0xff497174),
                color: Color.fromARGB(255, 216, 229, 248),
                boxShadow: []),
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // width: MediaQuery.of(context).size.width / 2.5,
                  child: Flexible(
                    child: ListView.builder(
                      itemCount: gradeList1.length,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, ind) {
                        return Container(
                            child: Column(
                              children: [
                                LumpSumTotal(context, gradeList1[ind]),
                          ],
                        ));
                      },
                    ),
                  ),
                ),
                Container(
                  height: 110,
                  child: Row(
                    children: [
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 2.0,
                        width: 20,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // flex: 1,
                  child: Container(
                    child: ListView.builder(
                      itemCount: gradeList2.length,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, ind) {
                        return Container(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                LumpSumTotal(context, gradeList2[ind]),
                              ],
                            ));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              //   color: Colors.black,
              margin: EdgeInsets.only(left: 10),
              height: 60,
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "abc ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),

          ListView.builder(
            reverse: true,
            itemCount: salesOrderList.length,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print("ordertype${salesOrderList[index].orderType}");
              if (salesOrderList[index].orderType == "With Size" ||
                  salesOrderList[index].orderType == "Use Lumpsum") {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderDetails(
                                  order: salesOrderList[index],
                                  lumpsum: lumpsum)
                          )
                      );
                    },
                    child: orderCard(
                      context,
                      salesOrderList[index],
                      //  qtyandprice[index],
                      id,
                    ));
              } else
                return Container();
            },
          )
          // LayoutBuilder(builder:(context, constraints){
          //   if(widget.order.date == DateFormat('dd-MM-yyyy').format(DateTime.now())){
          //     return ListView.builder(
          //       reverse: true,
          //       itemCount: salesOrderList.length,
          //       physics: const NeverScrollableScrollPhysics(),
          //       scrollDirection: Axis.vertical,
          //       shrinkWrap: true,
          //       itemBuilder: (context, index) {
          //         print("ordertype${salesOrderList[index].orderType}");
          //         if (salesOrderList[index].orderType == "With Size" ||
          //             salesOrderList[index].orderType == "Use Lumpsum") {
          //           return GestureDetector(
          //               onTap: () {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) => OrderDetails(
          //                             order: salesOrderList[index],lumpsum: lumpsum)
          //                     )
          //                 );
          //               },
          //               child: orderCard(
          //                 context,
          //                 salesOrderList[index],
          //                 //  qtyandprice[index],
          //                 id,
          //               )
          //           );
          //         } else
          //           return Container();
          //       },
          //     );
          //   }else {
          //     return Container();
          //   }
          // },
          // )

          // Container(
          //   //color: Colors.amber,
          //   child: Expanded(
          //     child: SingleChildScrollView(
          //       physics: BouncingScrollPhysics(),
          //       child: Column(children: [
          //         ListView.builder(
          //           itemCount: lumpsums.length,
          //           physics: const NeverScrollableScrollPhysics(),
          //           // scrollDirection: Axis.vertical,
          //           shrinkWrap: true,
          //           itemBuilder: (context, index) {
          //             return InkWell(
          //                 onTap: () {
          //                   // Navigator.push(context,
          //                   //     MaterialPageRoute(
          //                   //         builder: (context) => OrderDetails(order: salesOrderList[index]))
          //                   // );
          //                 },
          //                 child: Container(
          //                     margin: EdgeInsets.all(10.0),
          //                     padding: const EdgeInsets.all(8.0),
          //                     decoration: BoxDecoration(
          //                       // gradient: LinearGradient(colors: [
          //                       //   Color.fromARGB(255, 228, 245, 181),
          //                       //   Color.fromARGB(255, 242, 255, 64)
          //                       // ]),
          //
          //                       borderRadius: BorderRadius.circular(10.0),
          //                       //  border: Border.all(color: Colors.black),
          //                       // border: Border.all(color: Colors.black),
          //                       color: Colors.grey.shade100,
          //                     ),
          //                     // width: 200,
          //                     child: InventoryCard(context, lumpsums[index],Order(),id)));
          //           },
          //         ),
          //       ]),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
