import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:messwenger/common/widgets/loader.dart';
import 'package:messwenger/common/widgets/sender_messagecard.dart';
import 'package:messwenger/features/chat/controller/chatcontroller.dart';
import 'package:messwenger/models/message.dart';


import '../../../info.dart';
import '../../../common/widgets/my_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieveruserId;
  const ChatList( { required this.recieveruserId, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {

  final ScrollController messageScontroller=ScrollController();

  @override
  void dispose() {
    super.dispose();
    
    messageScontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: ref.read(chatcontrollerprovider).chatstream(widget.recieveruserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState==ConnectionState.waiting) {
          return const   Loader();
          
        }
        SchedulerBinding.instance.addPostFrameCallback((_) { 
          messageScontroller.jumpTo(messageScontroller.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: messageScontroller,
          
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData=snapshot.data![index];
            if (messageData.senderId==FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message:messageData.text,
                date:DateFormat.Hm().format(messageData.timeSent)
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: messages[index]['time'].toString(),
            );
          },
        );
      }
    );
  }
}

