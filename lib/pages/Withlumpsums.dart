import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:stefomobileapp/pages/HomePage.dart';
import 'package:stefomobileapp/pages/Withsize.dart';
import '../Models/lumpsum.dart';
import '../Models/order.dart';
import '../ui/common.dart';
// import '../ui/cards.dart';
import '../ui/custom_tabbar.dart';
import 'OrderPage.dart';

class lumpsumsOrdersPage extends StatelessWidget {
  final Lumpsum lumpsum;
  lumpsumsOrdersPage({super.key, required this.lumpsum});
  @override
  Widget build(BuildContext context) {
    return LumpsumContent(lumpsum:lumpsum);
    //  throw UnimplementedError();
  }
}

class LumpsumContent extends StatefulWidget {
  final Lumpsum lumpsum;
  const LumpsumContent({super.key, required this.lumpsum});
  final selected = 0;
  @override
  State<LumpsumContent> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<LumpsumContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar("Lump-Sums", () {
        Get.to(HomePage());
      }),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: CustomTabBar(
            // padding: EdgeInsets.only(left: 10,right: 10),
            selectedCardColor: Colors.blueGrey,
            selectedTitleColor: Colors.white,
            unSelectedTitleColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            unSelectedCardColor: Colors.white,
            titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tabBarItemExtend: ((MediaQuery.of(context).size.width) / 3),
            tabBarItems: [
              "Requests",
              "Confirmed\nOrders",
              "Completed"
            ],
            tabViewItems: [
              OrderList1(),
              OrdersPageBody(),
              CompletedListBody()
            ]),
      ),
    );
  }

  String? id = "";

  Lumpsum lumpsum= Lumpsum();
  // Lumpsum lumpsum = Lumpsum();
  List<Order> salesOrderList = [];
  List<Order> purchaseOrderList = [];

  Future<void> loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var m = id;
    id = await prefs.getString('id');
    print("sss" + "${id}");

    if (m != id) {
      final res = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/vieworder.php"),
        body: {"id": id!},
      );
      var responseData = jsonDecode(res.body);
      //print(responseData);
      for (int i = 0; i < responseData["data"].length; i++) {
        Order req = Order();
        req.deliveryDate = responseData["data"][i]["deliveryDate"];
        req.totalPrice = responseData["data"][i]["price"];
        req.reciever_id = responseData["data"][i]["supplier_id"];
        req.user_id = responseData["data"][i]["user_id"];
        req.user_mob_num = responseData["data"][i]["mobileNumber"];
        req.org_name = responseData["data"][i]["orgName"];
        req.userType = responseData["data"][i]["userType"];
        req.user_name = responseData["data"][i]["firstName"] +
            " " +
            responseData["data"][i]["lastName"];
        req.status = responseData["data"][i]["orderStatus"];
        req.totalQuantity = responseData["data"][i]["totalQuantity"];
        req.party_name = responseData["data"][i]["partyName"];
        req.dealerName = responseData["data"][i]["dealerName"];
        req.consignee_name = responseData["data"][i]["consigneeName"];
        req.party_address = responseData["data"][i]["shippingAddress"];
        req.pincode = responseData["data"][i]["pincode"];
        req.region = responseData["data"][i]["region"];
        req.billing_address = responseData["data"][i]["address"];
        req.party_mob_num = responseData["data"][i]["partyMobileNumber"];
        req.PartygstNumber = responseData["data"][i]["PartygstNumber"];
        req.gstNumber = responseData["data"][i]["gstNumber"];
        req.loading_type = responseData["data"][i]["loadingType"];
        req.trans_type = responseData["data"][i]["transType"];
        req.order_date = responseData["data"][i]["createdAt"];
        req.base_price = responseData["data"][i]["basePrice"];
        req.orderType = responseData["data"][i]["orderType"];
        req.qty_left = responseData["data"][i]["qty_left"];
        req.order_id = responseData["data"][i]["order_id"].toString();
        req.date = responseData["data"][i]["dateTime"];
        //print(req);
        if (req.status != "Rejected") {
          if (id == req.user_id) {
            purchaseOrderList.add(req);
          }
          if (id == req.reciever_id) {
            salesOrderList.add(req);
          }
        }
      }
      //  print(salesOrderList);
      setState(() {});
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    final user_id = await pref.getString('id');
    print('${user_id}ddddd');
    var res = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/getinventory.php"),
        body: {
          "user_id": user_id,
        });
    var responseData = jsonDecode(res.body);
    /// var orders = [];
    print("lumpsumlist${responseData}");
    for (int i = 0; i < responseData["data"].length; i++) {
      print(responseData['data'][i]['name']);
      Lumpsum l = Lumpsum();
      l.partyname = responseData["data"][i]["partyName"];
      l.order_id = responseData["data"][i]["order_id"];
      l.name = responseData["data"][i]["name"];
      l.basePrice = responseData["data"][i]["basePrice"];
      l.qty = responseData["data"][i]["qty"];
      l.qty_left = responseData["data"][i]["qty_left"];
      l.price = responseData["data"][i]["price"];
      l.status = responseData["data"][i]["orderStatus"];
      l.ls_id = responseData['data'][i]["ls_id"];
      l.date = responseData["data"][i]["createdAt"];
      // lumpsumList.add(l);
    }

    // final res2 = await http.post(
    //   Uri.parse("http://steefotmtmobile.com/steefo/getlumpsumorder.php"),
    //   body: {"order_id": id},
    // );
    // var responseData2 = jsonDecode(res2.body);
    // // print("lumpsum order"+responseData2);
    // for (int i = 0; i < responseData2["data"].length; i++) {
    //   Lumpsum lumpsum = Lumpsum();
    //   lumpsum.ls_id = responseData2["data"][i]["ls_id"];
    //   lumpsum.order_id = responseData2["data"][i]["order_id"];
    //   lumpsum.name = responseData2["data"][i]["name"];
    //   lumpsum.qty = responseData2["data"][i]["qty"];
    //   lumpsum.qty_left = responseData2["data"][i]["qty_left"];
    //   lumpsum.basePrice = responseData2["data"][i]["basePrice"];
    //   lumpsum.price = responseData2["data"][i]["price"];
    //   lumpsum.status = responseData2["data"][i]["orderStatus"];
    //   print("remaining qty "+ widget.lumpsum.order_id.toString());
    // }

  }

  String? id1 = "";
  String? userType;

  List<Order> requestList = [];

  Future<void> loadData1() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var m = id1;
    id1 = await prefs.getString('id');
    userType = await prefs.getString('userType');
    print("id1${id1}");

    if (m != id1) {
      final res = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/vieworder.php"),
        body: {"id": id1!},
      );
      var responseData = jsonDecode(res.body);
      print(responseData);

      for (int i = 0; i < responseData["data"].length; i++) {
        Order req = Order();
        req.deliveryDate = responseData["data"][i]["deliveryDate"];
        req.totalPrice = responseData["data"][i]["totalPrice"];
        req.totalQuantity = responseData["data"][i]["totalQuantity"];
        req.orderType = responseData["data"][i]["orderType"];
        req.reciever_id = responseData["data"][i]["supplier_id"];
        req.user_id = responseData["data"][i]["user_id"];
        req.user_mob_num = responseData["data"][i]["mobileNumber"];
        req.org_name = responseData["data"][i]["orgName"];
        req.userType = responseData["data"][i]["userType"];
        req.user_name = responseData["data"][i]["firstName"] +
            " " +
            responseData["data"][i]["lastName"];
        req.status = responseData["data"][i]["orderStatus"];
        req.party_name = responseData["data"][i]["partyName"];
        req.dealerName = responseData["data"][i]["dealerName"];
        req.consignee_name = responseData["data"][i]["consigneeName"];
        req.party_address = responseData["data"][i]["shippingAddress"];
        req.pincode = responseData["data"][i]["pincode"];
        req.region = responseData["data"][i]["region"];
        req.billing_address = responseData["data"][i]["address"];
        req.party_mob_num = responseData["data"][i]["partyMobileNumber"];
        req.PartygstNumber = responseData["data"][i]["PartygstNumber"];
        req.gstNumber = responseData["data"][i]["gstNumber"];
        req.loading_type = responseData["data"][i]["loadingType"];
        req.trans_type = responseData["data"][i]["transType"];
        req.order_date = responseData["data"][i]["createdAt"];
        req.base_price = responseData["data"][i]["basePrice"];
        req.qty_left = responseData["data"][i]["qty_left"];
        req.order_id = responseData["data"][i]["order_id"].toString();
        req.date = responseData["data"][i]["dateTime"];
        if (req.status?.trim() == "Pending" && id1 == req.reciever_id) {
          print(req.loading_type);
          print(req.trans_type);
          requestList.add(req);

          print("lumpsum quantity"+req.totalQuantity.toString());
        }
      }
      setState(() {});
      print(requestList.length);
    }


    // final res = await http.post(
    //   Uri.parse("http://steefotmtmobile.com/steefo/getlumpsumorder.php"),
    //   // body: {"order_id": orderId},
    // );
    // var responseData = jsonDecode(res.body);
    // //print(responseData);
    // for (int i = 0; i < responseData["data"].length; i++) {
    //   Lumpsum lumpsum = Lumpsum();
    //   lumpsum.name = responseData["data"][i]["name"];
    //   lumpsum.qty = responseData["data"][i]["qty"];
    //   lumpsum.qty_left = responseData["data"][i]["qty_left"];
    //   lumpsum.basePrice = responseData["data"][i]["basePrice"];
    //   lumpsum.price = responseData["data"][i]["price"];
    //   lumpsum.status = responseData["data"][i]["orderStatus"];
    //   //print(req);
    //   // if (req.status != "Rejected") {
    //   //   if (id3 == req.user_id) {
    //   //     purchaseOrderList.add(req);
    //   //   }
    //   //   if (id3 == req.reciever_id) {
    //   //     salesOrderList.add(req);
    //   //   }
    //   // }
    // }
  }

  Widget OrdersPageBody() {
    loadData();
    // loadData1();
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              reverse: true,
              itemCount: salesOrderList.length,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                print("ordertype${salesOrderList[index].orderType}");
                if (salesOrderList[index].orderType == "Lump-sum") {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderDetails(
                                    order: salesOrderList[index],lumpsum: lumpsum)));
                      },
                      child: orderCard(
                        context,
                        salesOrderList[index],
                        id,
                      ));
                } else
                  return Container();
              },
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  //----------------------------------OrderList---------------------------------//

  // Widget OrderList() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 10, right: 10),
  //     child: SingleChildScrollView(
  //       physics: BouncingScrollPhysics(),
  //       child: Column(
  //         children: [
  //           ListView.builder(
  //             itemCount: salesOrderList.length,
  //             physics: const NeverScrollableScrollPhysics(),
  //             scrollDirection: Axis.vertical,
  //             shrinkWrap: true,
  //             itemBuilder: (context, index) {
  //               // print("ordertype${salesOrderList[index].orderType}");
  //               // if (salesOrderList[index].orderType == "Lump-sum") {
  //               return GestureDetector(
  //                   onTap: () {
  //                     Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) =>
  //                                 OrderDetails(order: salesOrderList[index])));
  //                   },
  //                   child: orderCard(
  //                     context,
  //                     salesOrderList[index],
  //                     id,
  //                   ));
  //               // } else
  //               //   return null;
  //             },
  //           ),
  //           SizedBox(
  //             height: 50,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

