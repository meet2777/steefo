import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:stefomobileapp/notification_services.dart';
import 'package:stefomobileapp/pages/Buyers.dart';
import 'package:stefomobileapp/pages/InventoryPage.dart';
import 'package:stefomobileapp/pages/ProfilePage.dart';
import 'package:stefomobileapp/pages/Withlumpsums.dart';
import 'package:stefomobileapp/pages/consigneePage.dart';
import 'package:stefomobileapp/pages/dealerbuyerspage.dart';
import 'package:stefomobileapp/pages/purchases.dart';
import 'package:stefomobileapp/ui/common.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:http/http.dart' as http;
import '../Models/lumpsum.dart';
import '../Models/order.dart';
import '../Models/user.dart';
import 'LoginPage.dart';
import 'package:image_picker/image_picker.dart';
import 'OrderPage.dart';
import 'AddItem.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const HomeContent();
    // throw UnimplementedError();
  }
}

class HomeContent extends StatefulWidget {
  // static const _url =
  //     'https://upload.wikimedia.org/wikipedia/en/8/86/Einstein_tongue.jpg';
  const HomeContent({super.key});
  final selected = 0;
  @override
  State<HomeContent> createState() => _HomePageState(selected);
}

class _HomePageState extends State<HomeContent> {

  NotificationServices notificationServices = NotificationServices();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? token1;

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.getToken().then((token) {
      print("token is" + token!);
      // token1 = token;
      token = token1;
      setState(() {});
    });
  }

  var _selected = 0;

  var fabLoc;
  bool editPrice = false;
  TextEditingController newBasePrice = TextEditingController();

  var homeTab;

  _HomePageState(int val) {
    _selected = val;
  }
  File? pickedImage;
  List<File>? imagesFiles = [];

  var user_type;

  Order get order => Order();
  Lumpsum get lumpsum => Lumpsum();

  String? get curr_user_id => null;

  get index => null;

  get order_id => null;
  void loadusertype() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user_type = await prefs.getString('userType');
  }

  List<User> regReqList = [];
  List<Order> salesOrderList = [];
  List<Order> purchaseOrderList = [];
