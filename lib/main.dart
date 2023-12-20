import 'dart:async';
// import 'dart:js';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stefomobileapp/Models/lumpsum.dart';
import 'package:stefomobileapp/Models/user.dart';
import 'package:stefomobileapp/pages/DistributorsPage.dart';
import 'package:stefomobileapp/pages/EditableProfilePage.dart';
import 'package:stefomobileapp/pages/ForgetPassPage.dart';
import 'package:stefomobileapp/pages/GeneratedChallanPage.dart';
import 'package:stefomobileapp/pages/HomePage.dart';
import 'package:stefomobileapp/pages/InventoryPage.dart';
import 'package:stefomobileapp/pages/LoginPage.dart';
import 'package:stefomobileapp/pages/OTPPage.dart';
import 'package:stefomobileapp/pages/UserRequestPage.dart';
import 'package:stefomobileapp/pages/Withlumpsums.dart';
import 'package:stefomobileapp/pages/Withsize.dart';
import 'package:stefomobileapp/pages/ProfilePage.dart';
import 'package:stefomobileapp/pages/RegistrationPage.dart';
import 'package:stefomobileapp/pages/RequestPage.dart';
import 'package:stefomobileapp/pages/PlaceOrderPage.dart';
import 'package:stefomobileapp/pages/UserProfilePage.dart';
import 'package:stefomobileapp/pages/challangenerator.dart';
import 'package:stefomobileapp/pages/editorderpage.dart';
import 'package:stefomobileapp/pages/newPassPage.dart';
import 'package:stefomobileapp/pages/pdfView.dart';
import 'package:upgrader/upgrader.dart';
import 'Models/order.dart';
import 'pages/LRPage.dart';
import 'UI/common.dart';
import 'Models/lumpsum.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroungHandler);
  // if (!kIsWeb) {
  //   await setupFlutterNotifications();
  // }
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.landscapeLeft,
  //   DeviceOrientation.landscapeRight
  // ]);
  runApp(const MyApp());
}


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroungHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // await setupFlutterNotifications();
  // showFlutterNotification(message);
  print(message.data['moredata'].toString());
  // FirebaseMessaging.onMessageOpenedApp(){};
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

    print('A new onMessageOpenedApp event was published!');

    if(message.data['moredata'] == 'REGISTRATION'){
      navigatorKey.currentState?.pushNamed('/orderreq');
    }
    else if(message.data['moredata2'] == 'RATECHANGE'){
      navigatorKey.currentState?.pushNamed('/home');
    }else if(message.data['moredata3'] == 'NEWORDER'){
      navigatorKey.currentState?.pushNamed('/home');
    }else if(message.data['moredata4'] == 'ChallanGenerated'){
      navigatorKey.currentState?.pushNamed('/home');
    }

    // print('A new onMessageOpenedApp event was published!');
    // if(message.data['moredata'] == 'REGISTRATION'){
    //   navigatorKey.currentState?.pushNamed('/orderreq');
    // }
    // else if(message.data['moredata2'] == 'RATECHANGE'){
    //   navigatorKey.currentState?.pushNamed('/home');
    // }
    // else if(message.data['moredata3'] == 'NEWORDER'){
    //   navigatorKey.currentState?.pushNamed('/home');
    // }
    // else if(message.data['moredata4'] == 'ChallanGenerated'){
    //   navigatorKey.currentState?.pushNamed('/home');
    // }
    // Navigator.pushNamed(context,
    //   '/message',
      // arguments: MessageArguments(message, true),
    // );
  }
  );
}


// late AndroidNotificationChannel channel;
// bool isFlutterLocalNotificationsInitialized = false;
// var IOSFlutterLocalNotificationsPlugin ;
//
// Future<void> setupFlutterNotifications() async {
//   if (isFlutterLocalNotificationsInitialized) {
//     return;
//   }
//   channel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description:
//     'This channel is used for important notifications.', // description
//     importance: Importance.high,
//   );
//   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   /// Create an Android Notification Channel.
//   ///
//   /// We use this channel in the `AndroidManifest.xml` file to override the
//   /// default FCM channel to enable heads up notifications.
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//
//   /// Update the iOS foreground notification presentation options to allow
//   /// heads up notifications.
//   // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//   //   alert: true,
//   //   badge: true,
//   //   sound: true,
//   // );
//   isFlutterLocalNotificationsInitialized = true;
// }

