import 'package:flutter/material.dart';
import 'package:messwenger/common/utls/colors.dart';
import 'package:messwenger/common/utls/utls.dart';
import 'package:messwenger/common/widgets/custom_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messwenger/features/auth/controller/authcontroller.dart';

class Loginscreen extends ConsumerStatefulWidget {
  static const routename="/login-sreen";
  const Loginscreen({super.key});

  @override
  ConsumerState<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends ConsumerState<Loginscreen> {
   
     final TextEditingController phonenumcontroller=TextEditingController();
     Country ?country;

     @override
  void dispose() {
    phonenumcontroller.dispose();
    super.dispose();
  }
  void pickacountry(){
    showCountryPicker(context: context, onSelect:(Country _country) {
      setState(() {
        country=_country;
      });

      
    },);
  }

  void sendphonenumber(){
    String phoneNumber=phonenumcontroller.text;
    if (country!=null && phoneNumber.isNotEmpty) {
      ref.read(authcontrollerprovider).signinwithphone(context,"+${country!.phoneCode}$phoneNumber");
      
    }
    else{
      showsnackbar(context: context, content: 'Fill out all the fields');
    }
  }
  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;
    
     
    return Scaffold(
      appBar: AppBar(elevation: 0,
      backgroundColor: backgroundColor,
        title:const Text("Enter your phone number"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("we Need to verify your phone number"),
                const SizedBox( height: 10,),
                TextButton(onPressed: pickacountry, child: const Text("pick your county")),
                const SizedBox(height: 5,),
                Row(
                  children: [
                   if(country!=null)
                   Text('+${country!.phoneCode}'),
                    
                  
                    const SizedBox(width: 10,),
                    SizedBox(width: size.width* 0.7,
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: phonenumcontroller,
                      decoration:const InputDecoration(
                        
                        hintText: "phone number"
                      ),
                    ),),
                 
                  ],
                ),
                   
                   
              ],
            ),
             SizedBox(width: 90,
                  child:CustomButton(text: "next",
                   onPressed: sendphonenumber,) ,
                )
          ],
        ),
      ),
    );
  }
}