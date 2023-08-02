import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messwenger/common/enums/messages_enum.dart';
import 'package:messwenger/features/auth/controller/authcontroller.dart';
import 'package:messwenger/features/chat/repository/chat_repository.dart';
import 'package:messwenger/models/chat_contact.dart';
import 'package:messwenger/models/message.dart';


final chatcontrollerprovider=Provider((ref) { 
  final chatRepository =ref.watch(chatRepositoryprovider);
   return Chatcontroller (chatRepository: chatRepository,
 ref: ref
 );});

class Chatcontroller {
  
  final ChatRepository chatRepository;
  final ProviderRef ref;

  Chatcontroller({required this.chatRepository, required this.ref});

  void sendTextmessage(BuildContext context,
  String text,String recieveruserId){
    ref.read(userDataAuthprovider).whenData((value) => 
     chatRepository.sendTextmessage(context: context,
     text: text,
      recieveruserId: recieveruserId,
       senderuser: value!));
    
  }

  Stream<List<ChatContact>>chatcontacts(){
    return chatRepository.getChatcontacts();
  }
  Stream<List<Message>>chatstream(String recieveruserId){
    return chatRepository.getchatstream(recieveruserId);
  }
  void sendfilemessage(BuildContext context,
  File file,String recieveruserId,MessageEnum messageEnum){
    ref.read(userDataAuthprovider).whenData((value) => 
     chatRepository.sendFilemessage(context: context,
     
      recieveruserId: recieveruserId,
       file:file,
        messageEnum: messageEnum,
         ref: ref,
          senderuserData:value!,
       ));
    
  }
}