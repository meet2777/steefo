import 'dart:convert';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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
  List<Region> regionList = [];

  var isEnabled = false;
  TextEditingController newPrice = TextEditingController();
  TextEditingController Price = TextEditingController();

  TextEditingController newGrade = TextEditingController();

  TextEditingController newSize = TextEditingController();

  TextEditingController newRegionPrice = TextEditingController();

  TextEditingController newRegion = TextEditingController();
  // TextEditingController newSizePrice = TextEditingController();

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user_id = await prefs.getString('id');

    var res1 = await http
        .post(Uri.parse("http://urbanwebmobile.in/steffo/getgrade.php"));
    var responseData1 = jsonDecode(res1.body);
    for (int i = 0; i < responseData1['data'].length; i++) {
      print(responseData1['data'][i]);
      Grade g = Grade();
      g.value = responseData1['data'][i]['gradeName'];
      g.price = responseData1['data'][i]['gradePrice'];
      gradeList.add(g);
    }
    var res2 = await http
        .post(Uri.parse("http://urbanwebmobile.in/steffo/getsize.php"));
    var responseData2 = jsonDecode(res2.body);
    for (int i = 0; i < responseData2['data'].length; i++) {
      sizes.add(responseData2['data'][i]["sizeValue"].toString());
      ItemSize s = ItemSize();
      s.price = responseData2['data'][i]["sizePrice"];
      s.value = responseData2['data'][i]["sizeValue"];
      sizeList.add(s);
    }

    var res3 = await http
        .post(Uri.parse("http://urbanwebmobile.in/steffo/getregions.php"));
    var responseData3 = jsonDecode(res3.body);
    for (int i = 0; i < responseData3['data'].length; i++) {
      print(responseData3['data'][i]);
      regions.add(responseData3['data'][i]["regionName"]);
      Region r = Region();
      r.name = responseData3['data'][i]["regionName"];
      r.cost = responseData3['data'][i]["tCost"];
      regionList.add(r);
    }

    var res = await http.post(
        Uri.parse("http://urbanwebmobile.in/steffo/getinventory.php"),
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
    // loadData();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appbar("Product Controls", () {
          Navigator.pop(context);
        }),
        body: AddItemBody());
  }

  Widget AddItemBody() {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: CustomTabBar(
        titleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        selectedCardColor: Colors.blueGrey,
        selectedTitleColor: Colors.white,
        unSelectedCardColor: Colors.white,
        unSelectedTitleColor: Color.fromRGBO(12, 53, 68, 1),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tabBarItemExtend: ((MediaQuery.of(context).size.width) / 3),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tabBarItems: [
          "GRADE",
          "SIZE",
          "REGION",
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
                                    child: Text(gradeList[ind].value.toString(),
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black)),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                        '\u{20B9}' +
                                            gradeList[ind].price.toString(),
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black)),
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
                                                        height: 150,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .all(
                                                                  10),
                                                              child:
                                                              TextFormField(
                                                                maxLines: 1,
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
                                                                  FloatingLabelBehavior
                                                                      .never,
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
                                                            TextButton(
                                                                onPressed:
                                                                    () {
                                                                  final numericRegex =
                                                                  RegExp(
                                                                      r'^[0-9]*$');
                                                                  if (numericRegex.hasMatch(newPrice
                                                                      .text) &&
                                                                      newPrice.text.trim() !=
                                                                          "") {
                                                                    gradeList[ind].price =
                                                                        newPrice.text;
                                                                    http.post(
                                                                        Uri.parse("http://urbanwebmobile.in/steffo/updategrade.php"),
                                                                        body: {
                                                                          "gradeName": gradeList[ind].value,
                                                                          "price": newPrice.text
                                                                        });
                                                                  }
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                Container(
                                                                  padding: EdgeInsets.only(
                                                                      right:
                                                                      10),
                                                                  alignment:
                                                                  Alignment
                                                                      .bottomRight,
                                                                  child: Text(
                                                                      "Submit",
                                                                      style: TextStyle(
                                                                          fontSize: 17,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Colors.greenAccent)),
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
                                                          "http://urbanwebmobile.in/steffo/deletegrade.php"),
                                                      body: {
                                                        "gradeName":
                                                        gradeList[ind]
                                                            .value
                                                            .toString(),
                                                      });
                                                  gradeList.removeAt(ind);
                                                  setState(() {});
                                                }();
                                                Navigator.pop(context);
                                              },
                                              onCancelBtnTap: () {
                                                Get.back();
                                              }),
                                          // remove(),
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
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
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
                                    labelText: "Add new Grade",
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
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  maxLines: 1,
                                  controller: Price,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "New Price",
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                    border: OutlineInputBorder(
                                      // borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Color.fromRGBO(233, 236, 239,
                                        0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                                  ),
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
                                    await http.post(
                                        Uri.parse(
                                            "http://urbanwebmobile.in/steffo/addgrade.php"),
                                        body: {
                                          "gradeName": newGrade.text,
                                          "gradePrice": Price.text,
                                        });
                                    Navigator.pop(context);
                                    setState;
                                    // loadData();
                                    // setState(() {
                                    //   isEnabled = false;
                                    // });
                                  },
                                )
                              ],
                            );
                          },
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
          Container(
            //  margin: EdgeInsets.only(top: 15),
              child: SingleChildScrollView(
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
                            child: AddNewSize(context, sizeList[ind], () async {
                              await http.post(
                                  Uri.parse(
                                      "http://urbanwebmobile.in/steffo/deletesize.php"),
                                  body: {
                                    "sizeName": sizeList[ind].value.toString(),
                                  });
                              sizeList.removeAt(ind);
                              setState(() {});
                            }, () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      child: Dialog(
                                        child: Container(
                                          height: 150,
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  maxLines: 1,
                                                  controller: newPrice,
                                                  keyboardType:
                                                  TextInputType.number,
                                                  decoration: const InputDecoration(
                                                    labelText: "New Price",
                                                    floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                    border: OutlineInputBorder(
                                                      // borderRadius: BorderRadius.circular(20),
                                                        borderSide:
                                                        BorderSide.none),
                                                    filled: true,
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
                                                      shape: MaterialStatePropertyAll(
                                                          ContinuousRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  20))),
                                                      backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Colors
                                                              .lightBlueAccent)),
                                                  onPressed: () {
                                                    final numericRegex =
                                                    RegExp(r'^[0-9]*$');
                                                    if (numericRegex.hasMatch(
                                                        newPrice.text) &&
                                                        newPrice.text.trim() !=
                                                            "") {
                                                      sizeList[ind].price =
                                                          newPrice.text;
                                                      http.post(
                                                          Uri.parse(
                                                              "http://urbanwebmobile.in/steffo/updatesize.php"),
                                                          body: {
                                                            "sizeName":
                                                            sizeList[ind].value,
                                                            "price": newPrice.text
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
                            }),
                          );
                        },
                      ),
                    ),
                    LayoutBuilder(builder: (context, constraints) {
                      if (isEnabled == true) {
                        return Column(
                          children: [
                            TextFormField(
                              maxLines: 1,
                              controller: newSize,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Add new Size (Along with mm)",
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                border: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Color.fromRGBO(233, 236, 239,
                                    0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                              ),
                            ),
                            // TextFormField(
                            //   maxLines: 1,
                            //   controller: newSizePrice,
                            //   keyboardType: TextInputType.number,
                            //   decoration: const InputDecoration(
                            //     labelText: "Add price",
                            //     floatingLabelBehavior: FloatingLabelBehavior.never,
                            //     border: OutlineInputBorder(
                            //         // borderRadius: BorderRadius.circular(20),
                            //         borderSide: BorderSide.none),
                            //     filled: true,
                            //     fillColor: Color.fromRGBO(233, 236, 239,
                            //         0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                            //   ),
                            // ),
                            ElevatedButton(
                              // icon: Icon(Icons.done_outlined),

                                onPressed: () async {
                                  await http.post(
                                      Uri.parse(
                                          "http://urbanwebmobile.in/steffo/addsize.php"),
                                      body: {"sizeName": newSize.text});
                                  //  Navigator.pop(context);
                                  setState(() {
                                    isEnabled = false;
                                  });
                                  // print(newBasePrice.text);
                                },
                                child: Text("Submit"),
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        ContinuousRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20))),
                                    backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue)))
                          ],
                        );
                      } else {
                        return ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    ContinuousRectangleBorder(
                                        borderRadius: BorderRadius.circular(50))),
                                backgroundColor:
                                MaterialStatePropertyAll(Colors.blueGrey)),
                            onPressed: () {
                              setState(() {
                                isEnabled = true;
                              });
                            },
                            child: Icon(Icons.add)
                          // icon: Icon(
                          //   Icons.add_circle_outline_outlined,
                          //   color: Colors.white,
                          // ), // <-- Text
                        );
                      }
                    }),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              )),
          Container(
              margin: EdgeInsets.only(top: 15),
              child: SingleChildScrollView(
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
                            child: AddNewRegion(context, regionList[ind],
                                    () async {
                                  await http.post(
                                      Uri.parse(
                                          "http://urbanwebmobile.in/steffo/deleteregion.php"),
                                      body: {
                                        "regionName":
                                        regionList[ind].name.toString(),
                                      });
                                  regionList.removeAt(ind);
                                  setState(() {});
                                }, () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          child: Dialog(
                                            child: Container(
                                              height: 150,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(10),
                                                    child: TextFormField(
                                                      maxLines: 1,
                                                      controller: newRegionPrice,
                                                      keyboardType:
                                                      TextInputType.number,
                                                      decoration:
                                                      const InputDecoration(
                                                        labelText: "New Price",
                                                        floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .never,
                                                        border: OutlineInputBorder(
                                                          // borderRadius: BorderRadius.circular(20),
                                                            borderSide:
                                                            BorderSide.none),
                                                        filled: true,
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
                                                          shape: MaterialStatePropertyAll(
                                                              ContinuousRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      20))),
                                                          backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors
                                                                  .lightBlueAccent)),
                                                      onPressed: () {
                                                        final numericRegex =
                                                        RegExp(r'^[0-9]*$');
                                                        if (numericRegex.hasMatch(
                                                            newRegionPrice
                                                                .text) &&
                                                            newRegionPrice.text
                                                                .trim() !=
                                                                "") {
                                                          regionList[ind].cost =
                                                              newRegionPrice.text;
                                                          http.post(
                                                              Uri.parse(
                                                                  "http://urbanwebmobile.in/steffo/updateregion.php"),
                                                              body: {
                                                                "regionName":
                                                                regionList[ind]
                                                                    .name,
                                                                "price":
                                                                newRegionPrice
                                                                    .text
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
                                }),
                          );
                        },
                      ),
                    ),
                    LayoutBuilder(builder: (context, constraints) {
                      if (isEnabled == true) {
                        return Column(
                          children: [
                            TextFormField(
                              controller: newRegion,
                              maxLines: 1,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                labelText: "Add new Region",
                                floatingLabelBehavior:
                                FloatingLabelBehavior.never,
                                border: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Color.fromRGBO(233, 236, 239,
                                    0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                              ),
                            ),
                            ElevatedButton(
                              // icon: Icon(Icons.done_outlined),

                                onPressed: () async {
                                  await http.post(
                                      Uri.parse(
                                          "http://urbanwebmobile.in/steffo/addregion.php"),
                                      body: {"regionName": newRegion.text});
                                  Navigator.pop(context);
                                  setState(() {
                                    isEnabled = false;
                                  });
                                },
                                child: Text("Submit"),
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        ContinuousRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20))),
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.lightBlueAccent)))
                          ],
                        );
                      } else {
                        return ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    ContinuousRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(50))),
                                backgroundColor:
                                MaterialStatePropertyAll(Colors.blueGrey)),
                            onPressed: () {
                              setState(() {
                                isEnabled = true;
                              });
                            },
                            child: Icon(
                              Icons.add,
                            )
                          // icon: Icon(
                          //   Icons.add_circle_outline_outlined,
                          //   color: Colors.white,
                          // ), // <-- Text
                        );
                      }
                    }),
                  ],
                ),
              )),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget addButton = TextButton(
      child: Text(
        "ADD",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent,
            fontSize: 20),
      ),
      onPressed: () async {
        // print(newBasePrice.text);
        await http.post(
            Uri.parse("http://urbanwebmobile.in/steffo/addgrade.php"),
            body: {
              "gradeName": newGrade.text,
              "gradePrice": Price.text,
            });
        Navigator.pop(context);

        // loadData();
        setState(() {
          isEnabled = false;
        });
      },
    );

    // Create AlertDialog

    AlertDialog alert = AlertDialog(
      title: Text(
        "ADD GRADE",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Container(
        height: 130,
        child: Column(
          children: [
            TextFormField(
              controller: newGrade,
              maxLines: 1,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Add new Grade",
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color.fromRGBO(233, 236, 239,
                    0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              maxLines: 1,
              controller: Price,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "New Price",
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                  // borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Color.fromRGBO(233, 236, 239,
                    0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
              ),
            ),
          ],
        ),
      ),
      actions: [
        addButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }
}
// LayoutBuilder(builder: (context, constraints) {
//   if (isEnabled == true) {
//     return Column(
//       children: [
//         TextFormField(
//           controller: newGrade,
//           maxLines: 1,
//           keyboardType: TextInputType.text,
//           decoration: const InputDecoration(
//             labelText: "Add new Grade",
//             floatingLabelBehavior: FloatingLabelBehavior.never,
//             border: OutlineInputBorder(
//                 // borderRadius: BorderRadius.circular(20),
//                 borderSide: BorderSide.none),
//             filled: true,
//             fillColor: Color.fromRGBO(233, 236, 239,
//                 0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
//           ),
//         ),
//         TextFormField(
//           maxLines: 1,
//           controller: newPrice,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(
//             labelText: "New Price",
//             floatingLabelBehavior: FloatingLabelBehavior.never,
//             border: OutlineInputBorder(
//                 // borderRadius: BorderRadius.circular(20),
//                 borderSide: BorderSide.none),
//             filled: true,
//             fillColor: Color.fromRGBO(233, 236, 239,
//                 0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
//           ),
//         ),
//         ElevatedButton(

//             // icon: Icon(Icons.done_outlined),

//             onPressed: () async {
//               // print(newBasePrice.text);
//               await http.post(
//                   Uri.parse(
//                       "http://urbanwebmobile.in/steffo/addgrade.php"),
//                   body: {
//                     "gradeName": newGrade.text,
//                     "gradePrice": newPrice.text,
//                   });
//               Navigator.pop(context);

//               // loadData();
//               setState(() {
//                 isEnabled = false;
//               });
//             },
//             child: Text("Submit"),
//             style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.lightBlueAccent,
//                 foregroundColor: Colors.white))
//       ],
//     );
//   } else {
//     return ElevatedButton(
//       style: ButtonStyle(
//           shape: MaterialStatePropertyAll(
//               ContinuousRectangleBorder(
//                   borderRadius: BorderRadius.circular(50))),
//           backgroundColor:
//               MaterialStatePropertyAll(Colors.blueGrey)),
//       onPressed: () {
//         setState(() {
//           isEnabled = true;
//         });
//       },
//       child: Icon(Icons.add),
//     );
//   }
// }),