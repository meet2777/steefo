import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stefomobileapp/Models/order.dart';
import 'package:stefomobileapp/Models/user.dart';
import 'package:stefomobileapp/UI/common.dart';
import 'package:stefomobileapp/pages/DealerDetailPage.dart';
import 'package:stefomobileapp/pages/OrderPage.dart';
import 'package:stefomobileapp/ui/cards.dart';
import 'package:http/http.dart' as http;
import 'package:stefomobileapp/ui/custom_tabbar.dart';

class dealerallorderpage extends StatefulWidget {
  User user;
  dealerallorderpage({super.key, required this.user});

  @override
  State<dealerallorderpage> createState() => _dealerallorderpageState();
}

class _dealerallorderpageState extends State<dealerallorderpage> {
  var f = 0;
  String? id;
  List<Order> orderList = [];
  loadOrderList() async {
    if (f == 0) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      id = await prefs.getString('id');
      orderList = [];
      final res = await http.post(
        Uri.parse("http://urbanwebmobile.in/steffo/vieworder.php"),
        body: {"id": widget.user.id},
      );
      print("${widget.user.id}widgetuserid");
      var responseData = jsonDecode(res.body);
      for (int i = 0; i < responseData["data"].length; i++) {
        Order req = Order();
        req.date = responseData["data"][i]["dateTime"];
        req.deliveryDate = responseData["data"][i]["deliveryDate"];
        req.totalPrice = responseData["data"][i]["totalPrice"];
        req.totalQuantity = responseData["data"][i]["totalQuantity"];
        req.reciever_id = responseData["data"][i]["supplier_id"];
        req.user_id = responseData["data"][i]["user_id"];
        req.user_mob_num = responseData["data"][i]["mobileNumber"];
        req.user_name = responseData["data"][i]["firstName"] +
            " " +
            responseData["data"][i]["lastName"];
        req.status = responseData["data"][i]["orderStatus"];
        req.party_name = responseData["data"][i]["partyName"];
        req.party_address = responseData["data"][i]["shippingAddress"];
        req.party_mob_num = responseData["data"][i]["partyMobileNumber"];
        req.loading_type = responseData["data"][i]["loadingType"];
        req.order_date = responseData["data"][i]["createdAt"];
        req.base_price = responseData["data"][i]["basePrice"];
        req.order_id = responseData["data"][i]["order_id"].toString();

        //print(req);
        // if (req.status != "Denied" && req.status != "Pending") {
        orderList.add(req);

        /// }
      }
      f = 1;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadOrderList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar("Dealer's Orders", () {
        Navigator.pop(context);
      }),
      body: DefaultTabController(
        length: 5,
          // selectedCardColor: Colors.blueGrey,
          // selectedTitleColor: Colors.white,
          // unSelectedTitleColor: Colors.black,
          // shape:
          //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          // unSelectedCardColor: Colors.white,
          // titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          // // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          // tabBarItemExtend: ((MediaQuery.of(context).size.width) / 4),
          // // tabBarItems: ["Orders", "Requests"],
          // tabBarItems: [
          //   "REQUESTS",
          //   "DENIED",
          //   "CANCELED",
          //   "CONFIRMED",
          //   "COMPLETED",
          // ],
          // tabViewItems: [OrdersPageBody(), OrderList1()]
        ),
      //     Container(
      //   padding: EdgeInsets.only(left: 10, right: 10),
      //   // height: 100,
      //   // color: Colors.amber,
      //   child: ListView.builder(
      //     itemCount: orderList.length,
      //     physics: BouncingScrollPhysics(),
      //     scrollDirection: Axis.vertical,
      //     shrinkWrap: true,
      //     itemBuilder: (context, index) {
      //       print(orderList.length);
      //       return InkWell(
      //           onTap: () {
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) =>
      //                         OrderDetails(order: orderList[index])));
      //           },
      //           child: orderList[index].status == "Confirmed"
      //               ? orderCard(context, orderList[index], widget.user.id)
      //               : Container());
      //     },
      //   ),
      // ),
    );
  }
}
