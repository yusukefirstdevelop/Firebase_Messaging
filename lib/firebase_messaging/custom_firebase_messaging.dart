import 'package:firebase_test/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_test/firebase_messaging/custom_local_notification.dart';
import 'package:flutter/material.dart';

class CustomFirebaseMessaging {
  final CustomLocalNotification _customLocalNotification;

  CustomFirebaseMessaging._intenal(this._customLocalNotification);
  static final CustomFirebaseMessaging _singleton = CustomFirebaseMessaging._intenal(CustomLocalNotification());
  factory CustomFirebaseMessaging() => _singleton;

  Future<void> inicialize({VoidCallback? callback}) async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(badge: true,sound: true);
    //final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      //ajuste de notificacao para android
      AndroidNotification? android = message.notification?.android;

      if (message.data['forceFatchRC'] != null) return callback?.call();

      if (notification != null && android != null){
        _customLocalNotification.androidNotification(notification,android);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data['goTO'] != null) {
        navigatorKey.currentState?.pushNamed(message.data['goTO']);
      }
      if (message.data['forceFatchRC'] != null) callback?.call();
    });
  }
  getTokenFirebase() async =>
      debugPrint(await FirebaseMessaging.instance.getToken());
}