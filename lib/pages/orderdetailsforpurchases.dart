import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:stefomobileapp/Models/user.dart';
// import 'package:stefomobileapp/pages/ChallanListPage.dart';
import 'package:stefomobileapp/pages/purchasechallanlistpage.dart';
import '../Models/order.dart';
import '../ui/common.dart';
// import 'EditableProfilePage.dart';
// import 'PlaceOrderPage.dart';
import 'editorderpage.dart';
// import '../Models/user.dart';

// ignore: must_be_immutable
class OrderDetailsforpurchases extends StatelessWidget {
  Order order;
  OrderDetailsforpurchases({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return OrderPage(order: order);
  }
}

class OrderPage extends StatefulWidget {
  final Order? order;
  OrderPage({Key? key, this.order}) : super(key: key);

  // get user => null;
  final User user = User();
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  User user = User();
  int flag = 0;
  var listOfColumns = [];
  var remaininglist = [];
  var id;
  num tot_price = 0;
  double tot_qty = 0;
  loadData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    print(widget.order!.orderType);
    print(widget.order!.loading_type);
    print("user type ");
    print(widget.user.userType);


    if (flag == 0) {
      if (widget.order!.orderType != "Lump-sum") {


        var test = await http.post(
          Uri.parse(
            'http://steefotmtmobile.com/steefo/getrequests.php',
          ),
        );
        //Navigator.of(context).pushNamed("/home");
        var responseData1 = jsonDecode(test.body);
        // print("remaining qty"+ qty.qty_left.toString());
        print("enter1");
        print(responseData1);
        for (int i = 0; i < responseData1['data'].length; i++) {
          print("enter2");
          User user = User();
          user.id = responseData1['data'][i]['id'];
          user.firstName = responseData1['data'][i]['firstName'];
          user.lastName = responseData1['data'][i]['lastName'];
          user.email = responseData1['data'][i]['email'];
          user.mobileNumber = responseData1['data'][i]['mobileNumber'];
          user.parentId = responseData1['data'][i]['parentId'];
          user.userType = responseData1['data'][i]['userType'];
          user.userStatus = responseData1['data'][i]['userStatus'];
          user.orgName = responseData1['data'][i]['orgName'];
          user.gstNumber = responseData1['data'][i]['gstNumber'];
          user.panNumber = responseData1['data'][i]['panNumber'];
          user.adhNumber = responseData1['data'][i]['adhNumber'];
          user.address = responseData1['data'][i]['address'];
          user.uploadedFile = responseData1['data'][i]['uploadedFile'];
          // regReqList.add(u);
          print(user.userType);
          print("enter3");
          // print(lumpsum.qty_left);
        }




        print(widget.order!.order_id);
        print(widget.order!.PartygstNumber);
        final res = await http.post(
          Uri.parse("http://steefotmtmobile.com/steefo/getorderdetails.php"),
          body: {
            "order_id": widget.order!.order_id,
          },
        );
        var responseData = jsonDecode(res.body);
        //print(responseData);
        listOfColumns = [];

        for (int i = 0; i < responseData["data"].length; i++) {
          listOfColumns.add({
            "Sr_no": (i + 1).toString(),
            "Name": responseData["data"][i]["name"],
            "Qty": responseData["data"][i]["qty"],
            "Price": responseData["data"][i]["price"]
          });
          tot_price = tot_price + int.parse(responseData["data"][i]["price"]);
          tot_qty = tot_qty + double.parse(responseData["data"][i]["qty"]);
        }
        listOfColumns.add({
          "Sr_no": " ",
          "Name": "Total: ",
          "Qty": tot_qty.toString(),
          "Price": tot_price.toString()
          // NumberFormat.simpleCurrency(locale: 'hi-IN', decimalDigits: 2)
          //     .format(int.parse(tot_price.toString())),
        });
      } else {
        final res = await http.post(
          Uri.parse("http://steefotmtmobile.com/steefo/getlumpsumorder.php"),
          body: {
            "order_id": widget.order!.order_id,
          },
        );
        print("${widget.order!.order_id}order id");
        var responseData = jsonDecode(res.body);
        //print(responseData);
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

        remaininglist = [];
        final res1 = await http.post(
          Uri.parse("http://steefotmtmobile.com/steefo/getlumpsumorder.php"),
          body: {
            // "qty_left" : responseData["data"][i]["qty_left"],
            "order_id": widget.order?.order_id,
          },
        );
        var responseData1 = jsonDecode(res1.body);
        // print("ddddddddddd");
        remaininglist = [];
        for (int i = 0; i < responseData1["data"].length; i++) {
          remaininglist.add({
            "Sr_no": (i + 1).toString(),
            "Name": responseData1["data"][i]["name"],
            "Qty": responseData1["data"][i]["qty_left"],
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
      print(listOfColumns);
      print("usertype"+widget.order!.userType.toString());
      flag = 1;
      setState(() {});
    }
  }

  // void initState() {
  //   loadData();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    loadData();

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
                      child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: Color.fromRGBO(19, 59, 78, 1.0),
                                  ),
                              // color: Color.fromRGBO(19, 59, 78, 1.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.order!.org_name!.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: "Poppins_bold",
                                          color: Colors.white)),
                                  Text(widget.order!.order_id!.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: "Poppins_bold",
                                          color: Colors.white)),
                                ],
                              ),
                            ),
                        // Container(
                        //   alignment: Alignment.center,
                        //   width: double.infinity,
                        //   padding: const EdgeInsets.all(10),
                        //   decoration: const BoxDecoration(
                        //     borderRadius: BorderRadius.all(
                        //       Radius.circular(10),
                        //     ),
                        //     color: Color.fromRGBO(19, 59, 78, 1.0),
                        //   ),
                        //   child: Text(widget.order!.org_name!.toUpperCase(),
                        //       style: const TextStyle(
                        //           fontSize: 20,
                        //           fontFamily: "Poppins_bold",
                        //           color: Colors.white)),
                        // ),
                        SizedBox(
                          height: 10,
                        ),

                            LayoutBuilder(builder: (context, constraints) {
                              if(widget.order!.userType != "Dealer"){
                                return Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      // borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Dealer Name:",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Poppins_Bold")),
                                        Text(widget.order!.dealerName.toString(),
                                            style: const TextStyle(
                                                fontSize: 15, fontFamily: "Poppins"))
                                      ],
                                    )
                                );
                              }else {
                                return Container();
                              }
                            },
                            ),

                            LayoutBuilder(builder: (context, constraints) {
                              if(widget.order!.user_type == "Distributor"){
                                return Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      // borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Party Name:",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Poppins_Bold")),
                                        Text(widget.order!.party_name.toString(),
                                            style: const TextStyle(
                                                fontSize: 15, fontFamily: "Poppins"))
                                      ],
                                    )
                                );
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

                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Consignee Name:",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Poppins_Bold")),
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Contact:",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Poppins_Bold")),
                                    Text(widget.order!.party_mob_num.toString(),
                                        style: const TextStyle(
                                            fontSize: 15, fontFamily: "Poppins"))
                                  ],
                                )),


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
                            ],
                          ),
                        ),

                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Pincode:",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Poppins_Bold")),
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Region:",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Poppins_Bold")),
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("GST No.:",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Poppins_Bold")),
                                    Text(widget.order!.PartygstNumber.toString(),
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Payment Term:",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Poppins_Bold")),
                                    Text("${widget.order!.paymentTerm.toString()} Days",
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
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Loading Type:",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Poppins_Bold")),
                                Text(widget.order!.loading_type.toString(),
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
                                    const Text("Trailer Type:",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Poppins_Bold")),
                                    Text(widget.order!.trailerType.toString(),
                                        style: const TextStyle(
                                            fontSize: 15, fontFamily: "Poppins"))
                                  ],
                                )),


                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              // borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Base Price:",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Poppins_Bold")),
                                Text(widget.order!.base_price!,
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
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Delivery Date:",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Poppins_Bold")),
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
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Status: ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Poppins_Bold")),
                                Text(widget.order!.status!,
                                    style: const TextStyle(
                                        fontSize: 15, fontFamily: "Poppins"))
                              ],
                            )
                        ),
                            Container(
                              // margin: EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  // borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Transportation Type: ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Poppins_Bold")),
                                    Text(widget.order!.trans_type.toString(),
                                        style: const TextStyle(
                                            fontSize: 15, fontFamily: "Poppins"))
                                  ],
                                )),

                      ])),

                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Card(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      elevation: 2,
                      child: Container(
                          height: 250,
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
                                                DataCell(
                                                    Text(element["Name"]!)),
                                                DataCell(Text(element["Qty"]!)),

                                                DataCell(Container(
                                                  width: 100,
                                                  child: Text(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    NumberFormat.simpleCurrency(
                                                            locale: 'hi-IN',
                                                            decimalDigits: 0)
                                                        .format(int.parse(
                                                            element["Price"]!)),
                                                  ),
                                                )),
                                              ],
                                            )),
                                      )
                                      .toList(),
                            ),
                          )),
                    ),
                  ),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      if( widget.order?.orderType == "Lump-sum"){
                        return Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 10,bottom: 10),
                          child: Column(
                            children: [
                              Text("Remaining Qty. ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17
                                ),),
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
                                            DataColumn(label: Text("Quantity\n(Tons)")),
                                            // DataColumn(label: Text("Price"))
                                          ],
                                          rows:
                                          remaininglist // Loops through dataColumnText, each iteration assigning the value to element
                                              .map(
                                            ((element) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(Text(element[
                                                "Sr_no"]!)), //Extracting from Map element the value
                                                DataCell(
                                                    Text(element["Name"]!)),
                                                DataCell(Text(element["Qty"]!)),
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
                      }else{
                        return Container();
                      }
                    },

                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LayoutBuilder(builder: (context, constraints) {
                    if (widget.order!.status == "Pending" &&
                        id == widget.order!.reciever_id) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 40,
                                child: TextButton(
                                    onPressed: () async {
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
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white),
                                    child: GradientText(
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                      colors: [Colors.greenAccent, Colors.grey],
                                      "Accept",
                                    ))),
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
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                    colors: [Colors.redAccent, Colors.grey],
                                  ),
                                )
                            ),
                          ],
                        ),
                      );
                    } else {
                      if (widget.order!.status == "Confirmed") {
                        return Column(
                          children: [
                            // GestureDetector(
                            //   onTap: () async {
                            //     print('taapp');

                            //     await http.post(
                            //       Uri.parse(
                            //           "http://urbanwebmobile.in/steffo/approveorder.php"),
                            //       body: {
                            //         "decision": "Canceled",
                            //         "order_id": widget.order!.order_id!
                            //       },
                            //     );
                            //     widget.order!.status = "Canceled";
                            //     setState(() {});
                            //     Navigator.of(context).pushNamed('/orders');
                            //     // Navigator.pop(context);
                            //     //Get.back();
                            //   },
                            //   child: Padding(
                            //     padding: EdgeInsets.only(left: 20, right: 20),
                            //     child: Container(
                            //       alignment: Alignment.center,
                            //       width: double.infinity,
                            //       height: 40,
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         children: [
                            //           Icon(
                            //             Icons.cancel_outlined,
                            //             color: Colors.white,
                            //           ),
                            //           SizedBox(
                            //             width: 5,
                            //           ),
                            //           Text("Cancel Order",
                            //               style: const TextStyle(
                            //                   fontFamily: 'Poppins_Bold',
                            //                   color: Colors.white)),
                            //         ],
                            //       ),
                            //       decoration: BoxDecoration(
                            //           color: Colors.redAccent,
                            //           borderRadius: BorderRadius.circular(10)),
                            //     ),
                            //   ),
                            // ),
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
                          ],
                        );
                      } else {
                        return (Container());
                      }
                    }
                  }),
                  // GestureDetector(
                  //   onTap: () {
                  //     Get.to(EditableProfilePage());
                  //   },
                  //   child: Align(
                  //     alignment: Alignment.topRight,
                  //     child: Container(
                  //       // padding: EdgeInsets.only(right: 10),
                  //       // margin: const EdgeInsets.only(top: 20),
                  //       alignment: Alignment.center,
                  //       // height: 40,
                  //       decoration: BoxDecoration(
                  //           // color: Color.fromARGB(255, 216, 229, 248),
                  //           borderRadius: BorderRadius.only(
                  //               topLeft: Radius.circular(10),
                  //               bottomLeft: Radius.circular(10))),
                  //       // child: ElevatedButton(
                  //       //     onPressed: () {
                  //       //       onRegister();
                  //       //     },
                  //       //     child: Icon(Icons.edit)),
                  //       child: buttonStyle("Edit Order", () {
                  //         loadData();
                  //       })
                  //       // Icon(
                  //       //   Icons.edit_rounded,
                  //       //   color: Colors.black,
                  //       // ),
                  //     ),
                  //   ),
                  // ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if(widget.order?.userType == "Manufacturer" || widget.order?.status == "Pending"){
                        return GestureDetector(
                          onTap: () {
                            Get.to(EditOrderPage(order: widget.order));
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              // color:Color.fromRGBO(19, 59, 78, 1),
                              //   padding: EdgeInsets.only(right: 10),
                                margin: const EdgeInsets.only(top: 10,bottom: 10),
                                alignment: Alignment.center,
                                height: 50,
                                width: MediaQuery.of(context).size.width/2,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(75, 100, 160, 1.0),
                                      Color.fromRGBO(19, 59, 78, 1.0),
                                      //add more colors
                                    ]),
                                    // color: Color.fromRGBO(19, 59, 78, 1),
                                    borderRadius: BorderRadius.all(Radius.circular(10)
                                    )
                                ),
                                // child: ElevatedButton(
                                //     onPressed: () {
                                //       onRegister();
                                //     },
                                //     child: Icon(Icons.edit)),
                                child: Text("Edit Order",
                                  style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
                              // ElevatedButton(onPressed: () {
                              //
                              //   Navigator.of(context).pushNamed("/placeorder");
                              // },
                              //   child: Text("Edit Order"),
                              // )
                              // Icon(
                              //   Icons.edit_rounded,
                              //   color: Colors.black,
                              // ),
                            ),
                          ),
                        );
                      }else {return Container();}
                    }
                  ),

                  LayoutBuilder(builder: (context, constraints) {
                    if(widget.order?.orderType != "Lump-sum"){
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: buttonStyle("View Challan", () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PurchaseChallanListPage(
                                    order: widget.order!,
                                  )));
                        }),
                      );
                    }else {return Container();}
                  },
                  )

                  // GestureDetector(
                  //   onTap: () {
                  //     Get.to(PlaceOrderPage());
                  //   },
                  //   child: Align(
                  //     alignment: Alignment.topRight,
                  //     child:
                  //     Container(
                  //       padding: EdgeInsets.only(right: 10),
                  //       margin: const EdgeInsets.only(top: 20),
                  //       alignment: Alignment.center,
                  //       // height: 40,
                  //       width: MediaQuery.of(context).size.width,
                  //       decoration: BoxDecoration(
                  //           // color: Color.fromARGB(255, 216, 229, 248),
                  //           borderRadius: BorderRadius.only(
                  //               topLeft: Radius.circular(10),
                  //               bottomLeft: Radius.circular(10))),
                  //       // child: ElevatedButton(
                  //       //     onPressed: () {
                  //       //       onRegister();
                  //       //     },
                  //       //     child: Icon(Icons.edit)),
                  //       child: buttonStyle("Edit Order", () {})
                  //       // Icon(
                  //       //   Icons.edit_rounded,
                  //       //   color: Colors.black,
                  //       // ),
                  //     ),
                  //   ),
                  // ),
                ])),
          ),
        ),
    );
  }
}