// void showFlutterNotification(RemoteMessage message) {
//
//   var androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//   var iosInitializationSetting = DarwinInitializationSettings();
//
//   var initializationSetting = InitializationSettings(
//     android: androidInitializationSettings,
//     iOS: iosInitializationSetting,
//   );
//
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;
//   if (notification != null && android != null && !kIsWeb) {
//     flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           // TODO add a proper drawable resource to android, for now using
//           //      one that already exists in example app.
//           icon: 'launch_background',
//           importance: Importance.high,
//           priority: Priority.high
//         ),
//         iOS: DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound:true,
//         )
//       ),
//     );
//     // DarwinNotificationDetails darwinNotificationDetails =DarwinNotificationDetails(
//     //   presentAlert: true,
//     //   presentBadge: true,
//     //   presentSound:true,
//     // );
//   }
// }
// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// class NavigationService {
//   final GlobalKey<NavigatorState> navigatorKey =
//   new GlobalKey<NavigatorState>();
//   Future<dynamic>? navigateTo(String routeName) {
//     return navigatorKey.currentState?.pushNamed(routeName);
//   }
// }
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform  );
//   await setupFlutterNotifications();
//   showFlutterNotification(message);
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   print('Handling a background message ${message.messageId}');
// }





/// Initialize the [FlutterLocalNotificationsPlugin] package.



// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
// late AndroidNotificationChannel channel;
//
// bool isFlutterLocalNotificationsInitialized = false;
//
// Future<void> setupFlutterNotifications() async {
//   if (isFlutterLocalNotificationsInitialized) {
//     return;
//   }
//   channel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description:
//     'This channel is used for important notifications.', // description
//     importance: Importance.high,
//   );
//
//   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   /// Create an Android Notification Channel.
//   ///
//   /// We use this channel in the `AndroidManifest.xml` file to override the
//   /// default FCM channel to enable heads up notifications.
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//
//   /// Update the iOS foreground notification presentation options to allow
//   /// heads up notifications.
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   isFlutterLocalNotificationsInitialized = true;
// }






// FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
// late String token1;
//
// void firebaseCloudMessaging_Listeners(){
//   // FirebaseMessaging.onMessageOpenedApp(){}
//   FirebaseMessaging.onMessage.listen((message) {
//     print('Got a message whilst in the foreground!');
//     if (message.notification != null) {
//       // final snackBar = SnackBar(
//       //
//       //   content: Text(message.notification?.title ?? '', maxLines: 2),
//       // );
//       // ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }
//   }
//   // _firebaseMessagig.getToken().then((token){
//   //   print("token is"+ token!);
//   //   token1= token;
//   //   setState(() {});
//   // }
//   );
// }


