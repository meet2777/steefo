import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stefomobileapp/Models/challan.dart';
import "package:http/http.dart" as http;
import 'package:stefomobileapp/pages/HomePage.dart';
import '../Models/order.dart';
import '../Models/user.dart';
import '../ui/common.dart';
import 'GenerateChallanPage.dart';
import 'GeneratedChallanPage.dart';

class ChallanListPage extends StatelessWidget {
  final Order order;
  ChallanListPage({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    return ChallanListContent(
      order: order,
    );
  }
}

class ChallanListContent extends StatefulWidget {
  final Order order;
  ChallanListContent({super.key, required this.order});
  final selected = 0;
  @override
  State<ChallanListContent> createState() => _ChallanListPageState();
}

class _ChallanListPageState extends State<ChallanListContent> {
  var _selected = 0;

  User u = User();

  @override
  Widget build(BuildContext context) {
    print("${widget.order.items}orderitems  ");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar("Challan", () {
        Navigator.pop(context);
      }),
      body: ChallanListBody(),
     
    );
  }

  int flag = 0;
  String? id;
  // String? userType;
  List<Challan> challanList = [];
  loadChallanList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    id = await prefs.getString('id');
    if (flag == 0) {
      final res = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/getchallanlist.php"),
        body: {"order_id": widget.order.order_id},
      );
      var responseData = jsonDecode(res.body);
      print(responseData);

      for (int i = 0; i < responseData["data"].length; i++) {
        Challan ch = Challan();
        ch.order_id = responseData["data"][i]["order_id"];
        ch.challan_id = responseData["data"][i]["challan_id"].toString();
        ch.transporter_name = responseData["data"][i]["transporter_name"];
        ch.vehicle_number = responseData["data"][i]["vehicle_number"];
        ch.lr_number = responseData["data"][i]["lr_number"];
        ch.deliveryChallan = responseData["data"][i]["deliveryChallan"];
        challanList.add(ch);
      }
      flag = 1;
      setState(() {});
    }

    var test = await http.post(
      Uri.parse(
        'http://steefotmtmobile.com/steefo/getrequests.php',
      ),
    );
    //Navigator.of(context).pushNamed("/home");

    var responseData = jsonDecode(test.body);
    // print("remaining qty"+ qty.qty_left.toString());
    print("enter1");
    print(responseData);
    for (int i = 0; i < responseData['data'].length; i++) {
      print("enter2");
      User u = User();
      u.id = responseData['data'][i]['id'];
      u.firstName = responseData['data'][i]['firstName'];
      u.lastName = responseData['data'][i]['lastName'];
      u.email = responseData['data'][i]['email'];
      u.mobileNumber = responseData['data'][i]['mobileNumber'];
      u.parentId = responseData['data'][i]['parentId'];
      u.userType = responseData['data'][i]['userType'];
      u.userStatus = responseData['data'][i]['userStatus'];
      u.orgName = responseData['data'][i]['orgName'];
      u.gstNumber = responseData['data'][i]['gstNumber'];
      u.panNumber = responseData['data'][i]['panNumber'];
      u.adhNumber = responseData['data'][i]['adhNumber'];
      u.address = responseData['data'][i]['address'];
      u.uploadedFile = responseData['data'][i]['uploadedFile'];
      // regReqList.add(u);
      print("enter3");
      print(widget.order.userType.toString());
    }
  }

  //-----------------------------------ChallanListMainBody----------------------

  Widget ChallanListBody() {
    loadChallanList();
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // height: 40,
            alignment: Alignment.center,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: Color.fromRGBO(19, 59, 78, 1.0),
            ),
            // decoration: BoxDecoration(
            //     color: Colors.lightBlueAccent,
            //     borderRadius: BorderRadius.all(Radius.circular(10))
            //     // borderRadius: BorderRadius.circular(20)
            //     ),
            // width: MediaQuery.of(context).size.width * 0.8,
            margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
            // padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ORDER ID:",
                  style: TextStyle(
                      //fontFamily: "Poppins_Bold",
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.order.order_id.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              // reverse: true,
              itemCount: challanList.length,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GeneratedChallan(
                                    challan_id: challanList[index].challan_id!,
                                  )));
                    },
                    child: ChallanCard(context, challanList[index]));
              },
            ),
          ),
          LayoutBuilder(builder: (context, constraints) {
            if (widget.order.userType != "Dealer") {
              return Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: buttonStyle("Generate Challan", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GenerateChallanPage(
                                  order: widget.order,
                                )));
                  }));
              // } else {
              //   return Container();
              // }
            }else{
              return Container();
            }
          }
            ),
          SizedBox(
            height: 10,
          ),
          LayoutBuilder(builder: (context, constraints) {
            if (widget.order.orderStatus == "Confirmed") {
              return GestureDetector(
                onTap: () async {
                  await http.post(
                    Uri.parse(
                        "http://steefotmtmobile.com/steefo/approveorder.php"),
                    body: {
                      "decision": "Completed",
                      "order_id": widget.order.order_id
                    },
                  );
                      () {
                    // orderList.add(requestList[index]);
                    // requestList.removeAt(index);
                    // id = "none";
                    // requestList.removeAt(index);
                    // loadData();
                    setState(() {});
                    Get.to(HomePage());
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
              );
          }else{
              return Container();
            }
          }
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  //----------------------------SingleChallanCard-------------------------------

  Widget ChallanCard(context, Challan challan) {
    String trp_name = "XY Transporter";

    return Container(
      margin: EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey.shade100,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child: const Text(
                "Challan No:",
                textAlign: TextAlign.left,
                style: TextStyle(fontFamily: "Poppins_Bold"),
              )),
              Container(
                  padding: EdgeInsets.only(left: 65),
                  child: Text(
                    challan.challan_id!.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "Poppins_Bold"),
                  ))
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "Transporter Name:",
                    style: TextStyle(fontFamily: "Poppins_Bold"),
                  ),
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                ),
                Container(
                  child: Text(
                    challan.transporter_name!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(fontFamily: "Poppins_Bold"),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Vehicle Number:",
                  style: TextStyle(fontFamily: "Poppins_Bold"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 36.0),
                  child: Text(
                    challan.vehicle_number!,
                    style: TextStyle(fontFamily: "Poppins_Bold"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
