import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:stefomobileapp/Models/payment.dart';
import 'package:stefomobileapp/pages/HomePage.dart';
import 'package:stefomobileapp/ui/custom_tabbar.dart';
import '../Models/grade.dart';
import '../Models/region.dart';
import '../Models/size.dart';
import '../UI/common.dart';
import '../ui/cards.dart';

class AddItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AddItemContent();
  }
}

class AddItemContent extends StatefulWidget {
  AddItemContent({super.key});

  @override
  State<AddItemContent> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemContent> {
  bool isDataLoaded = false;
  List<Grade> gradeList = [];

  List sizes = [];
  List<ItemSize> sizeList = [];

  List regions = [];
  List payment = [];
  List<Payment> paymentList = [];
  List<Region> regionList = [];

  var isEnabled = false;
  TextEditingController newPrice = TextEditingController();
  TextEditingController Price = TextEditingController();

  TextEditingController newGrade = TextEditingController();

  TextEditingController newSize = TextEditingController();

  TextEditingController newSizeprice = TextEditingController();

  TextEditingController newRegionPrice = TextEditingController();
  TextEditingController RegionPrice = TextEditingController();
  TextEditingController newRegion = TextEditingController();

  TextEditingController newPaymentname = TextEditingController();
  TextEditingController newPaymentPrice = TextEditingController();
  TextEditingController editpaymentPrice = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  // TextEditingController newSizePrice = TextEditingController();

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user_id = await prefs.getString('id');

    var res1 = await http
        .post(Uri.parse("http://steefotmtmobile.com/steefo/getgrade.php"));
    var responseData1 = jsonDecode(res1.body);
    for (int i = 0; i < responseData1['data'].length; i++) {
      print(responseData1['data'][i]);
      Grade g = Grade();
      g.value = responseData1['data'][i]['gradeName'];
      g.price = responseData1['data'][i]['gradePrice'];

      gradeList.add(g);
    }
    var res2 = await http
        .post(Uri.parse("http://steefotmtmobile.com/steefo/getsize.php"));
    var responseData2 = jsonDecode(res2.body);
    for (int i = 0; i < responseData2['data'].length; i++) {
      sizes.add(responseData2['data'][i]["sizeValue"].toString());
      ItemSize s = ItemSize();
      s.price = responseData2['data'][i]["sizePrice"];
      s.value = responseData2['data'][i]["sizeValue"];
      sizeList.add(s);
    }

    var res3 = await http
        .post(Uri.parse("http://steefotmtmobile.com/steefo/getregions.php"));
    var responseData3 = jsonDecode(res3.body);
    for (int i = 0; i < responseData3['data'].length; i++) {
      print(responseData3['data'][i]);
      regions.add(responseData3['data'][i]["regionName"]);
      Region r = Region();
      r.name = responseData3['data'][i]["regionName"];
      r.cost = responseData3['data'][i]["tCost"];
      regionList.add(r);
    }
    var res4 = await http
        .post(Uri.parse("http://steefotmtmobile.com/steefo/getpayment.php"));
    var responseData4 = jsonDecode(res4.body);
    for (int i = 0; i < responseData4['data'].length; i++) {
      print(responseData4['data'][i]);
      payment.add(responseData4['data'][i]["payment Name"]);
      Payment p = Payment();
      p.paymentName = responseData4['data'][i]["paymentName"];
      p.paymentCost = responseData4['data'][i]["paymentPrice"];
      paymentList.add(p);
    }

    var res = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/getinventory.php"),
        body: {
          "user_id": user_id,
        });

    var responseData = jsonDecode(res.body);

