import 'dart:convert';
import 'dart:core';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:stefomobileapp/pages/ChallanListPage.dart';
import '../Models/lumpsum.dart';
import '../Models/order.dart';
import '../Models/user.dart';
import '../ui/cards.dart';
import '../ui/common.dart';
import 'HomePage.dart';
// import 'package:pdf/widgets.dart' as pw;

// ignore: must_be_immutable
class OrderDetails extends StatelessWidget {
  Order order;
  Lumpsum lumpsum;
  OrderDetails({super.key, required this.order, required this.lumpsum});
  @override
  Widget build(BuildContext context) {
    return OrderPage(order: order, lumpsum: lumpsum);
  }
}

class OrderPage extends StatefulWidget {
  OrderPage({Key? key, this.order, this.lumpsum}) : super(key: key);
  final Order? order;
  final Lumpsum? lumpsum;
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? token1;

  void firebaseCloudMessaging_Listeners(){
    _firebaseMessaging.getToken().then((token){
      print("token is"+ token!);
      // token1 = token;
      token = token1;
      setState(() {});
    }
    );
  }




  String? id, supplier_id;
  // orderId,
  // name,
  // qty,
  // qty_left,
  // basePrice,
  // price;

  List<Lumpsum> lumpsumList = [];
  bool isInventoryDataLoaded = false;
  // loadData() async {
  //   print("inLoadLumpsumData");
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final user_id = await prefs.getString('id');
  //   print('${user_id}ddddd');
  //
  //   var res = await http.post(
  //       Uri.parse("http://urbanwebmobile.in/steffo/getinventory.php"),
  //       body: {
  //         "user_id": user_id,
  //       });
  //   var responseData = jsonDecode(res.body);
  //   /// var orders = [];
  //   print("lumpsumlist${responseData}");
  //   for (int i = 0; i < responseData["data"].length; i++) {
  //     print(responseData['data'][i]['name']);
  //     Lumpsum l = Lumpsum();
  //     l.partyname = responseData["data"][i]["partyName"];
  //     l.orderId = responseData["data"][i]["order_id"];
  //     l.name = responseData["data"][i]["name"];
  //     l.basePrice = responseData["data"][i]["basePrice"];
  //     l.qty_left = responseData["data"][i]["qty_left"];
  //     l.price = responseData["data"][i]["price"];
  //     l.status = responseData["data"][i]["orderStatus"];
  //     l.id = responseData['data'][i]["ls_id"];
  //     l.date = responseData["data"][i]["createdAt"];
  //     lumpsumList.add(l);
  //   }
  //   isInventoryDataLoaded = true;
  //   setState(() {});
  // }

  // Lumpsum get lumpsum => Lumpsum();
  User user = User();

  bool isDataLoaded = false;
  // Lumpsum lumpsum = Lumpsum();
  int flag = 0;
  var listOfColumns = [];
  var listOfColumns1 = [];
  var remaininglist = [];
  // var id;
  var f = 0;
  num tot_price = 0;
  double tot_qty = 0;

  var reductionData = [];
  Future onClick() async{
    if (widget.order?.orderType == "Use Lumpsum") {
      for (int i = 0; i < reductionData.length; i++) {
        var res = await http.post(
            Uri.parse("http://steefotmtmobile.com/steefo/updateinventory.php"),
            body: {
              "id": reductionData[i]["id"],
              "qty": reductionData[i]["qty"]
            });
      }
    }
  }

  var m;

  Future<void> loadData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final user_id = await pref.getString('id');
    m = user_id;
    print('${user_id}ddddd');

    if (m != id){
    final res1 = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/getinventory.php"),
        body: {
          "user_id": user_id,
        });
    var responseData1 = jsonDecode(res1.body);

    /// var orders = [];
    print("lumpsumlist${responseData1}");
    for (int i = 0; i < responseData1["data"].length; i++) {
      print(responseData1['data'][i]['name']);
      print(responseData1['data'][i]['qty_left']);
      // print("order id"+ lumpsum.order_id.toString());
      Lumpsum l = Lumpsum();
      l.partyname = responseData1["data"][i]["partyName"];
      l.order_id = responseData1["data"][i]["order_id"];
      l.name = responseData1["data"][i]["name"];
      l.basePrice = responseData1["data"][i]["basePrice"];
      l.qty = responseData1["data"][i]["qty"];
      l.qty_left = responseData1["data"][i]["qty_left"];
      l.price = responseData1["data"][i]["price"];
      l.status = responseData1["data"][i]["orderStatus"];
      l.ls_id = responseData1['data'][i]["ls_id"];
      l.date = responseData1["data"][i]["createdAt"];
      lumpsumList.add(l);
    }

