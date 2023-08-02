import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:messwenger/common/widgets/loader.dart';
import 'package:messwenger/features/chat/controller/chatcontroller.dart';
import 'package:messwenger/models/chat_contact.dart';

import '../screens/mobilechatscreen.dart';
import '../../../common/utls/colors.dart';

class ContactList extends ConsumerWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder<List<ChatContact>>(
        stream: ref.watch(chatcontrollerprovider).chatcontacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState==ConnectionState.waiting) {
            return const Loader();
            
          }
          return ListView.builder(itemBuilder: (context, index) {
            var chatContactdata=snapshot.data![index];



            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(MobileChatScreen.routename,
                      arguments: {
                        "name":chatContactdata.name,
                        "uid" :chatContactdata.contactId
                      });
                    },
                    child: ListTile(
                      title: Text(
                        chatContactdata.name,
                        style: GoogleFonts.roboto(
                          fontSize: 17
                        ),
                        
                      ),
                      subtitle: Text(
                       chatContactdata.lastMessage,
                        style: GoogleFonts.roboto(fontSize: 15),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(chatContactdata.profilePic),
                        radius: 
                        30,
                      ),
                      trailing: Text(DateFormat.Hm().format(chatContactdata.timeSent),
                      style: GoogleFonts.roboto(fontSize: 15),),
                    ),
                  ),
                ),
                const Divider(color: dividerColor, indent: 85),
          
              ],
            );
          },
          shrinkWrap: true,
          itemCount:snapshot.data!.length,);
        }
      ),
    );
  }
}