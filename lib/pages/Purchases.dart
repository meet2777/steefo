import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stefomobileapp/Models/lumpsum.dart';
import 'package:stefomobileapp/Models/order.dart';
import 'package:http/http.dart' as http;
import 'package:stefomobileapp/pages/HomePage.dart';
// import 'package:stefomobileapp/pages/OrderPage.dart';
import 'package:stefomobileapp/pages/OrderDetailsForPurchases.dart';
import 'package:stefomobileapp/ui/cards.dart';
import 'package:stefomobileapp/ui/common.dart';
import 'package:stefomobileapp/ui/custom_tabbar.dart';

class purchases extends StatefulWidget {
  const purchases({super.key});

  @override
  State<purchases> createState() => _purchasesState();
}

class _purchasesState extends State<purchases> {
  List<Order> purchaseOrderList = [];
  List<Order> salesOrderList = [];
  String? id = "";

  Order order = Order();
  // Lumpsum lumpsum = Lumpsum();
  var user_type;
  void loadusertype() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user_type = await prefs.getString('userType');
  }

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
        req.date = responseData["data"][i]["dateTime"];
        req.totalPrice = responseData["data"][i]["totalPrice"];
        req.userType = responseData["data"][i]["userType"];
        req.pincode = responseData["data"][i]["pincode"];
        req.totalQuantity = responseData["data"][i]["totalQuantity"];
        req.reciever_id = responseData["data"][i]["supplier_id"];
        req.user_id = responseData["data"][i]["user_id"];
        req.orderid = responseData["data"][i]["orderid"];
        req.user_mob_num = responseData["data"][i]["mobileNumber"];
        req.org_name = responseData["data"][i]["orgName"];
        req.user_name = responseData["data"][i]["firstName"] + " " + responseData["data"][i]["lastName"];
        req.trans_type = responseData["data"][i]["transType"];
        req.status = responseData["data"][i]["orderStatus"];
        req.region = responseData["data"][i]["region"];
        req.paymentTerm = responseData["data"][i]["paymentTerm"];
        req.party_name = responseData["data"][i]["partyName"];
        req.dealerName = responseData["data"][i]["dealerName"];
        req.consignee_name = responseData["data"][i]["consigneeName"];
        req.PartygstNumber = responseData["data"][i]["PartygstNumber"];
        req.party_address = responseData["data"][i]["shippingAddress"];
        req.billing_address = responseData["data"][i]["address"];
        req.party_mob_num = responseData["data"][i]["partyMobileNumber"];
        req.loading_type = responseData["data"][i]["loadingType"];
        req.trailerType = responseData["data"][i]["trailerType"];
        req.order_date = responseData["data"][i]["createdAt"];
        req.base_price = responseData["data"][i]["basePrice"];
        req.orderType = responseData["data"][i]["orderType"];
        req.orderStatus = responseData["data"][i]["orderStatus"];
        req.order_id = responseData["data"][i]["order_id"].toString();

         // print(purchaseOrderList);
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

  // void initState() {
  //   super.initState();
  //   loadData();
  // }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar("Purchases", () {
        Get.to(() => HomePage());
      }),
      body: SingleChildScrollView(
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
            tabBarItems: ["With Size", "Lump-sums", "Completed"],
            tabViewItems: [withsize(), lumpsum(), completed()]),
      ),
    );
  }

  Widget withsize() {
    // loadData();
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: ListView.builder(
              reverse: true,
                itemCount: purchaseOrderList.length,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderDetailsforpurchases(
                                    order: purchaseOrderList[index])));
                      },
                      child: purchaseOrderList[index].orderType == "With Size" || purchaseOrderList[index].orderType == "Use Lumpsum"
                          && (purchaseOrderList[index].status == "Confirmed" || purchaseOrderList[index].status == "Pending")
                          ? orderCard(context, purchaseOrderList[index], id)
                          : Container());
                }),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  Widget lumpsum() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: ListView.builder(
              reverse: true,
              itemCount: purchaseOrderList.length,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                print(purchaseOrderList[index].order_id);
                //  if (purchaseOrderList[index].orderType == "Lump-sum") {}
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderDetailsforpurchases(
                                  order: purchaseOrderList[index])));
                    },
                    child: purchaseOrderList[index].orderType == "Lump-sum" &&
                            (purchaseOrderList[index].status == "Confirmed" ||
                                purchaseOrderList[index].status == "Pending")
                        ? orderCard(context, purchaseOrderList[index], id)
                        : Container());
              },
            ),
          ),

          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget completed() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: ListView.builder(
              reverse: true,
                itemCount: purchaseOrderList.length,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderDetailsforpurchases(
                                    order: purchaseOrderList[index])));
                      },
                      child: purchaseOrderList[index].status != "Confirmed" &&
                              purchaseOrderList[index].status != "Pending"
                          ? orderCard(context, purchaseOrderList[index], id)
                          : Container());
                }
                ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  // Widget PurchaseOrderList() {
  //   return Container(
  //       decoration: const BoxDecoration(
  //         color: Color.fromRGBO(255, 255, 255, 0.5),
  //         // borderRadius: BorderRadius.circular(5)
  //       ),
  //       height: 50,
  //       margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //       child: SingleChildScrollView(
  //         physics: BouncingScrollPhysics(),
  //         child: Column(
  //           children: [
  //             Container(
  //               child: ListView.builder(
  //                 itemCount: purchaseOrderList.length,
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 scrollDirection: Axis.vertical,
  //                 shrinkWrap: true,
  //                 itemBuilder: (context, index) {
  //                   return InkWell(
  //                       onTap: () {
  //                         Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) => OrderDetails(
  //                                     order: purchaseOrderList[index])));
  //                       },
  //                       child:
  //                           orderCard(context, purchaseOrderList[index], id));
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ));
  // }
}
