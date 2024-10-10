import 'dart:convert';
import 'dart:developer';

import 'package:assignbot/models/user_contact_model.dart';
import 'package:assignbot/sharedpref/shared_pref.dart';
import 'package:assignbot/sharedpref/user_pref_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ContactApi extends GetxController{

  Rx<UserContactModel>? userContactModel;
RxBool isLoading=false.obs;


  fetchContactApi() async{
try {
  isLoading.value=false;
  UserPreference userPreference = UserPreference();
  UserPrefModel userData = await userPreference.getUser();

  var token = userData.token;
  const String apiUrl =  'https://chat.satyakabir.com/chatify/api/getContacts';


  var result = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  Logger().i("Message from contect Api\n${result.statusCode}\n${result.body}");

  var finalData = jsonDecode(result.body);

  // print(finalData);
  // if (finalData['success'] == true) {

  userContactModel = UserContactModel
      .fromJson(finalData)
      .obs;
  log('${userContactModel?.value}');
  isLoading.value=true;
}catch(e){
  log(e.toString());
}
    }

  // }

}