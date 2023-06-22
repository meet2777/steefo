import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:stefomobileapp/Models/size.dart';

import '../Models/grade.dart';
import '../Models/lumpsum.dart';
import '../Models/order.dart';
import '../Models/region.dart';
import '../Models/user.dart';

// Widget orderCard(BuildContext context, Order order, String? curr_user_id) {
//   if (order.status != 'Pending') {
//     return Container(
//       margin: EdgeInsets.only(top: 10),
//       padding: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10.0),
//         color: Colors.grey.shade100,
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "ORDER ID: ",
//                 style: GoogleFonts.poppins(
//                     textStyle: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20)),
//               ),
//               Text(
//                 order.order_id.toString(),
//                 style: GoogleFonts.poppins(
//                     textStyle: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20)),
//               ),
//             ],
//           ),
//           RichText(
//             text: TextSpan(style: TextStyle(), children: [
//               TextSpan(
//                   text: "Organization Name: ",
//                   style: TextStyle(
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w600,
//                       fontSize: MediaQuery.of(context).size.width / 27)),
//               TextSpan(
//                   text: order.user_name,
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w600,
//                     fontSize: MediaQuery.of(context).size.width / 27,
//                   ))
//             ]),
//           ),
//           // LayoutBuilder(builder: (context, constraints) {
//           //   if (curr_user_id == order.reciever_id) {
//           //     return Container(
//           //         padding:
//           //             EdgeInsets.symmetric(horizontal: 3, vertical: 3),
//           //         decoration: BoxDecoration(
//           //             color: Colors.blue,
//           //             borderRadius: BorderRadius.circular(20)),
//           //         child: Text(
//           //           "Sales",
//           //         ));
//           //   } else {
//           //     return Container(
//           //         padding:
//           //             EdgeInsets.symmetric(horizontal: 3, vertical: 3),
//           //         decoration: BoxDecoration(
//           //             color: Colors.green,
//           //             borderRadius: BorderRadius.circular(20)),
//           //         child: Text("Purchase"));
//           //   }
//           // })
//           Divider(
//             color: Colors.greenAccent,
//           ),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 child: Text(
//                   "Org Name:",
//                   style: TextStyle(fontFamily: "Poppins_Bold"),
//                 ),
//                 padding: EdgeInsets.only(bottom: 5, right: 5),
//               ),
//               Text(
//                 order.party_name!,
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 3,
//               )
//             ],
//           ),
//           Container(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Status:", style: TextStyle(fontFamily: "Poppins_Bold")),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 35.0),
//                   child: Text(order.status!),
//                 )
//               ],
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 5),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Order Date: ",
//                     style: TextStyle(fontFamily: "Poppins_Bold")),
//                 Text(order.order_date!.substring(0, 10))
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   } else
//     return Container();
// }
Widget orderCard(BuildContext context, Order order, String? curr_user_id) {
  if (order.status != 'Pending') {
    return Column(
      children: [
        Container(
          height: 130,
          //margin: EdgeInsets.only(top: 10),
          // padding: const EdgeInsets.all(10.0),
          // width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey.shade100,
          ),
          child: Column(
            children: [
              Container(
                //  height: 50,
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                //  width: MediaQuery.of(context).size.width,
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
                          order.order_date!.substring(0, 10),
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    Text(
                      order.order_id!.toUpperCase(),
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17)),
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
                        order.user_name!.toUpperCase(),
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
                                order!.status!,
                              ));
                        } else if (order.status == "Denied") {
                          return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10))),
                              child: Text(
                                order.status!,
                                style: TextStyle(color: Colors.white),
                              ));
                        } else {
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
                                style: TextStyle(color: Colors.white),
                              ));
                        }
                      })),

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
                children: [
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Container(
                    child: Text(
                      "Base Price:",
                      style: TextStyle(
                          fontFamily: "Poppins_Bold", color: Colors.grey),
                    ),
                    padding: EdgeInsets.only(right: 5),
                  ),
                  Text(
                    order.base_price!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                        // color: Color.fromRGBO(19, 59, 78, 1.0),
                        color: Colors.grey),
                  ),
                  VerticalDivider(
                    color: Colors.grey,
                    thickness: 2,
                    width: 2,
                  ),
                  // Container(
                  //   child: Text(
                  //       item.price!
                  //   ),
                  // )
                ],
              ),
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

