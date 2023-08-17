import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';


class Videoplayeritem extends StatefulWidget {
  final String videoUrl;
  const Videoplayeritem({super.key, required this.videoUrl});

  @override
  State<Videoplayeritem> createState() => _VideoplayeritemState();
}

class _VideoplayeritemState extends State<Videoplayeritem> {

  late CachedVideoPlayerController videoPlayerController;
  bool isplay=false;
  @override
  void initState() {
  
    super.initState();
    videoPlayerController=CachedVideoPlayerController.network(widget.videoUrl,)..initialize().then((value) {
      videoPlayerController.setVolume(1);
    });
    
  }
  @override
  void dispose() {
    super.dispose();
    
    videoPlayerController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 16/9,
    child: Stack(
      children: [
        CachedVideoPlayer(videoPlayerController,
        ),
        Align(alignment: Alignment.center,
          child: IconButton(onPressed: (){
            if (isplay) {
              videoPlayerController.pause();
              
            }else{
              videoPlayerController.play();
            }
            setState(() {
              isplay=!isplay;
            });
          },
           icon:  Icon(isplay ? Icons.pause_circle_filled_rounded:Icons.play_circle_fill_rounded)),
        )
      ],
    ),);
  }
}