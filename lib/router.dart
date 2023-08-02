import 'package:flutter/material.dart';
import 'package:messwenger/common/widgets/error.dart';
import 'package:messwenger/features/auth/screens/loginscreen.dart';
import 'package:messwenger/features/auth/screens/otp_screen.dart';
import 'package:messwenger/features/auth/screens/user_informtion_screen.dart';
import 'package:messwenger/features/chat/screens/mobilechatscreen.dart';
import 'package:messwenger/features/selectcontacts/screens/select_contacts_screen.dart';

Route <dynamic> generateRoute(RouteSettings settings){
  switch (settings.name) {

    case Loginscreen.routename:
    
    return MaterialPageRoute(builder: (context) => const Loginscreen(),);
     case Otpscreen.routename:
     final verificationId=settings.arguments as String;
    return 
    MaterialPageRoute(builder: (context) => Otpscreen(verificationId: verificationId,),);
     case Userinfoscreen.routename:
    
    return 
    MaterialPageRoute(builder: (context) =>const Userinfoscreen());

     case SelectContactScreen.routename:
    
    return 
    MaterialPageRoute(builder: (context) => const SelectContactScreen());


   case MobileChatScreen.routename:
   final arguments=settings.arguments as Map<String,dynamic>;
   final name=arguments["name"];
   final uid= arguments["uid"];
    
    return 
    MaterialPageRoute(builder: (context) =>  MobileChatScreen(name: name,
     uid: uid,));
      
      
    default:
    return MaterialPageRoute(builder: (context) => const Scaffold(
      body: Errorscreen(error: "Something went wrong .try again"),
    ),);

  }
}