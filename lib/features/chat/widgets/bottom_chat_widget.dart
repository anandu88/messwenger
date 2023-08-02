import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messwenger/common/enums/messages_enum.dart';
import 'package:messwenger/common/utls/utls.dart';
import 'package:messwenger/features/chat/controller/chatcontroller.dart';

import '../../../common/utls/colors.dart';

class Bottomchatfield extends ConsumerStatefulWidget {

  final String recieveruserId;
  const Bottomchatfield( {
    super.key,
    required this.recieveruserId,
  });

  @override
  ConsumerState<Bottomchatfield> createState() => _BottomchatfieldState();
}

class _BottomchatfieldState extends ConsumerState<Bottomchatfield> {



 bool isshowsendbutton= false;
 final TextEditingController _messagecontroller=TextEditingController();
 @override
  void dispose() {
    _messagecontroller.dispose();
    super.dispose();
  }


 void sendTextmessage()async{
  if (isshowsendbutton) {
    ref.read(chatcontrollerprovider).sendTextmessage(context,
     _messagecontroller.text.trim(),widget.recieveruserId);
     setState(() {
       _messagecontroller.text="";
     });
    
  }
 }
 void sendFilemessage(
  File file,
  MessageEnum messageEnum
 ){
  ref.read(chatcontrollerprovider).sendfilemessage(context, file, widget.recieveruserId, messageEnum);
 }

 void selectimage()async{
  File? image=await pickimagefromgallery(context);
  if ( image !=null) {
    sendFilemessage(image, MessageEnum.image);
    
  }
 }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _messagecontroller,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  isshowsendbutton=true;
                });
                
              }
              else {setState(() {
                isshowsendbutton=false;
              },
              );
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(icon: const Icon(Icons.emoji_emotions, color: Colors.grey,),
                       onPressed: () {  },),
                       IconButton(icon:const  Icon(Icons.gif, color: Colors.grey,),
                        onPressed: () {  },),
                    ],
                  ),
                ),
              ),
              suffixIcon: SizedBox(
               width: 100,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(icon: const Icon(Icons.camera_alt, color: Colors.grey,),
                     onPressed:selectimage,
                     ),
                    IconButton(icon:const  Icon(Icons.attach_file, color: Colors.grey,),
                     onPressed: () {  },),
                   
                  ],
                ),
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding:const EdgeInsets.only(right: 2,left: 2,bottom: 8),
          child: GestureDetector(
            onTap: sendTextmessage,
            child: CircleAvatar(radius: 25,
              backgroundColor:const Color(0xFF128C7E),
              child:isshowsendbutton? const Icon(Icons.send,color: Colors.white,):const Icon(Icons.mic),
            ),
          ),
        )
      ],
    );
  }
}