import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:stefomobileapp/Models/item.dart';
import 'package:stefomobileapp/Models/lumpsum.dart';
import '../Models/challan.dart';
import '../Models/order.dart';
import '../ui/common.dart';
import '../ui/custom_tabbar.dart';
import 'OrderPage.dart';

class ChallangeneratorPage extends StatelessWidget {
  final Order order;
  ChallangeneratorPage({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    return ChallangeneratorContent(order: order);
    //  throw UnimplementedError();
  }
}

class ChallangeneratorContent extends StatefulWidget {
  final Order order;
  const ChallangeneratorContent({super.key, required this.order});
  final selected = 0;
  @override
  State<ChallangeneratorContent> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<ChallangeneratorContent> {
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
        Uri.parse("http://steefotmtmobile.com/steefo/getorderdetails.php"),
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

  @override
  void initState() {
    super.initState();
    //loadDatafortotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar("Orders", () {
        // Get.to(HomePage());
      }),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: CustomTabBar(
            selectedCardColor: Colors.blueGrey,
            selectedTitleColor: Colors.white,
            unSelectedTitleColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            unSelectedCardColor: Colors.white,
            titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tabBarItemExtend: ((MediaQuery.of(context).size.width) / 2),
            // tabBarItems: ["Orders", "Requests"],
            tabBarItems: [
              // "Requests",
              "Confirmed Orders",
              "Completed"
            ],
            // tabViewItems: [OrdersPageBody(), OrderList1()]
            tabViewItems: [
              // Container(child: OrderList1()),
              Container(child: ConfirmedOrders()),
              Container(child: CompletedListBody())
            ]
        ),
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

    final response = await http.post(
      Uri.parse("http://steefotmtmobile.com/steefo/challanorder.php"),
      body: {"id": id!},
    );
    var responseData1 = jsonDecode(response.body);
    for (int i = 0; i < responseData1["data"].length; i++) {
      Order or = Order();
      or.orderStatus = responseData1["data"][i]["orderStatus"];
      or.deliveryDate = responseData1["data"][i]["deliveryDate"];
      or.totalPrice = responseData1["data"][i]["totalPrice"];
      or.totalQuantity = responseData1["data"][i]["totalQuantity"];
      or.reciever_id = responseData1["data"][i]["supplier_id"];
      or.user_id = responseData1["data"][i]["user_id"];
      or.user_mob_num = responseData1["data"][i]["mobileNumber"];
      or.org_name = responseData1["data"][i]["orgName"];
      or.user_name = responseData1["data"][i]["firstName"] + " " +
          responseData1["data"][i]["lastName"];
      or.status = responseData1["data"][i]["orderStatus"];
      or.party_name = responseData1["data"][i]["partyName"];
      or.party_address = responseData1["data"][i]["shippingAddress"];
      or.pincode = responseData1["data"][i]["pincode"];
      or.billing_address = responseData1["data"][i]["address"];
      or.party_mob_num = responseData1["data"][i]["partyMobileNumber"];
      or.PartygstNumber = responseData1["data"][i]["PartygstNumber"];
      or.loading_type = responseData1["data"][i]["loadingType"];
      or.trans_type = responseData1["data"][i]["transType"];
      or.order_date = responseData1["data"][i]["createdAt"];
      or.base_price = responseData1["data"][i]["basePrice"];
      or.orderType = responseData1["data"][i]["orderType"];
      or.order_id = responseData1["data"][i]["order_id"].toString();
      or.date = responseData1["data"][i]["dateTime"];
      //print(req);
      if (or.status != "Rejected") {
        if (id == or.user_id) {
          purchaseOrderList.add(or);
        }
        if (id == or.reciever_id) {
          salesOrderList.add(or);
        }
      }
    }

    if (m != id) {
      final res = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/vieworder.php"),
        body: {"id": id!},
      );
      var responseData = jsonDecode(res.body);
      print(responseData);

      for (int i = 0; i < responseData["data"].length; i++) {
        Order req = Order();
        req.orderStatus = responseData["data"][i]["orderStatus"];
        req.deliveryDate = responseData["data"][i]["deliveryDate"];
        req.totalPrice = responseData["data"][i]["totalPrice"];
        req.totalQuantity = responseData["data"][i]["totalQuantity"];
        req.reciever_id = responseData["data"][i]["supplier_id"];
        req.user_id = responseData["data"][i]["user_id"];
        req.user_mob_num = responseData["data"][i]["mobileNumber"];
        req.org_name = responseData["data"][i]["orgName"];
        req.user_name = responseData["data"][i]["firstName"] + " " +
            responseData["data"][i]["lastName"];
        req.status = responseData["data"][i]["orderStatus"];
        req.party_name = responseData["data"][i]["partyName"];
        req.party_address = responseData["data"][i]["shippingAddress"];
        req.pincode = responseData["data"][i]["pincode"];
        req.billing_address = responseData["data"][i]["address"];
        req.party_mob_num = responseData["data"][i]["partyMobileNumber"];
        req.PartygstNumber = responseData["data"][i]["PartygstNumber"];
        req.loading_type = responseData["data"][i]["loadingType"];
        req.trans_type = responseData["data"][i]["transType"];
        req.order_date = responseData["data"][i]["createdAt"];
        req.base_price = responseData["data"][i]["basePrice"];
        req.orderType = responseData["data"][i]["orderType"];
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
        req.user_name = responseData["data"][i]["firstName"] +
            " " +
            responseData["data"][i]["lastName"];
        req.status = responseData["data"][i]["orderStatus"];
        req.party_name = responseData["data"][i]["partyName"];
        req.party_address = responseData["data"][i]["shippingAddress"];
        req.pincode = responseData["data"][i]["pincode"];
        req.billing_address = responseData["data"][i]["address"];
        req.party_mob_num = responseData["data"][i]["partyMobileNumber"];
        req.PartygstNumber = responseData["data"][i]["PartygstNumber"];
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
                if (salesOrderList[index].orderType == "With Size" ||
                    salesOrderList[index].orderType == "Use Lumpsum") {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderDetails(
                                    order: salesOrderList[index],lumpsum: Lumpsum(),)));
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
                print("orderty  pe${salesOrderList[index].orderType}");
                if (salesOrderList[index].orderType == "With Size" ||
                    salesOrderList[index].orderType == "Use Lumpsum") {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderDetails(
                                    order: salesOrderList[index],lumpsum: Lumpsum())));
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
                                  OrderDetails(order: requestList[index],lumpsum: Lumpsum())));
                    },
                    child: requestList[index].orderType == "With Size" ||
                        requestList[index].orderType == "Use Lumpsum"
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
                            "http://steefotmtmobile.com/steefo/approveorder.php"),
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

}

//---------------------------------SingleOrderRequestWidget---------------------

//-------------------------------SingleRegistrationRequest----------------------


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
                        } else {
                          return Container();
                        }
                      })),

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

                ],
              ),


            ],
          ),

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
                ],
              ),

            ],
          ),


        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  } else
    return Container();
}
