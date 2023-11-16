
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_haircutters/login.dart';
import 'package:the_haircutters/currentUser.dart';
import 'package:the_haircutters/root.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //initilization of Firebase app
  // other Firebase service initialization
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create:(context) => CurrentUser(),
      child: MaterialApp(
        home: OurRoot(
        ),

      ),
    );
  }

}


