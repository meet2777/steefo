import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stefomobileapp/Models/order.dart';
import 'package:stefomobileapp/ui/cards.dart';
import '../Models/consignee.dart';
import '../Models/dealer.dart';
import '../Models/grade.dart';
import '../Models/lumpsum.dart';
import '../Models/payment.dart';
import '../Models/region.dart';
import '../Models/size.dart';
import '../Models/user.dart';
import '../ui/common.dart';
import '../Models/order.dart';

class EditOrderPage extends StatelessWidget {
  final Order? order;
  EditOrderPage({super.key,required this.order});
  @override
  Widget build(BuildContext context) {
    return EditOrderContent(order: order);
  }
}

class EditOrderContent extends StatefulWidget {
  EditOrderContent({Key? key,this.order}): super(key: key);
  final Order? order;
  // final selected = 0;
  @override
  State<EditOrderContent> createState() => _EditOrderPageState();
}

class _EditOrderPageState extends State<EditOrderContent> {

  late TextEditingController party_name;
  late TextEditingController consignee_name;
  late TextEditingController party_pan_no;

  TextEditingController dateInput = TextEditingController();
  // TextEditingController party_name = TextEditingController(text: widget.order?.party_name);

  // @override
  // void initState() {
  //   dateInput.text = ""; //set the initial value of text field
  //   super.initState();
  // }

  final _formKey = GlobalKey<FormState>();

  late FocusNode focusNode1;
  late FocusNode focusNode2;
  late FocusNode focusNode3;
  late FocusNode focusNode4;
  late FocusNode focusNode5;
  late FocusNode focusNode6;
  late FocusNode focusNode7;
  late FocusNode focusNode8;
  late FocusNode focusNode9;
  late FocusNode focusNode10;
  late FocusNode focusNode11;
  final field1Key = GlobalKey<FormFieldState>();
  final field2Key = GlobalKey<FormFieldState>();
  final field3Key = GlobalKey<FormFieldState>();
  final field4Key = GlobalKey<FormFieldState>();
  final field5Key = GlobalKey<FormFieldState>();
  final field6Key = GlobalKey<FormFieldState>();
  final field8Key = GlobalKey<FormFieldState>();
  final field7Key = GlobalKey<FormFieldState>();
  final field9Key = GlobalKey<FormFieldState>();
  final field10Key = GlobalKey<FormFieldState>();
  final field11Key = GlobalKey<FormFieldState>();
  var idfortoken;
  var user_type;

  void loadusertype() async {

    print("ckecking data"+ widget.order!.dealerName.toString());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user_type = await prefs.getString('userType');

    idfortoken = await prefs.getString('id');
    print('idfortoken${idfortoken}');
  }

  var token;
  String isItem = " ";



  @override
  Widget build(BuildContext context) {

    selectedDealer = widget.order?.dealerName.toString();
    // selectedRegion = widget.order?.region.toString();
    selectedOrderType = widget.order?.orderType.toString();
    selectedTransType = widget.order?.trans_type.toString();
    selectedType = widget.order?.loading_type.toString();
    selectedconsignee?.userName = widget.order?.consignee_name.toString();
    trailerType = widget.order?.trailerType.toString();
    selectedRegion = widget.order?.region.toString();
    selectedpaymentType = widget.order?.paymentTerm.toString();

    // consignee_name = TextEditingController(text: "${widget.order?.consignee_name}");
    party_name = TextEditingController(text: "${widget.order?.dealerName}");
    party_address = TextEditingController(text: "${widget.order?.party_address}");
    pincode = TextEditingController(text: "${widget.order?.pincode}");
    party_pan_no = TextEditingController(text: "${widget.order?.PartygstNumber}");
    party_mob_num = TextEditingController(text: "${widget.order?.party_mob_num}");
    base_price = TextEditingController(text: "${widget.order?.base_price}");
    // qty = TextEditingController(text: "${widget.order?.totalQuantity}");
    deliveryDate = TextEditingController(text: "${widget.order?.deliveryDate}");
    // selectedconsignee= TextEditingController(text: "${widget.order?.consignee_name}") as Consignee?;


    print("${widget.order?.consignee_name} consignee name");
    //  getRegReqs();
    loadusertype();

    // party_name = TextEditingController(text: "${widget.order?.party_name}");

    return Scaffold(
      appBar: appbar("Edit Order", () {
        Navigator.pop(context);
      }),
      body: PlaceOrderBody(),
    );
  }

