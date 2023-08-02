import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messwenger/common/widgets/error.dart';
import 'package:messwenger/common/widgets/loader.dart';

import '../controllers/select-contact_controller.dart';



class SelectContactScreen extends ConsumerWidget {
  static const String routename='/select-contact';
  const SelectContactScreen({super.key});
  void selectcontact(WidgetRef ref,Contact selectedcontact ,BuildContext context){
    ref.read(selectcontactcontrollerProvider).selectContact(selectedcontact, context);
    
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
                appBar: AppBar(
                  title: Text("Select contacts",
                  style: GoogleFonts.roboto(),),
                  actions: [
                    IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert))
                  ],
                ),
                body: ref.watch(getContactsProvider).when(data: (ContactList)=>ListView.builder(
                  itemBuilder: (context, index) {
                    final contact=ContactList[index];

                  return InkWell(
                    onTap: () =>selectcontact(ref,contact, context) ,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(contact.displayName,
                        style: GoogleFonts.roboto(fontSize: 18),),
                        leading: contact.photo==null ? null : CircleAvatar(
                          backgroundImage: MemoryImage(contact.photo!,
                          ),
                          radius: 30,
                        )
                        ,
                      ),
                    ),
                  );
                },
                itemCount: ContactList.length,),
                 error: (err,trace)=>Errorscreen(error:err.toString()), 
                 loading: () =>const Loader() ,),
    );
  }
}