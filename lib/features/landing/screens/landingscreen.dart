import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messwenger/common/utls/colors.dart';
import 'package:messwenger/common/widgets/custom_button.dart';
import 'package:messwenger/features/auth/screens/loginscreen.dart';

class Landingscreen extends StatefulWidget {
  const Landingscreen({super.key});

  @override
  State<Landingscreen> createState() => _LandingscreenState();
}

class _LandingscreenState extends State<Landingscreen> {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text('Welcome to WhatsApp',style: GoogleFonts.roboto(
              fontSize: 32,
              fontWeight: FontWeight.w600
            ),),
          ),
          SizedBox(height: size.height/9,),
          Image.asset("assets/bg.png",
          height: 300,
          width: 300,),
          SizedBox(height: size.height/9),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text( 'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
            style: GoogleFonts.roboto(
              color: greyColor,
            ),
            textAlign: TextAlign.center,),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomButton(text:"AGREE AND CONTINUE",
             onPressed: () {
              Navigator.pushNamed(context, Loginscreen.routename);
               
             },),
          )
          


        ],
      )),
    );
  }
}