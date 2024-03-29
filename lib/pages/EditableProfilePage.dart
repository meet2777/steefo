import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stefomobileapp/UI/common.dart';
import 'package:http/http.dart' as http;
import '../Models/user.dart';

class EditableProfilePage extends StatelessWidget {
  final User? user;
  EditableProfilePage({super.key,required this.user});
  @override
  Widget build(BuildContext context) {
    return ProfileContent(user: user);
  }
}

class ProfileContent extends StatefulWidget {
  final User? user;
  ProfileContent({super.key, required this.user});
  // final selected = 0;
  @override
  State<ProfileContent> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileContent> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  var _selected = 3;

  late FocusNode focusNode1;
  late FocusNode focusNode2;
  late FocusNode focusNode3;
  late FocusNode focusNode4;
  late FocusNode focusNode5;
  late FocusNode focusNode6;
  late FocusNode focusNode7;
  late FocusNode focusNode8;
  late FocusNode focusNode9;
  final field1Key = GlobalKey<FormFieldState>();
  final field2Key = GlobalKey<FormFieldState>();
  final field3Key = GlobalKey<FormFieldState>();
  final field4Key = GlobalKey<FormFieldState>();
  final field5Key = GlobalKey<FormFieldState>();
  final field6Key = GlobalKey<FormFieldState>();
  final field7Key = GlobalKey<FormFieldState>();
  final field8Key = GlobalKey<FormFieldState>();
  final field9Key = GlobalKey<FormFieldState>();

  @override
  void initState() {
    // loadData();
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
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    focusNode5.dispose();
    super.dispose();
  }

  // String?
  // firstName;

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController orgName = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gstNumber = TextEditingController();
  TextEditingController panNumber = TextEditingController();
  TextEditingController adhNumber = TextEditingController();
  TextEditingController address = TextEditingController();

  onSave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = await prefs.getString('id');
    // print(selectedValue);
    await prefs.setString('id', id.toString());
    await prefs.setString('firstName', firstName.text.toString());
    await prefs.setString("lastName", lastName.text.toString());
    await prefs.setString("email", email.text.toString());
    await prefs.setString("mobileNumber", mobileNumber.text.toString());
    await prefs.setString("orgName", orgName.text.toString());
    await prefs.setString("gstNumber", gstNumber.text.toString());
    await prefs.setString("panNumber", panNumber.text.toString());
    await prefs.setString("adhNumber", adhNumber.text.toString());
    await prefs.setString("address", address.text.toString());
    // print(firstName);
    var test = await http.post(
      Uri.parse('http://steefotmtmobile.com/steefo/updateprofile.php'),
      body: {
        "id": id.toString(),
        "firstName": firstName.text,
        "lastName": lastName.text,
        "orgName": orgName.text,
        "mobileNumber": mobileNumber.text,
        "email": email.text,
        "gstNumber": gstNumber.text,
        "panNumber": panNumber.text,
        "adhNumber": adhNumber.text,
        "address": address.text,
      },
    );
    // validateLoginDetails(AutofillHints.email, AutofillHints.password);
    Navigator.of(context).pushNamed("/profilePage");
  }

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    firstName = TextEditingController(text: "${widget.user?.firstName}");
    lastName = TextEditingController(text: "${widget.user?.lastName}");
    orgName = TextEditingController(text: "${widget.user?.orgName}");
    email = TextEditingController(text: "${widget.user?.email}");
    mobileNumber = TextEditingController(text: "${widget.user?.mobileNumber}");
    gstNumber = TextEditingController(text: "${widget.user?.gstNumber}");
    panNumber = TextEditingController(text: "${widget.user?.panNumber}");
    adhNumber = TextEditingController(text: "${widget.user?.adhNumber}");
    address = TextEditingController(text: "${widget.user?.address}");
    print(widget.user!.orgName.toString());

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appbar("Profile", () {
          print("Back Pressed");
          Navigator.pop(context);
        }),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(left: 30, top: 20)),

                Container(
                  // color: Colors.orangeAccent,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      // IconButton(
                      //     icon: Icon(
                      //       Icons.edit,
                      //       color: Color(0xFF8D8D8D),
                      //     ),
                      //     onPressed: null),
                      Row(
                        children: [
                          Text("Your Information",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromRGBO(19, 59, 78, 1.0),
                                  fontFamily: "Poppins_Bold")),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10, top: 10)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Padding(padding: EdgeInsets.only(right: 10,)),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.3,
                            // width: 165,
                            // padding: EdgeInsets.only(left: 5),
                            child: TextFormField(
                              controller: firstName,
                              key: field1Key,
                              focusNode: focusNode1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.black),
                                  //<-- SEE HERE
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.black),
                                ),
                                hoverColor: Colors.black,
                                labelText: "First Name",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a First Name.';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.3,
                            // width: 165,
                            // padding: EdgeInsets.only(right: 5),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: lastName,
                                  key: field2Key,
                                  focusNode: focusNode2,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.black),
                                      //<-- SEE HERE
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.black),
                                    ),
                                    hoverColor: Colors.black,
                                    labelText: "Last Name",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a Last Name.';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        controller: orgName,
                        key: field3Key,
                        focusNode: focusNode3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                            //<-- SEE HERE
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          labelText: "Business Name",
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a Business Name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        controller: email,
                        key: field5Key,
                        focusNode: focusNode5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.black), //<-- SEE HERE
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          labelText: "Email",
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an E-mail address';
                          }
                          return null;
                        },
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: mobileNumber,
                        key: field4Key,
                        focusNode: focusNode4,
                        maxLength: 10,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.black), //<-- SEE HERE
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          labelText: "Contact Number",
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a Mobile Number.';
                          }
                          if (value.length != 10) {
                            return 'Mobile number should contain 10 digits';
                          }
                          return null;
                        },
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        controller: gstNumber,
                        maxLength: 15,
                        key: field6Key,
                        focusNode: focusNode6,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.black), //<-- SEE HERE
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          labelText: "GST Number",
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a GST Number.';
                          } else if (value.length < 15) {
                            return 'Please Enter Valid Number';
                          }
                          if (value.length > 15) {
                            return 'Please Enter Valid Number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        controller: panNumber,
                        key: field7Key,
                        focusNode: focusNode7,
                        maxLength: 10,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black)),
                            labelText: "PAN Number",
                            floatingLabelBehavior: FloatingLabelBehavior.never),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a PAN Number.';
                          } else if (value.length < 10) {
                            return 'Please Enter Valid Number';
                          }
                          if (value.length > 10) {
                            return 'Please Enter Valid Number';
                          }
                          return null;
                        },
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        controller: adhNumber,
                        key: field8Key,
                        focusNode: focusNode8,
                        maxLength: 12,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.black), //<-- SEE HERE
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          labelText: "Aadhaar Number",
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a Aadhar Number.';
                          } else if (value.length < 12) {
                            return 'Please Enter Valid Number';
                          }
                          if (value.length > 12) {
                            return 'Please Enter Valid Number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: address,
                        key: field9Key,
                        focusNode: focusNode9,
                        // minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.black), //<-- SEE HERE
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          labelText: "Address",
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an address';
                          }
                          return null;
                        },
                      ),

                      Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 30),
                          width: MediaQuery.of(context).size.width,
                          child: buttonStyle("Save", () {
                            if (_formKey.currentState!.validate()) {
                              print('validate');
                              onSave();
                            }
                          }))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

    );
  }


}
