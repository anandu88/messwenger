import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messwenger/common/provider/message_reply_provider.dart';
import 'package:messwenger/common/respository/comon_firebase_respository.dart';
import 'package:messwenger/common/utls/utls.dart';
import 'package:messwenger/models/chat_contact.dart';
import 'package:messwenger/models/message.dart';
import 'package:messwenger/models/usermodel.dart';
import 'package:uuid/uuid.dart';

import '../../../common/enums/messages_enum.dart';


final chatRepositoryprovider=Provider((ref) => ChatRepository(firestore: FirebaseFirestore.instance,
 auth: FirebaseAuth.instance),);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<ChatContact>>getChatcontacts(){
    return firestore.collection('users').doc(auth.currentUser!.uid).
    collection('chats').snapshots().
    asyncMap((event) async{

      List<ChatContact>contacts=[];
      for (var document in event.docs) {
        var chatContact=ChatContact.fromMap(document.data());
        var userData=await firestore.collection('users').doc(chatContact.contactId).get();
        var user =UserModel.fromMap(userData.data()!);

        contacts.add(ChatContact(name:user. name,
         profilePic:user.profilePic,
          contactId: chatContact.contactId,
           timeSent:chatContact.timeSent, 
           lastMessage: chatContact.lastMessage));
      }
      return contacts;
    });
  }
  
Stream<List<Message>>getchatstream(String recieveruserId){
return firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(recieveruserId).
collection('messages').orderBy('timeSent').
snapshots().map((event) {
  List<Message> messages=[];
  for (var document in event.docs) {
    messages.add(Message.fromMap(document.data()));
    
  }
  return messages;
});
}
  

  void _sendDatatocontactsSubcollection(
              UserModel senderuserData,
              UserModel recieveruserData,
              String text,
              DateTime timesent,
              String recieveruserId,
              

  )async{
    var recieverchatcontact=ChatContact(name: senderuserData.name,
     profilePic: senderuserData.profilePic,
      contactId: senderuserData.uid,
       timeSent: timesent,
        lastMessage:text);


        await firestore.collection('users').doc(recieveruserId).
        collection('chats').doc(auth.currentUser!.uid).set(recieverchatcontact.toMap());

         var senderChatContact= ChatContact(name:recieveruserData.name,
          profilePic: recieveruserData.profilePic,
           contactId: recieveruserData.uid,
            timeSent: timesent, 
            lastMessage: text);
            await firestore.collection('users').doc(auth.currentUser!.uid).
            collection('chats').doc(recieveruserId).set(senderChatContact.toMap());


  }
  void _savemessagetomessagesubcollection({
    required String recieveruserId,
    required String text,
    required DateTime timesent,
    required String messageId,
    required String username,
    required String recieverusername,
    required MessageEnum messageType,
    required MessageReplay? messageReplay,
    required String senderUsername,
    required MessageEnum repliedmessagetype
    
  })async{
    final message=Message(senderId: auth.currentUser!.uid,
     recieverid: recieveruserId,
      text: text, 
      type:messageType ,
       timeSent: timesent,
       messageId: messageId,
        isSeen: false, 
        repliedmessagetype: repliedmessagetype,
         repliedmessagge: messageReplay==null? '':messageReplay.message, 
         repliedto: messageReplay==null? '' : messageReplay.isMe ? senderUsername: recieverusername,
         );

         await firestore.collection('users').
         doc(auth.currentUser!.uid).collection('chats').
         doc(recieveruserId).collection('messages').doc(messageId).set(message.toMap());


          await firestore.collection('users').
         doc(recieveruserId).collection('chats').
         doc(auth.currentUser!.uid).collection('messages').doc(messageId).set(message.toMap());

    
  }


  void sendTextmessage(
    {
     required BuildContext context,
     required String text,
     required String recieveruserId,
     required UserModel senderuser,
     required MessageReplay? messageReplay,
    }
  )async{
    try {
      var timesent=DateTime.now();
      UserModel recieveruserData;
     var userDataMap= await firestore.collection('users').doc(recieveruserId).get();
      recieveruserData=UserModel.fromMap(userDataMap.data()!);
 
        var messageId =const Uuid().v1();
      _sendDatatocontactsSubcollection(senderuser,
       recieveruserData, 
       text, timesent, 
       recieveruserId);

       _savemessagetomessagesubcollection(messageId:  messageId,
        recieveruserId: recieveruserId, 
        text: text, timesent: timesent, 
        messageType: MessageEnum.text,
         recieverusername: recieveruserData.name,
          username: senderuser.name,
           messageReplay: messageReplay,
            repliedmessagetype: messageReplay==null ?MessageEnum.text: messageReplay.messageEnum,
             senderUsername:senderuser.name,
          



        );
      
    } catch (e) {
      showsnackbar(context: context, content:e.toString());
      
    }

  }


  void sendFilemessage({
    required BuildContext context,
    required File file,
    required String recieveruserId,
    required UserModel senderuserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReplay ? messageReplay
  })async{
    try {
      var timesent =DateTime.now();
      var messageId=  const Uuid().v1();

     String imageurl= await ref.read(commonfirebasestoragerespositoryprovider).storeFiletoFirebase(
        'chat/${messageEnum.type}/${senderuserData.uid}/$recieveruserId/$messageId',
       file);

       UserModel recieveruserData;
       var userDataMap=await firestore.collection('users').doc(recieveruserId).get();
       recieveruserData=UserModel.fromMap(userDataMap.data()!);

       String  contactmsg;
       switch (messageEnum) {
         case MessageEnum.image:
          contactmsg= ' 📷 photo';
           
           break;
         case MessageEnum.video:
         contactmsg='🎥 video';
           break;
          case MessageEnum.audio:
          contactmsg='🎵audio';
            break;
          case MessageEnum.gif:
             contactmsg="GIF";
             break;
         default:
         contactmsg="GIF";
       }
       _sendDatatocontactsSubcollection(senderuserData,
        recieveruserData,
         contactmsg, 
         timesent,
          recieveruserId);

          _savemessagetomessagesubcollection(recieveruserId: recieveruserId,
           text: imageurl,
            timesent: timesent,
             messageId: messageId, username: senderuserData.uid,
              recieverusername: recieveruserData.name,
               messageType: messageEnum,
                repliedmessagetype: messageEnum,
                 messageReplay: messageReplay,
                  senderUsername: senderuserData.name);
      
    } catch (e) {
      showsnackbar(context: context, content: e.toString());
    }
  }
}