//load request list length

  String? id3 = " ";
  Future<void> loadorderlength() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var m = id3;
    id3 = await prefs.getString('id');

    if (m != id3) {
      final res = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/vieworder.php"),
        body: {"id": id3!},
      );
      var responseData = jsonDecode(res.body);
      //print(responseData);
      for (int i = 0; i < responseData["data"].length; i++) {
        Order req = Order();
        req.reciever_id = responseData["data"][i]["supplier_id"];
        req.user_id = responseData["data"][i]["user_id"];
        req.orderid = responseData["data"][i]["orderid"];
        req.org_name = responseData["data"][i]["orgName"];
        req.userType = responseData["data"][i]["userType"];
        req.user_mob_num = responseData["data"][i]["mobileNumber"];
        req.user_name = responseData["data"][i]["firstName"] +
            " " +
            responseData["data"][i]["lastName"];
        req.status = responseData["data"][i]["orderStatus"];
        req.PartygstNumber = responseData["data"][i]["PartygstNumber"];
        req.gstNumber = responseData["data"][i]["gstNumber"];
        req.region = responseData["data"][i]["region"];
        req.paymentTerm = responseData["data"][i]["paymentTerm"];
        req.trailerType = responseData["data"][i]["trailerType"];
        req.party_name = responseData["data"][i]["partyName"];
        req.dealerName = responseData["data"][i]["dealerName"];
        req.consignee_name = responseData["data"][i]["consigneeName"];
        req.party_address = responseData["data"][i]["shippingAddress"];
        // req.party_address = responseData["data"][i]["shippingAddress"];
        req.address = responseData["data"][i]["address"];
        req.pincode = responseData["data"][i]["pincode"];
        req.billing_address = responseData["data"][i]["address"];
        req.party_mob_num = responseData["data"][i]["partyMobileNumber"];
        req.loading_type = responseData["data"][i]["loadingType"];
        // req.loading_type = responseData["data"][i][""];
        req.trans_type = responseData["data"][i]["transType"];
        req.totalQuantity = responseData["data"][i]["totalQuantity"];
        req.order_date = responseData["data"][i]["createdAt"];
        req.base_price = responseData["data"][i]["basePrice"];
        req.orderType = responseData["data"][i]["orderType"];
        req.qty_left = responseData["data"][i]["qty_left"];
        req.order_id = responseData["data"][i]["order_id"].toString();
        //print(req);
        if (req.status != "Rejected") {
          if (id3 == req.user_id) {
            purchaseOrderList.add(req);
          }
          if (id3 == req.reciever_id) {
            salesOrderList.add(req);
          }
        }
      }
      setState(() {});
    }

  }

  var flag = 0;

  getRegReqs() async {
    if (flag == 0) {
      print("enter");
      var test = await http.post(
        Uri.parse(
          'http://steefotmtmobile.com/steefo/getrequests.php',
        ),
      );
      //Navigator.of(context).pushNamed("/home");
      var responseData = jsonDecode(test.body);
      // print("remaining qty"+ qty.qty_left.toString());
      print("enter1");
      print(responseData);
      for (int i = 0; i < responseData['data'].length; i++) {
        print("enter2");
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
        u.uploadedFile = responseData['data'][i]['uploadedFile'];
        regReqList.add(u);
        print(u.email);
        print("enter3");
        print(lumpsum.qty_left);
      }
      setState(() {});
      flag = 1;
      print("registrationlist${regReqList.length.toString()}");
    }
  }

  // NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    loadorderlength();
    getRegReqs();
    //  loadrequestlistlength();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
    notificationServices.firebaseInit(context);
    notificationServices.isTokenRefresh();
    notificationServices.setupInteractMessage(context);
    super.initState();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    loadusertype();
    return WillPopScope(
      onWillPop: () async {
        if (_selected == 0) {
          // LogoutAlert();
        }
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
          appBar: appbar(DateFormat('dd-MM-yyyy').format(DateTime.now()), () {
            print("Back Pressed");
            Navigator.pop(context);
          }, alert: LogoutAlert),
          backgroundColor: Colors.white,
          body:
          // responseData1.isEmpty
          //     ? const Center(child: CircularProgressIndicator())
          //     :
        RefreshIndicator(
                onRefresh: refresh,
                child: HomePageBody(),
          ),
          floatingActionButton: LayoutBuilder(builder: (context, constraints) {
            if (user_type != "Manufacturer") {
              //fabLoc = FloatingActionButtonLocation.centerDocked;
              return FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/placeorder');
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                backgroundColor: Colors.grey.shade300,
              );
            } else {
              return Container();
            }
           }
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: StylishBottomBar(
            option: AnimatedBarOptions(
              iconSize: 30,
              //barAnimation: BarAnimation.liquid,
              iconStyle: IconStyle.simple,
              opacity: 0.3,
            ),
            items: [
              BottomBarItem(
                icon: const Icon(
                  Icons.home_outlined,
                ),
                title: const Text('Abc'),
                backgroundColor: Colors.grey,
                //  selectedColor: Colors.cyanAccent,
                selectedIcon:
                    const Icon(Icons.home_filled, color: Colors.black),
              ),
              BottomBarItem(
                  icon: LayoutBuilder(
                    builder: (context, constraints) {
                      if (user_type == "Manufacturer") {
                        return const Icon(
                          Icons.inventory_2_rounded,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  title: const Text('Safety'),
                  backgroundColor: Colors.grey,
                  selectedIcon: const Icon(Icons.inventory_2_rounded,
                      color: Colors.blueAccent)),
              BottomBarItem(
                  icon: LayoutBuilder(
                    builder: (context, constraints) {
                      if (user_type == "Manufacturer") {
                        return const Icon(
                          Icons.warehouse_rounded,
                        );
                      } else {
                        return Padding(padding: EdgeInsets.only());
                      }
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
                      const Icon(Icons.person_pin, color: Colors.blueAccent)),
            ],
            //fabLocation: StylishBarFabLocation.center,
            hasNotch: false,
            currentIndex: _selected,
            onTap: (index) {
              setState(() {
                if (index == 1) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          InventoryPage(
                        order: Order(),
                      ),
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

                if (index == 3) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          ProfilePage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                }
              });
            },
          )),
    );
    //  throw UnimplementedError();
  }

  Future<void> _saveImage(BuildContext context, int i) async {
    String? message;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // Download image
      final http.Response response = await http.get(Uri.parse(
          "http://steefotmtmobile.com/steefo/carousel/" +
              responseData1['images'][i]['name']));
      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename = '${dir.path}/image.jpg';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        message = 'Image saved to disk';
      }
    } catch (e) {
      message = 'An error occurred while saving the image';
    }

    if (message != null) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  String? id = "";
  int currentIndex = 0;
  bool isRes1Loaded = false;
  final List<String> imageList = [];
  var responseData1;
  List<Order> requestList = [];
  List<Order> orderList = [];
  String? isSalesEnabled, basePrice = "0";
  var m;

  Future refresh() async{
    timeDilation;
    setState(() =>
        responseData1.toString()
    );
    // loadData();
    final res1 = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/getsystemdata.php"));
    isRes1Loaded = true;
    responseData1 = jsonDecode(res1.body);

    isSalesEnabled = responseData1['data'][0]['value'];
    basePrice = responseData1['data'][1]['value'];
    print(" $isSalesEnabled and $basePrice");

  }

  Future<void> loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    m = id;
    id = await prefs.getString('id');

    if (m != id) {
      requestList = [];
      orderList = [];
      final res1 = await http.post(
          Uri.parse("http://steefotmtmobile.com/steefo/getsystemdata.php"));
      isRes1Loaded = true;
      responseData1 = jsonDecode(res1.body);

      isSalesEnabled = responseData1['data'][0]['value'];
      basePrice = responseData1['data'][1]['value'];
      print(" $isSalesEnabled and $basePrice");

      print("remaining qty" + lumpsum.qty_left.toString());
      final res = await http.post(
        Uri.parse("http://steefotmtmobile.com/steefo/vieworder.php"),
        body: {"id": id!},
      );
      var responseData = jsonDecode(res.body);

      for (int i = 0; i < responseData["data"].length; i++) {
        Order req = Order();
        req.reciever_id = responseData["data"][i]["supplier_id"];
        req.user_id = responseData["data"][i]["user_id"];
        req.orderid = responseData["data"][i]["orderid"];
        req.user_mob_num = responseData["data"][i]["mobileNumber"];
        req.userType = responseData["data"][i]["userType"];
        req.user_name = responseData["data"][i]["firstName"] +
            " " +
            responseData["data"][i]["lastName"];
        req.status = responseData["data"][i]["orderStatus"];
        req.party_name = responseData["data"][i]["partyName"];
        req.dealerName = responseData["data"][i]["dealerName"];
        req.consignee_name = responseData["data"][i]["consigneeName"];
        req.org_name = responseData["data"][i]["orgName"];
        req.trailerType = responseData["data"][i]["trailerType"];
        req.paymentTerm = responseData["data"][i]["paymentTerm"];
        req.PartygstNumber = responseData["data"][i]["PartygstNumber"];
        req.region = responseData["data"][i]["region"];
        req.gstNumber = responseData["data"][i]["gstNumber"];
        req.party_address = responseData["data"][i]["shippingAddress"];
        req.address = responseData["data"][i]["address"];
        req.pincode = responseData["data"][i]["pincode"];
        req.party_mob_num = responseData["data"][i]["partyMobileNumber"];
        req.loading_type = responseData["data"][i]["loadingType"];
        req.order_date = responseData["data"][i]["createdAt"];
        req.base_price = responseData["data"][i]["basePrice"];
        req.orderType = responseData["data"][i]["orderType"];
        req.order_id = responseData["data"][i]["order_id"].toString();
        //print(req);
        if (req.status != "Denied" && req.status != "Pending") {
          orderList.add(req);
        }
        if (req.status?.trim() == "Pending" && id == req.reciever_id) {
          requestList.add(req);
          print("Added to req list");
        }
      }

      SharedPreferences pref = await SharedPreferences.getInstance();
      final user_id = await pref.getString('id');
      print('${user_id}ddddd');
      var resp = await http.post(
          Uri.parse("http://steefotmtmobile.com/steefo/getinventory.php"),
          body: {
            "user_id": user_id,
          });
      var responseData2 = jsonDecode(resp.body);

      /// var orders = [];
      print("lumpsumlist${responseData2}");
      for (int i = 0; i < responseData2["data"].length; i++) {
        print(responseData2['data'][i]['name']);
        Lumpsum l = Lumpsum();
        l.partyname = responseData2["data"][i]["partyName"];
        l.order_id = responseData2["data"][i]["order_id"];
        l.name = responseData2["data"][i]["name"];
        l.basePrice = responseData2["data"][i]["basePrice"];
        l.qty = responseData2["data"][i]["qty"];
        l.qty_left = responseData2["data"][i]["qty_left"];
        l.price = responseData2["data"][i]["price"];
        l.status = responseData2["data"][i]["orderStatus"];
        l.ls_id = responseData2['data'][i]["ls_id"];
        l.date = responseData2["data"][i]["createdAt"];
        // lumpsumList.add(l);
      }

      if (!mounted) return;
    }
      setState(() {});
  }
  double timeDeletion = 1.0;


  var price = 999;
  bool light = true;
  Widget HomePageBody() {
    loadData();
    // print(NumberFormat.simpleCurrency(locale: 'hi-IN', decimalDigits: 2)
    //     .format(1000000000));
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      //  height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 40),
        physics: BouncingScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // TextButton(
          //   child: Text('send notification'),
          //   onPressed: () {
          //     notificationServices.getDeviceToken().then((value) async {
          //        var data = {
          //         'to': value.toString(),
          //         'priority': 'high',
          //         'notification': {
          //           'title': 'Meet',
          //           'body': 'You Got An Order',
          //         },
          //         'data': {'type': 'msg', 'id': 'parth1234'},
          //       };
          //       print(value.toString());
          //       await http.post(
          //           Uri.parse('https://fcm.googleapis.com/fcm/send'),
          //           body: jsonEncode(data),
          //           headers: {
          //             'Content-Type': 'application/json; charset=UTF-8',
          //             'Authorization':
          //                 'key=AAAA_8-x_z4:APA91bE5c27vN7PgA4BTTOtLcLpxnz3W-Ljjet2YAfwr3b0t10YMXSbgwTX01aJoDZhylqCZjZ3EiuUR9M2KDGcvCfBSBumulrujHHuN7zI_6kN0JIrMCkxiwT63QD5AfNTyE0gxEao7'
          //           });
          //     });
          //   },
          // ),

          //carousel slider start////////////////////////////////////
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              //  color: Colors.grey.shade200,
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              if (isRes1Loaded && user_type != 'challan') {
                print(responseData1['images'].length);
                if (responseData1['images'].length > 0) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: CarouselSlider.builder(
                      itemCount: responseData1['images'].length,
                      options: CarouselOptions(
                        //  scrollPhysics: BouncingScrollPhysics(),
                        height: 320.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        //  aspectRatio: 18 / 11,
                        //  autoPlayCurve: Curves.bounceIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 300),
                        viewportFraction: 1.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                      ),
                      itemBuilder: (context, i, id) {
                        //for onTap to redirect to another screen
                        return GestureDetector(
                          // onLongPress: () {
                          //   imagePickerOption();
                          // },
                          child: Stack(children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Center(
                                  child: Image.network(
                                      height: 330,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      "http://steefotmtmobile.com/steefo/carousel/" +
                                          responseData1['images'][i]['name']),
                                )
                            ),
                            LayoutBuilder(builder: (context, constraints) {
                              if (user_type == "Manufacturer") {
                                return Align(
                                  child: Container(
                                    height: 40,
                                    child: IconButton(
                                        onPressed: () async {
                                          var res1 = await http.post(
                                              Uri.parse(
                                                  "http://steefotmtmobile.com/steefo/delcar.php"),
                                              body: {
                                                "id": responseData1['images'][i]
                                                        ['id']
                                                    .toString(),
                                                "name": responseData1['images']
                                                    [i]['name'],
                                              });
                                          responseData1['images'].removeAt(i);
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          size: 25,
                                        ),
                                        color: Colors.black),
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  alignment: Alignment.bottomLeft,
                                );
                              } else {
                                return Align(
                                  child: Container(
                                      // height: 40,
                                      // margin: EdgeInsets.all(5),
                                      // decoration: BoxDecoration(
                                      //   color: Colors.black12,
                                      //   shape: BoxShape.circle,
                                      // ),
                                      // alignment: Alignment.bottomRight,
                                      child: IconButton(
                                        onPressed: () async {
                                          _saveImage(context, i);
                                        },
                                        iconSize: 35,
                                        color: Colors.black,
                                        // style: ButtonStyle(iconSize: ),
                                          icon: Icon(Icons.file_download_outlined,
                                            color: Color.fromRGBO(19, 59, 78, 1.0)),
                                  )),
                                  alignment: Alignment.bottomRight,
                                );

                              }
                            }),
                            LayoutBuilder(builder: (context, constraints) {
                              if (user_type == "Manufacturer") {
                                return Align(
                                  child: Container(
                                    height: 40,
                                    //color: Colors.amber,
                                    child: IconButton(
                                        onPressed: () async {
                                          await pickMultipleImage(
                                              ImageSource.gallery);
                                          setState(() {
                                            m = id;
                                          });
                                        },
                                        icon: Icon(
                                          size: 25,
                                          Icons.add,
                                          color: Colors.black,
                                        ),
                                        color: Colors.white),
                                    margin: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  alignment: Alignment.bottomRight,
                                );
                              } else {
                                return Container();
                              }
                            })
                          ]),
                        );
                      },
                    ),
                  );
                } else if (responseData1['images'].length == 0 &&
                    user_type == "Manufacturer") {
                  return Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    height: 150,
                    width: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      // border: Border.all(
                      //   color: Colors.black,
                      //)
                    ),
                    child: IconButton(
                      onPressed: () {
                        pickMultipleImage(ImageSource.gallery);
                        setState(() {});
                      },
                      icon: Icon(Icons.add_circle_outline_rounded),
                    ),
                  );
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            }),
          ),

          SizedBox(
            height: 0,
          ),



          SizedBox(
            height: 10,
          ),

          LayoutBuilder(builder: (context, constraint) {
            if (user_type == "challan") {
              return Container(
                child: Column(
                  children: [
                    ListView.builder(
                      reverse: true,
                      itemCount: salesOrderList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        print("ordertype${salesOrderList[index].orderType}");
                        if (salesOrderList[index].orderType == "With Size" ||
                            salesOrderList[index].orderType == "Use Lumpsum") {
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderDetails(
                                            order: salesOrderList[index],
                                            lumpsum: Lumpsum())));
                              },
                              child: orderCard(
                                context,
                                salesOrderList[index],
                                //  qtyandprice[index],
                                id,
                              )
                          );
                        } else
                          return Container();
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          }),

          LayoutBuilder(builder: (context, constraint) {
            if (isSalesEnabled == 'false' &&
                user_type != 'Manufacturer' &&
                user_type != 'challan') {
              print('market is close');
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 10, bottom: 5),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 95, 12, 12),
                    borderRadius: BorderRadius.circular(10)),
                width: double.infinity,
                height: 80,
                // height: 80,
                child: Text(
                  "Booking is closed",
                  style: TextStyle(
                      letterSpacing: 2,
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              );
            } else if (isSalesEnabled == 'true' &&
                user_type != 'Manufacturer' &&
                user_type != 'challan') {
              return Container(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(19, 59, 78, 1.0),
                    borderRadius: BorderRadius.circular(10)),
                width: double.infinity,
                // height: 80,
                child: Column(
                  children: [
                    Text(
                      "BASIC RATE PER TON",
                      style: TextStyle(
                          letterSpacing: 2,
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GradientText(
                          colors: [
                            Colors.white,
                            Colors.white,
                            Colors.white,
                          ],
                          NumberFormat.simpleCurrency(
                                  locale: 'hi-IN', decimalDigits: 0)
                              .format(int.parse(basePrice.toString())),
                          style: TextStyle(
                            letterSpacing: 2,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "/-",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    Text(
                      "North, Central and Rajkot: +200/-  &  Surat: +500/-",
                      style: TextStyle(
                          // letterSpacing: ,
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          }),
          SizedBox(
            height: 10,
          ),

          LayoutBuilder(builder: (context, constraints) {
            if (user_type != "Dealer" &&
                user_type != "Builder" &&
                user_type != 'challan') {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 3.2,
                    child: GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             OrdersPage(order: salesOrderList)));
                          Navigator.of(context).pushNamed('/orders');
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/number-12.png",
                              height: 60,
                              width: 60,
                              //  color: Colors.grey,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Specific",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )
                          ],
                        )),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3.2,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/lumpsumorders');
                          // Get.to(lumpsumsOrdersPage());
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/steel.png",
                              height: 60,
                              width: 60,
                              // color: Color.fromARGB(255, 129, 18, 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Lump-sum",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )
                          ],
                        )),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3.2,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/orderreq');
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/add-friend.png",
                              height: 60,
                              width: 60,
                              // color: Colors.orangeAccent,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Registrations",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )
                          ],
                        )),
                  ),
                ],
              );
            } else {
              return SizedBox();
            }
          }),
          SizedBox(
            height: 20,
          ),

          //.......................

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LayoutBuilder(builder: (context, constraints) {
                if (user_type != "Manufacturer") {
                  return GestureDetector(
                      onTap: () {
                        Get.to(purchases());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.2,
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/add-product.png",
                              height: 60,
                              width: 60,
                              //  color: Colors.blueGrey,
                            ),
                            // Icon(
                            //   Icons.settings_sharp,
                            //   color: Colors.blue,
                            //   size: 60,
                            // ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Purchases",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )
                          ],
                        ),
                      ));
                } else
                  return SizedBox();
              }),

              LayoutBuilder(builder: (context, constraints) {
                if (user_type != "Manufacturer") {
                  return GestureDetector(
                      onTap: () {
                        Get.to(consigneePage());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.2,
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/employee.png",
                              height: 60,
                              width: 60,
                              //  color: Colors.blueGrey,
                            ),
                            // Icon(
                            //   Icons.settings_sharp,
                            //   color: Colors.blue,
                            //   size: 60,
                            // ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Consignee",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )
                          ],
                        ),
                      ));
                } else
                  return Container();
              }),

              LayoutBuilder(builder: (context, constraints) {
                if (user_type == "Distributor") {
                  return GestureDetector(
                      onTap: () {
                        Get.to(DealerPage2());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.2,
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/broker.png",
                              height: 60,
                              width: 60,
                              //  color: Colors.blueGrey,
                            ),
                            // Icon(
                            //   Icons.settings_sharp,
                            //   color: Colors.blue,
                            //   size: 60,
                            // ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Dealers",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )
                          ],
                        ),
                      ));
                } else
                  return Container();
              }),
              // LayoutBuilder(builder: (context, constraints) {
              //   if (user_type != "Manufacturer") {
              //     return Container(
              //       width: MediaQuery.of(context).size.width / 3.2,
              //     );
              //   } else
              //     return Container();
              // }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (user_type == "Manufacturer") {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Get.to(AddItemPage());
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 3.2,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/add-product.png",
                                        height: 60,
                                        width: 60,
                                        //  color: Colors.blueGrey,
                                      ),
                                      // Icon(
                                      //   Icons.settings_sharp,
                                      //   color: Colors.blue,
                                      //   size: 60,
                                      // ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        "Product Control",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      )
                                    ],
                                  ),
                                )),
                            GestureDetector(
                                onTap: () {
                                  _showmodelbottomsheet();
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 3.2,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/price-tag.png",
                                        height: 60,
                                        width: 60,
                                        // color: Colors.orangeAccent,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Price Controls",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      )
                                    ],
                                  ),
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3.2,
                            )
                          ],
                        );
                      } else
                        return SizedBox();
                    },
                  ),
                ],
              ),
            ],
          ),

          // Container(
          //   width: MediaQuery.of(context).size.width / 3.2,
          //   height: 10,
          // ),
          // GestureDetector(
          //     onTap: () {
          //       _showmodelbottomsheet();
          //     },
          //     child: Text("show sheet")),
          // GestureDetector(
          //   onTap: () {
          //     AlertDialog(actions: [],);
          //   },
          //   child: Text("baserate"),
          // )
        ]),

        // SizedBox(
        //   height: 30,
        // )
      ),
    );
  }

  // Widget baserate() {
  //   return LayoutBuilder(builder: (context, constraint) {
  //     // if (light == true) {
  //     return Container(
  //       // height: 150,
  //       child: LayoutBuilder(builder: (context, constraints) {
  //         if (editPrice == false) {
  //           return Column(
  //             mainAxisAlignment: user_type == "Manufacturer"
  //                 ? MainAxisAlignment.spaceBetween
  //                 : MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 "BASIC RATE PER TON",
  //                 style: TextStyle(
  //                     letterSpacing: 2,
  //                     fontSize: 17,
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //               Divider(
  //                 color: Colors.white,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   GradientText(
  //                     colors: [
  //                       Colors.white,
  //                       Colors.white,
  //                       Colors.white60,
  //                     ],
  //                     NumberFormat.simpleCurrency(
  //                             locale: 'hi-IN', decimalDigits: 0)
  //                         .format(int.parse(basePrice.toString())),
  //                     style: TextStyle(
  //                       letterSpacing: 2,
  //                       fontSize: 35,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.black,
  //                     ),
  //                   ),
  //                   Text(
  //                     "/-",
  //                     style: TextStyle(color: Colors.white, fontSize: 35),
  //                   ),
  //                 ],
  //               ),
  //               Divider(
  //                 color: Colors.white,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   user_type == "Manufacturer"
  //                       ? FlutterSwitch(
  //                           borderRadius: 15,
  //                           showOnOff: true,

  //                           //  toggleSize: 50,
  //                           onToggle: (bool value) async {
  //                             light = value;
  //                             setState(() {});
  //                             var res = await http.post(
  //                                 Uri.parse(
  //                                     "http://urbanwebmobile.in/steffo/setsale.php"),
  //                                 body: {"status": value.toString()});
  //                           },

  //                           // This bool value toggles the switch.
  //                           value: light,
  //                           inactiveColor: Colors.black,
  //                           activeColor: Colors.white,
  //                           activeToggleColor: Colors.black,
  //                           inactiveTextColor: Colors.white,
  //                           activeTextColor: Colors.black,
  //                         )
  //                       : Container(),
  //                   LayoutBuilder(builder: (context, constraints) {
  //                     if (user_type == "Manufacturer") {
  //                       return Container(
  //                         // width:
  //                         //     MediaQuery.of(context).size.width * 0.2,
  //                         child: IconButton(
  //                           color: Colors.white,
  //                           onPressed: () {
  //                             setState(() {
  //                               editPrice = true;
  //                             });
  //                           },
  //                           icon: Icon(
  //                             Icons.edit,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       );
  //                     } else {
  //                       return Container();
  //                     }
  //                   }),
  //                 ],
  //               )
  //             ],
  //           );
  //         } else {
  //           return Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Container(
  //                 child: TextFormField(
  //                   // initialValue: price.toString(),
  //                   keyboardType: TextInputType.number,
  //                   textInputAction: TextInputAction.done,
  //                   controller: newBasePrice,
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 22,
  //                       fontWeight: FontWeight.w700),
  //                   cursorColor: Colors.white,
  //                   decoration: const InputDecoration(
  //                     focusedBorder: UnderlineInputBorder(
  //                       borderSide: BorderSide(color: Colors.white, width: 2.0),
  //                     ),
  //                     enabledBorder: UnderlineInputBorder(
  //                       borderSide: BorderSide(color: Colors.black, width: 4.0),
  //                     ),
  //                   ),
  //                 ),
  //                 width: MediaQuery.of(context).size.width / 3,
  //               ),
  //               ElevatedButton(
  //                   onPressed: () {
  //                     // print(newBasePrice.text);
  //                     setState(() {
  //                       editPrice = false;
  //                       final numericRegex = RegExp(r'^[0-9]*$');
  //                       if (numericRegex.hasMatch(newBasePrice.text) &&
  //                           newBasePrice.text.trim() != "") {
  //                         price = int.parse(newBasePrice.text);
  //                         http.post(
  //                             Uri.parse(
  //                                 "http://urbanwebmobile.in/steffo/setbaseprice.php"),
  //                             body: {
  //                               "basePrice": newBasePrice.text.toString()
  //                             });
  //                         basePrice = newBasePrice.text;
  //                       }
  //                     });
  //                   },
  //                   child: Text(
  //                     "Submit",
  //                     style: TextStyle(fontWeight: FontWeight.w600),
  //                   ),
  //                   style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.white,
  //                       foregroundColor: Colors.black))
  //             ],
  //           );
  //         }
  //       }),
  //       width: MediaQuery.of(context).size.width,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(8),
  //         color: light
  //             ? const Color.fromARGB(255, 61, 119, 148)
  //             : Colors.blueGrey.shade100,
  //       ),
  //       padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0),
  //     );
  //     // } else {
  //     //   return Container();
  //     // }
  //   });
  // }

  void showDialog() {}

  void _showmodelbottomsheet() {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      backgroundColor: Color.fromRGBO(19, 59, 78, 1.0),
      constraints: BoxConstraints.tight(Size.fromHeight(350)),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return LayoutBuilder(builder: (context, constraint) {
            // if (light == true) {
            return Container(
              //  height: 100,
              child: LayoutBuilder(builder: (context, constraints) {
                if (editPrice == false) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: user_type == "Manufacturer"
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      children: [
                        Text(
                          "BASIC RATE PER TON",
                          style: TextStyle(
                              letterSpacing: 2,
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GradientText(
                              colors: [
                                Colors.white,
                                Colors.white,
                                Colors.white60,
                              ],
                              NumberFormat.simpleCurrency(
                                      locale: 'hi-IN', decimalDigits: 0)
                                  .format(int.parse(basePrice.toString())),
                              style: TextStyle(
                                letterSpacing: 2,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "/-",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 35),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            user_type == "Manufacturer"
                                ? FlutterSwitch(
                                    borderRadius: 15,
                                    showOnOff: true,

                                    //  toggleSize: 50,
                                    onToggle: (bool value) async {
                                      setState(() {
                                        isSalesEnabled = value.toString();
                                      });

                                      var res = await http.post(
                                          Uri.parse(
                                              "http://steefotmtmobile.com/steefo/setsale.php"),
                                          body: {"status": isSalesEnabled});
                                    },

                                    // This bool value toggles the switch.
                                    value:
                                        bool.parse(isSalesEnabled.toString()),
                                    inactiveColor: Colors.black,
                                    activeColor: Colors.white,
                                    activeToggleColor: Colors.black,
                                    inactiveTextColor: Colors.white,
                                    activeTextColor: Colors.black,
                                  )
                                : Container(),
                            LayoutBuilder(builder: (context, constraints) {
                              if (user_type == "Manufacturer") {
                                return Container(
                                  // width:
                                  //     MediaQuery.of(context).size.width * 0.2,
                                  child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        editPrice = true;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                          ],
                        )
                      ],
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(padding: EdgeInsets.only(top: 20)),
                        Container(
                          child: TextFormField(
                            // initialValue: price.toString(),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            controller: newBasePrice,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 4.0),
                              ),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width / 3,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              // print(newBasePrice.text);
                              setState(() {
                                editPrice = false;
                                final numericRegex = RegExp(r'^[0-9]*$');
                                if (numericRegex.hasMatch(newBasePrice.text) &&
                                    newBasePrice.text.trim() != "") {
                                  price = int.parse(newBasePrice.text);
                                  http.post(
                                      Uri.parse(
                                          "http://steefotmtmobile.com/steefo/setbaseprice.php"),
                                      body: {
                                        "basePrice":
                                            newBasePrice.text.toString()
                                      });
                                  http.post(
                                      Uri.parse(
                                          "http://steefotmtmobile.com/steefo/ratenotification.php"),
                                      // "http://steefotmtmobile.com/steefo/notificationNew.php" as Uri,
                                      body: {"token": token1.toString()});

                                  // if (resorder.statusCode == 200) {
                                  //   // if(token1 != null){
                                  //   var response = await http.post(Uri.parse("http://steefotmtmobile.com/steefo/ordernotification.php"),
                                  //     // "http://steefotmtmobile.com/steefo/notificationNew.php" as Uri,
                                  //     // body: {"token": token1.toString()}
                                  //   );
                                  //   print(response.body);
                                  //   return jsonEncode(response.body);
                                  //   // }
                                  //   // else{
                                  //   //   print(response.request);
                                  //   //   print("Token is null");
                                  //   // }
                                  // }
                                  basePrice = newBasePrice.text;
                                }
                              });
                            },
                            child: SingleChildScrollView(
                              child: Text(
                                "Submit",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black))
                      ],
                    ),
                  );
                }
              }),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSalesEnabled == "true"
                    ? Color.fromRGBO(19, 59, 78, 1.0)
                    : Color.fromARGB(255, 95, 12, 12),
              ),
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 0),
            );
            // } else {
            //   return Container();
            // }
          });
        });
      },
    );
  }

  pickMultipleImage(ImageSource source) async {
    try {
      final images = await ImagePicker().pickMultiImage();
      if (images == null) return;
      for (XFile image in images) {
        var imagesTemporary = File(image.path);
        imagesFiles!.add(imagesTemporary);
        var imgBytes = imagesTemporary.readAsBytesSync();
        String baseImage = base64Encode(imgBytes);
        var res = await http.post(
            Uri.parse("http://steefotmtmobile.com/steefo/setcarousel.php"),
            body: {"name": image.name, "value": baseImage});

        var picUpRes = jsonDecode(res.body);

        responseData1['images']
            .add({"id": picUpRes['data'], "name": image.name});
      }
      setState(() {});
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'Image size is larger than expected!',
          //  icon: const Icon(Icons.refresh),
          duration: const Duration(seconds: 3),
        ),
      );
      print("Image Error");
    }
  }

  LogoutAlert() {
    print("object");
    QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        barrierDismissible: true,
        cancelBtnText: 'Cancel',
        confirmBtnText: 'Yes',
        title: 'Are you sure?',
        text: 'Logout',
        textColor: Colors.red,

        // customAsset: Icon(Icons.login_outlined),
        onConfirmBtnTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.clear();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              ModalRoute.withName(
                  '/') // Replace this with your root screen's route name (usually '/')
              );
        },
        onCancelBtnTap: () {
          Get.back();
        });
  }
}