//------------------------------Orderrequest--------------------------------
  Widget OrderList1() {
    loadData1();
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          //
          Container(
            child: ListView.builder(
              reverse: true,
              itemCount: requestList.length,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // print(requestList[index].orderType);
                // if (requestList[index].orderType == "With Size") {
                print("ordertype1${requestList[index].orderType}");
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetails(order: requestList[index],lumpsum: lumpsum)));
                    },
                    child: requestList[index].orderType == "Lump-sum"
                        ? orderwidget1(index)
                        : Container());
                // }
                // return null;
              },
            ),
          ),
          SizedBox(
            height: 110,
          )
        ],
      ),
    );
  }

  Widget orderwidget1(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        margin: EdgeInsets.only(top: 10),
        // padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey.shade100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  //  height: 50,
                  padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                  width: MediaQuery.of(context).size.width / 1.06,
                  // color: Colors.red,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(19, 59, 78, 1.0),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Padding(padding: EdgeInsets.only(left: 5)),
                          // Align(alignment: Alignment.topRight,),
                          Text(
                            "ORDER ID",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            requestList[index].date!.substring(0,10),
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            requestList[index].order_id!,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17)),
                          ),
                          Text(
                            requestList[index].date!.substring(10,19),
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 10),
              alignment: Alignment.topLeft,
              child: Text(
                requestList[index].org_name!.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Divider(color: Colors.orangeAccent),

            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Base Price:",
                              style: TextStyle(
                                  fontFamily: "Poppins_Bold",
                                  color: Colors.grey),
                            ),Padding(padding: EdgeInsets.only(left: 5)),
                            Text(requestList[index].base_price!,style: TextStyle(color: Colors.grey),)
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Trans. Type:",
                              style: TextStyle(
                                  fontFamily: "Poppins_Bold",
                                  color: Colors.grey),
                            ),
                            Text(requestList[index].trans_type.toString(), style: TextStyle(color: Colors.grey),)
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          "Quantity:",
                          style: TextStyle(
                              fontFamily: "Poppins_Bold", color: Colors.grey),
                        ),
                        Text(requestList[index].totalQuantity.toString())
                      ],
                    ),
                  ),
                  //Padding(padding: EdgeInsets.only(right: 5)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container(
                //     child: const Text(
                //   "Order Details",
                //   textAlign: TextAlign.left,
                //   style: TextStyle(fontFamily: "Poppins_Bold"),
                // )),
                TextButton(
                    onPressed: () async {
                      await http.post(
                        Uri.parse(
                            "http://steefotmtmobile.com/steefo/approveorder.php"),
                        body: {
                          "decision": "Approved",
                          "order_id": requestList[index].order_id!
                        },
                      );
                      () {
                        // orderList.add(requestList[index]);
                        // requestList.removeAt(index);
                        id = "none";
                        requestList.removeAt(index);
                        setState(() {
                          // print('setstate');
                          // loadData();
                        });
                      }();
                      // Get.to(RequestPage());
                    },
                    child: GradientText(
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      colors: [Colors.greenAccent, Colors.greenAccent],
                      "Accept",
                    )),

                TextButton(
                    onPressed: () async {
                      await http.post(
                        Uri.parse(
                            "http://steefotmtmobile.com/steefo/approveorder.php"),
                        body: {
                          "decision": "Denied",
                          "order_id": requestList[index].order_id!
                        },
                      );
                      () {
                        // orderList.add(requestList[index]);
                        // requestList.removeAt(index);
                        id = "none";
                        requestList.removeAt(index);
                        // loadData();
                        setState(() {});
                        // Get.to(RequestPage());
                      }();
                    },
                    child: GradientText(
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      colors: [Colors.redAccent, Colors.red],
                      "Decline",
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget CompletedListBody() {
    // loadChallanList();
    // return Container(
    //     height: MediaQuery.of(context).size.height * 0.83,
    //     decoration: const BoxDecoration(
    //         // gradient:
    //         //         LinearGradient(transform: GradientRotation(1.07), colors: [
    //         //   Color.fromRGBO(75, 100, 160, 1.0),
    //         //   Color.fromRGBO(19, 59, 78, 1.0),
    //         // ]
    //         //         )
    //         ),
    //     child: SingleChildScrollView(
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Container(
    //             decoration: const BoxDecoration(
    //                 // color: Colors.grey,
    //                 // borderRadius: BorderRadius.circular(20)
    //                 ),
    //             width: MediaQuery.of(context).size.width * 0.8,
    //             margin: const EdgeInsets.only(top: 20),
    //             padding: const EdgeInsets.symmetric(horizontal: 10),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 // Text(
    //                 //   "Order Id:",
    //                 //   style: TextStyle(fontFamily: "Poppins_Bold"),
    //                 // ),
    //                 // Padding(
    //                 //   padding: EdgeInsets.only(left: 8.0),
    //                 //   child: Text(widget.order.order_id.toString()),
    //                 // )
    //               ],
    //             ),
    //           ),
    //           Card(
    //             child: Container(
    //               decoration: BoxDecoration(
    //                   color: const Color.fromRGBO(255, 255, 255, 0.5),
    //                   borderRadius: BorderRadius.circular(8)),
    //               margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
    //               child: Column(
    //                 children: [
    //                   SingleChildScrollView(
    //                     child: Container(
    //                       height: MediaQuery.of(context).size.height * 0.6,
    //                       child: ListView.builder(
    //                         itemCount: challanList.length,
    //                         //physics: const NeverScrollableScrollPhysics(),
    //                         scrollDirection: Axis.vertical,
    //                         shrinkWrap: false,
    //                         itemBuilder: (context, index) {
    //                           return InkWell(
    //                               onTap: () {
    //                                 Navigator.push(
    //                                     context,
    //                                     MaterialPageRoute(
    //                                         builder: (context) =>
    //                                             GeneratedChallan(
    //                                                 challan_id:
    //                                                     challanList[index]
    //                                                         .challan_id!)));
    //                               },
    //                               child:
    //                                   ChallanCard(context, challanList[index]));
    //                         },
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ));
    // loadData();
    // loadData1();
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              reverse: true,
              itemCount: salesOrderList.length,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                print("ordertype${salesOrderList[index].orderType}");
                if (salesOrderList[index].orderType == "Lump-sum") {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderDetails(
                                    order: salesOrderList[index],lumpsum: lumpsum,)));
                      },
                      child: completedorderCard(
                        context,
                        salesOrderList[index],
                        //  qtyandprice[index],
                        id,
                      ));
                } else
                  return Container();
              },
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

