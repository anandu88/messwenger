import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messwenger/common/utls/colors.dart';
import 'package:messwenger/features/auth/controller/authcontroller.dart';
import 'package:messwenger/features/chat/widgets/contactlist.dart';
import 'package:messwenger/features/selectcontacts/screens/select_contacts_screen.dart';

class Mobillayoutscreen extends ConsumerStatefulWidget {
  const Mobillayoutscreen({super.key});

  @override
  ConsumerState<Mobillayoutscreen> createState() => _MobillayoutscreenState();
}

class _MobillayoutscreenState extends ConsumerState<Mobillayoutscreen> with WidgetsBindingObserver{


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    super.dispose();
    // TODO: implement dispose
    
    WidgetsBinding.instance.removeObserver(this);
  }
  
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    
    switch (state) {

      case AppLifecycleState.resumed:
      ref.read(authcontrollerprovider).setUserState(true);
        
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      ref.read(authcontrollerprovider).setUserState(false);
        break;
      
    }
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
       appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarColor,
        centerTitle: false,
        title: Text("Whatsapp",
        style: GoogleFonts.montserrat(
          fontSize: 20,
          color: Colors.grey,
          fontWeight: FontWeight.bold
        ),),
        actions: [
          IconButton(onPressed: (){}, 
          icon: const Icon(Icons.search,
          color: Colors.grey,),
          ),
          IconButton(onPressed: (){},
           icon: const Icon(Icons.more_vert,
           color: Colors.grey,),
           )
        ],
        bottom:  TabBar(tabs: const [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: GoogleFonts.roboto(
              fontWeight: FontWeight.bold
            ),
        ),
        
       ),
       body: const ContactList(),
       floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, SelectContactScreen.routename);
       },
       child: const Icon(Icons.comment,
       
       color: Colors.white,),),
      ),
    );
  }
}