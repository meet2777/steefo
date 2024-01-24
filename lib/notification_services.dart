import 'dart:io';
import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_core_dart/firebase_core_dart.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stefomobileapp/pages/HomePage.dart';
import 'package:stefomobileapp/pages/RequestPage.dart';
import 'package:stefomobileapp/pages/MessageScreen.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if(kDebugMode){
      print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if(kDebugMode){
      print('user granted provisional permission');
      }
    } else {
      // AppSettings.openNotificationSettings();
      if(kDebugMode){
      print('user denied provisional permission');
      }
    }
  }

  void initLocalNotification(
      RemoteMessage message, BuildContext context) async {
    var androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payLoad) {
        handleMessage(context, message);
      },
    );
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
        print(message.data['type']);
        print(message.data['id']);
      }
      if(Platform.isIOS){
        FirebaseMessaging.instance.requestPermission();
      }
      if (Platform.isAndroid) {
        initLocalNotification(message, context);
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        message.notification!.android!.channelId.toString(),
        message.notification!.android!.channelId.toString() ,
        importance: Importance.max  ,
        showBadge: true ,
        playSound: true,
        // sound: ,
        // sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'),
        // Random.secure().nextInt(100000).toString(),
        // 'High Importance Notification',
        // importance: Importance.max
    );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
          sound: channel.sound
    );
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('refresh');
    });
  }

//
  Future<void> setupInteractMessage(BuildContext context) async {
    //when app is terminated.................
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }
    //when app is in background...............
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {

    if(message.data['moredata'] == 'REGISTRATION'){
      Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => RequestPage(),
          ));
      // navigatorKey.currentState?.pushNamed('/orderreq');
    }
    else if(message.data['moredata2'] == 'RATECHANGE'){
      Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
      // navigatorKey.currentState?.pushNamed('/home');
    }else if(message.data['moredata3'] == 'NEWORDER'){
      Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
      // navigatorKey.currentState?.pushNamed('/home');
    }else if(message.data['moredata4'] == 'ChallanGenerated'){
      Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
      // navigatorKey.currentState?.pushNamed('/home');
    }

    // if (message.data['type'] == 'msg') {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => HomePage(),
    //       ));
    // }
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

}
