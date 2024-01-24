import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stefomobileapp/pages/DealerDetailPage.dart';
import 'package:stefomobileapp/pages/InformationPage.dart';
import 'package:stefomobileapp/pages/HomePage.dart';
import 'package:stefomobileapp/pages/InventoryPage.dart';
import 'package:stefomobileapp/pages/EditableProfilePage.dart';
import 'package:stefomobileapp/ui/cards.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:http/http.dart' as http;
import '../Models/user.dart';
import '../ui/common.dart';
import 'ProfilePage.dart';

class DistributorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DealerContent();
  }
}

class DealerContent extends StatefulWidget {
  const DealerContent({super.key});
  @override
  State<DealerContent> createState() => _DealerPageState();
}

class _DealerPageState extends State<DealerContent> {
  var _selected = 2;
  @override
  void initState() {
    // TODO: implement initState
    loadChildData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selected == 0) {
          return true;
        }
        setState(() {
          _selected = 0;
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => HomePage(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        });
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appbar("Distributors", () {
          Navigator.pop(context);
        }),
        body: DealerPageBody(),


      ),
    );
  }

  bool isDataReady = false;
  var userType;
  List<User> child = [];
  loadChildData() async {
    child = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = await prefs.getString('id');
    userType = await prefs.getString('userType');
    String uri;
    uri = "http://steefotmtmobile.com/steefo/getchildren.php";

    var res = await http.post(Uri.parse(uri), body: {
      "id": id,
    });

    var responseData = json.decode(res.body);
    print(responseData['data'].length);
    for (int i = 0; i < responseData['data'].length; i++) {
      User u = User();
      u.id = responseData["data"][i]["id"];
      u.userType = responseData["data"][i]["userType"];
      u.orgName = responseData["data"][i]["orgName"];
      u.address = responseData["data"][i]["address"];
      u.email = responseData["data"][i]["email"];
      u.mobileNumber = responseData["data"][i]["mobileNumber"];
      u.gstNumber = responseData["data"][i]["gstNumber"];
      u.panNumber = responseData["data"][i]["panNumber"];
      u.adhNumber = responseData["data"][i]["adhNumber"];
      print(u);
      child.add(u);
    }

    isDataReady = true;
    setState(() {});
  }

  Widget DealerPageBody() {
    //loadChildData();
    return LayoutBuilder(builder: (context, constraints) {
      if (isDataReady) {
        return Container(
          margin: EdgeInsets.only(top: 20),
          child: LayoutBuilder(builder: (context, constraints) {
            if (userType == "Manufacturer") {
              return ListView.builder(
                  //  physics: BouncingScrollPhysics(),
                  itemCount: child.length,
                  itemBuilder: (context, index) {
                    print("usertype${child[index].userType}");
                    return Column(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DistributorDetailPage(
                                              user: child[index])));
                            },
                            child: DistributorCard(child[index], context)),
                        // SizedBox(
                        //   height: 10,
                        // )
                      ],
                    );
                  });
            } else if (userType == "Builder") {
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: child.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                            overlayColor:
                                MaterialStatePropertyAll(Colors.white),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DistributorDetailPage(
                                              user: child[index])));
                            },
                            child: DistributorCard(child[index], context)),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  });
            } else {
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: child.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                            overlayColor:
                                MaterialStatePropertyAll(Colors.white),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DistributorDetailPage(
                                              user: child[index])));
                            },
                            child: DistributorCard(child[index], context)),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  });
            }
          }),
        );
      } else {
        return Center(
            child: CircularProgressIndicator(
          color: Colors.grey,
        ));
      }
    });
  }
}
