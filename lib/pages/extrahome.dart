import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stefomobileapp/notification_services.dart';
import 'package:http/http.dart' as http;

class extrahome extends StatefulWidget {
  const extrahome({super.key});

  @override
  State<extrahome> createState() => _extrahomeState();
}

class _extrahomeState extends State<extrahome> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
    notificationServices.firebaseInit(context);
    notificationServices.isTokenRefresh();

    notificationServices.setupInteractMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter notification'),
      ),
      body: Center(
        child: TextButton(
          child: Text('send notification'),
          onPressed: () {
            notificationServices.getDeviceToken().then((value) async {
              var data = {
                'to': value.toString(),
                'priority': 'high',
                'notification': {
                  'title': 'Parth',
                  'body': 'You Got An Order',
                },
                'data': {'type': 'msg', 'id': 'parth1234'},
              };
              print(value.toString());
              await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                  body: jsonEncode(data),
                  headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization':
                        'key=AAAA_8-x_z4:APA91bE5c27vN7PgA4BTTOtLcLpxnz3W-Ljjet2YAfwr3b0t10YMXSbgwTX01aJoDZhylqCZjZ3EiuUR9M2KDGcvCfBSBumulrujHHuN7zI_6kN0JIrMCkxiwT63QD5AfNTyE0gxEao7'
                  });
            });
          },
        ),
      ),
    );
  }
}
