
import 'dart:developer';
import 'dart:typed_data';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final AppSettings appSettings = AppSettings();

  Future<AuthorizationStatus> getPermission()async{

    // PERMISSION //
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    return settings.authorizationStatus;
  }

  // DEVICE TOKEN //
  Future<String?> getDeviceToken() async{
    getNewToken();
    var _t = await firebaseMessaging.getToken();
    print("this is Notification tocke ${_t}");
    return firebaseMessaging.getToken();
  }


  //   GET NEW TOKEN //
  void getNewToken(){
    firebaseMessaging.onTokenRefresh.listen((event) { });
  }
  @pragma('vm:entry-point')
  backgroundNotificationResponseHandler(NotificationResponse notification) async {
    log('Received background notification response: $notification');
  }

  Future<void> showNotification({
    int id = 0,
    RemoteMessage? message,
  }) async {
    print('Showing notification: $id,');
    await notificationPlugin.show(
      id,
      message!.notification!.title,
      message.notification!.body,
      await notificationDetails(),
      payload: message.data.toString(),
    );
  }

  Future<NotificationDetails> notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

}



Future<void> setNotification() async
{

  NotificationService notificationService = NotificationService();

  var st  = await notificationService.getPermission();
  log(st.toString());
  if(st == AuthorizationStatus.authorized)
  {
    log("Permission Granted");
  }


}