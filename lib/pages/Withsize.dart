import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:stefomobileapp/Models/item.dart';
import 'package:stefomobileapp/pages/HomePage.dart';
import '../Models/challan.dart';
import '../Models/order.dart';
import '../ui/common.dart';
import '../ui/cards.dart';
import '../ui/custom_tabbar.dart';
import 'GenerateChallanPage.dart';
import 'GeneratedChallanPage.dart';
import 'OrderPage.dart';

class OrdersPage extends StatelessWidget {
  final Order order;
  OrdersPage({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    return OrdersContent(order: order);
    //  throw UnimplementedError();
  }
}

class OrdersContent extends StatefulWidget {
  final Order order;
  const OrdersContent({super.key, required this.order});
  final selected = 0;
  @override
  State<OrdersContent> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersContent> {
  List<Item> qtyandprice = [];
  loadDatafortotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    print(widget.order.orderType);
    print(widget.order.loading_type);
    print(widget.order.trans_type);
    print(widget.order.order_id);

    if (widget.order.orderType != "Lump-sum" &&
        widget.order.orderType == "With Size") {
      print(widget.order.order_id);
      final res = await http.post(
        Uri.parse("http://urbanwebmobile.in/steffo/getorderdetails.php"),
        body: {
          "order_id": widget.order.order_id,
        },
      );
      var responseData1 = jsonDecode(res.body);
      for (int i = 0; i < responseData1["data"].length; i++) {
        Item i = Item();

        i.name = responseData1['data'][i]['id'];
        i.price = responseData1['data'][i]['price'];
        i.qty = responseData1['data'][i]['qty'];
        qtyandprice.add(i);
      }
      print(qtyandprice);

      // flag = 1;
      setState(() {});
    }
  }

  int flag = 0;
  String? id;
  String? userType;
  List<Challan> challanList = [];
  // loadChallanList() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   id = await prefs.getString('id');
  //   if (flag == 0) {
  //     final res = await http.post(
  //       Uri.parse("http://urbanwebmobile.in/steffo/getchallanlist.php"),
  //       body: {"order_id": widget.order.order_id},
  //     );
  //     var responseData = jsonDecode(res.body);
  //     print(responseData);

  //     for (int i = 0; i < responseData["data"].length; i++) {
  //       Challan ch = Challan();
  //       ch.order_id = responseData["data"][i]["order_id"];
  //       ch.challan_id = responseData["data"][i]["challan_id"].toString();
  //       ch.transporter_name = responseData["data"][i]["transporter_name"];
  //       ch.vehicle_number = responseData["data"][i]["vehicle_number"];
  //       ch.lr_number = responseData["data"][i]["lr_number"];
  //       challanList.add(ch);
  //     }
  //     flag = 1;
  //     setState(() {});
  //   }
  // }

