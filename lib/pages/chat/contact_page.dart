import 'dart:developer';

import 'package:assignbot/Mohit/notification.dart';
import 'package:assignbot/component/dimension.dart';
import 'package:assignbot/component/loder.dart';
import 'package:assignbot/controller/chat_controllers/contact_api.dart';
import 'package:assignbot/controller/chat_controllers/contectController.dart';
import 'package:assignbot/controller/chat_controllers/fetch_message_api.dart';
import 'package:assignbot/models/contactRequestModel.dart';
import 'package:assignbot/models/user_contact_model.dart';
import 'package:assignbot/pages/chat/chat_page.dart';
import 'package:assignbot/sharedpref/shared_pref.dart';
import 'package:assignbot/widgets/selectable_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

// ContactApi _contactApi = Get.put(ContactApi());

FetchMessageApi _fetchMessageApi = Get.put(FetchMessageApi());

String formatHourWithLabel(DateTime dateTime) {
  return '${DateFormat('H').format(dateTime)} hr';  // Format as "12 hr"
}

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late Future<void> fetchContactsFuture;

  @override
  void initState() {
    super.initState();
    final contactApi = Get.put(ContactApi()); // Use Get.find() to retrieve the instance
    // fetchContactsFuture = contactApi.fetchContactApi();

  }


  bool? serviceState;

  getServiceState()async
  {
    var serviece = FlutterBackgroundService();
    serviceState = await serviece.isRunning();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {


    getServiceState();



    return DefaultTabController(length: 2, child: Scaffold(

      appBar: AppBar(
        bottom:  TabBar(
          overlayColor: WidgetStateProperty.resolveWith((s)=>Colors.white),

          labelPadding: const EdgeInsets.symmetric(vertical: 15),
          labelStyle: const TextStyle(color: Colors.white),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicator:const BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.red,
              Colors.yellow,
            ])
          ),
          tabs: const [
            Text("New Chat"),
            Text("Recent Chat"),
        ],),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,

        // title: Text("$serviceState"),
        title:const  Padding(
          padding:  EdgeInsets.only(left: 28.0),
          child: Text('Chats', style: TextStyle(fontWeight: FontWeight.w500)),
        ),
        // backgroundColor: const Color(0xFFF60205),ch
        backgroundColor: const Color(0xFFF60205),
      ),
      body: TabBarView(
        children: [
          const NewChatTab(),
          RecentChatTab()
        ],
      ),
    ));
  }
}



class NewChatTab extends StatelessWidget {
  const NewChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.red,
      onRefresh:()=> Provider.of<ContactController>(context,listen: false).getRequest(context),
      child: FutureBuilder(
          future: Provider.of<ContactController>(context,listen: false).getRequest(context),
          builder:(context,snap){

            return Consumer<ContactController>(builder: (a,p,c){
              bool loding = snap.connectionState==ConnectionState.waiting;
              if( loding && p.allRequest.isNotEmpty)
                {
                  return const Loader();
                }
              if(p.allRequest.isEmpty)
                {
                  return SizedBox.expand(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(child: Text("No Request",style: TextStyle(fontSize: 20))),
                      ElevatedButton(onPressed: (){
                        p.getRequest(context);
                      }, child: Text("Refresh"))
                    ],
                  ));
                }

              return ListView.builder(
                itemCount: p.allRequest.length,
                itemBuilder: (context,i){
                  return  RequestTile(request: p.allRequest[i]);
                },
              );

            });
          }
      ),
    );
  }

}



class RequestTile extends StatelessWidget {
  final  Request request;
  const RequestTile({required this.request,super.key});


  @override
  Widget build(BuildContext context) {
    return ListTile(

      onTap: (){
        Provider.of<ContactController>(context,listen: false).acceptReq(request,context);
      },

      leading:   CircleAvatar(
        backgroundColor: Colors.red.shade100,
        child: const  Icon(Icons.person,color: Colors.red,),
      ),

      title: Text( "${request.userName}"??""),

      subtitle: Text("${request.userEmail}"),


    );
  }
}






class RecentChatTab extends StatefulWidget {
  RecentChatTab({super.key});

  @override
  State<RecentChatTab> createState() => _RecentChatTabState();
}

class _RecentChatTabState extends State<RecentChatTab> {
  final contactApi = Get.put(ContactApi());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contactApi.fetchContactApi();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: contactApi.userContactModel?.value.contacts.length??0,
        itemBuilder: (context, index) {
          final contact = contactApi.userContactModel?.value.contacts[index];
          return Column(
            children: [
              ListTile(
                onTap: () {
                  _fetchMessageApi.fetchmessageapi(context,contact?.id??0);
                  Get.to(ChattingPage(userEmail: contact?.email??"",userMobileNum: contact?.phone,userId: contact?.id, userName: contact?.name??"",));
                },

                leading:CircleAvatar(
                  backgroundColor: Colors.red.shade100,
                  child:const  Icon(Icons.person,color: Colors.red, ),
                ),

                // leading: Image.asset(people[index]['image']!),
                title: Text(
                  contact?.name ?? '',
                  style: TextStyle(fontSize: SC.fromWidth(24)),
                ),
                subtitle: Text(
                  contact?.email ?? '',
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Text(
                    timeago.format(contact?.maxCreatedAt ?? DateTime.now()),
                    style: TextStyle(fontSize: SC.fromWidth(35)),
                  ),
                ),
              ),
              // To separate each ListTile
            ],
          );
        },
      ),
    );
  }
}






