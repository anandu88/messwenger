import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messwenger/common/utls/utls.dart';
import 'package:messwenger/features/chat/screens/mobilechatscreen.dart';
import 'package:messwenger/models/usermodel.dart';
final selectContactsRepositoryProvider=Provider(
  (ref) => SelectContactRepository(firestore:FirebaseFirestore.instance));

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});


 Future <List<Contact>> getContacts()async{
    List<Contact>contacts=[];
    try {
      if (await FlutterContacts.requestPermission()) {
      contacts= await FlutterContacts.getContacts(withProperties: true);
        
      }
      
    } catch (e) {
      debugPrint(e.toString());
      
    }
    return contacts;
    
  }
  void selectcontact(Contact selectedcontact, BuildContext context) async{
    try {
      var userCollection= await firestore.collection("users").get();
      bool isFound=false;
      for (var document in userCollection.docs) {
        var userData=UserModel.fromMap(document.data());
        String selectedphonenum=selectedcontact.phones[0].number.replaceAll(' ', "");
        if (selectedphonenum==userData.phoneNumber) {
          isFound=true;

          Navigator.pushNamed(context, MobileChatScreen.routename,
          arguments: {
            'name' : userData.name,
            'uid' :userData.uid,
              
          });
          
          
        }
        if (!isFound) {
          showsnackbar(context: context, content: "this number doesnt exist  in this app");


          
        }
        
      }
      
    } catch (e) {
      showsnackbar(context: context, content: e.toString());
      
    }
      
    }

  
}