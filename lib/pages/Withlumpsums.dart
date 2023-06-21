import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:stefomobileapp/pages/HomePage.dart';

import '../Models/order.dart';
import '../ui/common.dart';
import '../ui/cards.dart';
import '../ui/custom_tabbar.dart';
import 'OrderPage.dart';

class lumpsumsOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OrdersContent();
    //  throw UnimplementedError();
  }
}

class OrdersContent extends StatefulWidget {
  const OrdersContent({super.key});
  final selected = 0;
  @override
  State<OrdersContent> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersContent> {
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
            titleStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tabBarItemExtend: ((MediaQuery.of(context).size.width) / 2),
            tabBarItems: [
              "Requests",
              "Orders"
            ],
            tabViewItems: [
              Container(child: OrderList1()),
              Container(child: OrdersPageBody())
            ]),
      ),
    );
  }

  String? id = "";

  List<Order> salesOrderList = [];
  List<Order> purchaseOrderList = [];

  Future<void> loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var m = id;
    id = await prefs.getString('id');
    print("sss" + "${id}");

    if (m != id) {
      final res = await http.post(
        Uri.parse("http://urbanwebmobile.in/steffo/vieworder.php"),
        body: {"id": id!},
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
        Uri.parse("http://urbanwebmobile.in/steffo/vieworder.php"),
        body: {"id": id1!},
      );
      var responseData = jsonDecode(res.body);
      print(responseData);

      for (int i = 0; i < responseData["data"].length; i++) {
        Order req = Order();
        req.orderType = responseData["data"][i]["orderType"];
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
        req.order_id = responseData["data"][i]["order_id"].toString();
        if (req.status?.trim() == "Pending" && id1 == req.reciever_id) {
          print(req.loading_type);
          requestList.add(req);
        }
      }
      setState(() {});
      print(requestList.length);
    }
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
                                    order: salesOrderList[index])));
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
                                  OrderDetails(order: requestList[index])));
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
                            requestList[index].order_date!.substring(0, 10),
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            requestList[index].order_id!,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17)),
                          ),
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
                requestList[index].user_name!.toUpperCase(),
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

            Container(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Base Price:",
                    style: TextStyle(
                        fontFamily: "Poppins_Bold", color: Colors.grey),
                  ),
                  Padding(padding: EdgeInsets.only(right: 5)),
                  Text(requestList[index].base_price!)
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
                            "http://urbanwebmobile.in/steffo/approveorder.php"),
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
                            "http://urbanwebmobile.in/steffo/approveorder.php"),
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
