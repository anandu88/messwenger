import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messwenger/common/widgets/loader.dart';
import 'package:messwenger/features/auth/controller/authcontroller.dart';
import 'package:messwenger/models/usermodel.dart';


import '../../../common/utls/colors.dart';
import '../widgets/chatlist.dart';
import '../widgets/bottom_chat_widget.dart';

class MobileChatScreen extends ConsumerWidget {
  final String name;
  final String uid;

  const MobileChatScreen({Key? key, required this.name, required this.uid}) : super(key: key);
  static const String routename="/mobile-chat-screen";

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.read(authcontrollerprovider).userDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState==ConnectionState.waiting) {
              return const Loader();
              
            }
            return Column(
                children: [
                  Text(
                  name,
                  style: GoogleFonts.roboto(fontSize: 30),
            ),
            Text(snapshot.data!.isOnline ?"online": "offline",
            style: GoogleFonts.montserrat(
              fontSize: 12
            ),)
                ],
              );
          }
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
           Expanded(
            child: ChatList(recieveruserId: uid),
          ),
          Bottomchatfield(recieveruserId: uid,),
        ],
      ),
    );
  }
}