class MyApp extends StatelessWidget {



  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme)),
      title: 'Flutter Demo',
      // navigatorKey: locator<NavigationService>().navigatorKey,
      navigatorKey: navigatorKey,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/lrpage': (BuildContext context) => LRPage(),
        '/login': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegistrationPage(),
        '/home': (BuildContext context) => HomePage(),
        '/inventory': (BuildContext context) => InventoryPage(order: Order(),),
        '/dealer': (BuildContext context) => DistributorPage(),
        '/orderreq': (BuildContext context) => RequestPage(),
        //'/challanlist': (BuildContext context) => ChallanListPage(),
        '/placeorder': (BuildContext context) => PlaceOrderPage(),
        '/editorder': (BuildContext context) => EditOrderPage(order: Order(),),
        '/orders': (BuildContext context) => OrdersContent(
              order: Order(),
            ),
        '/lumpsumorders': (BuildContext context) => LumpsumContent(lumpsum: Lumpsum(),
        ),
        //'/gnchallan': (BuildContext context) => GenerateChallanPage(),
        //'/order': (BuildContext context) => OrderDetails(),
        // '/challan': (BuildContext context) => GeneratedChallan(),
        '/profile': (BuildContext context) => UserProfilePage(),
        '/editprofile': (BuildContext context) => EditableProfilePage(user: User(),),
        '/forgetPass': (BuildContext context) => ForgetPassPage(),
        '/OTP': (BuildContext context) => OTPPage(),
        '/newPass': (BuildContext context) => NewPassPage(),
        '/profilePage': (BuildContext context) => ProfilePage(),
        '/EmailTest': (BuildContext context) => MyApp(),
        '/challangenerator': (BuildContext context) => ChallangeneratorPage(order: Order(),),
        '/pdfView': (BuildContext context) => pdfViewPage(user: User(),),
        '/requestpage': (BuildContext context) => UserRequestPage(user: User(),),
        '/generatedchallan': (BuildContext context) => GeneratedChallan(challan_id: '',),

        //'/request': (BuildContext context) => UserRequestPage(),
      },
    );
  }
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await setupFlutterNotifications();
//   showFlutterNotification(message);
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   print('Handling a background message ${message.messageId}');
// }
//
// late AndroidNotificationChannel channel;
//
// bool isFlutterLocalNotificationsInitialized = false;
//
// Future<void> setupFlutterNotifications() async {
//   if (isFlutterLocalNotificationsInitialized) {
//     return;
//   }
//   channel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description:
//     'This channel is used for important notifications.', // description
//     importance: Importance.high,
//   );
//
//   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   /// Create an Android Notification Channel.
//   ///
//   /// We use this channel in the `AndroidManifest.xml` file to override the
//   /// default FCM channel to enable heads up notifications.
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//
//   /// Update the iOS foreground notification presentation options to allow
//   /// heads up notifications.
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   isFlutterLocalNotificationsInitialized = true;
// }
//
// void showFlutterNotification(RemoteMessage message) {
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;
//   if (notification != null && android != null && !kIsWeb) {
//     flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           // TODO add a proper drawable resource to android, for now using
//           //      one that already exists in example app.
//           icon: 'launch_background',
//         ),
//       ),
//     );
//   }
// }
//
// /// Initialize the [FlutterLocalNotificationsPlugin] package.
// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;





class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {

  bool allowDirectLogin = false;
  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('isLoggedIn')) {
      allowDirectLogin = true;
    }
  }

  String? _token;
  String? initialMessage;
  bool _resolved = false;

  @override
  void initState() {
    loadData();

    Timer(Duration(seconds: 4), () {
      if (allowDirectLogin) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/lrpage');
      }
    });
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then(
          (value) => setState(
            () {
          _resolved = true;
          initialMessage = value?.data.toString();
        },
      ),
    );

    // FirebaseMessaging.onMessage.listen(showFlutterNotification);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print('A new onMessageOpenedApp event was published!');
      //
      // if(message.data['moredata'] == 'REGISTRATION'){
      //   navigatorKey.currentState?.pushNamed('/orderreq');
      // }
      // else if(message.data['moredata2'] == 'RATECHANGE'){
      //   navigatorKey.currentState?.pushNamed('/home');
      // }else if(message.data['moredata3'] == 'NEWORDER'){
      //   navigatorKey.currentState?.pushNamed('/home');
      // }else if(message.data['moredata4'] == 'ChallanGenerated'){
      //   navigatorKey.currentState?.pushNamed('/home');
      // }

      // navigatorKey.currentState?.pushNamed('/orderreq');
      // Navigator.pushNamed(
      //   context,
      //   '/message',
      //   arguments: MessageArguments(message, true),
      // );
    }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UpgradeAlert(
        upgrader: Upgrader(
          canDismissDialog: true,
          shouldPopScope: () => true,
          durationUntilAlertAgain: Duration(days: 3),
          dialogStyle: UpgradeDialogStyle.material
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logo(context).animate().fade(duration: Duration(seconds: 1)),
              //Form()
            ],
          ),
        ),
      ),
    );
  }
}
