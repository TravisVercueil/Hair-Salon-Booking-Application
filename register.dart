import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:the_haircutters/currentUser.dart';
import 'package:the_haircutters/homepage.dart';
import 'package:the_haircutters/main.dart';
import 'package:the_haircutters/login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: regScreen(),
    );
  }

}
class regScreen extends StatefulWidget {
  const regScreen({super.key});

  @override
  State<regScreen> createState() => _regScreenState();
}

class _regScreenState extends State<regScreen> {

  Future<FirebaseApp> initialzieFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF83b6cc),

        appBar: AppBar(
            automaticallyImplyLeading: false,
          title: Text( 'Registration',
            style: GoogleFonts.raleway(
                fontSize: 30, color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF83b6cc),


             leading: IconButton(
                icon: const Icon(Icons.arrow_back,color: Colors.black,),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
        ),
        body: FutureBuilder(
            future : initialzieFirebase(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                return RegisterScreen();
              }
              return const Center(child : CircularProgressIndicator(),
              );
            }
        )
    );
  }
}
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {



    @override
    Widget build(BuildContext context) {
      String btn = 'Register';

      TextEditingController _fullnameController = TextEditingController();
      TextEditingController _emailController = TextEditingController();
      TextEditingController _passwordController = TextEditingController();

       _registerUser(String email, String password, BuildContext context, String fullName) async {
        CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

        try {
          String? _returnString = await _currentUser.registerUser(email, password, fullName);
          if (_returnString == "success") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Verification email sent to: " + _emailController.text),
              backgroundColor: Colors.green,));
          }else{

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(_returnString!),
              backgroundColor: Colors.red,));
          }
        } on FirebaseAuthException catch (e) {

        }
      }

      return Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Text('Register here with your details to get started!',
                    style: GoogleFonts.raleway(
                        fontSize: 18),
                  )),

              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _fullnameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    filled: true,
                    //<-- SEE HERE
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                        width: 1, color: Colors.black87)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                        width: 2, color: Colors.black87)),
                    labelText: 'Full Name',
                    labelStyle: TextStyle(
                      color: Colors.black26,
                    ),
                    hintText: 'Enter your full name',
                    hintStyle: TextStyle(
                      color: Colors.black26,
                    ),
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    filled: true,
                    //<-- SEE HERE
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                        width: 1, color: Colors.black87)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                        width: 2, color: Colors.black87)),
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
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    filled: true,
                    //<-- SEE HERE
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                        width: 1, color: Colors.black87)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                        width: 2, color: Colors.black87)),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.black26,
                    ),
                    hintText: 'Enter your password',
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
                        'Register',
                        style: GoogleFonts.raleway(
                            fontSize: 20, color: Colors.black)),
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                    onPressed: () async {
                      if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty ||
                          _fullnameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Fill in required fields"),
                          backgroundColor: Colors.red,));
                      } else {
                        _registerUser(_emailController.text, _passwordController.text, context, _fullnameController.text);
                      }
                    },
                  )
              ),
            ],
          ));
    }
  }




