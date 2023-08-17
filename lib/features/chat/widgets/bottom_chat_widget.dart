import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messwenger/common/enums/messages_enum.dart';
import 'package:messwenger/common/provider/message_reply_provider.dart';
import 'package:messwenger/common/utls/utls.dart';
import 'package:messwenger/features/chat/controller/chatcontroller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:messwenger/features/chat/widgets/message_reply_preview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/utls/colors.dart';
import 'package:flutter_sound/flutter_sound.dart';

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
 FlutterSoundRecorder? _soundRecorder;
 bool isshowemojicontainer=false;
 bool isRecorderint=false;
 bool isRecording=false;
FocusNode focusNode=FocusNode();
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _soundRecorder=FlutterSoundRecorder();
    openAudio();
  }
  void openAudio()async{
final staus=await Permission.microphone.request();
if (staus!=PermissionStatus.granted) {
  throw RecordingPermissionException("mic permission denied");
  
}
else{
  await _soundRecorder!.openRecorder();
  isRecorderint=true;
}
  }

 @override
  void dispose() {
    super.dispose();
    _messagecontroller.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderint=false;
    
  }


 void sendTextmessage()async{
  if (isshowsendbutton) {
    ref.read(chatcontrollerprovider).sendTextmessage(context,
     _messagecontroller.text.trim(),widget.recieveruserId);
     setState(() {
       _messagecontroller.text="";
     });
    
  }
  else{
    var tempdir=await getTemporaryDirectory();
    var path='${tempdir.path}/flutter_sound.aac';
    if (isRecording) {
      await _soundRecorder!.stopRecorder();
      sendFilemessage(File(path), MessageEnum.audio);
      
    }
    else{
      await _soundRecorder!.startRecorder(
        toFile: path
      );
    }
    setState(() {
      isRecording=!isRecording;
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

 void selectvideo()async{
  File? video=await pickvideofromgallery(context);
  if ( video !=null) {
    sendFilemessage(video, MessageEnum.video);
    
  }
 }


 void hideEmojiContainer(){
  setState(() {
    isshowemojicontainer=false;
  });
 }
 void showEmojiContainer(){
  setState(() {
    isshowemojicontainer=true;
  });
 }
 void togleEmojiContainer(){
  if (isshowemojicontainer) {
    showkeyborad();
    hideEmojiContainer();
    
  } else {
    hidekeyboard();
    showEmojiContainer();
    
  }
 }
 void showkeyborad(){
  focusNode.requestFocus();
 }
 void hidekeyboard(){
  focusNode.unfocus(); 
 }
  @override
  Widget build(BuildContext context) {
    final messageReplay=ref.watch(messageReplayProvider);
    final isShowMessagereply=messageReplay!=null;
    return Column(
      children: [
        isShowMessagereply? const MessageReplyPreview():const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
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
                  prefixIcon:IconButton(icon: const Icon(Icons.emoji_emotions, color: Colors.grey,),
                           onPressed:togleEmojiContainer,
                           splashRadius: 2,),
                  suffixIcon: SizedBox(
                   width: 100,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(icon: const Icon(Icons.camera_alt, color: Colors.grey,),
                         onPressed:selectimage,
                         ),
                        IconButton(icon:const  Icon(Icons.attach_file, color: Colors.grey,),
                         onPressed: selectvideo,),
                       
                      ],
                    )
                    
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
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
            Padding(
              padding:const EdgeInsets.only(right: 2,left: 2,bottom: 8),
              child: GestureDetector(
                onTap: sendTextmessage,
                child: CircleAvatar(radius: 25,
                  backgroundColor:const Color(0xFF128C7E),
                  child:isshowsendbutton? const Icon(Icons.send,color: Colors.white,)
                  : isRecording? const Icon(Icons.close) : const Icon(Icons.mic),
                ),
              ),
            )
          ],
        ),
       isshowemojicontainer? SizedBox(
          height: MediaQuery.of(context).size.height*.30,
          child: EmojiPicker(
           textEditingController: _messagecontroller,
           config: const Config(
            columns: 8,
            emojiSizeMax: 20,
             verticalSpacing: 0,
            horizontalSpacing: 0,
          gridPadding: EdgeInsets.zero,
          initCategory: Category.RECENT,
          bgColor: backgroundColor,
          indicatorColor: Colors.blue,
          iconColor: Colors.grey,
          enableSkinTones: true,
           noRecents: Text(
          'No Recents',
          style: TextStyle(fontSize: 20, color: Colors.black26),
          textAlign: TextAlign.center,
        ),
         loadingIndicator: SizedBox.shrink(),
         categoryIcons: CategoryIcons(),
         buttonMode: ButtonMode.MATERIAL,


           ),
           onEmojiSelected: (category, emoji) {
             setState(() {
               isshowsendbutton=true;
             });
           },
          

          ),

        ):const SizedBox(),
      ],
    );
  }
}