  String? id, supplier_id;
  var f1 = 0;
  Future<void> loadData() async {
    if (f1 == 0) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      id = await prefs.getString('id');
      supplier_id = await prefs.getString('parentId');
      // if (user_type == "Builder") {
      //   selectedOrderType = "With Size";
      //   selectedTransType = "None";
      //   selectedType = "None";
      // }
      f1 = 1;
      setState(() {});
    }
    //print("is setstate on loop");
  }

  Consignee?
  selectedconsignee;

  String?
  // selectedValue,
      seletedconsignee,
      selectedDealer,
      selectedSize,
      selectedGrade,
      selectedType,
      trailerType,
      selectedpaymentType,
      selectedRegion,
      selectedTransType,
      selectedOrderType;
  TextEditingController qty = TextEditingController();
  // TextEditingController party_name = TextEditingController(text: "${widget.order}");
  // TextEditingController party_address = TextEditingController();
  // TextEditingController pincode = TextEditingController();
  // TextEditingController party_pan_no = TextEditingController();
  // TextEditingController party_mob_num = TextEditingController();
  // TextEditingController loading_type = TextEditingController();
  // TextEditingController base_price = TextEditingController();
  // TextEditingController deliveryDate = TextEditingController();
  List<Lumpsum> lumpsumList = [];
  bool isInventoryDataLoaded = false;


  loadLumpsumData() async {
    print("inLoadLumpsumData");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final user_id = await prefs.getString('id');
    print('${user_id}ddddd');

    var res = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/getinventory.php"),
        body: {
          "user_id": user_id,
        });
    var responseData = jsonDecode(res.body);
    /// var orders = [];
    print("lumpsumlist${responseData}");
    for (int i = 0; i < responseData["data"].length; i++) {
      print(responseData['data'][i]['name']);
      Lumpsum l = Lumpsum();
      l.partyname = responseData["data"][i]["partyName"];
      l.order_id = responseData["data"][i]["order_id"];
      l.name = responseData["data"][i]["name"];
      l.basePrice = responseData["data"][i]["basePrice"];
      l.qty = responseData["data"][i]["qty"];
      l.qty_left = responseData["data"][i]["qty_left"];
      l.price = responseData["data"][i]["price"];
      l.status = responseData["data"][i]["orderStatus"];
      l.ls_id = responseData['data'][i]["ls_id"];
      l.date = responseData["data"][i]["createdAt"];
      lumpsumList.add(l);
    }
    isInventoryDataLoaded = true;
    setState(() {});
  }

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();

    // selectedSize.sort();
    loadLumpsumData();
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();
    focusNode4 = FocusNode();
    focusNode5 = FocusNode();
    focusNode6 = FocusNode();
    focusNode7 = FocusNode();
    focusNode8 = FocusNode();
    focusNode9 = FocusNode();
    focusNode10 = FocusNode();
    focusNode11 = FocusNode();
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
    focusNode5.addListener(() {
      if (!focusNode5.hasFocus) {
        field5Key.currentState?.validate();
      }
    });
    focusNode6.addListener(() {
      if (!focusNode6.hasFocus) {
        field6Key.currentState?.validate();
      }
    });
    focusNode7.addListener(() {
      if (!focusNode7.hasFocus) {
        field7Key.currentState?.validate();
      }
    });
    focusNode8.addListener(() {
      if (!focusNode8.hasFocus) {
        field8Key.currentState?.validate();
      }
    });
    focusNode9.addListener(() {
      if (!focusNode9.hasFocus) {
        field9Key.currentState?.validate();
      }
    });
    focusNode10.addListener(() {
      if (!focusNode10.hasFocus) {
        field10Key.currentState?.validate();
      }
    });
    focusNode11.addListener(() {
      if (!focusNode11.hasFocus) {
        field11Key.currentState?.validate();
      }
    });
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    focusNode5.dispose();
    focusNode6.dispose();
    focusNode7.dispose();
    focusNode8.dispose();
    focusNode9.dispose();
    focusNode10.dispose();
    focusNode11.dispose();
    super.dispose();
  }

  // List items = ["TMT"];

  List users = [];
  List dealers = [];
  List payments = [];
  List grades = [];
  List sizes = [];
  List regions = [];
  List consignee = [];
  List<Dealer> dealerList = [];
  List<Payment> paymentList = [];
  List<Grade> gradeList = [];
  List<Region> regionList = [];
  List<ItemSize> sizeList = [];
  List<Consignee> consigneeList = [];
  List<User> userList = [];

  // TextEditingController party_name = TextEditingController(text: 'name: ${Order().party_name}');

  num tot_qty = 0;
  var listOfColumns = [];
  var f = 0;
  num tot_price = 0;
  loadItemData() async {


    if (f == 0) {
      f = 1;
      var res = await http.post(Uri.parse("http://steefotmtmobile.com/steefo/getsize.php"));
      var responseData = jsonDecode(res.body);
      for (int i = 0; i < responseData['data'].length; i++) {
        sizes.add(responseData['data'][i]["sizeValue"]);
        ItemSize s = ItemSize();
        s.price = responseData['data'][i]["sizePrice"];
        s.value = responseData['data'][i]["sizeValue"];
        sizeList.add(s);
      }
      var res1 = await http.post(Uri.parse("http://steefotmtmobile.com/steefo/getgrade.php"));
      var responseData1 = jsonDecode(res1.body);
      for (int i = 0; i < responseData1['data'].length; i++) {
        print(responseData1['data'][i]);
        grades.add(responseData1['data'][i]["gradeName"]);
        Grade s = Grade();
        s.price = responseData1['data'][i]["gradePrice"];
        s.value = responseData1['data'][i]["gradeName"];
        gradeList.add(s);
      }

      var res2 = await http.post(Uri.parse("http://steefotmtmobile.com/steefo/getregions.php"));
      var responseData2 = jsonDecode(res2.body);
      for (int i = 0; i < responseData2['data'].length; i++) {
        print(responseData2['data'][i]);
        regions.add(responseData2['data'][i]["regionName"]);
        Region r = Region();
        r.name = responseData2['data'][i]["regionName"];
        r.cost = responseData2['data'][i]["tCost"];
        regionList.add(r);
      }

      var res3 = await http.post(Uri.parse("http://steefotmtmobile.com/steefo/getpayment.php"));
      var responseData3 = jsonDecode(res3.body);
      for (int i = 0; i < responseData3['data'].length; i++) {
        print(responseData3['data'][i]);
        payments.add(responseData3['data'][i]["paymentName"]);
        Payment p = Payment();
        p.paymentName = responseData3['data'][i]["paymentName"];
        p.paymentCost = responseData3['data'][i]["paymentPrice"];
        paymentList.add(p);
      }


      String uri;
      final SharedPreferences pref = await SharedPreferences.getInstance();
      var id1 = await pref.getString('id');
      uri = "http://steefotmtmobile.com/steefo/getconsignee.php";
      var res5 = await http.post(Uri.parse(uri), body: {
        "id": id1,
      });
      var responseData5 = jsonDecode(res5.body);
      print(responseData5['data']);
      for (int i = 0; i < responseData5['data'].length; i++) {
        print(responseData5['data'][i]);
        consignee.add(responseData5['data'][i]["userName"]);
        Consignee c = Consignee();
        // c.cons_id = responseData5['data'][i]["cons_id"];
        // consDtls[responseData5["data"][i]["userName"]];
        c.id = responseData5['data'][i]["id"];
        c.userName = responseData5['data'][i]["userName"];
        c.userContact = responseData5['data'][i]["userContact"];
        c.userGST = responseData5['data'][i]["userGST"];
        c.userAddress = responseData5['data'][i]["userAddress"];
        consigneeList.add(c);
      }


      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = await prefs.getString('id');
      // userType = await prefs.getString('userType');
      uri = "http://steefotmtmobile.com/steefo/getchildren.php";
      var res6 = await http.post(Uri.parse(uri), body: {
        "id": id,
      });
      print(id);
      var responseData6 = json.decode(res6.body);
      print(responseData6['data']);
      for (int i = 0; i < responseData6['data'].length; i++) {
        users.add(responseData6['data'][i]["orgName"]);
        User u = User();
        u.id = responseData6['data'][i]["id"];
        u.userType = responseData6['data'][i]["userType"];
        u.orgName = responseData6['data'][i]["orgName"];
        u.address = responseData6['data'][i]["address"];
        u.email = responseData6['data'][i]["email"];
        u.mobileNumber = responseData6['data'][i]["mobileNumber"];
        u.gstNumber = responseData6['data'][i]["gstNumber"];
        u.panNumber = responseData6['data'][i]["panNumber"];
        u.adhNumber = responseData6['data'][i]["adhNumber"];
        userList.add(u);
        print(u);
        // child.add(u);
      }

      setState(() {});
    }
  }

  List payment = ["15 Days", "30 Days"];
  List trailer = ["Streight", "Band"];
  List type = ["Loose", "Bhari(Bundle)"];
  List transType = ["Ex-Work", "FOR"];
  List orderType = ["Lump-sum", "With Size", "Use Lumpsum"];
  int itemNum = 1;
  num totalQuantity = 0;

  // final List<Map<String, String>> listOfColumns = [];

  // String? str_party_name = widget.order?.party_name;

  // TextEditingController party_name = TextEditingController();
  TextEditingController party_address = TextEditingController();
  TextEditingController pincode = TextEditingController();
  // TextEditingController party_pan_no = TextEditingController();
  TextEditingController party_mob_num = TextEditingController();
  TextEditingController loading_type = TextEditingController();
  TextEditingController base_price = TextEditingController();
  TextEditingController deliveryDate = TextEditingController();

  onEditOrder() async {

    if (selectedOrderType == "Use Lumpsum") {
      for (int i = 0; i < reductionData.length; i++) {
        var res = await http.post(
            Uri.parse("http://steefotmtmobile.com/steefo/updateinventory.php"),
            body: {
              "id": reductionData[i]["id"],
              "qty": reductionData[i]["qty"]
            }
            );
      }
    }




    var resorder = await http.post(
      Uri.parse("http://steefotmtmobile.com/steefo/updateOrder.php"),
      body:
      selectedOrderType == "Lump-sum" ?
      {
        "order_id": widget.order?.order_id,
        "userId": id!,
        "supplierId": supplier_id!,
        "shippingAddress": party_address.text,
        "pincode": pincode.text,
        "region": selectedRegion??"",
        "dealerName": selectedDealer??"",
        "consigneeName": selectedconsignee?.userName?? "",
        "partyName": "",
        "PartygstNumber": party_pan_no.text,
        "mobileNumber": party_mob_num.text,
        "basePrice": base_price.text,
        "status": "Pending",
        "trailerType": "None",
        "loadingType": "None",
        "transType": "None",
        "paymentTerm": "None",
        "orderType": selectedOrderType??"",
        "totalQuantity": qty.text,
        "totalPrice": tot_price.toString(),
        "deliveryDate": deliveryDate.text,
        "dateTime": DateTime.now().toString(),
      }:
      {
        "order_id": widget.order?.order_id,
        "userId": id!,
        "supplierId": supplier_id!,
        "shippingAddress": party_address.text,
        "pincode": pincode.text,
        "partyName": "",
        "region": selectedRegion??"",
        "dealerName": selectedDealer??"",
        "consigneeName": selectedconsignee?.userName?? "",
        "PartygstNumber": party_pan_no.text,
        "mobileNumber": party_mob_num.text,
        "basePrice": base_price.text,
        "status": "Pending",
        "loadingType": selectedType?? "",
        "orderType": selectedOrderType?? "",
        "paymentTerm": selectedpaymentType?? "",
        "trailerType": trailerType?? "",
        "transType": selectedTransType?? "",
        "totalQuantity": qty.text,
        "totalPrice": tot_price.toString(),
        "deliveryDate": deliveryDate.text,
        "dateTime": DateTime.now().toString(),
      }
    );



    print("body"+resorder.request.toString());
    var responseData = jsonDecode(resorder.body);

    print("body"+resorder.body);
    if (responseData["status"] == '200' && selectedOrderType != "Lump-sum") {
      for (int i = 0; i < listOfColumns.length; i++) {
        http.post(
          Uri.parse("http://steefotmtmobile.com/steefo/updatewithsize.php"),
          body: {
            "order_id": widget.order?.order_id,
            "name": listOfColumns[i]["Name"],
            "qty": listOfColumns[i]["Qty"],
            "price": listOfColumns[i]["Price"]
          },
        );
        //  print("${listOfColumns[i]["Price"]}...................");
        tot_price = tot_price + num.parse(listOfColumns[i]["Price"]);
      }
    } else {
      for (int i = 0; i < listOfColumns.length; i++) {
        http.post(
          Uri.parse("http://steefotmtmobile.com/steefo/updatelumpsum.php"),
          body: {
            "order_id": responseData["value"].toString(),
            "name": listOfColumns[i]["Name"],
            "qty": listOfColumns[i]["Qty"],
            "price": listOfColumns[i]["Price"],
            "basePrice": base_price.text
          },
        );
        //  tot_price = tot_price + int.parse(responseData["data"][i]["price"]);
      }
    }



    print("response data"+ resorder.body);
    print(responseData["value"].toString());

    if(responseData["status"] == '200'){
      Fluttertoast.showToast(
          msg: 'Your Order Is Placed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white);
      Future.delayed(Duration(seconds: 1)).then((value) => {Navigator.of(context).pushNamed("/home")});
      // Navigator.of(context).pushNamed("/home");
    }else{
      Fluttertoast.showToast(
          msg: responseData["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white);
    }


    // print(listOfColumns[0]['Name']);
  }

  num tCost = 0;
  var reductionData = [];
  Widget PlaceOrderBody() {
    loadItemData();
    // List<DropdownMenuItem<String>> dropdownItems = [];
    List<DropdownMenuItem<String>> dropdownUser = [];
    List<DropdownMenuItem<String>> dropdownGrades = [];
    List<DropdownMenuItem<String>> dropdownSize = [];
    List<DropdownMenuItem<String>> dropdownDealer = [];
    List<DropdownMenuItem<String>> dropdownType = [];
    List<DropdownMenuItem<String>> dropdownTrailerType = [];
    List<DropdownMenuItem<String>> dropdownPaymentType = [];
    List<DropdownMenuItem<String>> dropdownRegion = [];
    List<DropdownMenuItem<String>> dropdownTransType = [];
    List<DropdownMenuItem<String>> dropdownOrderType = [];
    List<DropdownMenuItem<Consignee>> dropdownConsigneeType = [];
    // List<DropdownMenuItem<String>> getItems() {
    //   for (int i = 0; i < items.length; i++) {
    //     DropdownMenuItem<String> it = DropdownMenuItem(
    //       value: items[i],
    //       child: Text(items[i]),
    //     );
    //     dropdownItems.add(it);
    //   }
    //   return dropdownItems;
    // }

    List<DropdownMenuItem<String>> getGrade() {
      for (int i = 0; i < grades.length; i++) {
        DropdownMenuItem<String> it = DropdownMenuItem(
          value: grades[i],
          child: Text(grades[i]),
        );
        dropdownGrades.add(it);
      }

      return dropdownGrades;
    }

    List<DropdownMenuItem<Consignee>> getConsignee() {
      for (int i = 0; i < consigneeList.length; i++) {
        print(consigneeList[i].id.toString());
        DropdownMenuItem<Consignee> it = DropdownMenuItem(
          value: consigneeList[i],
          child: Text(consigneeList[i].userName??" "),
        );
        dropdownConsigneeType.add(it);
      }
      return dropdownConsigneeType;
    }                                        

    List<DropdownMenuItem<String>> getUser() {
      for (int i = 0; i < users.length; i++) {
        DropdownMenuItem<String> it = DropdownMenuItem(
          child: Text(users[i]),
          value: users[i],
        );
        dropdownUser.add(it);
      }
      return dropdownUser;
    }

    List<DropdownMenuItem<String>> getDealer() {
      for (int i = 0; i < dealers.length; i++) {
        DropdownMenuItem<String> it = DropdownMenuItem(
          value: dealers[i],
          child: Text(dealers[i]),
        );
        dropdownDealer.add(it);
      }
      return dropdownDealer;
    }

    List<DropdownMenuItem<String>> getSize() {
      for (int i = 0; i < sizes.length; i++) {
        DropdownMenuItem<String> it = DropdownMenuItem(
          value: sizes[i],
          child: Text(sizes[i]),
        );
        dropdownSize.add(it);
      }
      return dropdownSize;
    }

    List<DropdownMenuItem<String>> getRegion() {
      for (int i = 0; i < regions.length; i++) {
        DropdownMenuItem<String> it = DropdownMenuItem(
          value: regions[i],
          child: Text(regions[i]),
        );
        dropdownRegion.add(it);
      }
      return dropdownRegion;
    }

    List<DropdownMenuItem<String>> getTrailerType() {
      for (int i = 0; i < trailer.length; i++) {
        DropdownMenuItem<String> it = DropdownMenuItem(
          value: trailer[i],
          child: Text(trailer[i]),
        );
        dropdownTrailerType.add(it);
      }
      return dropdownTrailerType;
    }

    List<DropdownMenuItem<String>> getPaymentType() {
      for (int i = 0; i < payments.length; i++) {
        DropdownMenuItem<String> it = DropdownMenuItem(
          value: payments[i],
          child: Text("${payments[i]} Days"),
        );
        dropdownPaymentType.add(it);
      }
      return dropdownPaymentType;
    }

    List<DropdownMenuItem<String>> getType() {
      for (int i = 0; i < type.length; i++) {
        DropdownMenuItem<String> it = DropdownMenuItem(
          value: type[i],
          child: Text(type[i]),
        );
        dropdownType.add(it);
      }
      return dropdownType;
    }

    List<DropdownMenuItem<String>> getTransType() {
      for (int i = 0; i < transType.length; i++) {
        DropdownMenuItem<String> it = DropdownMenuItem(
          value: transType[i],
          child: Text(transType[i]),
        );
        dropdownTransType.add(it);
      }
      return dropdownTransType;
    }

    List<DropdownMenuItem<String>> getOrderType() {
      for (int i = 0; i < orderType.length; i++) {
        DropdownMenuItem<String> it = DropdownMenuItem(
          value: orderType[i],
          child: Text(orderType[i]),
        );
        dropdownOrderType.add(it);
      }
      // setState(() {});
      return dropdownOrderType;
    }

    loadData();

    return Form(
      // key: _formKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //
          //     transform: GradientRotation(1.07),
          //     colors: [
          //       Color.fromRGBO(75, 100, 160, 1.0),
          //       Color.fromRGBO(19, 59, 78, 1.0),
          //     ]
          //
          // )
            color: Colors.white),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              //-------------------------Consignee Dropdown------------------------------------

              LayoutBuilder(builder: (context, constraints){
                if(user_type == "Distributor" || user_type == "Dealer"){
                  return Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                            hintText: "Select Consignee",
                            hintStyle: TextStyle(fontSize: 20),
                            filled: true,
                            fillColor:
                            Color.fromRGBO(233, 236, 239, 0.792156862745098),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              // borderRadius: BorderRadius.circular(20)
                            )),
                        value: selectedconsignee,
                        items: getConsignee(),
                        // onChanged: (Consignee newValue) {
                        //   selectedconsignee = newValue;
                        //   // var selectedconsignee = consigneeList.firstWhere()
                        //   print('consignee ==> ${selectedconsignee}');
                        //   party_address.text= consDtls[selectedconsignee].toString();
                        //   party_mob_num.text= consDtls[selectedconsignee].toString();
                        //   // var ind = dealers.indexOf(selectedDealer);
                        //
                        //   // tCost = int.parse(regionList[ind].cost!);
                        // },
                        validator: (selectedValue) {
                          if (selectedValue == null) {
                            // return 'Please select a value.';
                          }
                          return null;
                        }, onChanged: (Consignee? value) {
                        selectedconsignee = value;
                        party_address.text= value!.userAddress.toString();
                        party_mob_num.text= value.userContact.toString();
                        party_pan_no.text = value.userGST.toString();
                      },
                      ));
                }else{
                  return Container();
                }
              },
              ),

              //-------------------------Dealer Dropdown------------------------------------

              LayoutBuilder(builder: (context, constraints){
                if(user_type == "Distributor"){
                  return Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                            hintText: "Select dealer",
                            hintStyle: TextStyle(fontSize: 20),
                            filled: true,
                            fillColor:
                            Color.fromRGBO(233, 236, 239, 0.792156862745098),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              // borderRadius: BorderRadius.circular(20)
                            )),
                        value: selectedDealer,
                        items: getUser(),
                        onChanged: (String? newValue) {
                          selectedDealer = newValue;
                          // var ind = dealers.indexOf(selectedDealer);

                          // tCost = int.parse(regionList[ind].cost!);
                        },
                        validator: (selectedValue) {
                          if (selectedValue == null) {
                            // return 'Please select a value.';
                          }
                          return null;
                        },
                      ));
                }else{
                  return Container();
                }
              },
              ),



              //----------------------------Shipping Address------------------

              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  // key: field2Key,
                  // focusNode: focusNode2,
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return 'Please enter an Address.';
                  //   }
                  //   return null;
                  // },
                  controller: party_address,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                      hintText: "Shipping Address",
                      hintStyle: TextStyle(fontSize: 20),
                      //  floatingLabelBehavior: FloatingLabelBehavior.never,
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Color.fromRGBO(233, 236, 239,
                          0.792156862745098) //Color.fromRGBO(233, 236, 239, 0.792156862745098)

                  ),
                ),
              ),
              //----------------------------Pincode--------------------
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  // key: field11Key,
                  // focusNode: focusNode11,
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return 'Please enter a Pincode.';
                  //   }
                  //   return null;
                  // },
                  controller: pincode,
                  // maxLines: 4,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                      hintText: "Pincode",
                      hintStyle: TextStyle(fontSize: 20),
                      //  floatingLabelBehavior: FloatingLabelBehavior.never,
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Color.fromRGBO(233, 236, 239,
                          0.792156862745098) //Color.fromRGBO(233, 236, 239, 0.792156862745098)

                  ),
                ),
              ),
              //-------------------------------Region---------------------------

              Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                        hintText: "Select Region of Delivery",
                        hintStyle: TextStyle(fontSize: 20),
                        filled: true,
                        fillColor:
                        Color.fromRGBO(233, 236, 239, 0.792156862745098),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          // borderRadius: BorderRadius.circular(20)
                        )),
                    value: selectedRegion,
                    items: getRegion(),
                    onChanged: (String? newValue) {
                      selectedRegion = newValue;
                      var ind = regions.indexOf(selectedRegion);
                      tCost = int.parse(regionList[ind].cost!);
                    },
                    // validator: (selectedValue) {
                    //   if (selectedValue == null) {
                    //     // return 'Please select a value.';
                    //   }
                    //   return null;
                    // },
                  )),

              //-----------------------------GST Number-------------------------

              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  // key: field3Key,
                  // focusNode: focusNode3,
                  controller: party_pan_no,
                  maxLines: 1,
                  maxLength: 15,
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return 'Please enter a value.';
                  //   } else if (value.length < 15) {
                  //     return 'Please Enter Valid Number';
                  //   }
                  //   if (value.length > 15) {
                  //     return 'Please Enter Valid Number';
                  //   }
                  //   return null;
                  // },
                  decoration: const InputDecoration(
                      hintText: "GST Number",
                      hintStyle: TextStyle(fontSize: 20),
                      //  floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: const Color.fromRGBO(233, 236, 239,
                          0.792156862745098) //Color.fromRGBO(233, 236, 239, 0.792156862745098)

                  ),
                ),
              ),

              //----------------------------Contact Number----------------------

              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  // key: field4Key,
                  // focusNode: focusNode4,
                  controller: party_mob_num,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return 'Please Enter a Number.';
                  //   } else if (value.length < 10) {
                  //     return 'Please Enter Valid Number';
                  //   }
                  //   if (value.length > 10) {
                  //     return 'Please Enter Valid Number';
                  //   }
                  //   return null;
                  // },
                  decoration: const InputDecoration(
                      hintText: "Contact Number",
                      hintStyle: TextStyle(fontSize: 20),
                      // floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Color.fromRGBO(233, 236, 239,
                          0.792156862745098) // Color.fromRGBO(233, 236, 239, 0.792156862745098)
                  ),
                ),
              ),

              //-------------------------Order Type------------------------------------

              LayoutBuilder(builder: (context, constraints) {
                if (user_type == "Distributor" ||
                    user_type == "Dealer" ||
                    user_type == "Builder") {
                  return Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                            hintText: "Select Order Type",
                            hintStyle: TextStyle(fontSize: 20),
                            filled: true,
                            fillColor: Color.fromRGBO(
                                233, 236, 239, 0.792156862745098),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              // borderRadius: BorderRadius.circular(20)
                            )),
                        value: selectedOrderType,
                        items: getOrderType(),
                        onChanged: null,


                      ));
                } else {
                  return Container();
                }
              }),

              //--------------------------Payment Term--------------------------

              LayoutBuilder(builder: (context, constraints) {
                if (selectedOrderType != "Lump-sum"
                // (user_type == "Dealer" || user_type == "Distributor")
                ) {
                  return Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                                hintText: "Payment Term",
                                hintStyle: TextStyle(fontSize: 20),
                                filled: true,
                                fillColor: Color.fromRGBO(
                                    233, 236, 239, 0.792156862745098),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  // borderRadius: BorderRadius.circular(20)
                                )),
                            value: selectedpaymentType,
                            items: getPaymentType(),
                            onChanged: (String? newValue) {
                              selectedpaymentType = newValue;
                            },
                            // key: field5Key,
                            // focusNode: focusNode5,
                            // validator: (selectedValue) {
                            //   if (selectedValue == null) {
                            //     //return 'Please select a value.';
                            //   }
                            //   return null;
                            // },
                          )),

                      //-------------------------Trailer Type------------------------------------

                      Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                                hintText: "Select trailer Type",
                                hintStyle: TextStyle(fontSize: 20),
                                filled: true,
                                fillColor: Color.fromRGBO(
                                    233, 236, 239, 0.792156862745098),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  // borderRadius: BorderRadius.circular(20)
                                )),
                            value: trailerType,
                             items: getTrailerType(),
                            onChanged: (String? newValue) {
                              trailerType = newValue;
                            },
                            // key: field5Key,
                            // focusNode: focusNode5,
                            // validator: (selectedValue) {
                            //   if (selectedValue == null) {
                            //     //return 'Please select a value.';
                            //   }
                            //   return null;
                            // },
                          )),

                      //-------------------------Loading Type------------------------------------

                      Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                                hintText: "Select Loading Type",
                                hintStyle: TextStyle(fontSize: 20),
                                filled: true,
                                fillColor: Color.fromRGBO(
                                    233, 236, 239, 0.792156862745098),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  // borderRadius: BorderRadius.circular(20)
                                )),
                            value: selectedType,
                            items: getType(),
                            onChanged: (String? newValue) {
                              selectedType = newValue;
                            },
                            // key: field5Key,
                            // focusNode: focusNode5,
                            // validator: (selectedValue) {
                            //   if (selectedValue == null) {
                            //     //return 'Please select a value.';
                            //   }
                            //   return null;
                            // },
                          )),

                      //-------------------------Transportation Type------------------------------------

                      Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                                hintText: "Select Transportation Type",
                                hintStyle: TextStyle(fontSize: 20),
                                filled: true,
                                fillColor: Color.fromRGBO(
                                    233, 236, 239, 0.792156862745098),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  // borderRadius: BorderRadius.circular(20)
                                )),
                            value: selectedTransType,
                            items: getTransType(),
                            onChanged: (String? newValue) {
                              selectedTransType = newValue;
                            },
                            // key: field5Key,
                            // focusNode: focusNode5,
                            // validator: (selectedValue) {
                            //   if (selectedValue == null) {
                            //     return 'Please select a value.';
                            //   }
                            //   return null;
                            // },
                          ))
                    ],
                  );
                } else {
                  return Container();
                }
              }),



              //------------------------------BasePrice--------------------------

              //-------------------Add Item Block-------------------------------

              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                decoration: const BoxDecoration(
                  // color: Colors.white, borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    //------------------------- Grade ------------------------------------

                    Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                              hintText: "Select The Grade",
                              hintStyle: TextStyle(fontSize: 20),
                              filled: true,
                              fillColor: Color.fromRGBO(
                                  233, 236, 239, 0.792156862745098),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                // borderRadius: BorderRadius.circular(20)
                              )),
                          value: selectedGrade,
                          items: getGrade(),
                          onChanged: (String? newValue) {
                            selectedGrade = newValue;
                          },
                          // key: field8Key,
                          // focusNode: focusNode8,
                          // validator: (selectedValue) {
                          //   if (selectedValue == null) {
                          //     // return 'Please select a value.';
                          //   }
                          //   return null;
                          // },
                        )),

                    //-------------------------Select Size------------------------------------

                    LayoutBuilder(builder: (context, constraints) {
                      if (selectedOrderType == "With Size" ||
                          selectedOrderType == "Use Lumpsum") {
                        if (selectedSize == " ") {
                          selectedSize = null;
                        }
                        return Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                  hintText: "Select The Size",
                                  hintStyle: TextStyle(fontSize: 20),
                                  filled: true,
                                  fillColor: Color.fromRGBO(
                                      233, 236, 239, 0.792156862745098),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    // borderRadius: BorderRadius.circular(20)
                                  )),
                              value: selectedSize,
                              items: getSize(),
                              onChanged: (String? newValue) {
                                selectedSize = newValue;
                              },
                              // key: field7Key,
                              // focusNode: focusNode7,
                              // validator: (selectedValue) {
                              //   if (selectedValue == null) {
                              //     // return 'Please select a value.';
                              //   }
                              //   return null;
                              // },
                            ));
                      } else {
                        selectedSize = " ";
                        return Container();
                      }
                    }),

                    //-------------------------Base Price------------------------------------

                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: TextFormField(
                        readOnly: true,
                        enableInteractiveSelection: false,
                        textInputAction: TextInputAction.next,
                        // key: field6Key,
                        // focusNode: focusNode6,
                        controller: base_price,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Please enter a value.';
                        //   }
                        //   return null;
                        // },
                        decoration: const InputDecoration(
                            hintText: "Base Price",
                            hintStyle: TextStyle(fontSize: 20),
                            //  floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Color.fromRGBO(
                                233, 236, 239, 0.792156862745098)),
                      ),
                    ),
                    //-------------------------Quantity------------------------------------
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        controller: qty,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Quantity",
                          hintStyle: TextStyle(fontSize: 20),
                          //  floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color.fromRGBO(233, 236, 239,
                              0.792156862745098), //Color.fromRGBO(233, 236, 239, 0.792156862745098)
                        ),
                      ),
                    ),

                    //-------------------------deliveryDate------------------------------------

                    Center(
                      child: Text(isItem, style: TextStyle(color: Colors.red)),
                    ),

                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            textStyle: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(190, 40)),
                        onPressed: () {
                          var grdpct, szpct = 0;
                          var przpct = 0;
                          if (selectedOrderType != "Use Lumpsum") {
                            if (selectedGrade != null &&
                                // selectedpaymentType != null &&
                                selectedSize != null &&
                                // qty.text != "" &&
                                base_price.text != "" &&
                                selectedRegion != null
                            // selectedTransType != null
                            ) {
                              for (int i = 0; i < paymentList.length; i++) {
                                if (paymentList[i].paymentName == selectedpaymentType) {
                                  przpct = int.parse(paymentList[i].paymentCost!);
                                }
                              }
                              for (int i = 0; i < gradeList.length; i++) {
                                if (gradeList[i].value == selectedGrade) {
                                  grdpct = int.parse(gradeList[i].price!);
                                }
                              }
                              for (int i = 0; i < sizeList.length; i++) {
                                if (sizeList[i].value == selectedSize) {
                                  szpct = int.parse(sizeList[i].price!);
                                }
                              }
                              setState(() {
                                //  tot_price = 0;
                                isItem = " ";
                                int f = 0;
                                for (int i = 0; i < listOfColumns.length; i++) {
                                  if (listOfColumns.elementAt(i)["Name"]! ==
                                      // "$selectedValue"
                                      "$selectedGrade $selectedSize") {
                                    int quty = int.parse(
                                        listOfColumns.elementAt(i)["Qty"]!);
                                    quty = quty + int.parse(qty.text);

                                    num p = selectedTransType == "Ex-Work" &&
                                        selectedOrderType != "Lump-sum"
                                        ? (int.parse(base_price.text) +
                                        grdpct +
                                        przpct +
                                        szpct +
                                        tCost) *
                                        quty
                                        : (int.parse(base_price.text) +
                                        grdpct +
                                        przpct+
                                        szpct +
                                        0) *
                                        quty;
                                    listOfColumns.elementAt(i)["Qty"] =
                                        quty.toString();
                                    listOfColumns.elementAt(i)["Price"] =
                                        p.toString();
                                    f = 1;
                                  }
                                }
                                if (f == 0) {
                                  listOfColumns.add({
                                    "Sr_no": itemNum.toString(),
                                    "Name": "$selectedGrade $selectedSize",
                                    "Qty": qty.text,
                                    "Price": selectedTransType == "Ex-Work" &&
                                        selectedOrderType != "Lump-sum"
                                        ? ((int.parse(base_price.text) +
                                        grdpct +
                                        szpct +
                                        przpct +
                                        tCost) *
                                        double .parse(qty.text))
                                        .toString()
                                        : ((int.parse(base_price.text) +
                                        grdpct +
                                        szpct +
                                        przpct +
                                        0) *
                                        double.parse(qty.text))
                                        .toString()
                                  });

                                  itemNum = itemNum + 1;
                                }
                              });

                              totalQuantity =
                                  totalQuantity + double.parse(qty.text);
                              // print(tot_price);
                            } else {
                              isItem = "Please Enter All of the above fields";
                              setState(() {});
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {

                                for (int i = 0; i < paymentList.length; i++) {
                                  if (paymentList[i].paymentName == selectedpaymentType) {
                                    przpct = int.parse(paymentList[i].paymentCost!);
                                  }
                                }

                                for (int i = 0; i < gradeList.length; i++) {
                                  if (gradeList[i].value == selectedGrade) {
                                    grdpct = int.parse(gradeList[i].price!);
                                  }
                                }
                                for (int i = 0; i < sizeList.length; i++) {
                                  if (sizeList[i].value == selectedSize) {
                                    szpct = int.parse(sizeList[i].price!);
                                  }
                                }
                                return Dialog(
                                  surfaceTintColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 16,
                                  child: Column(
                                    children: [
                                      Container(
                                        // margin: EdgeInsets.only(left: 5, right: 5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(19, 59, 78, 1.0),
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          height: 50,
                                          // width: ,
                                          child: Text("Select The Lumpsum",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.w600)))),
                                      SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height /
                                              1.24,
                                          child: ListView.builder(
                                              reverse: true,
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: lumpsumList.length,
                                              itemBuilder: (context, index) {
                                                print(lumpsumList[index]
                                                    .name
                                                    .toString());
                                                // print(
                                                //     "lumpsumlistlength${lumpsumList[index].name}selectedlist${selectedGrade}");
                                                // print(int.parse(
                                                //         lumpsumList[index]
                                                //             .qty!) >=
                                                //     int.parse(qty.text));
                                                return LayoutBuilder(builder:
                                                    (context, constraints) {
                                                  if (lumpsumList[index]
                                                      .status
                                                      .toString() ==
                                                      "Confirmed"

                                                  // lumpsumList[index].name ==
                                                  //       "$selectedGrade" &&
                                                  ) {
                                                    print(
                                                        "entrance............");
                                                    print(
                                                        "status....................${lumpsumList[index].name}");
                                                    print(szpct);
                                                    // print(prcpct);
                                                    print(selectedSize);
                                                    return Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10),
                                                        child: InkWell(
                                                          onTap: () {
                                                            listOfColumns.add({
                                                              "Sr_no": itemNum
                                                                  .toString(),
                                                              "Name":
                                                              lumpsumList[
                                                              index]
                                                                  .name.toString()+ selectedSize.toString(),
                                                              "Qty": qty.text,
                                                              "Price": selectedTransType == "Ex-Work" &&
                                                                  selectedOrderType != "Lump-sum"
                                                                  ? (
                                                                  (int.parse(lumpsumList[index].basePrice!) +
                                                                      tCost + szpct + grdpct + przpct ) *
                                                                      double.parse(qty.text)).toString()
                                                                  : ((int.parse(lumpsumList[index].basePrice!)+
                                                                  szpct + grdpct + przpct) *
                                                                  double.parse(qty.text)).toString()
                                                            });
                                                            lumpsumList[index]
                                                                .qty = (double.parse(
                                                                lumpsumList[index]
                                                                    .qty!) -
                                                                double.parse(qty
                                                                    .text))
                                                                .toString();

                                                            reductionData.add({
                                                              "id": lumpsumList[
                                                              index]
                                                                  .ls_id,
                                                              "qty":
                                                              lumpsumList[
                                                              index]
                                                                  .qty
                                                            });
                                                            totalQuantity =
                                                                totalQuantity +
                                                                    double.parse(qty
                                                                        .text);
                                                            itemNum =
                                                                itemNum + 1;
                                                            setState(() {});
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: InventoryCard(
                                                              context,
                                                              lumpsumList[
                                                              index],Order(), id ),
                                                        )
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                });
                                              }),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: const Text("Add Item",style: TextStyle(color: Colors.white),)),
                  ],
                ),
              ),
              LayoutBuilder(builder: (context, constraints) {
                if (selectedTransType == "Ex-Plant") {
                  return Text(
                    "*Transportaion Cost Are Included",
                    style: TextStyle(color: Colors.red),
                  );
                } else
                  return Container();
              }),

              //-----------------------DataTable--------------------------------

              Card(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // borderRadius: BorderRadius.circular(20)
                        ),
                        child: SingleChildScrollView(
                          child:

                          DataTable(
                            border: TableBorder.all(
                                width: 1, color: Colors.black26),
                            columnSpacing:
                            MediaQuery.of(context).size.width / 20,
                            //border: TableBorder.all(borderRadius: BorderRadius.circular(20)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),

                            columns: const [
                              DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Sr\nNo',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  numeric: true),
                              DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'HSN/Name',
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                              DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Quantity\n(Tons)',
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                              DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Price',
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                              DataColumn(label: Text(' '))
                            ],
                            rows:
                            listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
                                .map(
                                  (element) {
                                int i;
                                for (i = 0; i < listOfColumns.length; i++) {
                                  if (listOfColumns.elementAt(i)["Name"] ==
                                      element["Name"]!) {
                                    break;
                                  }
                                }
                                //listOfColumns.indexWhere((element) => false);
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(Align(
                                      child: Text((i + 1).toString()),
                                      alignment: Alignment.center,
                                    )), //Extracting from Map element the value
                                    DataCell(Text(element["Name"]!)),
                                    DataCell(Align(
                                        child: Text(element["Qty"]!),
                                        alignment: Alignment.center)),
                                    DataCell(Align(
                                        child: Container(
                                          child: Text(element["Price"]!),
                                          width: 70,
                                        ),
                                        alignment: Alignment.center)),
                                    DataCell(Container(
                                      child: IconButton(
                                        icon: Icon(Icons.delete_rounded,
                                            color: Colors.red),
                                        onPressed: () {
                                          // () async {
                                          //   await http.post(
                                          //       Uri.parse(
                                          //           "http://steefotmtmobile.com/steefo/deleteitem.php"),
                                          //       body: {
                                          //         // "gradeName": gradeList[ind].value.toString(),
                                          //         "order_id" : widget.order?.order_id,
                                          //         "Name": listOfColumns[element].value.toString(),
                                          //         "qty": listOfColumns[element].value.toString(),
                                          //         "price": listOfColumns[element].value.toString(),
                                          //       });
                                          //   listOfColumns
                                          //       .remove(element);
                                          //   setState(() {});
                                          // };

                                          setState(() {
                                            listOfColumns.remove(element);
                                            totalQuantity = totalQuantity -
                                                double.parse(element["Qty"]);
                                          });
                                        },
                                      ),
                                      width: 25,
                                    )),
                                    // DataCell(Icon(element["Action"]!))
                                  ],
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                      Align(
                        child: Container(
                            child: Text("Total = $totalQuantity Tons",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700)),
                            margin: EdgeInsets.fromLTRB(0, 10, 10, 10)),
                        alignment: Alignment.bottomRight,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  child: buttonStyle("Submit", () {
                    // if (_formKey.currentState!.validate()) {
                    // }
                    onEditOrder();
                  }))
            ],
          ),
        ),
      ),
    );
  }
}