Widget DistributorCard(User user, BuildContext context) {
  if (user.userType == "Distributor") {
    return Container(
      height: 160,
      // margin: EdgeInsets.only(top: 20,),
      margin: EdgeInsets.all(10.0),
      // padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        // gradient: LinearGradient(colors: [
        //   Color.fromARGB(255, 228, 245, 181),
        //   Color.fromARGB(255, 242, 255, 64)
        // ]),

        borderRadius: BorderRadius.circular(10.0),
        //  border: Border.all(color: Colors.black),
        // border: Border.all(color: Colors.black),
        color: Colors.grey.shade100,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(top: 10, left: 5),
                  child: Text(
                    user.userType!,
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    textAlign: TextAlign.left,
                  )),
              Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    user.orgName!,
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.visible,
                  )),
              Expanded(
                flex: 1,
                child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    padding: EdgeInsets.only(top: 10, left: 5),
                    child: Text(
                      user.address!,
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(fontSize: 15)),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.visible,
                      maxLines: 4,
                    )),
              ),
            ],
          ),
          Expanded(
              child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Image.asset("assets/images/distributor.png")))
        ],
      ),
    );
  } else
    return Container();
}

Widget BuilderCard(User user, BuildContext context) {
  if (user.userType == "Builder") {
    return Container(
      height: 160,
      margin: EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        // gradient: LinearGradient(colors: [
        //   Color.fromARGB(255, 228, 245, 181),
        //   Color.fromARGB(255, 242, 255, 64)
        // ]),

        borderRadius: BorderRadius.circular(10.0),
        //  border: Border.all(color: Colors.black),
        // border: Border.all(color: Colors.black),
        color: Colors.grey.shade100,
      ),
      // margin: EdgeInsets.only(top: 20,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(top: 10, left: 5),
                  child: Text(
                    user.userType!,
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    textAlign: TextAlign.left,
                  )),
              Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    user.orgName!,
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.visible,
                  )),
              Expanded(
                flex: 1,
                child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    padding: EdgeInsets.only(top: 10, left: 5),
                    child: Text(
                      user.address!,
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(fontSize: 15)),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.visible,
                      maxLines: 4,
                    )),
              ),
            ],
          ),
          Expanded(
              child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Image.asset("assets/images/distributor.png")))
        ],
      ),
    );
  } else
    return Container();
}

Widget DealerCard(User user, BuildContext context) {
  if (user.userType == "Dealer") {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey.shade100,
      ),
      // width: 400,
      height: 160,
      // margin: EdgeInsets.only(top: 20,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(top: 10, left: 5),
                  child: Text(
                    user.userType!,
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent)),
                    textAlign: TextAlign.left,
                  )),
              Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    user.orgName!,
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.visible,
                  )),
              Expanded(
                flex: 1,
                child: Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    padding: EdgeInsets.only(top: 10, left: 5),
                    child: Text(
                      user.address!,
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(fontSize: 15)),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.visible,
                      maxLines: 4,
                    )),
              ),
            ],
          ),
          Expanded(
            child: Container(
                margin: EdgeInsets.only(right: 10),
                // decoration: BoxDecoration(
                //     //color: Colors.green,
                //     borderRadius: BorderRadius.circular(20)),
                // width: 70,
                child: Image.asset("assets/images/dealer.png")),
          )
        ],
      ),
    );
  } else
    return Container();
}

