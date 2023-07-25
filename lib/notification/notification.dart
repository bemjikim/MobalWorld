import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {


  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized)
    {
      print('user granted permission');
    }
    else if(settings.authorizationStatus == AuthorizationStatus.authorized)
    {
      print('user granted previsional permission');
    }
    else
    {
      AppSettings.openNotificationSettings();
      print('user denied permission');
    }
  }

  void initLocalNotifications(BuildContext context, RemoteMessage message) async{
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings
    );

    await _flutterLocalNotificationsPlugin.initialize(
        initializationSetting,
      onDidReceiveNotificationResponse: (payload){

      }
    );


  }

  void firebaseInit(String _doc){

    Stream<QuerySnapshot<Map<String, dynamic>>> notificationStream1 =
    FirebaseFirestore.instance.collection('user').doc(_doc).collection('receive_letter').snapshots();
    notificationStream1.listen((event) {
      if(event.docs.isEmpty)
        {
          return;
        }
      for(DocumentSnapshot doc in event.docs)
        {
          bool isChecked = doc.get('check') ?? false;
          if(isChecked == false)
            {
              showNotification("편지의 마음", "편지가 도착했어요!");
              break;
            }
        }
    });

    // Stream<QuerySnapshot<Map<String, dynamic>>> notificationStream2 =
    // FirebaseFirestore.instance.collection('user').doc(_doc).collection('test').snapshots();
    // notificationStream2.listen((event) {
    //   if(event.docs.isEmpty)
    //   {
    //     return;
    //   }
    //   if(event.docs.last.data()['check'] == false)
    //     showNotification("편지의 마음", "편지 답장이 왔어요!");
    // });
  }

  Future<void> showNotification(String title, String body) async{

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notification',
    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero, (){
      _flutterLocalNotificationsPlugin.show(
          0,
          title,
          body,
          notificationDetails);
      });
  }

  Future<String> getDeviceToken() async{
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('refresh');
    });
  }
}