    //print(responseData);
    for (int i = 0; i < responseData["data"].length; i++) {
      print(responseData['data'][i]['name']);
      var ind = gradeList.indexWhere((element) =>
          element.value?.trim() == responseData['data'][i]['name'].trim());
    }
    isDataLoaded = true;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  gradeList.clear();
    //  loadData();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appbar("Product Controls", () {
          Navigator.pop(context);
        }),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: CustomTabBar(
            titleStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            selectedCardColor: Colors.blueGrey,
            selectedTitleColor: Colors.white,
            unSelectedCardColor: Colors.white,
            unSelectedTitleColor: Color.fromRGBO(12, 53, 68, 1),
            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            tabBarItemExtend: ((MediaQuery.of(context).size.width) / 4),

            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            tabBarItems: [
              "GRADE",
              "SIZE",
              "REGION",
              "PAYMENT",
            ],
            tabViewItems: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ListView.builder(
                      itemCount: gradeList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      //  scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, ind) {
                        return Center(
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                            gradeList[ind].value.toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black)),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                            '\u{20B9}' +
                                                gradeList[ind].price.toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black)),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                            onPressed: () => {
                                                  () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Container(
                                                            child: Dialog(
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                height: 170,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .topLeft,
                                                                      child:
                                                                          Text(
                                                                        "EDIT PRICE",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    TextFormField(
                                                                      maxLines:
                                                                          1,
                                                                      controller:
                                                                          newPrice,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        labelText:
                                                                            "New Price",
                                                                        floatingLabelBehavior:
                                                                            FloatingLabelBehavior.never,
                                                                        border: OutlineInputBorder(
                                                                            // borderRadius: BorderRadius.circular(20),
                                                                            borderSide: BorderSide.none),
                                                                        filled:
                                                                            true,
                                                                        fillColor: Color.fromRGBO(
                                                                            233,
                                                                            236,
                                                                            239,
                                                                            0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                                                                      ),
                                                                    ),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          final numericRegex =
                                                                              RegExp(r'^[0-9]*$');
                                                                          if (numericRegex.hasMatch(newPrice.text) &&
                                                                              newPrice.text.trim() != "") {
                                                                            gradeList[ind].price =
                                                                                newPrice.text;
                                                                            http.post(Uri.parse("http://steefotmtmobile.com/steefo/updategrade.php"), body: {
                                                                              "gradeName": gradeList[ind].value,
                                                                              "price": newPrice.text
                                                                            });
                                                                          }
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.only(right: 10),
                                                                          alignment:
                                                                              Alignment.bottomRight,
                                                                          child: Text(
                                                                              "Submit",
                                                                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                                                                        ))
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  }()
                                                },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.blueAccent,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                            onPressed: () => {
                                                  QuickAlert.show(
                                                      confirmBtnColor:
                                                          Colors.redAccent,
                                                      showCancelBtn: true,
                                                      context: context,
                                                      type:
                                                          QuickAlertType.error,
                                                      barrierDismissible: true,
                                                      cancelBtnText: 'Cancel',
                                                      confirmBtnText: 'Delete',
                                                      title:
                                                          'Are you sure you want to delete this item?',
                                                      // text: 'Delete',
                                                      // textColor: Colors.red,

                                                      // customAsset: Icon(Icons.login_outlined),
                                                      onConfirmBtnTap:
                                                          () async {
                                                        () async {
                                                          await http.post(
                                                              Uri.parse(
                                                                  "http://steefotmtmobile.com/steefo/deletegrade.php"),
                                                              body: {
                                                                "gradeName":
                                                                    gradeList[
                                                                            ind]
                                                                        .value
                                                                        .toString(),
                                                              });
                                                          gradeList
                                                              .removeAt(ind);
                                                          setState(() {});
                                                        }();
                                                        Navigator.pop(context);
                                                      },
                                                      onCancelBtnTap: () {
                                                        Get.back();
                                                      }),
                                                  // remove(),
                                                  print(
                                                      "Delete button pressed"),
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
                              )),
                        );
                      },
                    ),
                    GestureDetector(
                      child: Container(
                          height: 35,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.add)),
                      onTap: () {
                        //  showAlertDialog(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            // String contentText = "Content of Dialog";
                            // return StatefulBuilder(
                            //   builder: (context, setState) {
                            return Form(
                              key: _formKey,
                              child: AlertDialog(
                                title: Text(
                                  "ADD GRADE",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                //  content: Text(contentText),
                                actions: <Widget>[
                                  TextFormField(
                                    controller: newGrade,
                                    maxLines: 1,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: "Add Grade",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      border: OutlineInputBorder(
                                        // borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Color.fromRGBO(233, 236, 239,
                                          0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "This field can't be empty";
                                      } else
                                        return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    maxLines: 1,
                                    controller: Price,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: "Add Price",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      border: OutlineInputBorder(
                                          // borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Color.fromRGBO(233, 236, 239,
                                          0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "This field can't be empty";
                                      } else
                                        return null;
                                    },
                                  ),
                                  // TextButton(
                                  //   onPressed: () => Navigator.pop(context),
                                  //   child: Text("Cancel"),
                                  // ),
                                  TextButton(
                                      child: Text(
                                        "ADD",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.greenAccent,
                                            fontSize: 20),
                                      ),
                                      onPressed: () async {
                                        // print(newBasePrice.text);
                                        if (_formKey.currentState!.validate()) {
                                          await http.post(
                                              Uri.parse(
                                                  "http://steefotmtmobile.com/steefo/addgrade.php"),
                                              body: {
                                                "gradeName": newGrade.text,
                                                "gradePrice": Price.text,
                                              });
                                          //Navigator.pop(context);
                                          //  gradeList.indexed.toList();
                                          Get.to(HomePage());
                                          Get.showSnackbar(
                                            GetSnackBar(
                                              title: "",

                                              message:
                                                  'Item added successfully!',
                                              //  icon: const Icon(Icons.refresh),
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );
                                          setState(() {
                                            //   gradeList.length;
                                          });
                                        }
                                      })
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),

              //--------------------------Sizes-------------------------------//
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      child: ListView.builder(
                        itemCount: sizeList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, ind) {
                          return Center(
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                              sizeList[ind].value.toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black)),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                              '\u{20B9}' +
                                                  sizeList[ind]
                                                      .price
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black)),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: IconButton(
                                              onPressed: () => {
                                                    () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Container(
                                                              child: Dialog(
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  height: 170,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        alignment:
                                                                            Alignment.topLeft,
                                                                        child:
                                                                            Text(
                                                                          "EDIT PRICE",
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      TextFormField(
                                                                        maxLines:
                                                                            1,
                                                                        controller:
                                                                            newPrice,
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          labelText:
                                                                              "New Price",
                                                                          floatingLabelBehavior:
                                                                              FloatingLabelBehavior.never,
                                                                          border: OutlineInputBorder(
                                                                              // borderRadius: BorderRadius.circular(20),
                                                                              borderSide: BorderSide.none),
                                                                          filled:
                                                                              true,
                                                                          fillColor: Color.fromRGBO(
                                                                              233,
                                                                              236,
                                                                              239,
                                                                              0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            final numericRegex =
                                                                                RegExp(r'^[0-9]*$');
                                                                            if (numericRegex.hasMatch(newPrice.text) &&
                                                                                newPrice.text.trim() != "") {
                                                                              sizeList[ind].price = newPrice.text;
                                                                              http.post(Uri.parse("http://steefotmtmobile.com/steefo/updatesize.php"), body: {
                                                                                "sizeName": sizeList[ind].value,
                                                                                "price": newPrice.text
                                                                              });
                                                                            }
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Container(
                                                                              padding: EdgeInsets.only(right: 10),
                                                                              alignment: Alignment.bottomRight,
                                                                              child: Text(
                                                                                "Submit",
                                                                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                                                                              )))
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    }()
                                                  },
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.blueAccent,
                                              )),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: IconButton(
                                              onPressed: () => {
                                                    QuickAlert.show(
                                                        confirmBtnColor:
                                                            Colors.redAccent,
                                                        showCancelBtn: true,
                                                        context: context,
                                                        type: QuickAlertType
                                                            .error,
                                                        barrierDismissible:
                                                            true,
                                                        cancelBtnText: 'Cancel',
                                                        confirmBtnText:
                                                            'Delete',
                                                        title:
                                                            'Are you sure you want to delete this item?',
                                                        // text: 'Delete',
                                                        // textColor: Colors.red,

                                                        // customAsset: Icon(Icons.login_outlined),
                                                        onConfirmBtnTap:
                                                            () async {
                                                          () async {
                                                            await http.post(
                                                                Uri.parse(
                                                                    "http://steefotmtmobile.com/steefo/deletesize.php"),
                                                                body: {
                                                                  "sizeName":
                                                                      sizeList[
                                                                              ind]
                                                                          .value
                                                                          .toString(),
                                                                });
                                                            sizeList
                                                                .removeAt(ind);
                                                            setState(() {});
                                                          }();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        onCancelBtnTap: () {
                                                          Get.back();
                                                        }),
                                                    // remove(),
                                                    print(
                                                        "Delete button pressed"),
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
                                )),
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                          height: 35,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.add)),
                      onTap: () {
                        //  showAlertDialog(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            // String contentText = "Content of Dialog";
                            // return StatefulBuilder(
                            //   builder: (context, setState) {
                            return Form(
                              key: _formKey,
                              child: AlertDialog(
                                title: Text(
                                  "ADD SIZE",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                //  content: Text(contentText),
                                actions: <Widget>[
                                  TextFormField(
                                    controller: newSize,
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "Add size",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      border: OutlineInputBorder(
                                        // borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Color.fromRGBO(233, 236, 239,
                                          0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "This field can't be empty";
                                      } else
                                        return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    maxLines: 1,
                                    controller: newSizeprice,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: "Add Price",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      border: OutlineInputBorder(
                                          // borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Color.fromRGBO(233, 236, 239,
                                          0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "This field can't be empty";
                                      } else
                                        return null;
                                    },
                                  ),
                                  // TextButton(
                                  //   onPressed: () => Navigator.pop(context),
                                  //   child: Text("Cancel"),
                                  // ),
                                  TextButton(
                                      child: Text(
                                        "ADD",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.greenAccent,
                                            fontSize: 20),
                                      ),
                                      onPressed: () async {
                                        // print(newBasePrice.text);
                                        if (_formKey.currentState!.validate()) {
                                          await http.post(
                                              Uri.parse(
                                                  "http://steefotmtmobile.com/steefo/addsize.php"),
                                              body: {
                                                "sizeName": newSize.text,
                                                "sizePrice": newSizeprice.text,
                                              });
                                          // Navigator.pop(context);
                                          Get.to(HomePage());
                                          Get.showSnackbar(
                                            GetSnackBar(
                                              title: "",
                                              message:
                                                  'Item added successfully!',
                                              //  icon: const Icon(Icons.refresh),
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );
                                          setState(() {
                                            //   gradeList.length;
                                          });
                                        }
                                      })
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
              //-------------------------regions----------------------------------
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      child: ListView.builder(
                        itemCount: regionList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, ind) {
                          return Center(
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                              regionList[ind].name.toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black)),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                              '\u{20B9}' +
                                                  regionList[ind]
                                                      .cost
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black)),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: IconButton(
                                              onPressed: () => {
                                                    () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Container(
                                                              child: Dialog(
                                                                child:
                                                                    Container(
                                                                  height: 150,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                        child:
                                                                            TextFormField(
                                                                          maxLines:
                                                                              1,
                                                                          controller:
                                                                              newRegionPrice,
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            labelText:
                                                                                "New Price",
                                                                            floatingLabelBehavior:
                                                                                FloatingLabelBehavior.never,
                                                                            border: OutlineInputBorder(
                                                                                // borderRadius: BorderRadius.circular(20),
                                                                                borderSide: BorderSide.none),
                                                                            filled:
                                                                                true,
                                                                            fillColor: Color.fromRGBO(
                                                                                233,
                                                                                236,
                                                                                239,
                                                                                0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      ElevatedButton(
                                                                          style: ButtonStyle(
                                                                              shape: MaterialStatePropertyAll(ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                                                              backgroundColor: MaterialStatePropertyAll(Colors.lightBlueAccent)),
                                                                          onPressed: () {
                                                                            final numericRegex =
                                                                                RegExp(r'^[0-9]*$');
                                                                            if (numericRegex.hasMatch(newRegionPrice.text) &&
                                                                                newRegionPrice.text.trim() != "") {
                                                                              regionList[ind].cost = newRegionPrice.text;
                                                                              http.post(Uri.parse("http://steefotmtmobile.com/steefo/updateregion.php"), body: {
                                                                                "regionName": regionList[ind].name,
                                                                                "price": newRegionPrice.text
                                                                              });
                                                                            }
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Text("Submit"))
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    }(),
                                                  },
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.blueAccent,
                                              )),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: IconButton(
                                              onPressed: () {
                                                QuickAlert.show(
                                                    confirmBtnColor:
                                                        Colors.redAccent,
                                                    showCancelBtn: true,
                                                    context: context,
                                                    type: QuickAlertType.error,
                                                    barrierDismissible: true,
                                                    cancelBtnText: 'Cancel',
                                                    confirmBtnText: 'Delete',
                                                    title:
                                                        'Are you sure you want to delete this item?',
                                                    // text: 'Delete',
                                                    // textColor: Colors.red,

                                                    // customAsset: Icon(Icons.login_outlined),
                                                    onConfirmBtnTap: () async {
                                                      () async {
                                                        await http.post(
                                                            Uri.parse(
                                                                "http://steefotmtmobile.com/steefo/deleteregion.php"),
                                                            body: {
                                                              "regionName":
                                                                  regions[ind]
                                                                      .toString()
                                                              // regionList[ind]
                                                              //     .value
                                                              //     .toString(),
                                                            });

                                                        regionList
                                                            .removeAt(ind);
                                                        setState(() {});
                                                      }();
                                                      Navigator.pop(context);
                                                    },
                                                    onCancelBtnTap: () {
                                                      Get.back();
                                                    });
                                                // remove(),
                                                print("Delete button pressed");
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
                                )),
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                          height: 35,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.add)),
                      onTap: () {
                        //  showAlertDialog(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            // String contentText = "Content of Dialog";
                            // return StatefulBuilder(
                            //   builder: (context, setState) {
                            return Form(
                              key: _formKey,
                              child: AlertDialog(
                                title: Text(
                                  "ADD REGION",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                //  content: Text(contentText),
                                actions: <Widget>[
                                  TextFormField(
                                    controller: newRegion,
                                    maxLines: 1,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: "Add region",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      border: OutlineInputBorder(
                                        // borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Color.fromRGBO(233, 236, 239,
                                          0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "This field can't be empty";
                                      } else
                                        return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    maxLines: 1,
                                    controller: RegionPrice,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: "Add Price",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      border: OutlineInputBorder(
                                          // borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Color.fromRGBO(233, 236, 239,
                                          0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "This field can't be empty";
                                      } else
                                        return null;
                                    },
                                  ),
                                  // TextButton(
                                  //   onPressed: () => Navigator.pop(context),
                                  //   child: Text("Cancel"),
                                  // ),
                                  TextButton(
                                      child: Text(
                                        "ADD",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.greenAccent,
                                            fontSize: 20),
                                      ),
                                      onPressed: () async {
                                        // print(newBasePrice.text);
                                        if (_formKey.currentState!.validate()) {
                                          await http.post(
                                              Uri.parse(
                                                  "http://steefotmtmobile.com/steefo/addregion.php"),
                                              body: {
                                                "regionName": newRegion.text,
                                                "tCost": RegionPrice.text,
                                              });

                                          Get.to(HomePage());
                                          Get.showSnackbar(
                                            GetSnackBar(
                                              title: "",
                                              message:
                                                  'Item added successfully!',
                                              //  icon: const Icon(Icons.refresh),
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );

                                          setState(() {
                                            //   gradeList.length;
                                          });
                                        }
                                      })
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),

              //--------------------Payment-----------------------------

              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ListView.builder(
                      itemCount: paymentList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      //scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, ind) {
                        return Center(
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                            "${paymentList[ind].paymentName.toString() + "Days"}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black)),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                            paymentList[ind]
                                                .paymentCost
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black)),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                            onPressed: () => {
                                                  () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Container(
                                                            child: Dialog(
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                height: 170,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .topLeft,
                                                                      child:
                                                                          Text(
                                                                        "EDIT PRICE",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    TextFormField(
                                                                      maxLines:
                                                                          1,
                                                                      controller:
                                                                          newPaymentPrice,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        labelText:
                                                                            "New Price",
                                                                        floatingLabelBehavior:
                                                                            FloatingLabelBehavior.never,
                                                                        border: OutlineInputBorder(
                                                                            // borderRadius: BorderRadius.circular(20),
                                                                            borderSide: BorderSide.none),
                                                                        filled:
                                                                            true,
                                                                        fillColor: Color.fromRGBO(
                                                                            233,
                                                                            236,
                                                                            239,
                                                                            0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                                                                      ),
                                                                    ),
                                                                    ElevatedButton(
                                                                        style: ButtonStyle(
                                                                            shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(
                                                                                    20))),
                                                                            backgroundColor: MaterialStatePropertyAll(Colors
                                                                                .lightBlueAccent)),
                                                                        onPressed:
                                                                            () {
                                                                          final numericRegex =
                                                                              RegExp(r'^[0-9]*$');
                                                                          if (numericRegex.hasMatch(newPaymentPrice.text) &&
                                                                              newPaymentPrice.text.trim() != "") {
                                                                            paymentList[ind].paymentCost =
                                                                                newPaymentPrice.text;
                                                                            http.post(Uri.parse("http://steefotmtmobile.com/steefo/updatepayment.php"), body: {
                                                                              "paymentName": paymentList[ind].paymentName,
                                                                              "paymentPrice": newPaymentPrice.text,
                                                                            });
                                                                          }
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Text(
                                                                            "Submit")),
                                                                    // ElevatedButton(
                                                                    //     style: ButtonStyle(
                                                                    //         shape: MaterialStatePropertyAll(ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                                                    //         backgroundColor: MaterialStatePropertyAll(Colors.lightBlueAccent)),
                                                                    //     onPressed: () {
                                                                    //       final numericRegex =
                                                                    //       RegExp(r'^[0-9]*$');
                                                                    //       if (numericRegex.hasMatch(newRegionPrice.text) &&
                                                                    //           newRegionPrice.text.trim() != "") {
                                                                    //         regionList[ind].cost = newRegionPrice.text;
                                                                    //         http.post(Uri.parse("http://steefotmtmobile.com/steefo/updateregion.php"), body: {
                                                                    //           "regionName": regionList[ind].name,
                                                                    //           "price": newRegionPrice.text
                                                                    //         });
                                                                    //       }
                                                                    //       Navigator.pop(context);
                                                                    //     },
                                                                    //     child: Text("Submit"))

                                                                    // TextButton(
                                                                    //     onPressed:
                                                                    //         () {
                                                                    //       // final numericRegex =
                                                                    //       //     RegExp(r'^[0-9]*$');
                                                                    //       // if (numericRegex.hasMatch(newPrice.text) &&
                                                                    //       //     newPrice.text.trim() != "") {
                                                                    //       // gradeList[ind].price =
                                                                    //       //     newPrice.text;
                                                                    //       http.post(
                                                                    //           Uri.parse("http://urbanwebmobile.in/steffo/updatepayment.php"),
                                                                    //           body: {
                                                                    //             "paymentName": paymentList[ind].paymentName,
                                                                    //             "paymentPrice": editpaymentPrice.text
                                                                    //           });
                                                                    //       // }
                                                                    //       Navigator.pop(
                                                                    //           context);
                                                                    //     },
                                                                    //     child:
                                                                    //         Container(
                                                                    //           padding:
                                                                    //               EdgeInsets.only(right: 10),
                                                                    //           alignment:
                                                                    //               Alignment.bottomRight,
                                                                    //           child: Text(
                                                                    //               "Submit",
                                                                    //               style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                                                                    //     ))
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  }()
                                                },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.blueAccent,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                            onPressed: () => {
                                                  QuickAlert.show(
                                                      confirmBtnColor:
                                                          Colors.redAccent,
                                                      showCancelBtn: true,
                                                      context: context,
                                                      type:
                                                          QuickAlertType.error,
                                                      barrierDismissible: true,
                                                      cancelBtnText: 'Cancel',
                                                      confirmBtnText: 'Delete',
                                                      title:
                                                          'Are you sure you want to delete this item?',
                                                      // text: 'Delete',
                                                      // textColor: Colors.red,

                                                      // customAsset: Icon(Icons.login_outlined),
                                                      onConfirmBtnTap:
                                                          () async {
                                                        () async {
                                                          await http.post(
                                                              Uri.parse(
                                                                  "http://steefotmtmobile.com/steefo/deletepayment.php"),
                                                              body: {
                                                                "paymentName":
                                                                    paymentList[
                                                                            ind]
                                                                        .paymentName
                                                                        .toString(),
                                                              });
                                                          paymentList
                                                              .removeAt(ind);
                                                          setState(() {});
                                                        }();
                                                        Navigator.pop(context);
                                                      },
                                                      onCancelBtnTap: () {
                                                        Get.back();
                                                      }),
                                                  // remove(),
                                                  print(
                                                      "Delete button pressed"),
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
                              )),
                        );
                      },
                    ),
                    GestureDetector(
                      child: Container(
                          height: 35,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.add)),
                      onTap: () {
                        //  showAlertDialog(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            // String contentText = "Content of Dialog";
                            // return StatefulBuilder(
                            //   builder: (context, setState) {
                            return Form(
                              key: _formKey,
                              child: AlertDialog(
                                title: Text(
                                  "ADD PAYMENT",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                //  content: Text(contentText),
                                actions: <Widget>[
                                  TextFormField(
                                    controller: newPaymentname,
                                    maxLines: 1,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: "Add Days",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      border: OutlineInputBorder(
                                        // borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Color.fromRGBO(233, 236, 239,
                                          0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "This field can't be empty";
                                      } else
                                        return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    maxLines: 1,
                                    controller: newPaymentPrice,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: "Add Price",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      border: OutlineInputBorder(
                                          // borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                      fillColor: Color.fromRGBO(233, 236, 239,
                                          0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "This field can't be empty";
                                      } else
                                        return null;
                                    },
                                  ),
                                  // TextButton(
                                  //   onPressed: () => Navigator.pop(context),
                                  //   child: Text("Cancel"),
                                  // ),
                                  TextButton(
                                      child: Text(
                                        "ADD",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.greenAccent,
                                            fontSize: 20),
                                      ),
                                      onPressed: () async {
                                        // print(newBasePrice.text);
                                        if (_formKey.currentState!.validate()) {
                                          await http.post(
                                              Uri.parse(
                                                  "http://steefotmtmobile.com/steefo/addpayment.php"),
                                              body: {
                                                "paymentName":
                                                    newPaymentname.text,
                                                "paymentPrice":
                                                    newPaymentPrice.text,
                                              });
                                          //Navigator.pop(context);
                                          //  gradeList.indexed.toList();
                                          Get.to(HomePage());
                                          Get.showSnackbar(
                                            GetSnackBar(
                                              title: "",

                                              message:
                                                  'Item added successfully!',
                                              //  icon: const Icon(Icons.refresh),
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );
                                          setState(() {
                                            //   gradeList.length;
                                          });
                                        }
                                      })
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
