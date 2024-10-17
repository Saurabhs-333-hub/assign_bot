

import 'dart:convert';

import 'package:assignbot/component/dimension.dart';
import 'package:assignbot/component/loder.dart';
import 'package:assignbot/controller/chat_controller.dart';
import 'package:assignbot/controller/chat_controllers/fetch_message_api.dart';
import 'package:assignbot/models/message_list_model.dart';
import 'package:assignbot/models/user_contact_model.dart';
import 'package:assignbot/sharedpref/shared_pref.dart';
import 'package:assignbot/sharedpref/user_pref_model.dart';
import 'package:assignbot/widgets/custom_textfield_decoration.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:url_launcher/url_launcher.dart';




class ChattingPage extends StatefulWidget {
  final String userEmail;
  final dynamic userId;
  final String userName;
  final String? userMobileNum;
  const ChattingPage({required this.userEmail,this.userMobileNum,super.key,required this.userId,required this.userName});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {


  late final  chatController = Provider.of<MessageController>(context,listen: false);
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _showEmojiPicker = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // chatController.clear();
  }

  void _sendMessage() {
    String message = _messageController.text;
    _messageController.text="";
    if (message.isNotEmpty) {
      chatController.sendMessage(context,widget.userId, message);
    }
  }





  Future<void> _selectAndSendFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        setState(() {
          _messages.add({
            'text': '',
            'image': filePath,
            'sender': 'user',
            'time': DateTime.now(),
            'seen': false,
          });
        });
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  Widget _buildMessage(Message messageData,dynamic currentUserId) {
    String message = messageData.body??'';
    int sender = messageData.toId;
    DateTime time = messageData.createdAt;
    bool isUser = sender == currentUserId;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const  EdgeInsets.all(10.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ?const Color.fromRGBO(254, 217, 87, 1) : const Color.fromRGBO(252, 239, 192, 1),
          borderRadius: BorderRadius.only(
            topRight: isUser ? Radius.zero :const  Radius.circular(20),
            topLeft: isUser ?const  Radius.circular(20) : Radius.zero,
            bottomRight:const  Radius.circular(20),
            bottomLeft: const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4.0,
              offset:const  Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isUser? CrossAxisAlignment.end:CrossAxisAlignment.start,
          children: [
            if (message.isNotEmpty)
              Text(
                message,
                style: const  TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            Text(
            "${time.hour}:${time.minute}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
  FetchMessageApi fetchMessageApi= FetchMessageApi();
  UserPrefModel? userData ;
  getId()async{
  UserPreference userPreference = UserPreference();
  userData= await userPreference.getUser();
}
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getId();
    loadPusher();
  }


  Future<void> loadPusher() async
  {
    var user = await UserPreference().getUser();

    await pusher.init(
      apiKey: "5a938f7a30104f034cb5",
      cluster: "ap2",
      onSubscriptionSucceeded:onSub,
      onEvent: onEevent,
    );

    await pusher.subscribe(channelName: "${user.userId}_${widget.userId}");

    await pusher.connect();



  }

  onEevent(PusherEvent event) {
    print("Pusher Event");
    print("WhT IA EVENT nAMW = ");
    print(event);

    if(event.eventName == "receive")
    {
      print( "My Event event ${event.eventName}");
      print(event.data);

      var data = jsonDecode(event.data);
      Provider.of<MessageController>(context,listen: false).addNewMessage(
        Message(
          id: data["message"]["id"],
          toId: data["message"]["to_id"],
          seen:data["message"]["seen"]??0,
          attachment: null,
          type: "sdf",
          body: data["message"]["message"],
          fromId: data["message"]["from_id"],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),

        )
      );
    }
  }

  onSub (String s,dynamic d)
  {
    print("Pusher channel is Subscibed suks");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title:  Padding(
          padding: const EdgeInsets.only(left: 38.0),
          child: ListTile(
            title: Text(widget.userName, style:const TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
            subtitle: Text(widget.userMobileNum??"", style:const TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
          )
        ),
        backgroundColor: const Color(0xFFF60205),

        //App Bar Buttons
        actions: [

          Consumer<MessageController>(
            builder: (context, value, child) =>  IconButton(onPressed: (){
              value.closeChat(context,chatId: widget.userId);
            }, icon: Icon(Icons.close)),
          ),

          //
          if(widget.userMobileNum!=null)
            IconButton(onPressed: (){
              launch("tel:${widget.userMobileNum}");
            }, icon: Icon(Icons.call)),

        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: chatController.fetchmessageapi(context,widget.userId),
              builder: (context, snapshot) {

                return Consumer<MessageController>(builder: (a,p,c){

                  if(p.messages.isNotEmpty){


                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding:const EdgeInsets.all(8.0),
                      itemCount: p.messages.length,
                      itemBuilder: (context, index) {
                        Message  messageData = p.messages[index];
                        return _buildMessage(messageData, widget.userId);
                      },
                    );
                  }


                  if(snapshot.hasError){
                    return Center(child: Text("${snapshot.error}"));
                  }

                  if(p.loading){
                    return const Loader();
                  }

                  return const Center(child:  Text("No Chats Available"),);

                });


              },

            ),
          ),
          if (_showEmojiPicker)
            EmojiPicker(
              config:const  Config(
                swapCategoryAndBottomBar: true,
                categoryViewConfig: CategoryViewConfig(
                  backgroundColor: Colors.white,
                ),
                bottomActionBarConfig: BottomActionBarConfig(
                  buttonColor: Colors.white,
                  enabled: true,
                  buttonIconColor: Colors.grey,
                  backgroundColor: Colors.white,
                ),
                searchViewConfig: SearchViewConfig(
                  backgroundColor: Colors.white,
                ),
                emojiViewConfig: EmojiViewConfig(
                  backgroundColor: Colors.white,
                ),
              ),
              onEmojiSelected: (category, emoji) {
                _messageController
                  ..text += emoji.emoji
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: _messageController.text.length),
                  );
              },
            ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFieldDecoration(
                            suffixIcon: IconButton(onPressed: (){}, icon:  Transform(
                              alignment: Alignment.center,
                              transform:Matrix4.rotationZ(4),child: const  Icon(Icons.attachment_outlined),)),
                            icon: IconButton(
                              icon: Icon(
                                _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_showEmojiPicker) {
                                    _focusNode.requestFocus();
                                    _showEmojiPicker = false;
                                  } else {
                                    _focusNode.unfocus();
                                    _showEmojiPicker = true;
                                  }
                                });
                              },
                            ),
                            controller: _messageController,
                          ),
                        ),
                      ),


                      InkWell(
                        onTap:_sendMessage ,
                        child: Container(
                          margin:const  EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color:const  Color(0xFFFED957),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          width: 40,
                          height: 40,
                          child: Center(
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


}