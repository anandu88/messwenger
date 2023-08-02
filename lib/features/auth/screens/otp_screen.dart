import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messwenger/features/auth/controller/authcontroller.dart';

import '../../../common/utls/colors.dart';

class Otpscreen extends ConsumerWidget {
  static const String routename='/otp-screen';

  final String verificationId;
  const Otpscreen({super.key, required this.verificationId});
  void verifyOTP(BuildContext context,WidgetRef ref,String userOTP){

    ref.read(authcontrollerprovider).verifyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(elevation: 0,
      backgroundColor: backgroundColor,
        title:const Text("Verifying your number"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            const Text("We have sent an SMS with a code."),
             SizedBox(
              width: size.width*.5,
              child: TextField(textAlign: TextAlign.center,
                decoration:const  InputDecoration(
                  hintText: "- - - - - -",
                  hintStyle: TextStyle(fontSize: 30)
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.length==6) { 
                    verifyOTP(context, ref,value.trim());
                    
                  }
                  
                },
              ),
             )
          ],
        ),
      ),
    );
  }
}