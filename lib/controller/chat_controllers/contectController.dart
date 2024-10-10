



import 'dart:convert';
import 'dart:math';


import 'package:assignbot/component/loder.dart';
import 'package:assignbot/controller/chat_controllers/contact_api.dart';
import 'package:assignbot/controller/redirectfunction.dart';

import 'package:assignbot/models/contactRequestModel.dart';
import 'package:assignbot/pages/chat/chat_page.dart';

import 'package:assignbot/sharedpref/shared_pref.dart';
import 'package:assignbot/sharedpref/user_pref_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class  ContactController with ChangeNotifier
{

  List<Request> allRequest = [];

  Future<void> getRequest(BuildContext context) async
  {
    String uri = "https://chat.satyakabir.com/chatify/api/request-user";
    UserPrefModel user = await UserPreference().getUser();
    var resp = await http.get(Uri.parse(uri),
        headers: {
      "Authorization": 'Bearer ${user.token}' ,
    });
    // Logger().i("frome Request api \n${resp.statusCode}\n${resp.body}");
    Logger().i("frome Request api \n${resp.statusCode}\n${resp.body}");

    if(resp.statusCode==401)
      {
        reDirect(context);
      }

    if(resp.statusCode==200)
      {
        var _d = jsonDecode(resp.body);
        ContactRequestResponce contactRequestResponce = ContactRequestResponce.fromJson(_d);
        if(contactRequestResponce.data!=null)
          {
            allRequest = contactRequestResponce.data??[];
          }
      }
    else
      {
       print(resp.statusCode);
       print(resp.body);
      }

    allRequest.forEach((e){
      Logger().e(e.toJson());
    });
    notifyListeners();

  }



  Future <void> acceptReq(Request request,BuildContext context) async
  {
    await showDialog(context: context,barrierDismissible: false, builder: (context)=>WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: AlertDialog(

        title: Text("Accept chat request from ${request.userName}"),

        actions: [
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel")),
          ElevatedButton(
              onPressed: ()async{


            String uri = "https://chat.satyakabir.com/chatify/api/accept-request?id=${request.id}";



            showDialog(context: context, builder: (context)=>const Loader());

            UserPrefModel user = await UserPreference().getUser();
            var head =  {
              "Authorization": 'Bearer ${user.token}' ,
            };


            var resp =  await http.get(Uri.parse(uri),headers: head);
            Logger().e("${resp.statusCode}  asdf\n${resp.body}");
            if(resp.statusCode==401)
            {
              reDirect(context);
            }
            if(resp.statusCode==200)
            {


              var decode = jsonDecode(resp.body);
              var userdata  = decode["data"];
              final contactApi = Get.put(ContactApi());
              final contacts = contactApi.userContactModel?.value.contacts ?? [];

              // final chattingContactData= contacts.firstWhere((element) => element.id==userdata["to_id"]);
              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChattingPage(userEmail:request.userEmail??"" , userId:userdata["to_id"], userName: request.userName??"",)));
              getRequest(context);
            }
            else
            {
              print(resp.statusCode);
              print(resp.body);
              Navigator.pop(context);
            }


          }, child: Text("Accept"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((s)=>Colors.green)
            ),
          ),
        ],

      ),
    ));





  }






}