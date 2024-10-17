import 'package:assignbot/Mohit/notification.dart';
import 'package:assignbot/component/dimension.dart';
import 'package:assignbot/pages/chat/chat_page.dart';
import 'package:assignbot/sharedpref/shared_pref.dart';
import 'package:assignbot/widgets/selectable_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // floatingActionButton: kDebugMode?FloatingActionButton(onPressed: () async {
      //   var d = await NotificationService().getDeviceToken();
      //   print(d);
      // }):null,


      backgroundColor: Colors.white,

      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: GestureDetector(
              onTap: (){
                _showLogoutDialog();
              },
                child: Container(
                  width: SC.fromContextWidth(context, 11),
                  child: Image.asset('assets/log.png'),
                )
            ),
          )
        ],
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 28.0),
          child: Text('Welcome !',style: TextStyle(fontWeight: FontWeight.w500),),
        ),
        backgroundColor:const  Color(0xFFF60205),
      ),


      body: ListView(
        children: [

          SizedBox(height: SC.fromHeight(30),),


          const SizedBox(height: 10,),

          Container(
            margin:const  EdgeInsets.symmetric(horizontal: 18),
            width: double.infinity,
            height: SC.fromHeight(3),
            decoration: BoxDecoration(
                gradient:const  LinearGradient(
                  colors: [Color(0xFFF60C09), Color(0xFFFFD753)],// Replace with your desired colors
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                // border: Border.all(),
                borderRadius: BorderRadius.circular(10)),
            child: Stack(
              children: [
                Positioned(
                  top: SC.fromContextWidth(context, 18),
                  left: SC.fromContextWidth(context, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 160,child: Text('How are you feeling today?',style: GoogleFonts.akshar(textStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.w500,letterSpacing: 1,fontSize: SC.fromWidth(16))),)),
                      const SizedBox(height: 10,),
                      SizedBox(width: 140,child: Text('AssignBot will help you with any questions.',style: GoogleFonts.akshar(textStyle: TextStyle(color: Colors.white,fontSize: SC.fromWidth(22),fontWeight: FontWeight.w500)),)),
                    ],
                  ),
                ),

                // ASSIGN BOT IMAGE //
                Positioned(
                  top: SC.fromContextWidth(context, 30),
                  left: SC.fromContextWidth(context, 2),
                    child:  SizedBox(
                      // decoration: BoxDecoration(border: Border.all()),
                      width:  SC.fromWidth(2.8),
                      height:  SC.fromHeight(4.3),
                      child: Image.asset('assets/1.png',fit: BoxFit.cover,),
                    ),
                ),

                // START CHAT  //
                InkWell(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>  ChattingPage()));
                  },
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: SC.fromHeight(4)), // Adjust padding to position correctly
                      child: Container(
                        width: SC.fromWidth(1.8),
                        height: SC.fromHeight(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'START A CHAT',
                              style: TextStyle(
                                color: const Color(0xFFF60205),
                                fontSize: SC.fromWidth(22),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 10,),
                            const Icon(Icons.arrow_forward, color: Color(0xFFF60205),),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Are you sure you want to logout?",style: GoogleFonts.akshar(textStyle: TextStyle(fontSize: SC.fromContextWidth(context, 22),
                    color: Colors.black)),),
                const SizedBox(height:25,),
                Row(
                  children: [
                    Expanded(child: SelectableContainer2(isSelected: true,onTap: (){},text: "Yes",)),
                    const SizedBox(width: 10,),
                    Expanded(child: SelectableContainer2(isSelected: false,onTap: (){},text: "NO",)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
