import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:stefomobileapp/Models/item.dart';
import 'package:stefomobileapp/Models/user.dart';
// import 'package:stefomobileapp/Models/lumpsum.dart';
import 'package:stefomobileapp/pages/HomePage.dart';
import '../Models/challan.dart';
import '../Models/order.dart';
// import '../ui/cards.dart';
import '../ui/common.dart';
import '../Models/lumpsum.dart';
import '../ui/custom_tabbar.dart';
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
    supplier_id = await prefs.getString('parentId');
    print(widget.order.orderType);
    print(widget.order.loading_type);
    print(widget.order.trans_type);
    print(widget.order.order_id);

    if (widget.order.orderType != "Lump-sum" &&
        widget.order.orderType == "With Size" ) {
      print(widget.order.order_id);
      final res = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/getorderdetails.php"),
        body: {
          // "id" : responseData1['data'][i]['id'];
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

  Lumpsum lumpsum = Lumpsum();
  User user = User();

  var listOfColumns1 = [];
  List<Lumpsum> lumpsumList = [];
  int flag = 0;
  String? id, supplier_id;
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
    print(lumpsum.order_id);

    if (m != id) {
      final res = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/vieworder.php"),
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
        req.region = responseData["data"][i]["region"];
        req.billing_address = responseData["data"][i]["address"];
        req.party_mob_num = responseData["data"][i]["partyMobileNumber"];
        req.loading_type = responseData["data"][i]["loadingType"];
        req.paymentTerm = responseData["data"][i]["paymentTerm"];
        req.qty_left = responseData["data"][i]["qty_left"];
        req.trans_type = responseData["data"][i]["transType"];
        req.trailerType = responseData["data"][i]["trailerType"];
        req.order_date = responseData["data"][i]["createdAt"];
        req.base_price = responseData["data"][i]["basePrice"];
        req.orderType = responseData["data"][i]["orderType"];
        req.orderStatus = responseData["data"][i]["orderStatus"];
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

    final SharedPreferences pref = await SharedPreferences.getInstance();
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
      print(responseData['data'][0]['name']);
      // print("order id"+ lumpsum.order_id.toString());
      Lumpsum l = Lumpsum();
      l.partyname = responseData["data"][0]["partyName"];
      l.order_id = responseData["data"][0]["order_id"];
      l.name = responseData["data"][0]["name"];
      l.basePrice = responseData["data"][0]["basePrice"];
      l.qty = responseData["data"][0]["qty"];
      l.qty_left = responseData["data"][0]["qty_left"];
      l.price = responseData["data"][0]["price"];
      l.status = responseData["data"][0]["orderStatus"];
      l.ls_id = responseData['data'][0]["ls_id"];
      l.date = responseData["data"][0]["createdAt"];
      lumpsumList.add(l);
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
        req.orderStatus = responseData["data"][i]["orderStatus"];
        req.reciever_id = responseData["data"][i]["supplier_id"];
        req.user_id = responseData["data"][i]["user_id"];
        req.orderid = responseData["data"][i]["orderid"];
        req.user_mob_num = responseData["data"][i]["mobileNumber"];
        req.org_name = responseData["data"][i]["orgName"];
        req.region = responseData["data"][i]["region"];
        req.paymentTerm = responseData["data"][i]["paymentTerm"];
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
        req.qty_left = responseData["data"][i]["qty_left"];
        req.trans_type = responseData["data"][i]["transType"];
        req.trailerType = responseData["data"][i]["trailerType"];
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
                                    order: salesOrderList[index],lumpsum: lumpsum)));
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
                print("ordertype${salesOrderList[index].orderType}");
                if (salesOrderList[index].orderType == "With Size" ||
                    salesOrderList[index].orderType == "Use Lumpsum") {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderDetails(
                                    order: salesOrderList[index],lumpsum: lumpsum)
                            )
                        );
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
                                  OrderDetails(order: requestList[index],lumpsum: lumpsum)
                          )
                      );
                    },
                    child: requestList[index].orderType == "With Size" ||
                            requestList[index].orderType == "Use Lumpsum"
                        ? orderwidget1(index)
                        : Container()
                );
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
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        // margin: EdgeInsets.only(top: 10),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5, left: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    requestList[index].org_name!.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: GoogleFonts.poppins(
                      color: Color.fromRGBO(19, 59, 78, 1.0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints){
                    if(requestList[index].orderType == "Use Lumpsum"){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("From: " + "${requestList[index].orderType.toString()}",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold
                            ),),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("Order id: " + requestList[index].orderid.toString(),
                            style: TextStyle(
                              color: Colors.grey,

                            ),),
                          ),
                        ],
                      );
                  }else{
                      return Container();
                    }
                  }
                )
              ],
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
                              "Trans Type:",
                              style: TextStyle(
                                  fontFamily: "Poppins_Bold",
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              requestList[index].trans_type.toString(),
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
                // TextButton(
                //     onPressed: () async {
                //
                //       showDialog(
                //         context: context,
                //         builder: (context) {
                //
                //           // for (int i = 0; i < paymentList.length; i++) {
                //           //   if (paymentList[i].paymentName == selectedpaymentType) {
                //           //     przpct = int.parse(paymentList[i].paymentCost!);
                //           //   }
                //           // }
                //
                //           // for (int i = 0; i < gradeList.length; i++) {
                //           //   if (gradeList[i].value == selectedGrade) {
                //           //     grdpct = int.parse(gradeList[i].price!);
                //           //   }
                //           // }
                //           // for (int i = 0; i < sizeList.length; i++) {
                //           //   if (sizeList[i].value == selectedSize) {
                //           //     szpct = int.parse(sizeList[i].price!);
                //           //   }
                //           // }
                //           return Dialog(
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(10)),
                //             elevation: 16,
                //             child: Column(
                //               children: [
                //                 Container(
                //                   // margin: EdgeInsets.only(left: 5, right: 5),
                //                     alignment: Alignment.center,
                //                     decoration: BoxDecoration(
                //                         color: Color.fromRGBO(19, 59, 78, 1.0),
                //                         borderRadius:
                //                         BorderRadius.circular(10)),
                //                     height: 50,
                //                     // width: ,
                //                     child: Text("Select The Lumpsum",
                //                         style: GoogleFonts.poppins(
                //                             textStyle: TextStyle(
                //                                 color: Colors.white,
                //                                 fontWeight:
                //                                 FontWeight.w600)))),
                //                 SingleChildScrollView(
                //                   physics: BouncingScrollPhysics(),
                //                   child: Container(
                //                     height: MediaQuery.of(context)
                //                         .size
                //                         .height /
                //                         1.24,
                //                     child: ListView.builder(
                //                         reverse: true,
                //                         physics: BouncingScrollPhysics(),
                //                         shrinkWrap: true,
                //                         itemCount: lumpsumList.length,
                //                         itemBuilder: (context, index) {
                //                           // print(purchaseOrderList[index]
                //                           //     .name
                //                           //     .toString());
                //                           // print(
                //                           //     "lumpsumlistlength${lumpsumList[index].name}selectedlist${selectedGrade}");
                //                           // print(int.parse(
                //                           //         lumpsumList[index]
                //                           //             .qty!) >=
                //                           //     int.parse(qty.text));
                //                           return LayoutBuilder(builder:
                //                               (context, constraints) {
                //                             if (lumpsumList[index]
                //                                 .status
                //                                 .toString() ==
                //                                 "Confirmed"
                //
                //                             // lumpsumList[index].name ==
                //                             //       "$selectedGrade" &&
                //                             ) {
                //                               print(
                //                                   "entrance............");
                //                               print(
                //                                   "status....................${lumpsumList[index].name}");
                //                               // print(szpct);
                //                               // print(prcpct);
                //                               // print(selectedSize);
                //                               return Container(
                //                                   margin: EdgeInsets.only(
                //                                       top: 10),
                //                                   child: InkWell(
                //                                     onTap: () async {
                //                                       var resorder = await http.post(
                //                                         Uri.parse("http://steefotmtmobile.com/steefo/placeOrder2.php"),
                //                                         body: widget.order.orderType == "Lump-sum"
                //                                             ? {
                //                                           "userId": id1!,
                //                                           // "userId" : widget.order?.user_id,
                //                                           "supplierId": supplier_id,
                //                                           "shippingAddress": widget.order.party_address,
                //                                           "pincode": widget.order.pincode,
                //                                           "region": widget.order.region,
                //                                           "dealerName": widget.order.dealerName,
                //                                           "partyName": widget.order.party_name,
                //                                           "consigneeName": widget.order.consignee_name,
                //                                           "PartygstNumber": widget.order.PartygstNumber,
                //                                           "mobileNumber": widget.order.party_mob_num,
                //                                           // "orderid": widget.order?.orderid,
                //                                           "basePrice": widget.order.base_price,
                //                                           "status": "Pending",
                //                                           "trailerType": "None",
                //                                           "loadingType": "None",
                //                                           "transType": "None",
                //                                           "paymentTerm": "None",
                //                                           // "dealer":selectedDealer,
                //                                           "orderType": "Use Lumpsum",
                //                                           "totalQuantity": widget.order.totalQuantity.toString(),
                //                                           "totalPrice": widget.order.totalPrice.toString(),
                //                                           "deliveryDate": widget.order.deliveryDate,
                //                                           "dateTime": DateTime.now().toString(),
                //                                         }
                //                                             : {
                //                                           "userId": id1!,
                //                                           "supplierId": supplier_id,
                //                                           "shippingAddress": widget.order.party_address,
                //                                           "pincode": widget.order.pincode,
                //                                           "region": widget.order.region,
                //                                           "dealerName": widget.order.org_name,
                //                                           "partyName": widget.order.party_name,
                //                                           "consigneeName": widget.order.consignee_name,
                //                                           "PartygstNumber": widget.order.PartygstNumber,
                //                                           "mobileNumber": widget.order.party_mob_num,
                //                                           // "orderid": orderid.text,
                //                                           "basePrice": widget.order.base_price,
                //                                           "status": "Pending",
                //                                           // "dealer":selectedDealer,
                //                                           "loadingType": widget.order.loading_type,
                //                                           "orderType": "Use Lumpsum",
                //                                           "paymentTerm": widget.order.paymentTerm,
                //                                           "trailerType": widget.order.trailerType,
                //                                           "transType": widget.order.trans_type,
                //                                           "totalQuantity": widget.order.totalQuantity,
                //                                           "totalPrice": widget.order.totalPrice,
                //                                           "deliveryDate": widget.order.deliveryDate,
                //                                           "dateTime": DateTime.now().toString(),
                //                                         },
                //                                       );
                //
                //                                       var responseData = json.decode(resorder.body);
                //                                       if (responseData["status"] == '200' && widget.order.orderType != "Lump-sum") {
                //                                         for (int i = 0; i < listOfColumns1.length; i++) {
                //                                           http.post(
                //                                             Uri.parse("http://steefotmtmobile.com/steefo/setorder.php"),
                //                                             body: {
                //                                               "order_id": responseData["value"].toString(),
                //                                               "name": listOfColumns1[i]["Name"],
                //                                               "qty": listOfColumns1[i]["Qty"],
                //                                               "qty_left": listOfColumns1[i]["Qty"],
                //                                               "price": listOfColumns1[i]["Price"]
                //                                             },
                //                                           );
                //                                           //  print("${listOfColumns[i]["Price"]}...................");
                //                                           //tot_price = tot_price + num.parse(listOfColumns[i]["Price"]);
                //                                         }
                //                                       } else {
                //                                         for (int i = 0; i < listOfColumns1.length; i++) {
                //                                           http.post(
                //                                             Uri.parse("http://steefotmtmobile.com/steefo/addlumpsum.php"),
                //                                             body: {
                //                                               "order_id": responseData["value"].toString(),
                //                                               "name": listOfColumns1[i]["Name"],
                //                                               "qty": listOfColumns1[i]["Qty"],
                //                                               "price": listOfColumns1[i]["Price"],
                //                                               "basePrice": widget.order.base_price,
                //                                             },
                //                                           );
                //                                           //  tot_price = tot_price + int.parse(responseData["data"][i]["price"]);
                //                                         }
                //                                       }
                //
                //                                       await http.post(
                //                                         Uri.parse(
                //                                             "http://steefotmtmobile.com/steefo/approveorder.php"),
                //                                         body: {
                //                                           "decision": "Approved",
                //                                           "order_id": widget.order.order_id!
                //                                         },
                //                                       );
                //                                       widget.order.status = "Confirmed";
                //                                       setState(() {});
                //
                //                                       Navigator.pop(
                //                                           context);
                //
                //                                       // listOfColumns.add({
                //                                       //   "Sr_no": itemNum
                //                                       //       .toString(),
                //                                       //   "Name":
                //                                       //   lumpsumList[
                //                                       //   index]
                //                                       //       .name.toString()+ selectedSize.toString(),
                //                                       //   "Qty": qty.text,
                //                                       //   "Price": selectedTransType ==
                //                                       //       "Ex-Work" &&
                //                                       //       selectedOrderType !=
                //                                       //           "Lump-sum"
                //                                       //       ? (
                //                                       //       (int.parse(lumpsumList[index].basePrice!) +
                //                                       //           tCost + szpct + przpct) *
                //                                       //           int.parse(qty
                //                                       //               .text))
                //                                       //       .toString()
                //                                       //       : ((int.parse(lumpsumList[index]
                //                                       //       .basePrice!)) *
                //                                       //       int.parse(
                //                                       //           qty.text))
                //                                       //       .toString()
                //                                       // });
                //                                       // lumpsumList[index]
                //                                       //     .qty = (int.parse(
                //                                       //     lumpsumList[index]
                //                                       //         .qty!) -
                //                                       //     int.parse(qty
                //                                       //         .text))
                //                                       //     .toString();
                //                                       //
                //                                       // reductionData.add({
                //                                       //   "id": lumpsumList[
                //                                       //   index]
                //                                       //       .ls_id,
                //                                       //   "qty":
                //                                       //   lumpsumList[
                //                                       //   index]
                //                                       //       .qty
                //                                       // });
                //                                       // totalQuantity =
                //                                       //     totalQuantity +
                //                                       //         int.parse(qty
                //                                       //             .text);
                //                                       // itemNum =
                //                                       //     itemNum + 1;
                //                                       // setState(() {});
                //                                       // Navigator.pop(
                //                                       //     context);
                //                                     },
                //                                     child: InventoryCard(
                //                                         context,
                //                                         lumpsumList[
                //                                         index],Order(),id ),
                //                                   ));
                //                             } else {
                //                               return Container();
                //                             }
                //                           });
                //                         }),
                //                   ),
                //                 )
                //               ],
                //             ),
                //           );
                //         },
                //       );
                //
                //       // await http.post(
                //       //   Uri.parse(
                //       //       "http://steefotmtmobile.com/steefo/approveorder.php"),
                //       //   body: {
                //       //     "decision": "Approved",
                //       //     "order_id": requestList[index].order_id!
                //       //   },
                //       // );
                //       // () {
                //       //   // orderList.add(requestList[index]);
                //       //   requestList.removeAt(index);
                //       //   id = "none";
                //       //   setState(() {
                //       //     print('setstate');
                //       //     loadData();
                //       //   });
                //       // }();
                //       // Get.to(RequestPage());
                //     },
                //     child: GradientText(
                //       style:
                //           TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                //       colors: [Colors.greenAccent, Colors.greenAccent],
                //       "Accept",
                //     )),
                //
                // TextButton(
                //     onPressed: () async {
                //
                //       await http.post(
                //         Uri.parse(
                //             "http://steefotmtmobile.com/steefo/approveorder.php"),
                //         body: {
                //           "decision": "Denied",
                //           "order_id": requestList[index].order_id!
                //         },
                //       );
                //       () {
                //         // orderList.add(requestList[index]);
                //         requestList.removeAt(index);
                //         id = "none";
                //         loadData();
                //         setState(() {});
                //         // Get.to(RequestPage());
                //       }();
                //     },
                //     child: GradientText(
                //       style:
                //           TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                //       colors: [Colors.redAccent, Colors.red],
                //       "Decline",
                //     ))
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
                      padding: EdgeInsets.only(top: 20, left: 10),
                      child: Text(
                        order.org_name!.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Color.fromRGBO(19, 59, 78, 1.0),
                          // color: Colors.grey
                        ),
                      )),

                  LayoutBuilder(builder: (context, constraints) {
                    if(order.orderType == "Use Lumpsum"){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("From: " + "${order.orderType.toString()}",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold
                              ),),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("Order id: " + order.orderid.toString(),
                              style: TextStyle(
                                color: Colors.grey,

                              ),),
                          ),
                        ],
                      );
                    }else{
                      return Container();

                    }
                  },)

                  // Container(
                  //     padding: EdgeInsets.only(top: 10),
                  //     child: LayoutBuilder(builder: (context, constraints) {
                  //       if (order.status == "Confirmed") {
                  //         return Container(
                  //             // width: 40,
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: 5, vertical: 5),
                  //             decoration: BoxDecoration(
                  //                 color: Colors.greenAccent,
                  //                 borderRadius: BorderRadius.only(
                  //                     topLeft: Radius.circular(10),
                  //                     bottomLeft: Radius.circular(10))),
                  //             child: Text(
                  //               order.status!,
                  //             ));
                  //       } else {
                  //         return Container();
                  //       }
                  //     })),

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
          padding: const EdgeInsets.only(bottom: 10),
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
