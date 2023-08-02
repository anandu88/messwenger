import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




final commonfirebasestoragerespositoryprovider=Provider((ref) => 
Commonfirebasestoragerespository(firebaseStorage: FirebaseStorage.instance));
class Commonfirebasestoragerespository{
final FirebaseStorage firebaseStorage;

  Commonfirebasestoragerespository({required this.firebaseStorage});


  Future<String > storeFiletoFirebase(String ref,File file)async{
    UploadTask uploadTask=firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot=await uploadTask;
    String downloadurl=await snapshot.ref.getDownloadURL();
    return downloadurl;


  }
}