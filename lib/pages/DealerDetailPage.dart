import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stefomobileapp/UI/common.dart';
import 'package:stefomobileapp/pages/DealerAllOrdersPage.dart';
// import 'package:stefomobileapp/ui/cards.dart';
import 'package:http/http.dart' as http;
import '../Models/order.dart';
import '../Models/user.dart';
// import 'OrderPage.dart';

class DealerDetailPage extends StatelessWidget {
  final User user;
  DealerDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return DealerDetailContent(
      user: user,
    );
  }
}

class DealerDetailContent extends StatefulWidget {
  final User user;
  DealerDetailContent({super.key, required this.user});

  @override
  State<StatefulWidget> createState() {
    return DealerDetailState();
  }
}

class DealerDetailState extends State<DealerDetailContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar("Dealer Info", () {
        Navigator.pop(context);
      }),
      body: DealerDetailPageBody(),
    );
  }

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
        req.date = responseData["data"][i]["dateTime"];
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
        req.region = responseData["data"][i]["region"];
        req.PartygstNumber = responseData["data"][i]["PartygstNumber"];
        req.gstNumber = responseData["data"][i]["gstNumber"];
        req.pincode = responseData["data"][i]["pincode"];
        req.party_name = responseData["data"][i]["partyName"];
        req.paymentTerm = responseData["data"][i]["paymentTerm"];
        req.party_address = responseData["data"][i]["shippingAddress"];
        req.party_mob_num = responseData["data"][i]["partyMobileNumber"];
        req.loading_type = responseData["data"][i]["loadingType"];
        req.trans_type = responseData["data"][i]["transType"];
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

  Widget DealerDetailPageBody() {
    loadOrderList();
    return Column(
      children: [
        Stack(
          children: [
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Text(
                          widget.user.orgName!,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color.fromRGBO(19, 59, 78, 1.0),
                                  // color: Color.fromARGB(255, 129, 18, 18)
                              )),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          widget.user.address!,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontSize: 15)),
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Email Id :",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))),
                          Text(
                            widget.user.email!,
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Mobile Number :",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))),
                          Text(
                            widget.user.mobileNumber!,
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Gst Number :",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))),
                          Text(
                            widget.user.gstNumber!,
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("PAN Number :",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))),
                          Text(
                            widget.user.panNumber!,
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Aadhar Number :",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))),
                          Text(
                            widget.user.adhNumber!,
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),


        Expanded(
          //  flex: 1,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  dealerallorderpage(user: widget.user)));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "VIEW ORDERS",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(19, 59, 78, 1.0),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
