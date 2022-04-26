import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_test/firebase_messaging/custom_firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("バックグラウンドでメッセージを受け取りました");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // await CustomFirebaseMessaging().inicialize();

  // await CustomFirebaseMessaging().getTokenFirebase();

  // FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.deepPurple,
    //   ),
    //   initialRoute: "/home",
    //   routes: {
    //     '/home': (context) => const MyHomePage(title: 'home page'),
    //     '/virtual': (context) => Scaffold(
    //           appBar: AppBar(),
    //           body: const SizedBox.expand(
    //             child: Center(
    //               child: Text('Virtual Page'),
    //             ),
    //           ),
    //         ),
    //     "/gabriel": (context) => Scaffold(
    //         appBar: AppBar(),
    //         body: const SizedBox(
    //           width: 200.0,
    //           height: 300.0,
    //           child: Card(
    //             color: Colors.yellow,
    //             child: Center(
    //               child: Text('Hello World!'),
    //             ),
    //           ),
    //         )),
    //   },
    // );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static FirebaseInAppMessaging fiam = FirebaseInAppMessaging();

  @override
  void initState() {
    super.initState();
    fiam.triggerEvent('update_event');
    FirebaseMessaging.instance.getToken().then((token) {
      print("$token");
    });

    // get firebaseMessaging Token code
    _firebaseMessaging.getToken().then((token) {
      print("$token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: 'launch_background',
              ),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("FCMテスト"),
          ],
        )));
  }
}
