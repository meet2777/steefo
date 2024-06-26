import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gallery_saver/files.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stefomobileapp/Models/order.dart';
import 'package:stefomobileapp/pages/Buyers.dart';
// import 'package:stefomobileapp/pages/EditableProfilePage.dart';
import 'package:stefomobileapp/pages/InventoryPage.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

// import '../Models/order.dart';
import '../Models/user.dart';
// import '../UI/common.dart';
// import 'DistributorsPage.dart';
import '../ui/common.dart';
import 'EditableProfilePage.dart';
import 'HomePage.dart';
import 'package:http/http.dart' as http;

import 'LoginPage.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileContent();
  }
}

class ProfileContent extends StatefulWidget {
  ProfileContent({super.key});
  // final selected = 0;
  @override
  State<ProfileContent> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileContent> {
  String? id,
      firstName,
      lastName,
      email,
      mobileNumber,
      address,
      orgName,
      adhNumber,
      gstNumber,
      panNumber;
  var f = 0;
  bool isDataLoaded = false;
  User user = User();
  var user_type;

  loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user_type = await prefs.getString('userType');

    if (f == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      user.id = await prefs.getString('id');
      user.firstName = await prefs.getString('firstName');
      user.lastName = await prefs.getString("lastName");
      user.email = await prefs.getString("email");
      user.mobileNumber = await prefs.getString("mobileNumber");
      user.orgName = await prefs.getString("orgName");
      user.gstNumber = await prefs.getString("gstNumber");
      user.panNumber = await prefs.getString("panNumber");
      user.adhNumber = await prefs.getString("adhNumber");
      user.address = await prefs.getString("address");
      user.userType = await prefs.getString("userType");
      print(user.userType);
      f = 1;
      isDataLoaded = true;
      setState(() {});
    }
  }

  var _selected = 3;
  onRegister() async {
    Navigator.of(context).pushNamed("/editprofile");
  }

  void initState() {
    super.initState();
    loadData();
  }

  Future onDelete() async {
    await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/deleteuser1.php"),
        body: {
          "id" : user.id,
        });

