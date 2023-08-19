import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:stefomobileapp/pages/ChallanListPage.dart';
import '../Models/lumpsum.dart';
import '../Models/lumpsum.dart';
import '../Models/order.dart';
import '../ui/common.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// ignore: must_be_immutable
class OrderDetails extends StatelessWidget {
  Order order;
  OrderDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return OrderPage(order: order);
  }
}

class OrderPage extends StatefulWidget {
  OrderPage({Key? key, this.order}) : super(key: key);
  final Order? order;
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {


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

  Lumpsum get lumpsum => Lumpsum();
  int flag = 0;
  var listOfColumns = [];
  var id;
  num tot_price = 0;
  loadData() async {
    print(
        "${widget.order!.order_id.toString()}");
    print(
        "${widget.order!.orderType.toString()}");
    print(
        "${widget.order!.trans_type.toString()}");

    print("inLoadLumpsumData");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    // print(widget.order!.orderType);
    // print(widget.order!.trans_type);
    // print(widget.order!.loading_type);
    if (flag == 0) {
      if (widget.order!.orderType != "Lump-sum") {
        print('insize');
        final res = await http.post(
          Uri.parse("http://steefotmtmobile.com/steefo/getorderdetails.php"),
          body: {
            "order_id": widget.order!.order_id,
            // "qty_left": widget.order!.qty_left,
            // "id": widget.order!.id,
          },
        );
        var responseData = jsonDecode(res.body);
        // print(
        //     "dddddddddddddddddddddddddddddddddddddddddddddddddddddddd${responseData}");
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
        }
        listOfColumns.add({
          "Sr_no": " ",
          "Name": " ",
          "Qty": "Total:",
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
            "order_id": widget.order!.order_id,
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
        }
        listOfColumns.add({
          "Sr_no": " ",
          "Name": " ",
          "Qty": "Total:",
          "Price": tot_price.toString()
          // NumberFormat.simpleCurrency(locale: 'hi-IN', decimalDigits: 2)
          //     .format(int.parse(tot_price.toString())),
        });
      }
      // print(
      //   NumberFormat.simpleCurrency(locale: 'hi-IN', decimalDigits: 2)
      //       .format(int.parse(tot_price.toString())),
      // );

      print(listOfColumns);
      print(widget.order!.qty_left);
      //  print("${widget.order!.order_id.toString()}order id");
      flag = 1;
      setState(() {});
    }
  }



  // void initState() {
  //   loadData();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context,) {
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
                      child: Column(
                          children: [
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  widget.order!.org_name.toString().toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Poppins_bold",
                                      color: Colors.white)
                              ),
                              Text(
                                  widget.order!.order_id.toString().toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Poppins_bold",
                                      color: Colors.white)
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
                                const Text("Party Name:",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Poppins_Bold")),
                                Text(widget.order!.party_name.toString(),
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
                                        fontSize: 15,
                                        fontFamily: "Poppins_Bold")),
                                Text(widget.order!.party_mob_num.toString(),
                                    style: const TextStyle(
                                        fontSize: 15, fontFamily: "Poppins")
                                )
                              ],
                            )
                        ),

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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Loading Type:",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Poppins_Bold")),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Transportation Type: ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Poppins_Bold")),
                                Text(widget.order!.trans_type.toString(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Remaining Qty: ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Poppins_Bold")),
                                Text(lumpsum.qty_left.toString(),
                                    style: const TextStyle(
                                        fontSize: 15, fontFamily: "Poppins"))
                              ],
                            )
                        ),
                       ]
                      )
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
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
                                      colors: [
                                        Colors.greenAccent,
                                        Colors.greenAccent
                                      ],
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
                                    colors: [
                                      Colors.redAccent,
                                      Colors.redAccent
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      );
                    } else {
                      if (widget.order!.status == "Confirmed") {
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
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      } else {
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
                      }
                    }
                  }),


                ]
                ),

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
