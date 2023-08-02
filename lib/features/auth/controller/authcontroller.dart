import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messwenger/features/auth/repository/auth_respository.dart';
import 'package:messwenger/models/usermodel.dart';
final authcontrollerprovider=Provider((ref) {
  final authrespository=ref.watch(authRepositoryProvider);
  return Authcontroller(authrespository: authrespository, ref: ref);
});
final userDataAuthprovider=FutureProvider((ref) {
  final authcontroller=ref.watch(authcontrollerprovider);
  return authcontroller.getuserdata();
});
class Authcontroller{
  final Authrespository authrespository;
  final ProviderRef ref;

  Authcontroller( {required this.authrespository,required this.ref});

   Future<UserModel?>getuserdata()async{
    UserModel? user=await authrespository.getCurrentUserdata();
    return user;
   } 

  void signinwithphone(BuildContext context ,String phoneNumber){
    authrespository.signinwithphone(context, phoneNumber);
  
}
 void verifyOTP(BuildContext context ,String verificationId,String userOTP){
    authrespository.verifyotp(context: context, verificationId: verificationId, userOTP: userOTP);
  
}
void saveuserdatatofirebase(BuildContext context,String name,File?profilePic){

authrespository.saveuserdatatofirebase(name: name, 
profilepic: profilePic,
 ref: ref, context: context);
}
Stream<UserModel>userDataById(String userId){
  return  authrespository.userData(userId);
}
void setUserState(bool isOnline){
    authrespository.setUserState(isOnline);


  }

  
}