    if (flag == 0) {
      if (widget.order!.orderType != "Lump-sum") {
        print('insize');
        final res3 = await http.post(
          Uri.parse("http://steefotmtmobile.com/steefo/getorderdetails.php"),
          body: {
            "order_id": widget.order!.order_id,
            // "qty_left": widget.order!.qty_left,
            // "id": widget.order!.id,
          },
        );
        var responseData3 = jsonDecode(res3.body);
        // print(
        //     "dddddddddddddddddddddddddddddddddddddddddddddddddddddddd${responseData}");
        //print(responseData);
        listOfColumns = [];
        listOfColumns1 = [];

        for (int i = 0; i < responseData3["data"].length; i++) {
          listOfColumns.add({
            "Sr_no": (i + 1).toString(),
            "Name": responseData3["data"][i]["name"],
            "Qty": responseData3["data"][i]["qty"],
            "Price": responseData3["data"][i]["price"]
          });
          tot_price = tot_price + int.parse(responseData3["data"][i]["price"]);
          tot_qty = tot_qty + double.parse(responseData3["data"][i]["qty"]);
          listOfColumns1.add({
            "Sr_no": (i + 1).toString(),
            "Name": responseData3["data"][i]["name"],
            "Qty": responseData3["data"][i]["qty"],
            "Price": responseData3["data"][i]["price"]

          });
          print("Specific Order  ${listOfColumns}");
        }
        listOfColumns.add({
          "Sr_no": " ",
          "Name": "Total:",
          "Qty": tot_qty.toString(),
          "Price": tot_price.toString()
          // NumberFormat.simpleCurrency(locale: 'hi-IN', decimalDigits: 2)
          //     .format(int.parse(tot_price.toString())),
        });
      } else {
        print("inlumpsum");
        final res = await http.post(
          Uri.parse("http://steefotmtmobile.com/steefo/getlumpsumorder.php"),
          body: {
            // "qty_left" : responseData["data"][i]["qty_left"],
            "order_id": widget.order?.order_id,
          },
        );
        var responseData = jsonDecode(res.body);
        // print("ddddddddddd");
        listOfColumns = [];
        for (int i = 0; i < responseData["data"].length; i++) {
          listOfColumns.add({
            "Sr_no": (i + 1).toString(),
            "Name": responseData["data"][i]["name"],
            "Qty": responseData["data"][i]["qty"],
            "Price": responseData["data"][i]["price"]
          });
          tot_price = tot_price + int.parse(responseData["data"][i]["price"]);
          tot_qty = tot_qty + int.parse(responseData["data"][i]["qty"]);
        }
        listOfColumns.add({
          "Sr_no": " ",
          "Name": "Total: ",
          "Qty": tot_qty.toString(),
          "Price": tot_price.toString()
          // NumberFormat.simpleCurrency(locale: 'hi-IN', decimalDigits: 2)
          //     .format(int.parse(tot_price.toString())),
        });

        //-------------------- remaining quantity list --------------------//

        remaininglist = [];
        final res1 = await http.post(
          Uri.parse("http://steefotmtmobile.com/steefo/getlumpsumorder.php"),
          body: {
            // "qty_left" : responseData["data"][i]["qty_left"],
            "order_id": widget.order?.order_id,
          },
        );
        var responseData2 = jsonDecode(res1.body);
        // print("ddddddddddd");
        remaininglist = [];
        for (int i = 0; i < responseData2["data"].length; i++) {
          remaininglist.add({
            "Sr_no": (i + 1).toString(),
            "Name": responseData2["data"][i]["name"],
            "Qty": responseData2["data"][i]["qty_left"],
            // "Price": responseData["data"][i]["price"]
          });
          // tot_price = tot_price + int.parse(responseData["data"][i]["price"]);
          // tot_qty = tot_qty + int.parse(responseData["data"][i]["qty"]);
        }
        remaininglist.add({
          "Sr_no": " ",
          "Name": " ",
          "Qty": " ",
          // "Price": tot_price.toString()
          // NumberFormat.simpleCurrency(locale: 'hi-IN', decimalDigits: 2)
          //     .format(int.parse(tot_price.toString())),
        });
      }
      // print(
      //   NumberFormat.simpleCurrency(locale: 'hi-IN', decimalDigits: 2)
      //       .format(int.parse(tot_price.toString())),
      // );

      setState(() {});
      flag = 1;
      print("Specific Order items ${listOfColumns}");
      // print('usertype' + widget.order!.userType.toString());
      // print('usertype =======>>>>>' + user.userType.toString());
      // // print(lumpsum.qty_left);
      // print(widget.lumpsum?.order_id.toString());
      //  print("${widget.order!.order_id.toString()}order id");
    }


    if (f == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      user.id = await prefs.getString('id');
      user.firstName = await prefs.getString('firstName');
      user.lastName = await prefs.getString("lastName");
      user.email = await prefs.getString("email");
      user.mobileNumber = await prefs.getString("mobileNumber");
      user.orgName = await prefs.getString("orgName");
      user.gstNumber = await prefs.getString("gstNumber");
      user.panNumber = await prefs.getString("panNumber");
      user.adhNumber = await prefs.getString("adhNumber");
      user.address = await prefs.getString("address");
      user.userType = await prefs.getString("userType");

      print("user type" + user.userType.toString());
      f = 1;
      isDataLoaded = true;
      setState(() {});
    }
    //
    // print("${widget.order!.order_id.toString()}");
    // print("${widget.order!.orderType.toString()}");
    // print("${widget.order!.trans_type.toString()}");
    // print("usertype" + widget.order!.user_type.toString());
    // print("remaining qty" + widget.lumpsum!.qty_left.toString());

    print("inLoadLumpsumData");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    supplier_id = await prefs.getString('parentId');
    var reductionData = [];
    // print(widget.order!.orderType);
    // print(widget.order!.trans_type);
    // print(widget.order!.loading_type);

