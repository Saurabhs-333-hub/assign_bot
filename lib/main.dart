import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:assignbot/Mohit/notification.dart';
import 'package:assignbot/component/background_service.dart';
import 'package:assignbot/component/bottom_navigation_bar.dart';
import 'package:assignbot/component/dimension.dart';
import 'package:assignbot/controller/chat_controllers/contectController.dart';
import 'package:assignbot/firebase_options.dart';
import 'package:assignbot/pages/onboard.dart';
import 'package:assignbot/setNotification%20method.dart';
import 'package:assignbot/sharedpref/shared_pref.dart';
import 'package:assignbot/sharedpref/user_pref_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'controller/chat_controllers/fetch_message_api.dart';


final navigatorKey = GlobalKey<NavigatorState>();

// Define the top-level function for handling background messages

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Logger().e("bacgroubn Notification is Receved ${message.data}");
  await Firebase.initializeApp();


  AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("@mipmap/launcher_icon");

  InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings
  );

  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);

  AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails("full_screen_intent", "hggfgfgdfgdfgdfdf",
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('sound'),
      category: AndroidNotificationCategory.alarm,
      priority: Priority.high,
      fullScreenIntent: true);

  final platformNoitifcationPlugin =
  NotificationDetails(android: androidNotificationDetails);

  // await FlutterLocalNotificationsPlugin()
  //     .show(0, "This Id Body", "sdfasdfd", platformNoitifcationPlugin,payload: );

  //

  Logger().i("backGround notification receved\nPaylode : - \n${message.data}");

  await NotificationService().showNotification(message: message, id: 0);
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await initializeService();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  


  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


  AwesomeNotifications().initialize(
    debug: true,
    // Your app icon
    'resource://drawable/ic_launcher',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      )
    ],
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => MessageController()),
      ChangeNotifierProvider(create: (context) => ContactController()),
    ],
    child: const MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  UserPrefModel? user;
  @override
  void initState() {
    // TODO: implement initState
    getUser();
    setListenerNotification(context);
    
    super.initState();
  }





  getUser()async{
    UserPreference userPreference= UserPreference();
   user=await userPreference.getUser();
   log('${user?.token}');
   setState(() {

   });
  }
  @override
  Widget build(BuildContext context) {
// log(user!.token.toString());
    SC.getScreen(context);
    return GetMaterialApp(

      theme: ThemeData(

        //elevated them
        elevatedButtonTheme: ElevatedButtonThemeData(

          style: ButtonStyle(

            foregroundColor: MaterialStateProperty.resolveWith((s)=>Colors.white),

            textStyle: MaterialStateProperty.resolveWith((s)=>TextStyle(color: Colors.white)),

            backgroundColor: MaterialStateProperty.resolveWith((s)=>Colors.red),

            shape: MaterialStateProperty.resolveWith((s)=>RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            )),
          )

        )
      ),

      navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home:user?.token!=null&&user?.token!=''?MyBottomNavigationBar(): const OnboardPage(),
             );
  }
}

