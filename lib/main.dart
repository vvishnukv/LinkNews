import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linknews/pushnotifications.dart';
import 'NewsController.dart';
import 'NewsScreen.dart';
import 'firebase_options.dart';
import 'message.dart';

final navigatorKey = GlobalKey<NavigatorState>();

//function to listen to background changes
Future _firebaseBackgroundMessage(RemoteMessage message)async{
  if(message.notification != null){
    print("Some Notification Recieved");
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // on background notification tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if(message.notification!=null){
      print("Background Notification Tapped");
      navigatorKey.currentState!.pushNamed("/message",arguments: message);
    }
  });
  PushNotifications.init();
  PushNotifications.localNotiInit();
  // listen to background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  // to handle foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("Got a message in foreground");
    if (message.notification != null) {
      PushNotifications.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadData);
    }
  });

  // for handling in terminated state
  final RemoteMessage? message =
  await FirebaseMessaging.instance.getInitialMessage();

  if (message != null) {
    print("Launched from terminated state");
    Future.delayed(Duration(seconds: 1), () {
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    });
  }

  Get.put(NewsController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'LinkNews',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NewsScreen(),
      routes: {
        // Add the route for '/lib/message'
        "/message": (context) => Message(), // replace MessageScreen with the actual screen/widget you want to navigate to
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
