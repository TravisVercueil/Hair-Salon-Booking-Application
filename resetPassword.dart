

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: fpScreen(),
    );
  }

}
class fpScreen extends StatefulWidget {
  const fpScreen({super.key});

  @override
  State<fpScreen> createState() => _fpScreenState();
}

class _fpScreenState extends State<fpScreen> {

  Future<FirebaseApp> initialzieFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.black, // <-- SEE HERE
          ),
          title: Text('Reset Password',style: GoogleFonts.raleway(
              fontSize: 30, color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF83b6cc),

        ),
        backgroundColor: Color(0xFF83b6cc),
        body: FutureBuilder(
            future : initialzieFirebase(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                return forgotPassword();
              }
              return const Center(child : CircularProgressIndicator(),
              );
            }
        )
    );
  }
}
class forgotPassword extends StatefulWidget {
  const forgotPassword({super.key});

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {


  @override
  Widget build(BuildContext context) {

    TextEditingController _emailController = TextEditingController();

    return  Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Colors.white70,
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black87)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.black87)),
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.black26,
                  ),
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                  ),
                ),
              ),
            ),


            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: Text(
                      'Reset Password',
                      style: GoogleFonts.raleway(
                          fontSize: 20,color: Colors.black)),
                  style: ElevatedButton.styleFrom(primary: Colors.grey),
                  onPressed: () async {
                    if(_emailController.text.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please enter email"),
                        backgroundColor: Colors.red,));
                    } else{

                      FirebaseAuth.instance.sendPasswordResetEmail(
                        email: _emailController.text);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Reset link sent to " + _emailController.text),
                        backgroundColor: Colors.green,));
                    }



                  }
                ),
            ),
          ],
        ));
  }
}