    final res = await http.post(
      Uri.parse("http://steefotmtmobile.com/steefo/vieworder.php"),
      body: {"id": id!},
    );
    var responseData = jsonDecode(res.body);
    // print(responseData);
    for (int i = 0; i < responseData["data"].length; i++) {
      Order req = Order();
      req.deliveryDate = responseData["data"][i]["deliveryDate"];
      req.totalPrice = responseData["data"][i]["totalPrice"];
      req.totalQuantity = responseData["data"][i]["totalQuantity"];
      req.orderType = responseData["data"][i]["orderType"];
      req.orderStatus = responseData["data"][i]["orderStatus"];
      req.reciever_id = responseData["data"][i]["supplier_id"];
      req.user_id = responseData["data"][i]["user_id"];
      req.orderid = responseData["data"][i]["orderid"];
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
      req.PartygstNumber = responseData["data"][i]["PartygstNumber"];
      req.gstNumber = responseData["data"][i]["gstNumber"];
      req.party_address = responseData["data"][i]["shippingAddress"];
      req.pincode = responseData["data"][i]["pincode"];
      req.billing_address = responseData["data"][i]["address"];
      req.party_mob_num = responseData["data"][i]["partyMobileNumber"];
      req.loading_type = responseData["data"][i]["loadingType"];
      req.region = responseData["data"][i]["region"];
      req.qty_left = responseData["data"][i]["qty_left"];
      req.trans_type = responseData["data"][i]["transType"];
      req.trailerType = responseData["data"][i]["trailerType"];
      req.order_date = responseData["data"][i]["createdAt"];
      req.base_price = responseData["data"][i]["basePrice"];
      req.order_id = responseData["data"][i]["order_id"].toString();
      req.date = responseData["data"][i]["dateTime"];
      if (req.status?.trim() == "Pending" && id == req.reciever_id) {
        // print(req.loading_type);
        // print(req.trans_type);
        // requestList.add(req);
      }
    }


    // setState(() {});


    // if (f == 0) {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   lumpsum.ls_id = await prefs.getString('ls_id');
    //   lumpsum.order_id = await prefs.getString('order_id');
    //   lumpsum.name = await prefs.getString("name");
    //   lumpsum.qty = await prefs.getString("qty");
    //   lumpsum.qty_left = await prefs.getString("qty_left");
    //   lumpsum.basePrice = await prefs.getString("basePrice");
    //   lumpsum.price = await prefs.getString("price");
    //   // user.orgName = await prefs.getString("orgName");
    //   // user.gstNumber = await prefs.getString("gstNumber");
    //   // user.panNumber = await prefs.getString("panNumber");
    //   // user.adhNumber = await prefs.getString("adhNumber");
    //   // user.address = await prefs.getString("address");
    //   f = 1;
    //   // isDataLoaded = true;
    //   setState(() {});
    // }

