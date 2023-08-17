import 'package:flutter/material.dart';
import 'package:messwenger/common/enums/messages_enum.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:messwenger/features/chat/widgets/video_player_item.dart';
import 'package:audioplayers/audioplayers.dart';

class DisplayTextandFiles extends StatelessWidget {
  


  final String message;
  final MessageEnum type;
  const DisplayTextandFiles({super.key,
  required this.message,required this.type});

  @override
  Widget build(BuildContext context) {
    bool isplaying=false;
    final AudioPlayer audioPlayer=AudioPlayer();
    return  type==MessageEnum.text?
    Text(message,style:const  TextStyle(
      fontSize: 16
    ),
    ):type == MessageEnum.audio? StatefulBuilder(
      builder: (context,setState) {
        return IconButton(onPressed: ()async {
          if (isplaying) {
          
            await audioPlayer.pause();
              setState(() {
              isplaying=false;
            },);
            
          }
          else{
            
            await audioPlayer.play(UrlSource(message));
            setState(() {
              isplaying=true;
            },);
          }

          
        },constraints: const BoxConstraints(
          minWidth: 150,

        ),
         icon: Icon(isplaying? Icons.pause_circle : Icons.play_circle));
      }
    ) : type==MessageEnum.video?Videoplayeritem(videoUrl: message):
    CachedNetworkImage(imageUrl: message);
  }
}