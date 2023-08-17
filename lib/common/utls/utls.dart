import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


void showsnackbar({required BuildContext context,required String content}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));

}


Future<File?>pickimagefromgallery(BuildContext context)async{
  File? image;
  try {
    final pickedimage=  await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedimage!=null) {
      image=File(pickedimage.path );
      
    }
    
  } catch (e) {
    showsnackbar(context: context, content: e.toString());
    
  }
  return image;

}

Future<File?>pickvideofromgallery(BuildContext context)async{
  File? video;
  try {
    final pickedvideo=  await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedvideo!=null) {
      video=File(pickedvideo.path );
      
    }
    
  } catch (e) {
    showsnackbar(context: context, content: e.toString());
    
  }
  return video;

}

