import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:gallery_saver/files.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../UI/common.dart';
import 'package:http/http.dart' as http;

class consigneePage extends StatelessWidget {
  const consigneePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedConsignee();
  }

}

class ExtendedConsignee extends StatefulWidget{
  const ExtendedConsignee({Key? key}) : super(key: key);

  @override
  State<ExtendedConsignee> createState() => _consigneeState();
}

class _consigneeState extends State<ExtendedConsignee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar("Consignee Detail", () {
        Navigator.pop(context);
      }),
      body: consigneePagebody(),

    );

  }

  String? id;
  var f1 = 0;
  // Future<void> loadData() async {
  //   if (f1 == 0) {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     id = await prefs.getString('id');
  //     // supplier_id = await prefs.getString('parentId');
  //     // if (user_type == "Builder") {
  //     //   selectedOrderType = "With Size";
  //     //   selectedTransType = "None";
  //     //   selectedType = "None";
  //     // }
  //     f1 = 1;
  //     setState(() {});
  //   }
  //   //print("is setstate on loop");
  // }

  onSubmit() async{
    if (f1 == 0) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      id = await prefs.getString('id');
      // supplier_id = await prefs.getString('parentId');
      // if (user_type == "Builder") {
      //   selectedOrderType = "With Size";
      //   selectedTransType = "None";
      //   selectedType = "None";
      // }
      f1 = 1;
      setState(() {});
    }


    var res = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/setconsignee.php"),
        body: {
          "id":id,
          "userName" : userName.text,
          "userAddress": userAddress.text,
          "userContact": userContact.text,
          "userGST": userGST.text,
        }
    );
    Fluttertoast.showToast(
        msg: 'Consignee Details are saved',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white);
    Navigator.of(context).pushNamed("/home");
  }

  TextEditingController userName = TextEditingController();
  TextEditingController userAddress = TextEditingController();
  TextEditingController userContact = TextEditingController();
  TextEditingController userGST = TextEditingController();

    Widget consigneePagebody(){
    return Form(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                // key: field1Key,
                // focusNode: focusNode1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a Name.';
                  }
                  return null;
                },
                controller: userName,
                maxLines: 1,
                decoration: const InputDecoration(
                    hintText: "Name",
                    hintStyle: TextStyle(fontSize: 20),
                    //  hintText: "Name",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Color.fromRGBO(233, 236, 239,
                        0.792156862745098) //Color.fromRGBO(233, 236, 239, 0.792156862745098)

                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                // key: field2Key,
                // focusNode: focusNode2,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an Address.';
                  }
                  return null;
                },
                controller: userAddress,
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

            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                // key: field1Key,
                // focusNode: focusNode1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a Contact No.';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                maxLength: 10,
                controller: userContact,
                maxLines: 1,
                decoration: const InputDecoration(
                    hintText: "Contact no.",
                    hintStyle: TextStyle(fontSize: 20),
                    //  hintText: "Name",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Color.fromRGBO(233, 236, 239,
                        0.792156862745098) //Color.fromRGBO(233, 236, 239, 0.792156862745098)

                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                // key: field1Key,
                // focusNode: focusNode1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a GST No.';
                  }
                  return null;
                },
                controller:userGST,
                maxLines: 1,
                maxLength: 15,
                decoration: const InputDecoration(
                    hintText: "GST No.",
                    hintStyle: TextStyle(fontSize: 20),
                    //  hintText: "Name",
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Color.fromRGBO(233, 236, 239,
                        0.792156862745098) //Color.fromRGBO(233, 236, 239, 0.792156862745098)

                ),
              ),
            ),

            Container(
              padding: EdgeInsets.only(bottom: 10,top: 200),
                margin:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: MediaQuery.of(context).size.width,
                child: buttonStyle("Submit", () {

                  // if (_formKey.currentState!.validate()) {
                  // }
                  onSubmit();
                }))
          ],
        )
      ),
    );
    }


}
