import 'dart:convert';

import 'package:assignbot/controller/redirectfunction.dart';
import 'package:assignbot/models/message_list_model.dart';
import 'package:assignbot/sharedpref/shared_pref.dart';
import 'package:assignbot/sharedpref/user_pref_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:logger/logger.dart';

class FetchMessageApi extends GetxController{

  Rx<MessageListModel>? messagemodel;
  RxList<Message> messages=<Message>[].obs;

  Future<RxList<Message>?>fetchmessageapi (BuildContext context,int id)async{

    UserPreference userPreference = UserPreference();
    UserPrefModel userData = await userPreference.getUser();

    var token = userData.token;
    final http.Response response;
    const  apiUrl = 'https://chat.satyakabir.com/chatify/api/fetchMessages';
    var data = {
      'id': id,
    };
    var bodydata = json.encode(data);
    var UrlParse = Uri.parse(apiUrl);

    response = await http.post(
      UrlParse,
      body: bodydata,
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      },
    );


    if(response.statusCode==401)
      {
        reDirect(context);
      }
    print(response.body);

    var dataa = jsonDecode(response.body);

    messagemodel = MessageListModel.fromJson(dataa).obs;
     messages = messagemodel!.value.messages.map((e) => Message.fromJson(e.toJson())).toList().obs;
    // Get.to(ChattingPage());
return messages;
  }


  Future <void> sendMessage(int id,String message,BuildContext context) async
  {

    UserPreference userPreference = UserPreference();
    UserPrefModel user = await userPreference.getUser();



    var head = {
  'Authorization': 'Bearer ${user.token}',
  "Content-Type": "application/json"
  };

    Map<String,String> data = {
      "id":id.toString(),
      "message":message,
    };

    const String uri = "https://chat.satyakabir.com/chatify/api/sendMessage";

    var request = http.MultipartRequest("POST",Uri.parse(uri));

    request.headers.addAll(head);

    request.fields.addAll(data);

    var resp = await request.send();

    if(resp.statusCode==401)
      {
        reDirect(context);
      }

    var d = await  resp.stream.bytesToString();
    print(resp.statusCode);
    print(d);



  }

}




class MessageController with ChangeNotifier
{

  MessageListModel? _messageListModel;
  List<Message> _messages = [];
  bool _loading = true;


  MessageListModel? get  messageListModel=> _messageListModel;
  List<Message> get messages =>_messages;
  bool get loading =>_loading;



  Future<void>fetchmessageapi (BuildContext context,int id)async{

    UserPreference userPreference = UserPreference();
    UserPrefModel userData = await userPreference.getUser();

    var token = userData.token;
    final http.Response response;
    const  apiUrl = 'https://chat.satyakabir.com/chatify/api/fetchMessages';
    var data = {
      'id': id,
    };
    var bodydata = json.encode(data);
    var UrlParse = Uri.parse(apiUrl);

    response = await http.post(
      UrlParse,
      body: bodydata,
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      },
    );

    Logger().e("message\n${response.statusCode}\n${response.body }");
    if(response.statusCode ==401)
      {
        reDirect(context);
      }



    var dataa = jsonDecode(response.body);

    _messageListModel = MessageListModel.fromJson(dataa);
    _messages = _messageListModel!.messages.map((e) => Message.fromJson(e.toJson())).toList();

    _loading = false;
    notifyListeners();
  }


  Future <void> sendMessage(BuildContext context,int id,String message) async
  {

    UserPreference userPreference = UserPreference();
    UserPrefModel user = await userPreference.getUser();



    var head = {
      'Authorization': 'Bearer ${user.token}',
      "Content-Type": "application/json"
    };

    Map<String,String> data = {
      "id":id.toString(),
      "message":message,
    };


    const String uri = "https://chat.satyakabir.com/chatify/api/sendMessage";

    var request = http.MultipartRequest("POST",Uri.parse(uri));

    request.headers.addAll(head);

    request.fields.addAll(data);

    var resp = await request.send();
    Logger().e(resp.statusCode);


    if(resp.statusCode==401)
      {
        reDirect(context);
      }

    var d = await  resp.stream.bytesToString();
    var d2 = jsonDecode(d);
    var dataDecode =  d2["message"];
    Logger().e(dataDecode);
    // var nm  = Message.fromJson(dataDecode);


    print("${dataDecode["created_at"] } = ${DateTime.now().toIso8601String()}");
     var time2  = DateTime.parse(dataDecode["created_at"]);
    var time = DateTime.now();

    print("convert time ${time2.hour}:${time2.minute}  =   ${time.hour}:${time.minute}   ${time2.timeZoneOffset}");

    print(user.toJson());

    Message newMessage =  Message(
      id: dataDecode["id"],
      fromId: dataDecode["from_id"],
      toId: int.parse(dataDecode["to_id"].toString()),
      body: dataDecode["message"],
      attachment: null,
      createdAt: setDateTime(dataDecode["created_at"]),
      updatedAt: DateTime.now(),
      seen: 0,
      type: "",
    );
    _messages.insert(0,newMessage);
    notifyListeners();



    print(d);
  }

  addNewMessage(Message message)
  {
    print("sdhgf");
    _messages.insert(0, message);
    print("sdhgf");
    notifyListeners();
    print("sdhgf");
  }

  clear()
  {
    _messages = [];
    _messageListModel = null;
    _loading = true;
    notifyListeners();
  }


  //Close Chat
  closeChat(BuildContext context,{required int chatId})
  {

    showDialog(context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
      title: Text("Close this chat${kDebugMode?"$chatId":""}"),
      actions: [

        ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Cancle")),
        ElevatedButton(onPressed: ()async{

          String uri = "https://chat.satyakabir.com/chatify/api/chat-history?id=$chatId";
          var user = await UserPreference().getUser();
          Map<String,String> head = {
            "Authorization":"${user.token}"
          };

          var resp = await http.get(Uri.parse(uri),headers: head);
          Logger().i("resp frome clos chat Api\n${user.token}\n${resp.statusCode}\n${resp.body}");

          if(resp.statusCode==200)
            {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Chat Close")));
            }
          else if(resp.statusCode==404)
            {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Chat Not Found")));
            }
          else if(resp.statusCode==401&&kReleaseMode)
            {
              reDirect(context);
            }
          else
            {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Some Thing is wrong${kDebugMode?'\n${resp.statusCode}\n${resp.body}':''}")));
            }


        }, child: Text("Yes ")),

      ],
    ),);
  }

}

DateTime setDateTime(String s)
{
  DateTime d = DateTime.parse(s.split("+").first);
  return d;
}