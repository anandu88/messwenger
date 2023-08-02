import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messwenger/common/widgets/error.dart';
import 'package:messwenger/common/widgets/loader.dart';
import 'package:messwenger/features/auth/controller/authcontroller.dart';
import 'package:messwenger/features/landing/screens/landingscreen.dart';
import 'package:messwenger/features/landing/screens/mobilelayoutscreen.dart';
import 'package:messwenger/firebase_options.dart';
import 'package:messwenger/router.dart';

import 'common/utls/colors.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const ProviderScope(child: Myapp()));
}
class Myapp extends ConsumerWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       title: 'Whatsapp UI',
       theme: ThemeData.dark().copyWith(
         scaffoldBackgroundColor: backgroundColor,
         appBarTheme: const AppBarTheme(
          color: appBarColor
         )
       ),
       onGenerateRoute: (settings) => generateRoute(settings),
       home: ref.watch(userDataAuthprovider).when(data: (user){
        if (user==null) {
          return const Landingscreen();
          
        }
        return const Mobillayoutscreen();

       }, 
       error: (err,trace){
        return Errorscreen(error: err.toString());
       }, 
       loading:() => const Loader(),)
    );
  }
}