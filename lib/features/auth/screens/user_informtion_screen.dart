import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messwenger/common/utls/utls.dart';
import 'package:messwenger/features/auth/controller/authcontroller.dart';

class Userinfoscreen extends ConsumerStatefulWidget {
  static const String routename='/user-information';
  const Userinfoscreen({super.key});

  @override
  ConsumerState<Userinfoscreen> createState() => _UserinfoscreenState();
}

class _UserinfoscreenState extends ConsumerState<Userinfoscreen> {
  final TextEditingController namecontroller=TextEditingController();
  File? image;
  @override
  void dispose() {
    namecontroller.dispose();
    super.dispose();
  }
  void selectimage()async{
    image=await pickimagefromgallery(context);
    setState(() {
      
    });

  }
  void storeuserdata()async{
    String name=namecontroller.text.trim();
    if (name.isNotEmpty) {
      return ref.read(authcontrollerprovider).saveuserdatatofirebase(context, name, image);
      
    }

  }
  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(child: 
      Center(
        child: Column(
          children: [
            Stack(
              children: [image==null?
               const  CircleAvatar(radius: 70,
                  backgroundImage:
                   NetworkImage(
                    "https://staticg.sportskeeda.com/editor/2022/08/53e15-16596004347246.png?w=840"),
                ):
                 CircleAvatar(radius: 70,
                  backgroundImage:
                   FileImage(image!)
                ),
                Positioned(bottom: -10,left: 80,
                  child: IconButton(onPressed: selectimage,
                   icon: const Icon(Icons.add_a_photo),
                  ),
                )
              ],
            ),
            Row(
              children: [
                   Container(
                    width: size.width*0.75,
                    margin: const EdgeInsets.all(20),
                    child: TextField(
                      controller: namecontroller,
                      decoration:const  InputDecoration(
                        hintText: "Enter your name"

                      ),
                    ),
                   ),
                   IconButton(onPressed: storeuserdata, 
                   icon:const Icon(Icons.done))
              ],
            )
            
          ],
        ),
      )),
    );
  }
}