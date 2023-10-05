import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stefomobileapp/UI/common.dart';
import 'package:http/http.dart' as http;
import 'package:stefomobileapp/pages/pdfView.dart';
import '../Models/user.dart';

class UserRequestPage extends StatelessWidget {
  final User user;
  UserRequestPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    loadDistributors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar("Requests", () {
        print("Back Pressed");
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 10)),
            Card(
              margin: EdgeInsets.only(left: 5,right: 5),
              child: Container(
                color: Colors.grey.shade100,
                // height: 100,
                width: 700,
                // alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                // color: Colors.green,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Padding(padding: EdgeInsets.only(left: 10)),
                        Text(user.orgName!,
                            style: TextStyle(
                              fontFamily: "Poppins_Bold",
                              fontSize: 20,
                              color: Color.fromRGBO(19, 59, 78, 1),
                            )),
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                                // color: Colors.white,
                                color: Color.fromRGBO(19, 59, 78, 1),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))),
                            child: Text(
                              user.userType!,
                                style: TextStyle(
                                        fontFamily: "Poppins_Bold",
                                        fontSize: 17,
                                        color: Colors.white,
                                      )
                            )
                        )

                        //
                        // Text(user.userType!,
                        //     textAlign: TextAlign.center,
                        //     style: TextStyle(
                        //       fontFamily: "Poppins_Bold",
                        //       fontSize: 17,
                        //       color: Colors.green,
                        //     )),
                      ],
                    ),
                    // Text(user.userType!,
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //       fontFamily: "Poppins_Bold",
                    //       fontSize: 17,
                    //       color: Colors.green,
                    //     )),
                    // // SizedBox(height: 10),
                    // Text(user.orgName!,
                    //     style: TextStyle(
                    //       fontFamily: "Poppins_Bold",
                    //       fontSize: 20,
                    //       color: Color.fromRGBO(19, 59, 78, 1),
                    //     )),
                    SizedBox(height: 10),
                    Text(user.address!,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15,
                          color: Colors.grey,
                        ))
                  ],
                ),
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
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Person Name:",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Poppins_Bold")),
                    Text(user.firstName! +" "+ user.lastName!,
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
                    const Text("Contact No:",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Poppins_Bold")),
                    Text(user.mobileNumber!,
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
                    const Text("Email:",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Poppins_Bold")),
                    Text(user.email!,
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
                    const Text("Pan No:",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Poppins_Bold")),
                    Text(user.panNumber!,
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
                    const Text("Aadhar No:",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Poppins_Bold")),
                    Text(user.adhNumber!,
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
                    const Text("GST No:",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Poppins_Bold")),
                    Text(user.gstNumber!,
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
                    const Text("Registered Date:",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Poppins_Bold")),
                  Text(user.date!,
                        style: const TextStyle(
                            fontSize: 15, fontFamily: "Poppins"))
                  ],
                )
            ),


            // Container(
            //   // width: 500,
            //   padding: EdgeInsets.only(top: 20, bottom: 20, left: 10),
            //   child: Row(
            //     children: [
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           // Padding(padding: EdgeInsets.only(top: 10,bottom: 10)),
            //           Text("Person Name:",
            //               style: TextStyle(
            //                   fontFamily: "Poppins_Bold",
            //                   fontSize: 15,
            //                   color: Color.fromRGBO(19, 59, 78, 1))),
            //           SizedBox(height: 20),
            //           Text("Contact No.:",
            //               style: TextStyle(
            //                   fontFamily: "Poppins_Bold",
            //                   fontSize: 15,
            //                   color: Color.fromRGBO(19, 59, 78, 1))),
            //           SizedBox(height: 20),
            //           Text("Email:",
            //               style: TextStyle(
            //                   fontFamily: "Poppins_Bold",
            //                   fontSize: 15,
            //                   color: Color.fromRGBO(19, 59, 78, 1))),
            //           SizedBox(height: 20),
            //           Text("PAN Number:",
            //               style: TextStyle(
            //                   fontFamily: "Poppins_Bold",
            //                   fontSize: 15,
            //                   color: Color.fromRGBO(19, 59, 78, 1))),
            //           SizedBox(height: 20),
            //           Text("Aadhar No.:",
            //               style: TextStyle(
            //                   fontFamily: "Poppins_Bold",
            //                   fontSize: 15,
            //                   color: Color.fromRGBO(19, 59, 78, 1))),
            //           SizedBox(height: 20),
            //           Text("GST Number:",
            //               style: TextStyle(
            //                   fontFamily: "Poppins_Bold",
            //                   fontSize: 15,
            //                   color: Color.fromRGBO(19, 59, 78, 1))),
            //           SizedBox(height: 20),
            //           Text("Registered  date:",
            //               style: TextStyle(
            //                   fontFamily: "Poppins_Bold",
            //                   fontSize: 15,
            //                   color: Color.fromRGBO(19, 59, 78, 1))),
            //         ],
            //       ),
            //       SizedBox(width: 4),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           // Padding(padding: EdgeInsets.only(top: 10,bottom: 10)),
            //           Text(user.firstName! +" "+ user.lastName!,
            //               style: TextStyle(
            //                   fontFamily: "Poppins",
            //                   fontSize: 15,
            //                   color: Colors.grey)),
            //           SizedBox(height: 20),
            //           Text(user.mobileNumber!,
            //               style: TextStyle(
            //                   fontFamily: "Poppins",
            //                   fontSize: 15,
            //                   color: Colors.grey)),
            //           SizedBox(height: 20),
            //           // Text("98765432",style: TextStyle(fontFamily: "Poppins", fontSize: 15, color: Colors.grey)
            //           // ),
            //           // SizedBox(height:20),
            //           Container(
            //             width: 200,
            //             // color: Colors.amber,
            //             child: Text(user.email!,
            //                 maxLines: 1,
            //                 style: TextStyle(
            //                     fontFamily: "Poppins",
            //                     // overflow: TextOverflow.ellipsis,
            //                     fontSize: 15,
            //                     color: Colors.grey)),
            //           ),
            //           SizedBox(height: 20),
            //           Text(user.panNumber!,
            //               style: TextStyle(
            //                   fontFamily: "Poppins",
            //                   fontSize: 15,
            //                   color: Colors.grey)),
            //           SizedBox(height: 20),
            //           Text(user.adhNumber!,
            //               style: TextStyle(
            //                   fontFamily: "Poppins",
            //                   fontSize: 15,
            //                   color: Colors.grey)),
            //           SizedBox(height: 20),
            //           Text(user.gstNumber!,
            //               style: TextStyle(
            //                   fontFamily: "Poppins",
            //                   fontSize: 15,
            //                   color: Colors.grey)),
            //           SizedBox(height: 20),
            //           Text(user.date.toString().substring(0, 10),
            //               style: TextStyle(
            //                   fontFamily: "Poppins",
            //                   fontSize: 15,
            //                   color: Colors.grey)),
            //
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            Container(
              child: buttonStyle("View Document",(){
                print("Press View Download===>${user.uploadedFile}");
                if(user.uploadedFile != null){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => pdfViewPage(
                              user: user)));

                  // Navigator.of(context).pushNamed("/pdfView");
                }
              }),
            ),

            // ElevatedButton(onPressed: (){
            //   print("Press View Download===>${user.uploadedFile}");
            //   if(user.uploadedFile != null){
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => pdfViewPage(
            //                 user: user)));
            //
            //     // Navigator.of(context).pushNamed("/pdfView");
            //   }
            //
            // },
            //     child: Text("View Documents",  )),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                  child: Text("APPROVE",style: TextStyle(fontSize: 18),),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(102, 178, 83, 1.0)),
                  onPressed: () async {
                    var f = 0;
                    if (user.userType == "Dealer") {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: DistributorDialog(context),
                            );
                            // final res = await http.post(
                            //   Uri.parse(
                            //       "http://urbanwebmobile.in/steffo/approveuser.php"),
                            //   body: {"decision": "Approve", "id": user.id},
                            // );
                          });
                    } else {
                      final res = await http.post(
                        Uri.parse(
                            "http://steefotmtmobile.com/steefo/setdealerparent.php"),
                        body: {"id": user.id, "parentId": "0"},
                      );
                      Fluttertoast.showToast(
                          msg: 'user request is Approved',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.greenAccent,
                          textColor: Colors.black);
                      Navigator.popUntil(context, ModalRoute.withName('/home'));
                    }
                  }),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 113, 91)),
                  onPressed: () async {
                    final res = await http.post(
                      Uri.parse(
                          "http://steefotmtmobile.com/steefo/approveuser.php"),
                      body: {"decision": "Reject", "id": user.id},
                    );
                    Fluttertoast.showToast(
                        msg: 'user request is Rejected',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white);
                    Navigator.of(context).pushNamed("/home");
                    // {
                    //   if (route.isFirst) {
                    //     return false;
                    //   } else {
                    //     return true;
                    //   }
                    // }
                  },
                  child: Text("REJECT",style: TextStyle(fontSize: 18),)),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  var f = 0;
  List<User> distributors = [];
  loadDistributors() async {
    if (f == 0) {
      final res = await http.post(
          Uri.parse("http://steefotmtmobile.com/steefo/getdistributors.php"));
      var responseData = jsonDecode(res.body);
      for (int i = 0; i < responseData["data"].length; i++) {
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
        u.date = responseData['data'][i]['registeredDate'];
        u.uploadedFile = responseData['data'][i]['uploadedFile'];
        distributors.add(u);
      }
      f = 1;
    }
  }

  Widget DistributorDialog(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          // Container(
          //   child: Text(
          //     "Dealer Address",
          //     style: TextStyle(fontFamily: "Poppins_Bold"),
          //   ),
          // ),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 20),
          //   child: Text(
          //     user.address!,
          //     style: TextStyle(fontFamily: "Poppins"),
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "Select Distributor",
              style: TextStyle(fontFamily: "Poppins_Bold"),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Container(
                child: ListView.builder(
                  reverse: true,
                  itemCount: distributors.length,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () async {
                          var f = 0;
                          {
                            if (f == 0) {
                              final res = await http.post(
                                Uri.parse(
                                    "http://steefotmtmobile.com/steefo/setdealerparent.php"),
                                body: {
                                  "id": user.id,
                                  "parentId": distributors[index].id
                                },
                              );
                            }
                            f = 1;
                          }
                          if (f == 1) {
                            Navigator.popUntil(
                                context, ModalRoute.withName('/home'));
                          }
                        },
                        child: Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          elevation: 4,
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  distributors[index].orgName!,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 20,color: Colors.white),
                                ),
                                // margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                      color: Color.fromRGBO(19, 59, 78, 1.0),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)
                                    )
                                ),
                                // width: 300,
                                width: MediaQuery.of(context).size.width/1,
                                // color: Color.fromRGBO(19, 59, 78, 1.0),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(left: 10),
                                  margin: EdgeInsets.only(bottom: 10,top: 5),
                                  child: Text(distributors[index].mobileNumber!,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 15)
                                  )
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(left: 10),
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text(distributors[index].address!,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 15,)
                                  )
                              ),
                            ],
                          ),
                        ));
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