//   Widget PurchaseOrderList() {
//     return Container(
//         decoration: const BoxDecoration(
//           color: Color.fromRGBO(255, 255, 255, 0.5),
//           // borderRadius: BorderRadius.circular(5)
//         ),
//         height: 50,
//         margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               Container(
//                 child: ListView.builder(
//                   itemCount: purchaseOrderList.length,
//                   physics: const NeverScrollableScrollPhysics(),
//                   scrollDirection: Axis.vertical,
//                   shrinkWrap: true,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => OrderDetails(
//                                       order: purchaseOrderList[index])));
//                         },
//                         child:
//                             orderCard(context, purchaseOrderList[index], id));
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
}

//---------------------------------SingleOrderRequestWidget---------------------

//-------------------------------SingleRegistrationRequest----------------------

// Widget RegistrationRequestCard(context, index) {
//   String org_name = " Bhuyangdev Steel Corporation";
//   var region = ['Ahmedabad', 'Mehsana', 'Anand'];

//   return Container(
//     decoration: BoxDecoration(
//         color: Colors.white, borderRadius: BorderRadius.circular(20)),
//     padding: EdgeInsets.all(5),
//     margin: EdgeInsets.all(5),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Text("PlaceHolder"),
//         Row(
//           children: [
//             Container(
//                 child: Text(
//               "Entity Details",
//               textAlign: TextAlign.left,
//               style: TextStyle(fontFamily: "Poppins_Bold"),
//             )),
//             Container(
//                 width: MediaQuery.of(context).size.width - 200,
//                 child: IconButton(
//                     onPressed: () {},
//                     icon: Icon(
//                       Icons.thumb_up_alt_rounded,
//                       color: Colors.green,
//                     ))),
//             IconButton(
//                 onPressed: () {},
//                 icon: Icon(
//                   Icons.thumb_down_alt_rounded,
//                   color: Colors.red,
//                 ))
//           ],
//         ),
//         Container(
//           child: Row(
//             children: [
//               Container(
//                 child: Text(
//                   "Org Name:",
//                   style: TextStyle(fontFamily: "Roboto"),
//                 ),
//                 padding: EdgeInsets.symmetric(vertical: 5),
//               ),
//               Expanded(
//                   child: Text(
//                 org_name,
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 3,
//               ))
//             ],
//           ),
//         ),
//         Container(
//           child: Row(
//             children: [Text("Region:"), Text(region[index])],
//           ),
//         ),
//       ],
//     ),
//   );
// }
Widget orderCard(BuildContext context, Order order, String? curr_user_id) {
  if (order.status == 'Confirmed') {
    return Column(
      children: [
        Container(
          //  height: 130,

          // margin: EdgeInsets.only(top: 10),
          // padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey.shade100,
          ),
          child: Column(
            children: [
              Container(
                //  height: 50,
                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                // color: Colors.red,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(19, 59, 78, 1.0),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Align(alignment: Alignment.topRight,),
                        Text(
                          "ORDER ID",
                          style: TextStyle(color: Colors.grey),
                        ),

                        // SizedBox(
                        //   width: 180,
                        // ),
                        Text(
                          order.date!.substring(0,10),
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.order_id!.toUpperCase(),
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17)),
                        ),
                        Text(
                          order.date!.substring(10,19),
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 10, left: 10),
                      child: Text(
                        order.org_name!.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Color.fromRGBO(19, 59, 78, 1.0),
                          // color: Colors.grey
                        ),
                      )),

                  Container(
                      padding: EdgeInsets.only(top: 10),
                      child: LayoutBuilder(builder: (context, constraints) {
                        if (order.status == "Confirmed") {
                          return Container(
                              // width: 40,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10))),
                              child: Text(
                                order.status!,
                              ));
                        } else if (order.status == "Denied") {
                          return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10))),
                              child: Text(
                                order.status!,
                                style: TextStyle(color: Colors.white),
                              ));
                        } else {
                          return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10))),
                              child: Text(
                                order.status!,
                                style: TextStyle(color: Colors.white),
                              ));
                        }
                      })),

                  // Container(
                  //     padding: EdgeInsets.only(top: 10),
                  //     child: LayoutBuilder(builder: (context, constraints) {
                  //       if (order.status == "Confirmed") {
                  //         return Container(
                  //           // width: 40,
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: 5, vertical: 5),
                  //             decoration: BoxDecoration(
                  //                 color: Colors.greenAccent,
                  //                 borderRadius: BorderRadius.only(
                  //                     topLeft: Radius.circular(10),
                  //                     bottomLeft: Radius.circular(10))),
                  //             child: Text(
                  //               order!.status!,
                  //
                  //             ));
                  //       } else if(order.status == "Denied") {
                  //         return Container(
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: 5, vertical: 5),
                  //             decoration: BoxDecoration(
                  //                 color: Colors.redAccent,
                  //                 borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))),
                  //             child: Text(
                  //               order.status!,
                  //               style: TextStyle(
                  //                   color: Colors.white
                  //               ),
                  //             ));
                  //       } else{
                  //         return Container(
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: 5, vertical: 5),
                  //             decoration: BoxDecoration(
                  //                 color: Colors.yellow,
                  //                 borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))),
                  //             child: Text(
                  //               order.status!,
                  //               style: TextStyle(
                  //                   color: Colors.white
                  //               ),
                  //             ));
                  //       }
                  //     })),

                  // Container(
                  //   padding: EdgeInsets.only(right: 10),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text("Status:", style: TextStyle(fontFamily: "Poppins_Bold")),
                  //             Padding(
                  //               padding: const EdgeInsets.only(left: 10),
                  //               child: Text(order.status!),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  // Container(
                  //   child: Text(),
                  // )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //  Padding(padding: EdgeInsets.only(left: 10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Text(
                              "Base Price:",
                              style: TextStyle(
                                  fontFamily: "Poppins_Bold",
                                  color: Colors.grey),
                            ),
                            Text(
                              order.base_price!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                  // color: Color.fromRGBO(19, 59, 78, 1.0),
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        //  padding: EdgeInsets.only(right: 5),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Text(
                              "Trans. Type:",
                              style: TextStyle(
                                  fontFamily: "Poppins_Bold",
                                  color: Colors.grey),
                            ),
                            Text(
                              order.trans_type.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                  // color: Color.fromRGBO(19, 59, 78, 1.0),
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        //  padding: EdgeInsets.only(right: 5),
                      ),
                    ],
                  ),

                  // Container(
                  //   padding: EdgeInsets.only(left: 20),
                  //   height: 30,
                  //   child: VerticalDivider(
                  //     color: Colors.grey,
                  //     thickness: 2,
                  //     width: 2,
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        Text(
                          "Quantity:",
                          style: TextStyle(
                              fontFamily: "Poppins_Bold", color: Colors.grey),
                        ),
                        Text(
                          order.totalQuantity.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                              // color: Color.fromRGBO(19, 59, 78, 1.0),
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    //  padding: EdgeInsets.only(right: 5),
                  ),
                  // Text(
                  //   "${order.totalQuantity!.toString()}",
                  //   style: TextStyle(color: Colors.black),
                  // ),
                  // Text( tot_price )

                  // Container(
                  //   child: Text(
                  //       item.price!
                  //   ),
                  // )
                ],
              ),

              // TextButton(
              //             onPressed: () async {
              //               await http.post(
              //                 Uri.parse(
              //                     "http://urbanwebmobile.in/steffo/approveorder.php"),
              //                 body: {
              //                   "decision": "Approved",
              //                   "order_id": requestList[index].order_id!
              //                 },
              //               );
              //               () {
              //                 // orderList.add(requestList[index]);
              //                 // requestList.removeAt(index);
              //                 id = "none";
              //                 setState(() {
              //                   print('setstate');
              //                   //  loadData();
              //                 });
              //               }();
              //               // Get.to(RequestPage());
              //             },
              //             child: GradientText(
              //               style:
              //                   TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              //               colors: [Colors.greenAccent, Colors.grey],
              //               "Accept",
              //             )),

              // TextButton(
              //     onPressed: () async {
              //       await http.post(
              //         Uri.parse(
              //             "http://urbanwebmobile.in/steffo/approveorder.php"),
              //         body: {
              //           "decision": "Denied",
              //           "order_id": requestList[index].order_id!
              //         },
              //       );
              //       () {
              //         // orderList.add(requestList[index]);
              //         // requestList.removeAt(index);
              //         id = "none";
              //         loadData();
              //         setState(() {});
              //         // Get.to(RequestPage());
              //       }();
              //     },
              //     child: GradientText(
              //       style:
              //           TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              //       colors: [Colors.redAccent, Colors.grey],
              //       "Decline",
              //     ))
            ],
          ),
          // Container(
          //   child: Text("data"),
          // )

          // Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Container(
          //       padding: EdgeInsets.only(top: 5, bottom: 5),
          //       child: Text(
          //         order.user_name!.toUpperCase(),
          //         style: GoogleFonts.poppins(
          //             textStyle: TextStyle(
          //                 color: Colors.black,
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 20)),
          //       ),
          //     ),
          //     // LayoutBuilder(builder: (context, constraints) {
          //     //   if (curr_user_id == order.reciever_id) {
          //     //     return Container(
          //     //         padding:
          //     //             EdgeInsets.symmetric(horizontal: 3, vertical: 3),
          //     //         decoration: BoxDecoration(
          //     //             color: Colors.blue,
          //     //             borderRadius: BorderRadius.circular(20)),
          //     //         child: Text(
          //     //           "Sales",
          //     //         ));
          //     //   } else {
          //     //     return Container(
          //     //         padding:
          //     //             EdgeInsets.symmetric(horizontal: 3, vertical: 3),
          //     //         decoration: BoxDecoration(
          //     //             color: Colors.green,
          //     //             borderRadius: BorderRadius.circular(20)),
          //     //         child: Text("Purchase"));
          //     //   }
          //     // })
          //     Divider(
          //       color: Colors.greenAccent,
          //     ),
          //
          //     Container(
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Container(
          //             child: Text(
          //               "Org Name:",
          //               style: TextStyle(fontFamily: "Poppins_Bold"),
          //             ),
          //             padding: EdgeInsets.only(bottom: 5, right: 5),
          //           ),
          //           Text(
          //             order.party_name!,
          //             overflow: TextOverflow.ellipsis,
          //             maxLines: 3,
          //           )
          //         ],
          //       ),
          //     ),
          //     Container(
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text("Status:", style: TextStyle(fontFamily: "Poppins_Bold")),
          //           Padding(
          //             padding: const EdgeInsets.only(left: 35.0),
          //             child: Text(order.status!),
          //           )
          //         ],
          //       ),
          //     ),
          //     Container(
          //       padding: EdgeInsets.symmetric(vertical: 5),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text("Order Date: ",
          //               style: TextStyle(fontFamily: "Poppins_Bold")),
          //           Text(order.order_date!.substring(0, 10))
          //         ],
          //       ),
          //     )
          //   ],
          // ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  } else
    return Container();
}
