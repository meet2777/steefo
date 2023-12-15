import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:stefomobileapp/Models/lumpsum.dart';
import 'package:stefomobileapp/pages/GeneratedChallanPage.dart';
import '../Models/order.dart';
import 'package:http/http.dart' as http;
import '../ui/common.dart';

class GenerateChallanPage extends StatelessWidget {
  final Order order;

  GenerateChallanPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GenerateChallanContent(order: order);
    //  throw UnimplementedError();
  }
}

class GenerateChallanContent extends StatefulWidget {
  GenerateChallanContent({super.key, required this.order});
  final Order order;
  @override
  State<GenerateChallanContent> createState() => _GenerateChallanPageState();
}

class _GenerateChallanPageState extends State<GenerateChallanContent> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? token1;

  void firebaseCloudMessaging_Listeners(){
    _firebaseMessaging.getToken().then((token){
      print("token is"+ token!);
      // token1 = token;
      token = token1;
      setState(() {});
    }
    );
  }

  final _formKey = GlobalKey<FormState>();
  late FocusNode focusNode1;
  late FocusNode focusNode2;
  late FocusNode focusNode3;
  late FocusNode focusNode4;

  final field1Key = GlobalKey<FormFieldState>();
  final field2Key = GlobalKey<FormFieldState>();
  final field3Key = GlobalKey<FormFieldState>();
  final field4Key = GlobalKey<FormFieldState>();
  late File file;
  // String? selectedValue;
  // TextEditingController first_name = TextEditingController();
  // TextEditingController last_name = TextEditingController();
  // TextEditingController email = TextEditingController();
  // TextEditingController mob_num = TextEditingController();
  // TextEditingController user_type = TextEditingController();
  // TextEditingController password = TextEditingController();

  TextEditingController transporter_name = TextEditingController();
  TextEditingController vehicle_number = TextEditingController();
  TextEditingController lr_number = TextEditingController();
  TextEditingController ch_number = TextEditingController();
  TextEditingController qty = TextEditingController();

  @override
  void initState() {
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();
    focusNode4 = FocusNode();

    focusNode1.addListener(() {
      if (!focusNode1.hasFocus) {
        field1Key.currentState?.validate();
      }
    });
    focusNode2.addListener(() {
      if (!focusNode2.hasFocus) {
        field2Key.currentState?.validate();
      }
    });
    focusNode3.addListener(() {
      if (!focusNode3.hasFocus) {
        field3Key.currentState?.validate();
      }
    });
    focusNode4.addListener(() {
      if (!focusNode4.hasFocus) {
        field4Key.currentState?.validate();
      }
    });
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    super.dispose();
  }

  Lumpsum lumpsum = Lumpsum();
  // var _selected = 0;
  List listOfColumns = [];
  List items = [];
  final Map<String, double> itemDtls = {};
  String? selectedValue;
  int itemNum = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar("Generate Challan", () {
        Navigator.pop(context);
      }),
      body: GenerateChallanPageBody(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){},
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.red,
      // ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: StylishBottomBar(
      //   option: AnimatedBarOptions(
      //     iconSize: 30,
      //     //barAnimation: BarAnimation.liquid,
      //     iconStyle: IconStyle.simple,
      //     opacity: 0.3,
      //   ),
      //   items: [
      //     BottomBarItem(
      //       icon: const Icon(
      //         Icons.home_filled,
      //       ),
      //       title: const Text('Abc'),
      //       backgroundColor: Colors.red,
      //       selectedIcon: const Icon(
      //         Icons.home_filled,
      //         color: Colors.grey,
      //       ),
      //     ),
      //     BottomBarItem(
      //         icon: const Icon(Icons.inventory_2_rounded),
      //         title: const Text('Safety'),
      //         backgroundColor: Colors.orange,
      //         selectedIcon: const Icon(Icons.inventory_2_rounded,
      //             color: Colors.blueAccent)),
      //     BottomBarItem(
      //         icon: const Icon(
      //           Icons.warehouse_rounded,
      //         ),
      //         title: const Text('Safety'),
      //         backgroundColor: Colors.orange,
      //         selectedIcon: const Icon(Icons.warehouse_rounded,
      //             color: Colors.blueAccent)),
      //     BottomBarItem(
      //         icon: const Icon(
      //           Icons.person_pin,
      //         ),
      //         title: const Text('Cabin'),
      //         backgroundColor: Colors.purple,
      //         selectedIcon:
      //             const Icon(Icons.person_pin, color: Colors.blueAccent)),
      //   ],
      //   //fabLocation: StylishBarFabLocation.center,
      //   hasNotch: false,
      //   currentIndex: _selected,
      //   onTap: (index) {
      //     setState(() {
      //       if (index == 0) {
      //         Navigator.of(context).popAndPushNamed('/home');
      //       }
      //
      //       if (index == 1) {
      //         Navigator.of(context).popAndPushNamed('/inventory');
      //       }
      //     });
      //   },
      // )
    );
    //  throw UnimplementedError();
  }

  int flag = 0;
  loadOrderData() async {
    if (flag == 0) {
      if (widget.order.orderType != "Lump-sum") {
        final res = await http.post(
          Uri.parse("http://steefotmtmobile.com/steefo/getorderdetails.php"),
          body: {
            "order_id": widget.order.order_id,
          },
        );
        var responseData = jsonDecode(res.body);
        print("responsedata${responseData}");
        for (int i = 0; i < responseData["data"].length; i++) {
          items.add(responseData["data"][i]["name"]);
          itemDtls[responseData["data"][i]["name"]] =
              double.parse(responseData["data"][i]["qty_left"]);
        }
      } else {
        final res = await http.post(
          Uri.parse("http://steefotmtmobile.com/steefo/getlumpsumorder.php"),
          body: {
            "order_id": widget.order.order_id,
          },
        );
        var responseData = jsonDecode(res.body);
        print("responsedata${responseData}");
        for (int i = 0; i < responseData["data"].length; i++) {
          items.add(responseData["data"][i]["name"]);
          itemDtls[responseData["data"][i]["name"]] =
              double.parse(responseData["data"][i]["qty_left"]);
        }
      }

      print("item details${itemDtls}");
      flag = 1;
      setState(() {});
    }
  }

  var challan_id;
  onSubmit() async {
    final res = await http.post(
      Uri.parse("http://steefotmtmobile.com/steefo/addchallan.php"),
      body: {
        "order_id": widget.order.order_id,
        "transporter_name": transporter_name.text,
        "vehicle_number": vehicle_number.text,
        "lr_number": lr_number.text,
        "ch_number": ch_number.text,
        "generated_time": DateTime.now().toString(),
      },
    );
    var responseData = jsonDecode(res.body);
    if (responseData["status"] == "200") {print(responseData["data"]);
    }

    for (int i = 0; i < listOfColumns.length; i++) {
      final res = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/addtochallan.php"),
        body: {
          "challan_id": responseData["data"].toString(),
          "name": listOfColumns[i]["Name"],
          "qty": listOfColumns[i]["Qty"].toString(),
          "qty_left": itemDtls[listOfColumns[i]["Name"]].toString(),
          "order_id": widget.order.order_id
        },
      );
    }

    // if (resorder.statusCode == 200) {
      // if(token1 != null){
      var response = await http.post(Uri.parse("http://steefotmtmobile.com/steefo/challanNotification.php"),
          // "http://steefotmtmobile.com/steefo/notificationNew.php" as Uri,
          body: {"token": token1.toString(),
            "challan_id": challan_id.toString(),
            // "order_id": widget.order.order_id
      }
      );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GeneratedChallan(
              challan_id: responseData['data'].toString(),
            )));
      // Future.delayed(Duration(seconds: 1)).then((value) => {Navigator.of(context).pushNamed("/home")});
      print(response.body);
      return jsonEncode(response.body);
      // }
      // else{
      //   print(response.request);
      //   print("Token is null");
      // }
    // }


  }

  Widget GenerateChallanPageBody() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    print("orderid${widget.order.order_id}");
    loadOrderData();
    getItems() {
      dropdownItems = [];
      for (int i = 0; i < items.length; i++) {
        DropdownMenuItem<String> item = DropdownMenuItem<String>(
            value: items[i],
            child: Container(
              decoration: BoxDecoration(
                  //color: ,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(items[i]),
            ));

        dropdownItems.add(item);
      }
      return dropdownItems;
    }

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              //----------------------------TransporterName Field-----------------

              Container(
                //margin: EdgeInsets.fromLTRB(20, 20,20,0),

                width: width,
                padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: TextFormField(
                    controller: transporter_name,
                    textAlign: TextAlign.left,
                    key: field1Key,
                    focusNode: focusNode1,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Transporter Name.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.emoji_transportation_rounded),
                      filled: true,
                      fillColor: Color.fromRGBO(233, 236, 239, 1.0),
                      labelText: "Transporter Name",
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        // borderRadius: BorderRadius.circular(20.0)
                      ),
                    )),
              ),

              //---------------------------Vehicle Number Field-------------------

              Container(
                //margin: EdgeInsets.fromLTRB(20, 20,20,0),

                width: width,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                    controller: vehicle_number,
                    textAlign: TextAlign.left,
                    key: field2Key,
                    focusNode: focusNode2,
                    // textCapitalization: TextCapitalization.characters,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a Vehicle Number.';
                      }
                      return null;
                    },
                    onChanged: (value){
                      vehicle_number.value=TextEditingValue(
                        text: value.toUpperCase(),
                      );
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.fire_truck_rounded),
                      filled: true,
                      fillColor: Color.fromRGBO(233, 236, 239, 1.0),
                      labelText: "Vehicle Number",
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        // borderRadius: BorderRadius.circular(20.0)
                      ),
                    )),
              ),

              Container(
                //margin: EdgeInsets.fromLTRB(20, 20,20,0),

                width: width,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                    controller: lr_number,
                    textAlign: TextAlign.left,
                    key: field3Key,
                    focusNode: focusNode3,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a lr Number.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.numbers),
                      filled: true,
                      fillColor: Color.fromRGBO(233, 236, 239, 1.0),
                      labelText: "LR Number",
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        // borderRadius: BorderRadius.circular(20.0)
                      ),
                    )),
              ),

              Container(
                //margin: EdgeInsets.fromLTRB(20, 20,20,0),

                width: width,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                    controller: ch_number,
                    textAlign: TextAlign.left,
                    // key: field3Key,
                    // focusNode: focusNode3,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a Challan Number.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.numbers),
                      filled: true,
                      fillColor: Color.fromRGBO(233, 236, 239, 1.0),
                      labelText: "Challan No.",
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        // borderRadius: BorderRadius.circular(20.0)
                      ),
                    )),
              ),



              Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                  hintText: "Select The Product",
                                  filled: true,
                                  fillColor: const Color.fromRGBO(
                                      233, 236, 239, 0.792156862745098),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    // borderRadius: BorderRadius.circular(20)
                                  )),
                              value: selectedValue,
                              items: getItems(),
                              onChanged: (String? newValue) {
                                selectedValue = newValue;
                                print(itemDtls[selectedValue]);
                                qty.text = itemDtls[selectedValue].toString();
                              },
                            )),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: TextFormField(
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false
                            ),
                            maxLines: 1,
                            controller: qty,
                            key: field4Key,
                            focusNode: focusNode4,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a Qty.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Quantity",
                              border: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: const Color.fromRGBO(233, 236, 239,
                                  0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                            ),
                          ),
                        ),
                        // Container(
                        //   width: width,
                        //   padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        //   child: ElevatedButton(
                        //     onPressed: () async {
                        //       FilePickerResult? result =
                        //           await FilePicker.platform.pickFiles();

                        //       if (result != null) {
                        //         print(result.files.single.path);
                        //         file = File(result.files.single.path!);
                        //       } else {
                        //         // User canceled the picker
                        //       }
                        //     },
                        //     child: Text("Upload"),
                        //   ),
                        // ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide.none),
                                minimumSize: const Size(190, 40)),
                            onPressed: () {
                              if (selectedValue != null
                                  // qty.text.trim() != "" &&
                                  // int.parse(qty.toString()) > 0 &&
                                  // int.parse(qty.toString()) <=
                                  //     itemDtls[selectedValue]!
                              ) {
                                listOfColumns.add({
                                  "Sr_no": itemNum.toString(),
                                  "Name": "$selectedValue",
                                  "Qty": qty.text
                                });

                                // int quty = itemDtls[selectedValue]!;
                                // quty = quty - int.parse(qty.text);
                                // itemDtls[selectedValue!] = quty;
                                // print(itemDtls[selectedValue]);
                                // itemNum = itemNum + 1;
                                // selectedValue = null;
                                //  qty.text = "";

                                setState(() {});
                              }
                            },
                            child: const Text("Add Item"))
                      ],
                    ),
                  ),

                  //-----------------------DataTable--------------------------------

                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(20)
                      ),
                      child: Container(
                          height: 200,
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                          width: MediaQuery.of(context).size.width,
                          // padding: EdgeInsets.only(
                          //     top: 10, bottom: 10, left: 10, right: 10),
                          // decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.circular(20.0)),
                          // alignment: Alignment.center,
                          // padding: const EdgeInsets.only(top: 20),
                          // child: SingleChildScrollView(
                          //   padding: EdgeInsets.only(
                          //       top: 10, bottom: 10, left: 10, right: 10),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                border: TableBorder.all(
                                    width: 1, color: Colors.black26),
                                columnSpacing:
                                MediaQuery.of(context).size.width / 25,
                                //border: TableBorder.all(borderRadius: BorderRadius.circular(20)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),

                                // border: TableBorder.all(borderRadius: BorderRadius.circular(20)),
                                // decoration: BoxDecoration(
                                //   color: const Color.fromRGBO(
                                //       233, 236, 239, 0.792156862745098),
                                //
                                //   // borderRadius: BorderRadius.circular(20)
                                // ),

                                columns: const [
                                  DataColumn(label: Text('Sr No')),
                                  DataColumn(label: Text('HSN/Name')),
                                  DataColumn(label: Text('Quantity(Tons)')),
                                  DataColumn(label: Text(' '))
                                ],
                                rows:
                                    listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
                                        .map(
                                          ((element) => DataRow(
                                                cells: <DataCell>[
                                                  DataCell(Text(element[
                                                      "Sr_no"]!)), //Extracting from Map element the value
                                                  DataCell(
                                                      Text(element["Name"]!)),
                                                  DataCell(
                                                      Text(element["Qty"])),
                                                  DataCell(
                                                      Container(
                                                        child: IconButton(
                                                          icon: Icon(Icons.delete_rounded,
                                                              color: Colors.red),
                                                          onPressed: () {
                                                            setState(() {
                                                              listOfColumns.remove(element);
                                                              // totalQuantity = (totalQuantity -
                                                              //     double.parse(element["Qty"]!)
                                                              // );
                                                            });
                                                          },
                                                        ),
                                                        width: 25,
                                                      )),

                                                ],
                                              )
                                          ),
                                        )
                                        .toList(),
                              )))),
                ],
              ),

              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: buttonStyle("Submit", () {
                    if (_formKey.currentState!.validate()) {
                      onSubmit();
                    }
                  }))
            ],
          ),
        ),
      ),
    );
  }
}