Widget InventoryCard(BuildContext context, Lumpsum lumpsum) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("ORDER ID: ",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20))),
          Text(lumpsum.orderId.toString(),
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20))),
        ],
      ),

      RichText(
        text: TextSpan(style: TextStyle(), children: [
          TextSpan(
              text: "Organization Name: ",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.width / 27)),
          TextSpan(
              text: lumpsum.partyname,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: MediaQuery.of(context).size.width / 27,
              ))
        ]),
      ),
      SizedBox(
        height: 5,
      ),
      Divider(
        color: Colors.purple.shade100,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Order Date: ", style: TextStyle(fontFamily: "Poppins_Bold")),
          Text(lumpsum.date!.substring(0, 10),
              style: TextStyle(
                color: Colors.black,
              )),
        ],
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Quantity: ", style: TextStyle(fontFamily: "Poppins_Bold")),
          Text(lumpsum.qty!,
              style: TextStyle(
                color: Colors.black,
              )),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Price: ", style: TextStyle(fontFamily: "Poppins_Bold")),
          Text(lumpsum.price!,
              style: TextStyle(
                color: Colors.black,
              )),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Status: ", style: TextStyle(fontFamily: "Poppins_Bold")),
          Text(lumpsum.status!.toString(),
              style: TextStyle(
                color: Colors.black,
              )),
        ],
      ),

      // Container(
      //   width: MediaQuery.of(context).size.width - 20,
      //   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      //   child: DataTable(
      //       columnSpacing: double.minPositive,
      //       headingTextStyle: const TextStyle(
      //           fontWeight: FontWeight.bold, color: Colors.black),
      //       columns: const [
      //         // DataColumn(
      //         //     label: Text(
      //         //   "Sr No",
      //         //   textAlign: TextAlign.center,
      //         // )),
      //         DataColumn(label: Text("Item name")),
      //         DataColumn(label: Text("Quantity (Tons)"))
      //       ],
      //       rows: [
      //         DataRow(
      //           cells: <DataCell>[
      //             // DataCell(Text("1")), //Extracting from Map element the value

      //             DataCell(Text(lumpsum.name!)),
      //             DataCell(Text(lumpsum.qty!))
      //           ],
      //         )
      //       ]),
      // ),
    ],
  );
}

Widget LumpSumTotal(BuildContext context, Grade g) {
  return Container(
      child: Row(
    children: [
      Expanded(
        flex: 6,
        child: Text(g.value.toString(),
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
            )),
      ),
      Expanded(
        flex: 1,
        child: Text(":", style: TextStyle(fontSize: 17, color: Colors.black)),
      ),
      Expanded(
        flex: 2,
        child: Center(
            child: Text(g.qty.toString(),
                style: TextStyle(fontSize: 17, color: Colors.black))),
      ),
    ],
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.start,
  ));
}

Widget AddNewGrade(BuildContext context, Grade g, remove(), update()) {
  return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(g.value.toString(),
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Expanded(
                flex: 1,
                child: Text('\u{20B9}' + g.price.toString(),
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () => {update()},
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blueAccent,
                    )),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () => {
                          remove(),
                          print("Delete button pressed"),
                        },
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    )),
              ),
            ],
          ),
          Divider(color: Colors.black54),
        ],
      ));
}

Widget AddNewSize(BuildContext context, ItemSize s, remove(), update()) {
  return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(s.value.toString(),
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Expanded(
                flex: 1,
                child: Text('\u{20B9}' + s.price.toString(),
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () => {update()},
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blueAccent,
                    )),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () => {
                          remove(),
                          print("Delete button pressed"),
                        },
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    )),
              ),
            ],
          ),
          Divider(color: Colors.black54),
        ],
      ));
}

Widget AddNewRegion(BuildContext context, Region r, remove(), update()) {
  return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(r.name.toString(),
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Expanded(
                flex: 1,
                child: Text('\u{20B9}' + r.cost.toString(),
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () => {
                          update(),
                        },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blueAccent,
                    )),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () => {remove()},
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    )),
              ),
            ],
          ),
          Divider(color: Colors.black54),
        ],
      ));
}
