import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messwenger/common/utls/utls.dart';
import 'package:messwenger/features/auth/screens/otp_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messwenger/features/auth/screens/user_informtion_screen.dart';
import 'package:messwenger/features/landing/screens/mobilelayoutscreen.dart';
import 'package:messwenger/models/usermodel.dart';

import '../../../common/respository/comon_firebase_respository.dart';
final authRepositoryProvider =Provider((ref) => Authrespository(auth: FirebaseAuth.instance,
 firestore: FirebaseFirestore.instance));
class Authrespository{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  Authrespository({
    required this.auth,
    required this.firestore,
  });
  Future<UserModel?>getCurrentUserdata()async{
      var userdata=await firestore.collection('users').doc(auth.currentUser?.uid).get();
      UserModel ? user;
      if (userdata.data()!=null) {

        user=UserModel.fromMap(userdata.data()!);
      }
      return user;
  }



  void signinwithphone(BuildContext context,String phonenumber)async{
    try {
      await auth.verifyPhoneNumber(phoneNumber: phonenumber,
        verificationCompleted:(PhoneAuthCredential credential)async{
          await auth.signInWithCredential(credential);
        },
       verificationFailed: (error) { 
         throw Exception(error.message);
       }, 
       codeSent: (verificationId, forceResendingToken)async {
        Navigator.pushNamed(context, Otpscreen.routename,arguments: verificationId);

         
       }, 
       codeAutoRetrievalTimeout:(verificationId) {
         
       },);
      
      
    }on FirebaseAuthException catch (e) {
      showsnackbar(context: context, content: e.message!);
      
    }

  }

  void verifyotp(
    {
      required BuildContext context,
      required String verificationId,
      required String userOTP
    }
  )async{
    try {
      PhoneAuthCredential credential =PhoneAuthProvider.credential(
        verificationId: verificationId,
       smsCode:userOTP);
       await auth.signInWithCredential(credential);
       Navigator.pushNamedAndRemoveUntil(context,
        Userinfoscreen.routename, (route) => false);
      
    }on FirebaseAuthException catch (e) {
      showsnackbar(context: context, content: e.message!);
    }
  }

  saveuserdatatofirebase(
    {
      required String name,
      required File? profilepic,
      required ProviderRef ref,
      required BuildContext context
    }
  )async{
    try {
      String uid=auth.currentUser!.uid;
      String photourl= "https://staticg.sportskeeda.com/editor/2022/08/53e15-16596004347246.png?w=840";
      if (profilepic!=null) { 
       photourl= await ref.read(commonfirebasestoragerespositoryprovider).storeFiletoFirebase("profilepic$uid", profilepic,);
      }
      var user=UserModel(name: name, uid: uid, 
      profilePic: photourl,
       isOnline: true,
        phoneNumber:auth.currentUser!.phoneNumber!,
       groupId: []);
       await firestore.collection("users").doc(uid).set(user.toMap());
       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Mobillayoutscreen() ,), 
       (route) => false);
    } catch (e) {
      showsnackbar(context: context, content: e.toString() );
      
    }


  }
 Stream<UserModel> userData(String userId){
    return firestore.collection("users").doc(userId).snapshots().
    map((event) => UserModel.fromMap(event.data()!),);
  }


  void setUserState(bool isOnline)async{
    await firestore.collection('users').doc(auth.currentUser!.uid).update({'isOnline':isOnline});


  }
}