    // final res = await http.post(
    //   Uri.parse("http://steefotmtmobile.com/steefo/getlumpsumorder.php"),
    //   // body: {"order_id": orderId},
    // );
    // var responseData = jsonDecode(res.body);
    // print(responseData);
    // print(lumpsum.id);
    // for (int i = 0; i < responseData["data"].length; i++) {
    //   Lumpsum req = Lumpsum();
    //   req.id = responseData["data"][i]["ls_id"];
    //   req.orderId = responseData["data"][i]["order_id"];
    //   req.name = responseData["data"][i]["name"];
    //   req.qty = responseData["data"][i]["qty"];
    //   req.qty_left = responseData["data"][i]["qty_left"];
    //   req.basePrice = responseData["data"][i]["basePrice"];
    //   req.price = responseData["data"][i]["price"];
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
    setState(() {});
  }
  }

  // void initState() {
  //   loadData();
  //   super.initState();
  // }

  @override
  Widget build(
    BuildContext context,
  ) {
    loadData();
    //  print("orderpage${widget.order!.items.toString()}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar("Order", () {
        Navigator.pop(context);
      }),
      body: Container(
        // decoration: const BoxDecoration(),
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width - 10,
                  child: Column(children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Color.fromRGBO(19, 59, 78, 1.0),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  widget.order!.org_name
                                      .toString()
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Poppins_bold",
                                      color: Colors.white)),
                              Text(
                                  widget.order!.order_id
                                      .toString()
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Poppins_bold",
                                      color: Colors.white)),
                            ],
                          ),
                          Row(
                            children: [
                              Text("GST No. ",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Poppins_bold",
                                      color: Colors.white)),
                              Text(widget.order!.gstNumber.toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      // fontFamily: "Poppins_bold",
                                      color: Colors.white)),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (widget.order!.user_type == "Dealer") {
                          return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Dealer Name:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Poppins_Bold")),
                                  Text(widget.order!.dealerName.toString(),
                                      style: const TextStyle(
                                          fontSize: 15, fontFamily: "Poppins"))
                                ],
                              ));
                        } else {
                          return Container();
                        }
                      },
                      // child: Container(
                      //     padding: const EdgeInsets.all(10),
                      //     decoration: BoxDecoration(
                      //       // borderRadius: BorderRadius.circular(10),
                      //       color: Colors.white,
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         const Text("Party Name:",
                      //             style: TextStyle(
                      //                 fontSize: 15,
                      //                 fontFamily: "Poppins_Bold")),
                      //         Text(widget.order!.party_name.toString(),
                      //             style: const TextStyle(
                      //                 fontSize: 15, fontFamily: "Poppins"))
                      //       ],
                      //     )
                      // ),
                    ),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (user.userType != "Distributor") {
                          return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Dealer Name:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Poppins_Bold")),
                                  Text(widget.order!.dealerName.toString(),
                                      style: const TextStyle(
                                          fontSize: 15, fontFamily: "Poppins"))
                                ],
                              ));
                        } else {
                          return Container();
                        }
                      },
                    ),

                    // LayoutBuilder(
                    //   builder: (context, constraints) {
                    //     if (widget.order?.user_type == "Distributor") {
                    //       return Container(
                    //           padding: const EdgeInsets.all(10),
                    //           decoration: BoxDecoration(
                    //             // borderRadius: BorderRadius.circular(10),
                    //             color: Colors.white,
                    //           ),
                    //           child: Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               const Text("Party Name:",
                    //                   style: TextStyle(
                    //                       fontSize: 15,
                    //                       fontFamily: "Poppins_Bold")),
                    //               Text(widget.order!.party_name.toString(),
                    //                   style: const TextStyle(
                    //                       fontSize: 15, fontFamily: "Poppins"))
                    //             ],
                    //           ));
                    //     } else {
                    //       return Container();
                    //     }
                    //   },
                    //   // child: Container(
                    //   //     padding: const EdgeInsets.all(10),
                    //   //     decoration: BoxDecoration(
                    //   //       // borderRadius: BorderRadius.circular(10),
                    //   //       color: Colors.white,
                    //   //     ),
                    //   //     child: Row(
                    //   //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   //       children: [
                    //   //         const Text("Party Name:",
                    //   //             style: TextStyle(
                    //   //                 fontSize: 15,
                    //   //                 fontFamily: "Poppins_Bold")),
                    //   //         Text(widget.order!.party_name.toString(),
                    //   //             style: const TextStyle(
                    //   //                 fontSize: 15, fontFamily: "Poppins"))
                    //   //       ],
                    //   //     )
                    //   // ),
                    // ),

                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Consignee Name:",
                                style: TextStyle(
                                    fontSize: 15, fontFamily: "Poppins_Bold")),
                            Text(widget.order!.consignee_name.toString(),
                                style: const TextStyle(
                                    fontSize: 15, fontFamily: "Poppins"))
                          ],
                        )
                    ),

                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Contact:",
                                style: TextStyle(
                                    fontSize: 15, fontFamily: "Poppins_Bold")),
                            Text(widget.order!.party_mob_num.toString(),
                                style: const TextStyle(
                                    fontSize: 15, fontFamily: "Poppins"))
                          ],
                        )),

                    // Container(
                    //   padding: const EdgeInsets.all(10),
                    //   decoration: const BoxDecoration(
                    //     // borderRadius: BorderRadius.circular(20),
                    //     color: Colors.white,
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       Row(
                    //         children: const [
                    //           Text("Party Name",
                    //               style: TextStyle(
                    //                   fontSize: 15,
                    //                   fontFamily: "Poppins_Bold")),
                    //         ],
                    //       ),
                    //       Row(
                    //         children: [
                    //           Flexible(
                    //             child: Text(widget.order!.party_name!,
                    //                 style: const TextStyle(
                    //                   fontSize: 15,
                    //                   fontFamily: "Poppins",
                    //                 )),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Text("Shipping Address",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Poppins_Bold")),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(widget.order!.party_address!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Poppins",
                                    )),
                              ),
                            ],
                          ),
                          // con
                          // Row(
                          //   children: const [
                          //     Text("Contact",
                          //         style: TextStyle(
                          //             fontSize: 15,
                          //             fontFamily: "Poppins_Bold")),
                          //   ],
                          // ),
                          // Row(
                          //   children: [
                          //     Text(widget.order!.party_mob_num!,
                          //         style: const TextStyle(
                          //             fontSize: 15,
                          //             fontFamily: "Poppins"))
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    // const SizedBox(
                    //   height: 10.0,
                    // ),

                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Region:",
                                style: TextStyle(
                                    fontSize: 15, fontFamily: "Poppins_Bold")),
                            Text(widget.order!.region.toString(),
                                style: const TextStyle(
                                    fontSize: 15, fontFamily: "Poppins"))
                          ],
                        )),

                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Pincode:",
                                style: TextStyle(
                                    fontSize: 15, fontFamily: "Poppins_Bold")),
                            Text(widget.order!.pincode.toString(),
                                style: const TextStyle(
                                    fontSize: 15, fontFamily: "Poppins"))
                          ],
                        )),

                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("GST No.:",
                                style: TextStyle(
                                    fontSize: 15, fontFamily: "Poppins_Bold")),
                            Text(widget.order!.PartygstNumber.toString(),
                                style: const TextStyle(
                                    fontSize: 15, fontFamily: "Poppins"))
                          ],
                        )),

                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Payment Term:",
                                style: TextStyle(
                                    fontSize: 15, fontFamily: "Poppins_Bold")),
                            Text("${widget.order!.paymentTerm.toString()} Day",
                                style: const TextStyle(
                                    fontSize: 15, fontFamily: "Poppins"))
                          ],
                        )),

                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Loading Type:",
                                style: TextStyle(
                                    fontSize: 15, fontFamily: "Poppins_Bold")),
                            Text(widget.order!.loading_type.toString(),
                                style: const TextStyle(
                                    fontSize: 15, fontFamily: "Poppins"))
                          ],
                        )
                    ),

                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Trailer Type:",
                                style: TextStyle(
                                    fontSize: 15, fontFamily: "Poppins_Bold")),
                            Text(widget.order!.trailerType.toString(),
                                style: const TextStyle(
                                    fontSize: 15, fontFamily: "Poppins"))
                          ],
                        )
                    ),

                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          // borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Base Price:",
                                style: TextStyle(
                                    fontSize: 15, fontFamily: "Poppins_Bold")),
                            Text(widget.order!.base_price!,
                                style: const TextStyle(
                                    fontSize: 15, fontFamily: "Poppins"))
                          ],
                        )
                    ),

                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Delivery Date:",
                                style: TextStyle(
                                    fontSize: 15, fontFamily: "Poppins_Bold")),
                            Text(widget.order!.deliveryDate.toString(),
                                style: const TextStyle(
                                    fontSize: 15, fontFamily: "Poppins"))
                          ],
                        )),

                    Container(
                        // margin: EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          // borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Status: ",
                                style: TextStyle(
                                    fontSize: 15, fontFamily: "Poppins_Bold")),
                            Text(widget.order!.status!,
                                style: const TextStyle(
                                    fontSize: 15, fontFamily: "Poppins"))
                          ],
                        )),

                    Container(
                        // margin: EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          // borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Transportation Type: ",
                                style: TextStyle(
                                    fontSize: 15, fontFamily: "Poppins_Bold")),
                            Text(widget.order!.trans_type.toString(),
                                style: const TextStyle(
                                    fontSize: 15, fontFamily: "Poppins"))
                          ],
                        )),

                    //  Container(
                    //     // margin: EdgeInsets.only(top: 10),
                    //     padding: const EdgeInsets.all(10),
                    //     decoration: const BoxDecoration(
                    //       // borderRadius: BorderRadius.circular(20),
                    //       color: Colors.white,
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         const Text("Remaining Qty: ",
                    //             style: TextStyle(
                    //                 fontSize: 15,
                    //                 fontFamily: "Poppins_Bold")),
                    //         Text(lumpsum.qty.toString(),
                    //             style: const TextStyle(
                    //                 fontSize: 15, fontFamily: "Poppins"))
                    //       ],
                    //     )
                    // ),
                  ])),
              const SizedBox(
                height: 10.0,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Card(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  elevation: 2,
                  child: Container(
                      // height: 250,
                      width: MediaQuery.of(context).size.width - 20,
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                          // color: Colors.grey.withOpacity(0.20),
                          // borderRadius: BorderRadius.circular(20.0)
                          ),
                      // alignment: Alignment.center,
                      // padding: const EdgeInsets.only(top: 20),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: DataTable(
                          horizontalMargin: 2,
                          headingTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          columnSpacing: 10,
                          columns: const [
                            DataColumn(label: Text("Sr.\nNo.")),
                            DataColumn(label: Text("Item name")),
                            DataColumn(label: Text("Quantity\n(Tons)")),
                            DataColumn(label: Text("Price"))
                          ],
                          rows:
                              listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
                                  .map(
                                    ((element) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(Text(element[
                                                "Sr_no"]!)), //Extracting from Map element the value
                                            DataCell(Text(element["Name"]!)),
                                            DataCell(Text(element["Qty"]!)),
                                            DataCell(Text(
                                              NumberFormat.simpleCurrency(
                                                      locale: 'hi-IN',
                                                      decimalDigits: 0)
                                                  .format(int.parse(
                                                      element["Price"]!)),
                                            )),
                                          ],
                                        )),
                                  )
                                  .toList(),
                        ),
                      )),
                ),
              ),

              // Container(
              //   alignment: Alignment.topLeft,
              //   padding: EdgeInsets.only(top: 10,bottom: 10,left: 15),
              //   child: Column(
              //     children: [
              //       Text
              //         ("Remaining Qty. ",
              //         style: TextStyle(
              //           color: Colors.black,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 17
              //         ),),
              //     ],
              //   ),
              // ),

              LayoutBuilder(
                builder: (context, constraints) {
                  if (widget.order?.orderType == "Lump-sum") {
                    return Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
                        children: [
                          Text(
                            "Remaining Qty. ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Card(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              elevation: 2,
                              child: Container(
                                  // height: 250,
                                  width: MediaQuery.of(context).size.width - 20,
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      // color: Colors.grey.withOpacity(0.20),
                                      // borderRadius: BorderRadius.circular(20.0)
                                      ),
                                  // alignment: Alignment.center,
                                  // padding: const EdgeInsets.only(top: 20),
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: DataTable(
                                      horizontalMargin: 2,
                                      headingTextStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      columnSpacing: 10,
                                      columns: const [
                                        DataColumn(label: Text("Sr.\nNo.")),
                                        DataColumn(label: Text("Item name")),
                                        DataColumn(
                                            label: Text("Quantity\n(Tons)")),
                                        // DataColumn(label: Text("Price"))
                                      ],
                                      rows:
                                          remaininglist // Loops through dataColumnText, each iteration assigning the value to element
                                              .map(
                                                ((element) => DataRow(
                                                      cells: <DataCell>[
                                                        DataCell(Text(element[
                                                            "Sr_no"]!)), //Extracting from Map element the value
                                                        DataCell(Text(
                                                            element["Name"]!)),
                                                        DataCell(Text(
                                                            element["Qty"]!)),
                                                        // DataCell(Text(
                                                        //   NumberFormat.simpleCurrency(
                                                        //       locale: 'hi-IN',
                                                        //       decimalDigits: 0)
                                                        //       .format(int.parse(
                                                        //       element["Price"]!)),
                                                        // )),
                                                      ],
                                                    )),
                                              )
                                              .toList(),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),

              SizedBox(
                height: 10,
              ),

              //----------------------- Options for Distributor ------------------------------------------

              LayoutBuilder(builder: (context, constraints) {
                if (widget.order!.status == "Pending" &&
                    id == widget.order!.reciever_id &&
                    user.userType == "Distributor" &&
                    widget.order?.orderType != "Lump-sum"
                ) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 40,
                            child: TextButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      // for (int i = 0; i < paymentList.length; i++) {
                                      //   if (paymentList[i].paymentName == selectedpaymentType) {
                                      //     przpct = int.parse(paymentList[i].paymentCost!);
                                      //   }
                                      // }

                                      // for (int i = 0; i < gradeList.length; i++) {
                                      //   if (gradeList[i].value == selectedGrade) {
                                      //     grdpct = int.parse(gradeList[i].price!);
                                      //   }
                                      // }
                                      // for (int i = 0; i < sizeList.length; i++) {
                                      //   if (sizeList[i].value == selectedSize) {
                                      //     szpct = int.parse(sizeList[i].price!);
                                      //   }
                                      // }
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        elevation: 16,
                                        child: Column(
                                          children: [
                                            Container(
                                                // margin: EdgeInsets.only(left: 5, right: 5),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        19, 59, 78, 1.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                height: 50,
                                                // width: ,
                                                child: Text(
                                                    "Select The Lumpsum",
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w600)
                                                    )
                                                )
                                            ),
                                            SingleChildScrollView(
                                              physics: BouncingScrollPhysics(),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.24,
                                                child: ListView.builder(
                                                    reverse: true,
                                                    physics: BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: lumpsumList.length,
                                                    itemBuilder: (context, index) {
                                                      print(lumpsumList[index]
                                                          .name
                                                          .toString());
                                                      // print(
                                                      //     "lumpsumlistlength${lumpsumList[index].name}selectedlist${selectedGrade}");
                                                      // print(int.parse(
                                                      //         lumpsumList[index]
                                                      //             .qty!) >=
                                                      //     int.parse(qty.text));
                                                      return LayoutBuilder(
                                                          builder: (context,
                                                              constraints) {
                                                        if (lumpsumList[index].status.toString() == "Confirmed"
                                                            // lumpsumList[index].name ==
                                                            //       "$selectedGrade" &&
                                                            ) {
                                                          print(
                                                              "entrance............");
                                                          print(
                                                              "status....................${lumpsumList[index].name}");
                                                          // print(szpct);
                                                          // print(prcpct);
                                                          // print(selectedSize);
                                                          return Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 10),
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  onClick();
                                                                      lumpsumList[index]
                                                                          .qty_left = (double.parse(
                                                                          lumpsumList[index]
                                                                              .qty_left!) -
                                                                          double.parse(widget.order!.totalQuantity.toString()))
                                                                          .toString();

                                                                      reductionData.add({
                                                                        "id": lumpsumList[
                                                                        index]
                                                                            .ls_id,
                                                                        "qty":
                                                                        lumpsumList[
                                                                        index]
                                                                            .qty_left
                                                                      });

                                                                  // totalQuantity =
                                                                  //     totalQuantity +
                                                                  //         int.parse(widget.order!.totalQuantity.toString());


                                                                  // if (widget.order?.orderType == "Use Lumpsum") {
                                                                  for (int i = 0; i < reductionData.length; i++) {
                                                                    var res = await http.post(
                                                                        Uri.parse("http://steefotmtmobile.com/steefo/updateinventory.php"),
                                                                        body: {
                                                                          "id": reductionData[i]["id"],
                                                                          "qty": reductionData[i]["qty"]
                                                                        });
                                                                  }
                                                                  // }

                                                                  var resorder =
                                                                      await http
                                                                          .post(
                                                                    Uri.parse(
                                                                        "http://steefotmtmobile.com/steefo/placeOrder2.php"),
                                                                    body: widget.order?.orderType ==
                                                                            "Lump-sum"
                                                                        ? {
                                                                            "userId":
                                                                                id!,
                                                                            // "userId" : widget.order?.user_id,
                                                                            "supplierId":
                                                                                supplier_id!,
                                                                            "shippingAddress":
                                                                                widget.order?.party_address,
                                                                            "pincode":
                                                                                widget.order?.pincode,
                                                                            "region":
                                                                                widget.order?.region,
                                                                            "dealerName":
                                                                                widget.order?.dealerName,
                                                                            "partyName":
                                                                                widget.order?.party_name,
                                                                            "consigneeName":
                                                                                widget.order?.consignee_name,
                                                                            "PartygstNumber":
                                                                                widget.order?.PartygstNumber,
                                                                            "mobileNumber":
                                                                                widget.order?.party_mob_num,
                                                                            "orderid": lumpsumList[index].order_id,
                                                                            "basePrice":
                                                                                widget.order?.base_price,
                                                                            "status":
                                                                                "Pending",
                                                                            "trailerType":
                                                                                "None",
                                                                            "loadingType":
                                                                                "None",
                                                                            "transType":
                                                                                "None",
                                                                            "paymentTerm":
                                                                                "None",
                                                                            // "dealer":selectedDealer,
                                                                            "orderType":
                                                                                "Use Lumpsum",
                                                                            "totalQuantity":
                                                                                widget.order?.totalQuantity.toString(),
                                                                            "totalPrice":
                                                                                widget.order?.totalPrice.toString(),
                                                                            "deliveryDate":
                                                                                widget.order?.deliveryDate,
                                                                            "dateTime":
                                                                                DateTime.now().toString(),
                                                                          }
                                                                        : {
                                                                            "userId":
                                                                                id!,
                                                                            "supplierId":
                                                                                supplier_id!,
                                                                            "shippingAddress":
                                                                                widget.order?.party_address,
                                                                            "pincode":
                                                                                widget.order?.pincode,
                                                                            "region":
                                                                                widget.order?.region,
                                                                            "dealerName":
                                                                                widget.order?.org_name,
                                                                            "partyName":
                                                                                widget.order?.party_name,
                                                                            "consigneeName":
                                                                                widget.order?.consignee_name,
                                                                            "PartygstNumber":
                                                                                widget.order?.PartygstNumber,
                                                                            "mobileNumber":
                                                                                widget.order?.party_mob_num,
                                                                            "orderid": lumpsumList[index].order_id,
                                                                            "basePrice":
                                                                                widget.order?.base_price,
                                                                            "status":
                                                                                "Pending",
                                                                            // "dealer":selectedDealer,
                                                                            "loadingType":
                                                                                widget.order?.loading_type,
                                                                            "orderType":
                                                                                "Use Lumpsum",
                                                                            "paymentTerm":
                                                                                widget.order?.paymentTerm,
                                                                            "trailerType":
                                                                                widget.order?.trailerType,
                                                                            "transType":
                                                                                widget.order?.trans_type,
                                                                            "totalQuantity":
                                                                                widget.order?.totalQuantity,
                                                                            "totalPrice":
                                                                                widget.order?.totalPrice,
                                                                            "deliveryDate":
                                                                                widget.order?.deliveryDate,
                                                                            "dateTime":
                                                                                DateTime.now().toString(),
                                                                          },
                                                                  );
                                                                  print("orderid from lumpsum =======> "+ lumpsumList[index].order_id.toString());

                                                                  var responseData =
                                                                      json.decode(
                                                                          resorder
                                                                              .body);
                                                                  if (responseData[
                                                                              "status"] ==
                                                                          '200' &&
                                                                      widget.order
                                                                              ?.orderType !=
                                                                          "Lump-sum") {
                                                                    for (int i =
                                                                            0;
                                                                        i < listOfColumns1.length;
                                                                        i++) {
                                                                      http.post(
                                                                        Uri.parse(
                                                                            "http://steefotmtmobile.com/steefo/setorder.php"),
                                                                        body: {
                                                                          "order_id":
                                                                              responseData["value"].toString(),
                                                                          "name":
                                                                              listOfColumns1[i]["Name"],
                                                                          "qty":
                                                                              listOfColumns1[i]["Qty"],
                                                                          "qty_left":
                                                                              listOfColumns1[i]["Qty"],
                                                                          "price":
                                                                              listOfColumns1[i]["Price"]
                                                                        },
                                                                      );
                                                                      //  print("${listOfColumns[i]["Price"]}...................");
                                                                      //tot_price = tot_price + num.parse(listOfColumns[i]["Price"]);
                                                                    }
                                                                  } else {
                                                                    for (int i =
                                                                            0;
                                                                        i < listOfColumns1.length;
                                                                        i++) {
                                                                      http.post(
                                                                        Uri.parse(
                                                                            "http://steefotmtmobile.com/steefo/addlumpsum.php"),
                                                                        body: {
                                                                          "order_id":
                                                                              responseData["value"].toString(),
                                                                          "name":
                                                                              listOfColumns1[i]["Name"],
                                                                          "qty":
                                                                              listOfColumns1[i]["Qty"],
                                                                          "price":
                                                                              listOfColumns1[i]["Price"],
                                                                          "basePrice": widget
                                                                              .order
                                                                              ?.base_price,
                                                                        },
                                                                      );
                                                                      //  tot_price = tot_price + int.parse(responseData["data"][i]["price"]);
                                                                    }
                                                                  }

                                                                  if (resorder.statusCode == 200) {
                                                                    // if(token1 != null){
                                                                    var response = await http.post(Uri.parse("http://steefotmtmobile.com/steefo/ordernotification.php"),
                                                                        // "http://steefotmtmobile.com/steefo/notificationNew.php" as Uri,
                                                                        body: {"token": token1.toString(),
                                                                          "parentId": supplier_id}
                                                                    );
                                                                    // Future.delayed(Duration(seconds: 1)).then((value) => {Navigator.of(context).pushNamed("/home")});
                                                                    print(response.body);
                                                                    // return jsonEncode(response.body);
                                                                    // }
                                                                    // else{
                                                                    //   print(response.request);
                                                                    //   print("Token is null");
                                                                    // }
                                                                  }

                                                                  await http.post(
                                                                    Uri.parse(
                                                                        "http://steefotmtmobile.com/steefo/approveorder.php"),
                                                                    body: {
                                                                      "decision": "Approved",
                                                                      "order_id": widget.order!.order_id!
                                                                    },
                                                                  );
                                                                  widget.order!.status = "Confirmed";
                                                                  setState(() {});

                                                                  Navigator.pop(
                                                                      context);

                                                                  // listOfColumns.add({
                                                                  //   "Sr_no": itemNum
                                                                  //       .toString(),
                                                                  //   "Name":
                                                                  //   lumpsumList[
                                                                  //   index]
                                                                  //       .name.toString()+ selectedSize.toString(),
                                                                  //   "Qty": qty.text,
                                                                  //   "Price": selectedTransType ==
                                                                  //       "Ex-Work" &&
                                                                  //       selectedOrderType !=
                                                                  //           "Lump-sum"
                                                                  //       ? (
                                                                  //       (int.parse(lumpsumList[index].basePrice!) +
                                                                  //           tCost + szpct + przpct) *
                                                                  //           int.parse(qty
                                                                  //               .text))
                                                                  //       .toString()
                                                                  //       : ((int.parse(lumpsumList[index]
                                                                  //       .basePrice!)) *
                                                                  //       int.parse(
                                                                  //           qty.text))
                                                                  //       .toString()
                                                                  // });
                                                                  // lumpsumList[index]
                                                                  //     .qty = (int.parse(
                                                                  //     lumpsumList[index]
                                                                  //         .qty!) -
                                                                  //     int.parse(qty
                                                                  //         .text))
                                                                  //     .toString();
                                                                  //
                                                                  // reductionData.add({
                                                                  //   "id": lumpsumList[
                                                                  //   index]
                                                                  //       .ls_id,
                                                                  //   "qty":
                                                                  //   lumpsumList[
                                                                  //   index]
                                                                  //       .qty
                                                                  // });
                                                                  // totalQuantity =
                                                                  //     totalQuantity +
                                                                  //         int.parse(qty
                                                                  //             .text);
                                                                  // itemNum =
                                                                  //     itemNum + 1;
                                                                  // setState(() {});
                                                                  // Navigator.pop(
                                                                  //     context);
                                                                },
                                                                child: InventoryCard1(
                                                                    context,
                                                                    lumpsumList[index], widget.order!, id),
                                                              )
                                                          );
                                                        } else {
                                                          return Container();
                                                        }
                                                      });
                                                    }),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );

                                  // await http.post(
                                  //   Uri.parse(
                                  //       "http://steefotmtmobile.com/steefo/approveorder.php"),
                                  //   body: {
                                  //     "decision": "Approved",
                                  //     "order_id": widget.order!.order_id!
                                  //   },
                                  // );
                                  // widget.order!.status = "Confirmed";
                                  // setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                child: GradientText(
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                  colors: [
                                    Colors.greenAccent,
                                    Colors.greenAccent
                                  ],
                                  "Accept",
                                )
                            )
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            flex: 40,
                            child: TextButton(
                              onPressed: () async {
                                await http.post(
                                  Uri.parse(
                                      "http://steefotmtmobile.com/steefo/approveorder.php"),
                                  body: {
                                    "decision": "Denied",
                                    "order_id": widget.order!.order_id!
                                  },
                                );
                                widget.order!.status = "Denied";
                                setState(() {});
                              },
                              child: GradientText(
                                "Decline",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                                colors: [Colors.redAccent, Colors.redAccent],
                              ),
                            )),
                      ],
                    ),
                  );
                }

                // ------------------------------ For Manufacturer ---------------------

                else if (widget.order!.status == "Pending" &&
                    id == widget.order!.reciever_id &&
                    user.userType == "Manufacturer"
                ) {
                  return Container(
                    padding: EdgeInsets.only(left: 15,right: 15),
                    child: Row(
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
                                  "order_id": widget.order!.order_id!
                                },
                              );
                              widget.order!.status = "Canceled";
                              setState(() {});
                              Navigator.of(context).pushNamed('/orders');
                              // Get.to(RequestPage());
                            },
                            child: GradientText(
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
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
                                  "order_id": widget.order!.order_id!
                                },
                              );
                              widget.order!.status = "Denied";
                              setState(() {
                                Navigator.of(context).pushNamed('/home');
                                Fluttertoast.showToast(
                                    msg: 'Order is Cancelled',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.blueAccent,
                                    textColor: Colors.white);
                              });
                            },
                            child: GradientText(
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                              colors: [Colors.redAccent, Colors.red],
                              "Decline",
                            ))
                      ],
                    ),
                  );
                } if (widget.order!.status == "Confirmed" && widget.order!.orderType == "Lump-sum") {

                    return Column(
                      children: [
                        Container(
                          // ------------------------Complate lumpsum order---------------------

                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: GestureDetector(
                            onTap: () async {
                              await http.post(
                                Uri.parse(
                                    "http://steefotmtmobile.com/steefo/approveorder.php"),
                                body: {
                                  "decision": "Completed",
                                  "order_id": widget.order?.order_id
                                },
                              );
                                  () {
                                // orderList.add(requestList[index]);
                                // requestList.removeAt(index);
                                // id = "none";
                                // requestList.removeAt(index);
                                // loadData();
                                setState(() {});
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()
                                    ));
                                // Get.to(HomePage());
                              }();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                height: 55,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 1.123,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(75, 100, 160, 1.0),
                                      Color.fromRGBO(19, 59, 78, 1.0),

                                      //add more colors
                                    ])),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 18,
                                    bottom: 18,
                                  ),
                                  child: Text(
                                    "Complete Order",
                                    style: const TextStyle(
                                        fontFamily: 'Poppins_Bold', color: Colors.white),
                                  ),
                                )),
                          ),
                          // buttonStyle("View Challan", () {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => ChallanListPage(
                          //                 order: widget.order!,
                          //               )));
                          // }),
                        ),

                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   padding: const EdgeInsets.symmetric(
                        //       vertical: 10, horizontal: 20),
                        //   child: buttonStyle("View Challan", () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => ChallanListPage(
                        //                   order: widget.order!,
                        //                 )));
                        //   }),
                        // ),
                        GestureDetector(
                          onTap: () async {
                            await http.post(
                              Uri.parse(
                                  "http://steefotmtmobile.com/steefo/approveorder.php"),
                              body: {
                                "decision": "Canceled",
                                "order_id": widget.order!.order_id!
                              },
                            );
                            widget.order!.status = "Canceled";
                            setState(() {});
                            Navigator.of(context).pushNamed('/orders');
                            // Navigator.pop(context);
                            //Get.back();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Cancel Order",
                                      style: const TextStyle(
                                          fontFamily: 'Poppins_Bold',
                                          color: Colors.white)),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  } if(widget.order!.status == "Confirmed" && widget.order!.orderType != "Lump sum"){
                    return Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: buttonStyle("View Challan", () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChallanListPage(
                                          order: widget.order!,
                                        )));
                          }),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await http.post(
                              Uri.parse(
                                  "http://steefotmtmobile.com/steefo/approveorder.php"),
                              body: {
                                "decision": "Canceled",
                                "order_id": widget.order!.order_id!
                              },
                            );
                            widget.order!.status = "Canceled";
                            setState(() {});
                            Navigator.of(context).pushNamed('/orders');
                            // Navigator.pop(context);
                            //Get.back();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Cancel Order",
                                      style: const TextStyle(
                                          fontFamily: 'Poppins_Bold',
                                          color: Colors.white)),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    );

                  } if(widget.order!.status == "Completed" && widget.order!.orderType != "Lump-sum") {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: buttonStyle("View Challan", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChallanListPage(
                                order: widget.order!,
                              )));
                    }),
                  );
                }else {
                  return Container();
                }
                }
              ),
            ]),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context){
      //       return  Container();
      //     }));
      //   },
      //   child: const Icon(Icons.picture_as_pdf_sharp),
      // ),
    );
  }
}
