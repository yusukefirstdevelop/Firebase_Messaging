import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class CustomLocalNotification {
  //Comedcao null mais depois de receber um valor nao podem mais ser anulados
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;

  CustomLocalNotification(){
    //comfiguracao do channel
    channel = const AndroidNotificationChannel(
        "high_importance_channel",
        "High Importance Notifications",
        description: "This channel is used for important notifications.",
        importance: Importance.max
    );

        // depois de configurado o channel ele pega o valor e manda pro flutterLocalNotificationsPlugin
        _configuraAndroid().then((value){
          flutterLocalNotificationsPlugin = value;
          inicializeNotifications();
        },
    );
  }


  Future<FlutterLocalNotificationsPlugin> _configuraAndroid() async{
    var flutterLocalNotificationsPlugins = FlutterLocalNotificationsPlugin();

    // Canal pra criar comunicacao
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation
          <AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel((channel));

    return flutterLocalNotificationsPlugins;
  }
  // Inicializacao das notificacoes
  inicializeNotifications(){
    //Icone da notificacao
    const android = AndroidInitializationSettings("@mipmap/ic_launcher");

    // configuracao do ios das versao antes do 10
    final IOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: (_,__,___,____){},
    );
    // ordenando o plugin a inicializar com as configuracaoes de android e IOS
    flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(android:android,iOS:IOS),
    );
  }
  androidNotification(
      RemoteNotification notification,
      AndroidNotification android,
  ){
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon:android.smallIcon,
        ),
      ),
    );
  }
}