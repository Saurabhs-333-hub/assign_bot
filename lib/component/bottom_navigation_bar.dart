//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:leadkart/add_images/add_images.dart';
// import 'package:leadkart/business_pages/busines_detail.dart';
// import 'package:leadkart/helper/dimention.dart';
// import 'package:leadkart/home_pages/home_screen.dart';
// import 'package:leadkart/leads/ads_image.dart';
// import 'package:leadkart/leads/create_ads_page.dart';
//
//
// class MyBottomNavigationBar extends StatefulWidget {
//   int? page;
//   MyBottomNavigationBar({this.page, super.key});
//
//   @override
//   State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
// }
//
// class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
//   int curruntPage = 0;
//   late PageController controller;
//   int backPress = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.page != null) {
//       curruntPage = widget.page!;
//     }
//     controller = PageController(initialPage: curruntPage);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         backPress++;
//         if (backPress == 2) {
//           return true;
//         } else {
//           Timer(Duration(seconds: 1), () {
//             backPress = 0;
//           });
//         }
//         return false;
//       },
//       child: Scaffold(
//         body: PageView(
//           physics: NeverScrollableScrollPhysics(),
//           controller: controller,
//           children: [
//             HomeScreen(),
//             AddImages(),
//             AdsPage(),
//             CreateAds(),
//             BusinessDetail(),
//           ],
//         ),
//         bottomNavigationBar: BottomAppBar(
//           padding: EdgeInsets.only(top: 3),
//           color: Colors.white,
//           child: BottomAppBar(
//             clipBehavior: Clip.hardEdge,
//             padding: EdgeInsets.zero,
//             color: Colors.transparent,
//             shape: CircularNotchedRectangle(),
//             child: BottomNavigationBar(
//               iconSize: SC.from_width(22),
//               type: BottomNavigationBarType.fixed,
//               currentIndex: curruntPage,
//               selectedItemColor: Color.fromRGBO(36, 238, 221, 1),
//               unselectedItemColor: Colors.grey,
//               selectedLabelStyle: TextStyle(color: Color.fromRGBO(36, 238, 221, 1)),
//               unselectedLabelStyle: TextStyle(color: Colors.black26),
//               onTap: (page) {
//                 setState(() {
//                   curruntPage = page;
//                 });
//                 controller.jumpToPage(curruntPage);
//               },
//               items: [
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.home_outlined),
//                   label: "Home",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Container(
//                     width: SC.from_width(23),
//                     height: SC.from_width(23),
//                     child: Image.asset(
//                       'assets/bottom_nav/5.png',
//                       color: curruntPage == 1 ? Color.fromRGBO(36, 238, 221, 1) : Colors.grey,
//                     ),
//                   ),
//                   label: "Add images",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Container(
//                     width: SC.from_width(23),
//                     height: SC.from_width(23),
//                     child: Image.asset(
//                       'assets/bottom_nav/2.png',
//                       color: curruntPage == 2 ? Color.fromRGBO(36, 238, 221, 1) : Colors.grey,
//                     ),
//                   ),
//                   label: "Ads",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Container(
//                     width: SC.from_width(23),
//                     height: SC.from_width(23),
//                     child: Image.asset(
//                       'assets/bottom_nav/3.png',
//                       color: curruntPage == 3 ? Color.fromRGBO(36, 238, 221, 1) : Colors.grey,
//                     ),
//                   ),
//                   label: "Leads",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Container(
//                     width: SC.from_width(23),
//                     height: SC.from_width(23),
//                     child: Image.asset(
//                       'assets/bottom_nav/4.png',
//                       color: curruntPage == 4 ? Color.fromRGBO(36, 238, 221, 1) : Colors.grey,
//                     ),
//                   ),
//                   label: "Busines",
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//

import 'dart:async';
import 'package:assignbot/Mohit/notification.dart';
import 'package:assignbot/component/dimension.dart';
import 'package:assignbot/controller/chat_controllers/contectController.dart';
import 'package:assignbot/pages/chat/chat_page.dart';
import 'package:assignbot/pages/chat/contact_page.dart';
import 'package:assignbot/pages/home_pages/home_page.dart';
import 'package:assignbot/pages/logout/logout_page.dart';
import 'package:assignbot/pages/user/user_edit_profile.dart';
import 'package:assignbot/pages/user/user_profile.dart';
import 'package:assignbot/widgets/customBotomNavigationBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../models/contactRequestModel.dart';



class MyBottomNavigationBar extends StatefulWidget {
  int? page;
  int? requestId;
  MyBottomNavigationBar({this.requestId,this.page, super.key});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> with SingleTickerProviderStateMixin {
  int currentPage = 0;
  int backPress = 0;

  final List<Widget> pages = [
    // const HomePage(),
    const ContactPage(),
    const UserEditProfile(),
    const LogoutPage(),

  ];

  @override
  void initState() {
    super.initState();
    if (widget.page != null) {
      currentPage = widget.page!;
    }

  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if(widget.requestId!=null)
    {
      Timer(Duration(milliseconds: 1000),(){
        Provider.of<ContactController>(context,listen: false).acceptReq(Request(id: widget.requestId,userName: "NewUser",userEmail: "",userPhone: ""), context);
      });
    }
  }



  void animateToPage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        backPress++;
        if (backPress == 2) {
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.transparent,behavior: SnackBarBehavior.floating,elevation: 0,content: Center(
              child: Card(
              color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Press again to exit",style: TextStyle(color: Colors.white),),
                  )))));
          Timer(const Duration(seconds: 1), () {
            backPress = 0;
          });
        }
        return false;
      },
      child: Scaffold(


        floatingActionButton: kDebugMode?FloatingActionButton(onPressed: () async {
          var d = await NotificationService().getDeviceToken();
          print("  --($d)--");
          



          var notification_detail = NotificationDetails(
            android: AndroidNotificationDetails(
              sound: RawResourceAndroidNotificationSound('sound'),
              playSound: true,
              'channelId',
              'channelName',
              category: AndroidNotificationCategory.alarm,
              importance: Importance.max,
              fullScreenIntent: true,
              priority: Priority.high,
            ),

          );

          FlutterLocalNotificationsPlugin()
              .show(0, "This Id Body", "sdfasdfd", await notification_detail);
        }):null,

        body: PageTransitionSwitcher(
          duration:const Duration(milliseconds: 700),
          transitionBuilder: (Widget child, Animation<double> animation, Animation<double> secondaryAnimation) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: pages[currentPage],
        ),

        bottomNavigationBar: Custombotomnavigationbar(
          onTap: (n){
            currentPage = n;
            setState(() {

            });
          },
          currentIndex: currentPage,
          items: [
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.home_outlined),
            //   label: "Home",
            // ),
            BottomNavigationBarItem(
              icon: Container(
                width: SC.from_width(23),
                child: Image.asset(
                  'assets/bottomnavigation/chat.png',
                  color: currentPage == 0 ? Color(0xFFF60205) : Colors.black,
                ),

              ),
              label: "Chat ",
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: SC.from_width(23),
                height: SC.from_width(23),
                child: Image.asset(
                  'assets/profile.png',
                  color: currentPage == 1 ? Color(0xFFF60205): Colors.black,
                ),
              ),
              label: "User Profile",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout_outlined,color:  currentPage == 2 ? Color(0xFFF60205): Colors.black,),
              label: "Log Out",
            ),
          ],
        ),
      ),
    );
  }
}