  @override
  void initState() {
    super.initState();
    //loadDatafortotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar("Specific", () {
        Get.to(HomePage());
      }),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: CustomTabBar(
            selectedCardColor: Colors.blueGrey,
            selectedTitleColor: Colors.white,
            unSelectedTitleColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            unSelectedCardColor: Colors.white,
            titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tabBarItemExtend: ((MediaQuery.of(context).size.width) / 3),
            // tabBarItems: ["Orders", "Requests"],
            tabBarItems: [
              "Requests",
              " Confirmed Orders",
              "Completed"
            ],
            // tabViewItems: [OrdersPageBody(), OrderList1()]
            tabViewItems: [
              Container(child: OrderList1()),
              Container(child: ConfirmedOrders()),
              Container(child: CompletedListBody())
            ]),
      ),
    );
  }

  // String? id = "";

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
      print(responseData);

      for (int i = 0; i < responseData["data"].length; i++) {
        Order req = Order();
        req.deliveryDate = responseData["data"][i]["deliveryDate"];
        req.totalPrice = responseData["data"][i]["totalPrice"];
        req.totalQuantity = responseData["data"][i]["totalQuantity"];
        req.reciever_id = responseData["data"][i]["supplier_id"];
        req.user_id = responseData["data"][i]["user_id"];
        req.user_mob_num = responseData["data"][i]["mobileNumber"];
        req.org_name = responseData["data"][i]["orgName"];
        req.user_name = responseData["data"][i]["firstName"] +
            " " +
            responseData["data"][i]["lastName"];

        req.status = responseData["data"][i]["orderStatus"];
        req.party_name = responseData["data"][i]["partyName"];
        req.party_address = responseData["data"][i]["shippingAddress"];
        req.pincode = responseData["data"][i]["pincode"];
        req.billing_address = responseData["data"][i]["address"];
        req.party_mob_num = responseData["data"][i]["partyMobileNumber"];
        req.loading_type = responseData["data"][i]["loadingType"];
        req.trans_type = responseData["data"][i]["transType"];
        req.order_date = responseData["data"][i]["createdAt"];
        req.base_price = responseData["data"][i]["basePrice"];
        req.orderType = responseData["data"][i]["orderType"];
        req.order_id = responseData["data"][i]["order_id"].toString();
        req.date = responseData["data"][i]["dateTime"].toString();
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
  // String? userType;

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
        req.deliveryDate = responseData["data"][i]["deliveryDate"];
        req.totalPrice = responseData["data"][i]["totalPrice"];
        req.totalQuantity = responseData["data"][i]["totalQuantity"];
        req.orderType = responseData["data"][i]["orderType"];
        req.reciever_id = responseData["data"][i]["supplier_id"];
        req.user_id = responseData["data"][i]["user_id"];
        req.user_mob_num = responseData["data"][i]["mobileNumber"];
        req.org_name = responseData["data"][i]["orgName"];
        req.user_name = responseData["data"][i]["firstName"] +
            " " +
            responseData["data"][i]["lastName"];
        req.status = responseData["data"][i]["orderStatus"];
        req.party_name = responseData["data"][i]["partyName"];
        req.party_address = responseData["data"][i]["shippingAddress"];
        req.pincode = responseData["data"][i]["pincode"];
        req.billing_address = responseData["data"][i]["address"];
        req.party_mob_num = responseData["data"][i]["partyMobileNumber"];
        req.loading_type = responseData["data"][i]["loadingType"];
        req.trans_type = responseData["data"][i]["transType"];
        req.order_date = responseData["data"][i]["createdAt"];
        req.base_price = responseData["data"][i]["basePrice"];
        req.order_id = responseData["data"][i]["order_id"].toString();
        req.date = responseData["data"][i]["dateTime"];
        if (req.status?.trim() == "Pending" && id1 == req.reciever_id) {
          print(req.loading_type);
          print(req.trans_type);
          requestList.add(req);
        }
      }
      setState(() {});
      print(requestList.length);
    }
  }

  Widget ConfirmedOrders() {
    //loadDatafortotal();
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
                if (salesOrderList[index].orderType == "With Size") {
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
                if (salesOrderList[index].orderType == "With Size") {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderDetails(
                                    order: salesOrderList[index])));
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

  // Widget ChallanCard(context, Challan challan) {
  //   String trp_name = "XY Transporter";

  //   return Card(
  //     child: Container(
  //       decoration: BoxDecoration(
  //           // color: Colors.white, borderRadius: BorderRadius.circular(20)
  //           ),
  //       padding: EdgeInsets.all(5),
  //       margin: EdgeInsets.all(5),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Container(
  //                   child: const Text(
  //                 "Challan ID:",
  //                 textAlign: TextAlign.left,
  //                 style: TextStyle(fontFamily: "Poppins_Bold"),
  //               )),
  //               Container(
  //                   padding: EdgeInsets.only(left: 65),
  //                   child: Text(
  //                     challan.challan_id!.toString(),
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(fontFamily: "Poppins_Bold"),
  //                   ))
  //             ],
  //           ),
  //           Container(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Container(
  //                   child: Text(
  //                     "Transporter Name:",
  //                     style: TextStyle(fontFamily: "Roboto"),
  //                   ),
  //                   padding: EdgeInsets.only(top: 5, bottom: 5),
  //                 ),
  //                 Container(
  //                   child: Text(
  //                     challan.transporter_name!,
  //                     overflow: TextOverflow.ellipsis,
  //                     maxLines: 3,
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //           Container(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text("Vehicle Number:"),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 36.0),
  //                   child: Text(challan.vehicle_number!),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget ComplatedOrders(){
  //   return Padding(
  //       padding: EdgeInsets.only(left: 5,right: 7),
  //     child: Container(
  //       color: Colors.grey,
  //       // height: 10,
  //       child: Text("data") ,
  //     ),
  //
  //   );
  //
  // }

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
                print("ordertype${requestList[index].orderType}");
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetails(order: requestList[index])));
                    },
                    child: requestList[index].orderType == "With Size"
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
                            requestList[index].date!,
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

            Container(
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
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              requestList[index].base_price!,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "TotalPrice:",
                              style: TextStyle(
                                  fontFamily: "Poppins_Bold",
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              requestList[index].totalPrice.toString(),
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Padding(padding: EdgeInsets.only(right: 5)),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          "Quantity:",
                          style: TextStyle(
                              fontFamily: "Poppins_Bold", color: Colors.grey),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          requestList[index].totalQuantity.toString(),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
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
                        requestList.removeAt(index);
                        id = "none";
                        setState(() {
                          print('setstate');
                          loadData();
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
                        requestList.removeAt(index);
                        id = "none";
                        loadData();
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

// Widget orderwidget1(int index) {
//   return Center(
//     // padding: const EdgeInsets.only(left: 10, right: 1),
//     child: Container(
//         decoration: const BoxDecoration(
//           color: Color.fromRGBO(255, 255, 255, 0.5),
//           // borderRadius: BorderRadius.circular(8)
//         ),
//         //  height: 50,
//         //  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
//         padding: EdgeInsets.only(left: 10, right: 10),
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               Container(
//                 child: ListView.builder(
//                   itemCount: salesOrderList.length,
//                   physics: const NeverScrollableScrollPhysics(),
//                   scrollDirection: Axis.vertical,
//                   shrinkWrap: true,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => OrderDetails(
//                                       order: salesOrderList[index])));
//                         },
//                         child: orderCard(
//                           context,
//                           salesOrderList[index],
//                           id,
//                         )
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//             ],
//           ),
//         )),
//
//     // Container(
//     //   margin: EdgeInsets.only(top: 10),
//     //   padding: const EdgeInsets.all(8.0),
//     //   decoration: BoxDecoration(
//     //     borderRadius: BorderRadius.circular(10.0),
//     //     color: Colors.grey.shade100,
//     //   ),
//     //   child: Column(
//     //     mainAxisAlignment: MainAxisAlignment.start,
//     //     children: [
//     //       SizedBox(
//     //         height: 5,
//     //       ),
//     //       Text(
//     //         requestList[index].user_name!.toUpperCase(),
//     //         overflow: TextOverflow.ellipsis,
//     //         maxLines: 3,
//     //         style: GoogleFonts.poppins(
//     //           fontSize: 20,
//     //           fontWeight: FontWeight.bold,
//     //         ),
//     //       ),
//     //       SizedBox(
//     //         height: 5,
//     //       ),
//     //       Divider(color: Colors.orangeAccent),
//     //       Container(
//     //         child: Row(
//     //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //           children: [
//     //             Container(
//     //               child: Text(
//     //                 "Organization Name:",
//     //                 style: TextStyle(fontFamily: "Poppins_Bold"),
//     //               ),
//     //               padding: EdgeInsets.symmetric(vertical: 5),
//     //             ),
//     //             Text(
//     //               requestList[index].party_name!,
//     //               overflow: TextOverflow.ellipsis,
//     //               maxLines: 3,
//     //             )
//     //           ],
//     //         ),
//     //       ),
//     //       Container(
//     //         child: Row(
//     //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //           children: [
//     //             Text(
//     //               "Order Date:",
//     //               style: TextStyle(fontFamily: "Poppins_Bold"),
//     //             ),
//     //             Text(requestList[index].order_date!.substring(0, 10))
//     //           ],
//     //         ),
//     //       ),
//     //       Container(
//     //         padding: EdgeInsets.symmetric(vertical: 5),
//     //         child: Row(
//     //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //           children: [
//     //             Text(
//     //               "Base Price:",
//     //               style: TextStyle(fontFamily: "Poppins_Bold"),
//     //             ),
//     //             Text(requestList[index].base_price!)
//     //           ],
//     //         ),
//     //       ),
//     //       Row(
//     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //         children: [
//     //           // Container(
//     //           //     child: const Text(
//     //           //   "Order Details",
//     //           //   textAlign: TextAlign.left,
//     //           //   style: TextStyle(fontFamily: "Poppins_Bold"),
//     //           // )),
//     //           TextButton(
//     //               onPressed: () async {
//     //                 await http.post(
//     //                   Uri.parse(
//     //                       "http://urbanwebmobile.in/steffo/approveorder.php"),
//     //                   body: {
//     //                     "decision": "Approved",
//     //                     "order_id": requestList[index].order_id!
//     //                   },
//     //                 );
//     //
//     //                 () {
//     //                   // orderList.add(requestList[index]);
//     //                   // requestList.removeAt(index);
//     //                   id = "none";
//     //
//     //                   setState(() {
//     //                     print('setstate');
//     //                     //  loadData();
//     //                   });
//     //                 }();
//     //                 // Get.to(RequestPage());
//     //               },
//     //               child: GradientText(
//     //                 style:
//     //                     TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//     //                 colors: [Colors.greenAccent, Colors.grey],
//     //                 "Accept",
//     //               )),
//     //
//     //           TextButton(
//     //               onPressed: () async {
//     //                 await http.post(
//     //                   Uri.parse(
//     //                       "http://urbanwebmobile.in/steffo/approveorder.php"),
//     //                   body: {
//     //                     "decision": "Denied",
//     //                     "order_id": requestList[index].order_id!
//     //                   },
//     //                 );
//     //                 () {
//     //                   // orderList.add(requestList[index]);
//     //                   // requestList.removeAt(index);
//     //                   id = "none";
//     //                   loadData();
//     //                   setState(() {});
//     //                   // Get.to(RequestPage());
//     //                 }();
//     //               },
//     //               child: GradientText(
//     //                 style:
//     //                     TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//     //                 colors: [Colors.redAccent, Colors.grey],
//     //                 "Decline",
//     //               ))
//     //         ],
//     //       ),
//     //     ],
//     //   ),
//     // ),
//   );
// }

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
                          order.date!,
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          order.order_id!.toUpperCase(),
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
                        } else {
                          return Container();
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
                              "Total Price:",
                              style: TextStyle(
                                  fontFamily: "Poppins_Bold",
                                  color: Colors.grey),
                            ),
                            Text(
                              order.totalPrice.toString(),
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

Widget completedorderCard(
    BuildContext context, Order order, String? curr_user_id) {
  if (order.status == 'Canceled' ||
      order.status == 'Denied' ||
      order.status == 'Completed') {
    return Column(
      children: [
        Container(
          // height: 130,

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
                          order.date!,
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          order.order_id!.toUpperCase(),
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
                        if (order.status == "Completed") {
                          return Container(
                              // width: 40,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10))),
                              child: Text(
                                order.status!,
                                style: TextStyle(color: Colors.white),
                              ));
                        } else if (order.status == "Denied") {
                          return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10))),
                              child: Text(
                                order.status!,
                                style: TextStyle(color: Colors.white),
                              ));
                        } else if (order.status == "Canceled") {
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
                                style: TextStyle(color: Colors.black),
                              ));
                        } else {
                          return Container();
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
                              "Total Price:",
                              style: TextStyle(
                                  fontFamily: "Poppins_Bold",
                                  color: Colors.grey),
                            ),
                            Text(
                              order.totalPrice.toString(),
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
