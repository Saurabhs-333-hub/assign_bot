import 'dart:async';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_autostart/flutter_autostart.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future initializeService() async {
  final service = FlutterBackgroundService();

  // Set up notification channel
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'Satya_Kabir', // Notification Channel ID
    'Background Service',
    playSound: true,
    sound: RawResourceAndroidNotificationSound('sound'),
    importance: Importance.high,
    description: 'This channel is used for background service notifications.',
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: 'Satya_Kabir',
      initialNotificationTitle: 'Background Service',
      initialNotificationContent: 'App is running in background',
      foregroundServiceNotificationId: 1, // Use a non-zero value
    ),
  );

  service.startService();
}

@pragma('vm-entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int notificationCount = 0; // Counter to track number of notifications sent

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(Duration(seconds: 5), (timer) async {
    try {
      // if (service is AndroidServiceInstance) {
      //   if (await service.isForegroundService()) {
      //     if (notificationCount < 2) {
      //       await flutterLocalNotificationsPlugin.show(
      //         notificationCount + 1, // Unique ID for each notification
      //         'SatyaKabir Chat',
      //         'Shake feature enabled',
      //         NotificationDetails(
      //           android: AndroidNotificationDetails(
      //             'Satya_Kabir', // Notification Channel ID
      //             'Background Service',
      //             ongoing: true,
      //             importance: Importance.high,
      //             priority: Priority.high,
      //           ),
      //         ),
      //       );
      //       notificationCount++; // Increment the notification counter
      //     } else {
      //       timer.cancel(); // Stop the timer after sending two notifications
      //     }
      //   }
      // }
    } catch (e) {
      print('Error showing notification: $e');
    }

    var pref = await SharedPreferences.getInstance();
    int count = pref.getInt("county") ?? 0;
    print("This Is Count = ${count}");
    count++;
    await pref.setInt("county", count);

    if (count > 10) {

      // showFullScreenNotification();
    }
  });
}

@pragma("vm:entry-point")
void showOverlay() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text("Over lay"),
        ),
      )));
}

Future<void> openApp() async {
  // var d = await LaunchApp.isAppInstalled(
  //   // androidPackageName: "com.example.assignbot"
  //   androidPackageName: "com.android.chrome",
  // );
  // String chromePkName = "com.android.chrome";
  // String YtPkName = "com.google.android.youtube";
  // String WhatsAppPkName = "com.whatsapp";
  // String packageName =YtPkName;
  //
  // String url = 'tel:7747071882';
  // // LaunchApp.openApp(
  // //   androidPackageName:"com.whatsapp"
  // // );
  //
  // launch(url);
  // print(d);
}

Future<void> getAutoStartPermission() async {
  var _flutterAutostartPlugin = FlutterAutostart();

  String autoStartPermission;
  try {
    autoStartPermission =
        await _flutterAutostartPlugin.showAutoStartPermissionSettings() ??
            'Unknown autoStartPermission';
  } on PlatformException {
    autoStartPermission = 'Failed to show autoStartPermission.';
  }
}

@pragma("vm:entry-point")
Future<void> showFullScreenNotification() async {


  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails("channelId", "channelName",
          importance: Importance.max,
          category: AndroidNotificationCategory.alarm,
          priority: Priority.high,
          fullScreenIntent: true);

  final platformNoitifcationPlugin =
      NotificationDetails(android: androidNotificationDetails);

  await FlutterLocalNotificationsPlugin()
      .show(0, "This Id Body", "sdfasdfd", platformNoitifcationPlugin);
}
