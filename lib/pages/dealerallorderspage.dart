import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stefomobileapp/Models/order.dart';
import 'package:stefomobileapp/Models/user.dart';

import 'package:stefomobileapp/pages/HomePage.dart';
import 'package:stefomobileapp/pages/OrderPage.dart';
import 'package:stefomobileapp/ui/cards.dart';
import 'package:http/http.dart' as http;

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
        Uri.parse("http://steefotmtmobile.com/steefo/vieworder.php"),
        body: {"id": widget.user.id},
      );
      print("${widget.user.id}widgetuserid");
      var responseData = jsonDecode(res.body);
      for (int i = 0; i < responseData["data"].length; i++) {
        Order req = Order();
        req.org_name = responseData["data"][i]["orgName"];
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
        req.pincode = responseData["data"][i]["pincode"];
        req.party_name = responseData["data"][i]["partyName"];
        req.consignee_name = responseData["data"][i]["consigneeName"];
        req.trans_type = responseData["data"][i]["transType"];
        req.trailerType = responseData["data"][i]["trailerType"];
        req.PartygstNumber = responseData["data"][i]["PartygstNumber"];
        req.gstNumber = responseData["data"][i]["gstNumber"];
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
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Dealer's order",
          style: const TextStyle(
              color: Color.fromRGBO(19, 59, 78, 1), fontFamily: "Poppins_Bold"),
        ),
        leading: IconButton(
            onPressed: () {
              navigator!.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                Get.to(HomePage());
              },
              child: SvgPicture.asset(
                "assets/images/logo.svg",
                // fit: BoxFit.fill,
                // color: Colors.green,
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            Material(
              color: Colors.white,
              child: TabBar(
                indicatorColor: Colors.blueGrey,
                indicator: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10)),
                labelColor: Colors.black,
                isScrollable: true,
                tabs: [
                  Tab(
                    child: Text(
                      "REQUESTS",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "DENIED",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "CANCELED",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "CONFIRMED",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "COMPLETED",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: TabBarView(physics: BouncingScrollPhysics(), children: [
                requests(context),
                denied(context),
                canceled(context),
                confirmed(context),
                completed(context),
              ]),
            )
          ],
        ),
      ),

    
    );
  }

  Widget requests(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        // height: 100,
        // color: Colors.amber,
        child: ListView.builder(
          reverse: true,
          itemCount: orderList.length,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            print(orderList.length);
            return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OrderDetails(order: orderList[index])));
                },
                child: orderList[index].status == "Pending"
                    ? orderCard(context, orderList[index], widget.user.id)
                    : Container());
          },
        ),
      ),
    );
  }

  Widget denied(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        // height: 100,
        // color: Colors.amber,
        child: ListView.builder(
          reverse: true,
          itemCount: orderList.length,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            print(orderList.length);
            return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OrderDetails(order: orderList[index])));
                },
                child: orderList[index].status == "Denied"
                    ? orderCard(context, orderList[index], widget.user.id)
                    : Container());
          },
        ),
      ),
    );
  }

  Widget canceled(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        // height: 100,
        // color: Colors.amber,
        child: ListView.builder(
          reverse: true,
          itemCount: orderList.length,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            print(orderList.length);
            return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OrderDetails(order: orderList[index])));
                },
                child: orderList[index].status == "Canceled"
                    ? orderCard(context, orderList[index], widget.user.id)
                    : Container());
          },
        ),
      ),
    );
  }

  Widget confirmed(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        // height: 100,
        // color: Colors.amber,
        child: ListView.builder(
          reverse: true,
          itemCount: orderList.length,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            print(orderList.length);
            return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OrderDetails(order: orderList[index])));
                },
                child: orderList[index].status == "Confirmed"
                    ? orderCard(context, orderList[index], id)
                    : Container());
          },
        ),
      ),
    );
  }

  Widget completed(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        // height: 100,
        // color: Colors.amber,
        child: ListView.builder(
          reverse: true,
          itemCount: orderList.length,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            print(orderList.length);
            return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OrderDetails(order: orderList[index])));
                },
                child: orderList[index].status == "Completed"
                    ? orderCard(context, orderList[index], widget.user.id)
                    : Container());
          },
        ),
      ),
    );
  }
}