    // var responseData = json.decode(res.body);
    Navigator.of(context).pushNamed('/login');
  }

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    loadData();
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
          appBar: appbar("Profile", () {
            Get.to(HomePage());
          }),
          // appBar: AppBar(
          //   actions: [
          //     // IconButton(
          //     //     onPressed: () {},
          //     //     icon: const Icon(
          //     //       Icons.check,
          //     //       color: Colors.black,
          //     //       size: 30,
          //     //     )
          //     // )
          //   ],
          //   title: Center(
          //       child: Text("Profile",
          //         // textAlign: TextAlign.center,
          //         style: const TextStyle(
          //             color: Color.fromRGBO(19, 59, 78, 1), fontFamily: "Poppins_Bold"),
          //       )),
          //   backgroundColor: Colors.white,
          //   leading: IconButton(
          //       onPressed: (){
          //
          //       },
          //       icon: const Icon(
          //         Icons.arrow_back_ios_new,
          //         color: Colors.black,
          //       )),
          // ),

          body: LayoutBuilder(builder: (context, constraints) {
            if (isDataLoaded) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(children: [
                  Padding(padding: EdgeInsets.only(left: 20,right: 20)),
                  GestureDetector(
                    onTap: () {
                      Get.to(EditableProfilePage(user: user));
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        // padding: EdgeInsets.only(right: 10),
                        margin: const EdgeInsets.only(top: 20),
                        alignment: Alignment.centerRight,
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 216, 229, 248),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        child: Icon(
                          Icons.edit_rounded,
                          color: Colors.black,
                        ),

                        // ElevatedButton(
                        //     onPressed: () {
                        //       // onRegister();
                        //     },
                        //     child: ),
                        // child: Icon(
                        //   Icons.edit_rounded,
                        //   color: Colors.black,
                        // ),
                      ),
                    ),
                  ),
                  // ElevatedButton(
                  //     onPressed: () { EditableProfilePage(); },
                  //     child: const Text("Edit")),
                  // Text("Your Information",style: TextStyle(fontSize: 25,color:Color.fromRGBO(19, 59, 78, 1.0),fontFamily: "Poppins_Bold")),
                  //   Container(
                  //     color: Colors.grey,
                  //     width: 300,
                  //     // padding: EdgeInsets.only(right: 200),
                  //     child: Text(user.firstName! +" "+ user.lastName!,style: TextStyle(fontFamily: "Poppins_bold", fontSize: 25,color:Color.fromRGBO(19, 59, 78, 1.0))
                  //     ),
                  //   ),
                  // Padding(padding: EdgeInsets.only(left: 30,top: 20)),
                  // Container(
                  //   color: Colors.white,
                  //   padding: EdgeInsets.only(left: 10,top: 20,bottom: 20),
                  //   // height: 100,
                  //   width: 500,
                  //   child: Column(
                  //     children: [
                  //
                  //       imageProfile(context),
                  //     ],
                  //   ),
                  // ),

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                          right: 20,
                        )),
                        Column(
                          children: [
                            // Padding(padding: EdgeInsets.only(right: 30)),
                            Image(
                              image: AssetImage(
                                'assets/images/profile.png',
                              ),
                              height: 50,
                            )
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(user.firstName! + " " + user.lastName!,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 18,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(right: 20)),
                      Column(
                        children: [
                          // Padding(padding: EdgeInsets.only(right: 30)),
                          Image(
                            image: AssetImage(
                              'assets/images/organization.png',
                            ),
                            height: 50,
                          )
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(user.orgName!,
                              style: TextStyle(
                                  fontFamily: "Poppins", fontSize: 18)),
                        ],
                      )
                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(right: 20)),
                      Column(
                        children: [
                          // Padding(padding: EdgeInsets.only(right: 30)),
                          Image(
                            image: AssetImage(
                              'assets/images/call.png',
                            ),
                            height: 50,
                          )
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(user.mobileNumber!,
                              style: TextStyle(
                                  fontFamily: "Poppins", fontSize: 18)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 20)),
                        Column(
                          children: [
                            // Padding(padding: EdgeInsets.only(right: 30)),
                            Image(
                              image: AssetImage(
                                'assets/images/email.png',
                              ),
                              height: 50,
                            )
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Padding(padding: EdgeInsets.only(right: 20)),
                              Text(user.email!,
                                  style: TextStyle(
                                      fontFamily: "Poppins", fontSize: 18)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(right: 20)),
                      Column(
                        children: [
                          // Padding(padding: EdgeInsets.only(right: 30)),
                          Image(
                            image: AssetImage(
                              'assets/images/gst.png',
                            ),
                            height: 50,
                          )
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(user.gstNumber!,
                              style: TextStyle(
                                  fontFamily: "Poppins", fontSize: 18)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(right: 20)),
                      Column(
                        children: [
                          // Padding(padding: EdgeInsets.only(right: 30)),
                          Image(
                            image: AssetImage(
                              'assets/images/pan.png',
                            ),
                            height: 50,
                          ),
                          Text("PAN")
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(user.panNumber!,
                              style: TextStyle(
                                  fontFamily: "Poppins", fontSize: 18)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(right: 20)),
                      Column(
                        children: [
                          // Padding(padding: EdgeInsets.only(right: 30)),
                          Image(
                            image: AssetImage(
                              'assets/images/aadhar.png',
                            ),
                            height: 50,
                          ),
                          Text("aadhar")
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(user.adhNumber!,
                              style: TextStyle(
                                  fontFamily: "Poppins", fontSize: 18)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // padding: EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 20, bottom: 30)),
                        Column(
                          children: [
                            // Padding(padding: EdgeInsets.only(right: 30)),
                            Image(
                              image: AssetImage(
                                'assets/images/address.png',
                              ),
                              height: 50,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Padding(padding: EdgeInsets.only(left: 20)),
                              Text(
                                user.address!,
                                style: TextStyle(
                                    fontFamily: "Poppins", fontSize: 18),
                                maxLines: 10,
                                softWrap: true,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      print(user.userType);
                      if(user.userType != "Manufacturer"){
                        return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          width: MediaQuery.of(context).size.width,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(75, 100, 160, 1.0),
                                Color.fromRGBO(19, 59, 78, 1.0),

                                //add more colors
                              ]),
                              // borderRadius: BorderRadius.circular(30),
                              // boxShadow: <BoxShadow>[
                              // BoxShadow(
                              //     color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                              //     blurRadius: 5) //blur radius of shadow
                              //]
                            ),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  disabledForegroundColor: Colors.transparent.withOpacity(0.38), disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
                                  shadowColor: Colors.transparent,
                                  //make color or elevated button transparent
                                ),
                                onPressed:() => {
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      barrierDismissible: true,
                                      cancelBtnText: 'Cancel',
                                      confirmBtnText: 'Yes',
                                      title: 'Are you sure?',
                                      text: 'Delete your account',
                                      textColor: Colors.red,

                                      // customAsset: Icon(Icons.login_outlined),
                                      onConfirmBtnTap: () async {
                                        onDelete();
                                        // SharedPreferences prefs = await SharedPreferences.getInstance();
                                        // prefs.clear();
                                        // Navigator.pushAndRemoveUntil(
                                        //     context,
                                        //     MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                                        //     ModalRoute.withName(
                                        //         '/') // Replace this with your root screen's route name (usually '/')
                                        // );
                                      },
                                      onCancelBtnTap: () {
                                        Get.back();
                                      }
                                  ),
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 18,
                                    bottom: 18,
                                  ),
                                  child: Text("Delete Account",
                                    style: const TextStyle(fontFamily: 'Poppins_Bold',color: Colors.white),
                                  ),
                                )
                            ),
                          )

                        //   buttonStyle1("Delete Account ", () {
                        //     onDelete();
                        //   }
                        // )

                        );
                      }else{
                        return Container();
                      }
                    },
                  ),
                  // SizedBox(
                  //   height: 30,
                  // )

                  //   Column(
                  //   children:[
                  //
                  //
                  //     Padding(padding: EdgeInsets.only(right: 20,left: 40)),
                  //     // Column
                  //     //   children: [
                  //     //     Container(
                  //     //       padding: EdgeInsets.only(bottom: 20),
                  //     //       child: Row(
                  //     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     //         children: [
                  //     //           Text("Name:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //           ),
                  //     //           Text(user.firstName! +" "+ user.lastName!,style: TextStyle(fontFamily: "Poppins", fontSize: 15,)
                  //     //           ),
                  //     //         ],
                  //     //       ),
                  //     //     ),
                  //     //
                  //     //     Container(
                  //     //       padding: EdgeInsets.only(bottom: 20),
                  //     //       child: Row(
                  //     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     //         children: [
                  //     //           Text("business Name:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //           ),
                  //     //           Text(user.orgName!,style: TextStyle(fontFamily: "Poppins", fontSize: 15)
                  //     //           ),
                  //     //         ],
                  //     //       ),
                  //     //     ),
                  //     //
                  //     //     Container(
                  //     //       padding: EdgeInsets.only(bottom: 20),
                  //     //       child: Row(
                  //     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     //         children: [
                  //     //           Text("Contact Number:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //           ),
                  //     //           Text(user.mobileNumber!,style: TextStyle(fontFamily: "Poppins", fontSize: 15)
                  //     //           ),
                  //     //         ],
                  //     //       ),
                  //     //     ),
                  //     //
                  //     //     Container(
                  //     //       padding: EdgeInsets.only(bottom: 20),
                  //     //       child: Row(
                  //     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     //         children: [
                  //     //           Text("Email:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //           ),
                  //     //           Text(user.email!,style: TextStyle(fontFamily: "Poppins", fontSize: 15)
                  //     //       ),
                  //     //         ],
                  //     //       ),
                  //     //     ),
                  //     //
                  //     //     Container(
                  //     //       padding: EdgeInsets.only(bottom: 20),
                  //     //       child: Row(
                  //     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     //         children: [
                  //     //           Text("GST Number:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //           ),
                  //     //           Text(user.gstNumber!,style: TextStyle(fontFamily: "Poppins", fontSize: 15)
                  //     //           ),
                  //     //         ],
                  //     //       ),
                  //     //     ),
                  //     //
                  //     //     Container(
                  //     //       padding: EdgeInsets.only(bottom: 20),
                  //     //       child: Row(
                  //     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     //         children: [
                  //     //           Text("PAN Number:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //           ),
                  //     //           Text(user.panNumber!,style: TextStyle(fontFamily: "Poppins", fontSize: 15)
                  //     //           ),
                  //     //         ],
                  //     //       ),
                  //     //     ),
                  //     //
                  //     //     Container(
                  //     //       padding: EdgeInsets.only(bottom: 20),
                  //     //       child: Row(
                  //     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     //         children: [
                  //     //           Text("Aadhar Number:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //           ),
                  //     //           Text(user.adhNumber!,style: TextStyle(fontFamily: "Poppins", fontSize: 15)
                  //     //           ),
                  //     //         ],
                  //     //       ),
                  //     //     ),
                  //     //
                  //     //     Container(
                  //     //       padding: EdgeInsets.only(bottom: 20),
                  //     //       child: Column(
                  //     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     //         children: [
                  //     //           Row(
                  //     //             children: [
                  //     //               Text("Address:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //               ),
                  //     //             ],
                  //     //           ),
                  //     //           Row(
                  //     //             children: [
                  //     //               Flexible(
                  //     //                 child: Text(user.address!,style: TextStyle(fontFamily: "Poppins", fontSize: 15)
                  //     //                 ),
                  //     //               ),
                  //     //             ],
                  //     //           ),
                  //     //         ],
                  //     //       ),
                  //     //     ),
                  //     //
                  //     //     // Container(
                  //     //     //   padding: EdgeInsets.only(bottom: 20),
                  //     //     //   child: Row(
                  //     //     //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     //     //     children: [
                  //     //     //       Text("Registered date:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //     //       ),
                  //     //     //       Text("21/03/2023",style: TextStyle(fontFamily: "Poppins", fontSize: 15)
                  //     //     //       ),
                  //     //     //     ],
                  //     //     //   ),
                  //     //     // ),
                  //     //
                  //     //   ],
                  //     // ),
                  //
                  //     // Align(alignment: Alignment.topLeft,),
                  //     // Card(
                  //     //   color: Colors.white54,
                  //     //   child: Container(
                  //     //     width: 500,
                  //     //     padding: EdgeInsets.only(top: 20,bottom: 20,right: 20),
                  //     //     child: Row(
                  //     //       children: [
                  //     //         Column(
                  //     //           crossAxisAlignment: CrossAxisAlignment.center,
                  //     //           children: [
                  //     //             Icon(Icons.person),
                  //     //             // Padding(padding: EdgeInsets.only(top: 10,bottom: 10)),
                  //     //             // Text("Name:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //             // ),
                  //     //             SizedBox(height:20),
                  //     //             Text("business Name:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //             ),
                  //     //             SizedBox(height:20),
                  //     //             Text("Contact Number:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //             ),
                  //     //             SizedBox(height:20),
                  //     //             Text("Email:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //             ),
                  //     //             SizedBox(height:20),
                  //     //             Text("GST Number:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //             ),
                  //     //             SizedBox(height:20),
                  //     //             Text("PAN Number:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //             ),
                  //     //             SizedBox(height:20),
                  //     //             Text("Aadhar Number:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //             ),
                  //     //             SizedBox(height:20),
                  //     //             Text("Address:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //             ),
                  //     //             SizedBox(height:20),
                  //     //             Text("Registered date:",style: TextStyle(fontFamily: "Poppins_Bold", fontSize: 15, color: Color.fromRGBO(19, 59, 78, 1))
                  //     //             ),
                  //     //           ],
                  //     //         ),
                  //     //         SizedBox(width: 20),
                  //     //         Column(
                  //     //           crossAxisAlignment: CrossAxisAlignment.start,
                  //     //           children: [
                  //     //             // Padding(padding: EdgeInsets.only(top: 10,bottom: 10)),
                  //     //             Text(user.firstName! +" "+ user.lastName!,style: TextStyle(fontFamily: "Poppins", fontSize: 15, color: Colors.grey)
                  //     //             ),
                  //     //             SizedBox(height:20),
                  //     //             Text(user.orgName!,style: TextStyle(fontFamily: "Poppins", fontSize: 15, color: Colors.grey)
                  //     //             ),
                  //     //             SizedBox(height:20),
                  //     //             Text(user.mobileNumber!,style: TextStyle(fontFamily: "Poppins", fontSize: 15, color: Colors.grey)
                  //     //             ),
                  //     //             SizedBox(height:20),
                  //     //             // Text("98765432",style: TextStyle(fontFamily: "Poppins", fontSize: 15, color: Colors.grey)
                  //     //             // ),
                  //     //             // SizedBox(height:20),
                  //     //             Text(user.email!,style: TextStyle(fontFamily: "Poppins", fontSize: 15, color: Colors.grey)
                  //     //             ),
                  //     //             SizedBox(height:20),
                  //     //             Text(user.gstNumber!,style: TextStyle(fontFamily: "Poppins", fontSize: 15, color: Colors.grey)
                  //     //             ),
                  //     //             SizedBox(height:20),
                  //     //             Text(user.panNumber!,style: TextStyle(fontFamily: "Poppins", fontSize: 15, color: Colors.grey)
                  //     //             ),
                  //     //             SizedBox(height:20),
                  //     //             Text(user.adhNumber!,style: TextStyle(fontFamily: "Poppins", fontSize: 15, color: Colors.grey)
                  //     //             ),
                  //     //             SizedBox(height:20),
                  //     //             Text(user.address!,style: TextStyle(fontFamily: "Poppins", fontSize: 15, color: Colors.grey,),softWrap: true,maxLines: 5,
                  //     //             ),
                  //     //             SizedBox(height:20),
                  //     //             Text("21/03/2023",style: TextStyle(fontFamily: "Poppins", fontSize: 15, color: Colors.grey)
                  //     //             ),
                  //     //           ],
                  //     //         ),
                  //     //       ],
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //
                  //     // IconButton(
                  //     //     icon: Icon(
                  //     //       Icons.edit,
                  //     //       color: Color(0xFF8D8D8D),
                  //     //     ),
                  //     //     onPressed: null),
                  //     // Row(
                  //     //   children: [
                  //     //     Text("Your Information",style: TextStyle(fontSize: 25,color:Color.fromRGBO(19, 59, 78, 1.0),fontFamily: "Poppins_Bold")),
                  //     //   ],
                  //     // ),
                  //     // Padding(padding: EdgeInsets.only(bottom: 10,top: 10)),
                  //     // Card(
                  //     //   elevation: 5,
                  //     //   child: Text("Name"
                  //     //   ),
                  //     // ),
                  //     //
                  //     // SizedBox(
                  //     //   height: 10,
                  //     // ),
                  //     //
                  //     // Card(
                  //     //   elevation: 5,
                  //     //   child: TextField(
                  //     //     decoration: InputDecoration(
                  //     //       border: OutlineInputBorder(
                  //     //         borderSide: BorderSide(
                  //     //             width: 1, color: Colors.black),
                  //     //         //<-- SEE HERE
                  //     //       ),
                  //     //       focusedBorder: OutlineInputBorder(
                  //     //         borderSide: BorderSide(width: 2, color: Colors.indigo),
                  //     //       ),
                  //     //       labelText: "Business Name",
                  //     //       floatingLabelBehavior: FloatingLabelBehavior.never,
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //     // SizedBox(
                  //     //   height: 10,
                  //     // ),
                  //     // Card(
                  //     //   elevation: 5,
                  //     //   child: TextFormField(
                  //     //     decoration: InputDecoration(
                  //     //       border: OutlineInputBorder(
                  //     //         borderSide: BorderSide(
                  //     //             width: 1, color: Colors.black), //<-- SEE HERE
                  //     //       ),
                  //     //       focusedBorder: OutlineInputBorder(
                  //     //         borderSide: BorderSide(width: 2, color: Colors.indigo),
                  //     //       ),
                  //     //       labelText: "Contact Number",
                  //     //       floatingLabelBehavior: FloatingLabelBehavior.never,
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //     //
                  //     // SizedBox(
                  //     //   height: 10,
                  //     // ),
                  //     //
                  //     // Card(
                  //     //   elevation: 5,
                  //     //   child: TextFormField(
                  //     //     decoration: InputDecoration(
                  //     //       border: OutlineInputBorder(
                  //     //         borderSide: BorderSide(
                  //     //             width: 1, color: Colors.black), //<-- SEE HERE
                  //     //       ),
                  //     //       focusedBorder: OutlineInputBorder(
                  //     //         borderSide: BorderSide(width: 2, color: Colors.indigo),
                  //     //       ),
                  //     //       labelText: "Email",
                  //     //       floatingLabelBehavior: FloatingLabelBehavior.never,
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //     // SizedBox(
                  //     //   height: 10,
                  //     // ),
                  //     // Card(
                  //     //   elevation: 5,
                  //     //   child: TextFormField(
                  //     //     decoration: InputDecoration(
                  //     //       border: OutlineInputBorder(
                  //     //         borderSide: BorderSide(
                  //     //             width: 1, color: Colors.black), //<-- SEE HERE
                  //     //       ),
                  //     //       focusedBorder: OutlineInputBorder(
                  //     //         borderSide: BorderSide(width: 2, color: Colors.indigo),
                  //     //       ),
                  //     //       labelText: "GST Number",
                  //     //       floatingLabelBehavior: FloatingLabelBehavior.never,
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //     // SizedBox(
                  //     //   height: 10,
                  //     // ),
                  //     //
                  //     // Card(
                  //     //   elevation: 5,
                  //     //   child: TextFormField(
                  //     //     decoration: InputDecoration(
                  //     //         border: OutlineInputBorder(
                  //     //             borderSide: BorderSide(
                  //     //                 width: 1,color: Colors.black)
                  //     //         ),
                  //     //         focusedBorder: OutlineInputBorder(
                  //     //             borderSide: BorderSide(width: 2,color: Colors.indigo)
                  //     //         ),
                  //     //         labelText: "PAN Number",
                  //     //         floatingLabelBehavior: FloatingLabelBehavior.never
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //     //
                  //     // SizedBox(
                  //     //   height: 10,
                  //     // ),
                  //     //
                  //     // Card(
                  //     //   elevation: 5,
                  //     //   child: TextFormField(
                  //     //     decoration: InputDecoration(
                  //     //       border: OutlineInputBorder(
                  //     //         borderSide: BorderSide(
                  //     //             width: 1, color: Colors.black), //<-- SEE HERE
                  //     //       ),
                  //     //       focusedBorder: OutlineInputBorder(
                  //     //         borderSide: BorderSide(width: 2, color: Colors.indigo),
                  //     //       ),
                  //     //       labelText: "Aadhar Number",
                  //     //       floatingLabelBehavior: FloatingLabelBehavior.never,
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //     // SizedBox(
                  //     //   height: 10,
                  //     // ),
                  //     // Card(
                  //     //   elevation: 5,
                  //     //   child: TextFormField(
                  //     //     // minLines: 1,
                  //     //     maxLines: 4,
                  //     //     decoration: InputDecoration(
                  //     //       border: OutlineInputBorder(
                  //     //         borderSide: BorderSide(
                  //     //             width: 1, color: Colors.black), //<-- SEE HERE
                  //     //       ),
                  //     //       focusedBorder: OutlineInputBorder(
                  //     //         borderSide: BorderSide(width: 2, color: Colors.indigo),
                  //     //       ),
                  //     //       labelText: "Address",
                  //     //       floatingLabelBehavior: FloatingLabelBehavior.never,
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //
                  //     // Container(
                  //     //     margin:
                  //     //     const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  //     //     width: MediaQuery.of(context).size.width,
                  //     //     child: buttonStyle("Save", () {
                  //     //     }
                  //     //     )
                  //     // )
                  //   ],
                  // ),
                ]),
              );
            } else {
              return Column(
                children: [
                  CircularProgressIndicator(),
                  Text("Loading User Profile")
                ],
              );
            }
          }),
          bottomNavigationBar: StylishBottomBar(
            option: AnimatedBarOptions(
              iconSize: 30,
              barAnimation: BarAnimation.fade,
              //barAnimation: BarAnimation.liquid,
              iconStyle: IconStyle.simple,
              opacity: 0.3,
            ),
            items: [
              BottomBarItem(
                icon: const Icon(
                  Icons.home_filled,
                ),
                title: const Text('Abc'),
                backgroundColor: Colors.grey,
                selectedIcon:
                    const Icon(Icons.home_filled, color: Colors.blueAccent),
              ),
              BottomBarItem(
                  icon: LayoutBuilder(builder: (context, constraints){
                    if(user_type=="Manufacturer"){
                      return const Icon(
                        Icons.inventory_2_rounded,
                      );
                    }else{return Container();}
                  },
                  ),
                  title: const Text('Safety'),
                  backgroundColor: Colors.grey,
                  selectedIcon: const Icon(Icons.inventory_2_rounded,
                      color: Colors.blueAccent)),
              BottomBarItem(
                  icon: LayoutBuilder(builder: (context, constraints){
                    if(user_type=="Manufacturer"){
                      return const Icon(
                        Icons.warehouse_rounded,
                      );
                    }else{return Container();}
                  },
                  ),

                  title: const Text('Safety'),
                  //  backgroundColor: Colors.orange,
                  selectedIcon: const Icon(Icons.warehouse_rounded,
                      color: Colors.blueAccent)),
              BottomBarItem(
                  icon: const Icon(
                    Icons.person_pin,
                  ),
                  title: const Text('Cabin'),
                  backgroundColor: Colors.grey,
                  selectedIcon:
                      const Icon(Icons.person_pin, color: Colors.black)),
            ],
            //fabLocation: StylishBarFabLocation.center,
            hasNotch: false,
            currentIndex: _selected,
            onTap: (index) {
              setState(() {
                if (index == 0) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          HomePage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                }
                if (index == 1) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          InventoryPage(order: Order(),),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                }
                if (index == 2) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          buyerspage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                }
              });
            },
          )),
    );
  }
// Widget imageProfile(BuildContext context){
// return Stack(
//   // alignment: Alignment.topLeft,
//   children:[
//     Align(alignment: Alignment.topRight),
//     CircleAvatar(
//       radius: 50,
//       backgroundImage: AssetImage("assets/images/profile.png"),
//     ),
//     Positioned(
//         bottom: 10,
//         left: 60,
//         child: InkWell(
//           onTap: (){
//             showModalBottomSheet<void>(
//               context: context,
//               builder: (BuildContext context) {
//                 return SizedBox(
//                   height: 150,
//                   child: Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         IconButton(onPressed: (){}, icon: Icon(Icons.camera)),
//                         IconButton(onPressed: (){}, icon: Icon(Icons.folder_copy)),
//                         // const Text('Modal BottomSheet'),
//
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//           child: Icon(
//             Icons.camera_alt,
//             color: Colors.white,
//             size: 30,
//           ),
//         ),
//     ),
//   ]
// );
// }
}
