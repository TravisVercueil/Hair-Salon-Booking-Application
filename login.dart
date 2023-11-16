import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:the_haircutters/currentUser.dart';
import 'package:the_haircutters/homepage.dart';
import 'package:the_haircutters/register.dart';
import 'package:the_haircutters/resetPassword.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
          title: Text( 'The Haircutters',
              style: GoogleFonts.aclonica(
                  fontSize: 30, color: Colors.black) ),
          centerTitle: true,
          backgroundColor: Color(0xFF83b6cc),

        ),
        body: Container(

            child:FutureBuilder(
                future : initialzieFirebase(),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.done){
                    return LoginScreen();
                  }
                  return const Center(child : CircularProgressIndicator(),
                  );
                }

            ))

    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {



  @override
  Widget build(BuildContext context) {

    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    void _loginUser(String email, String password, BuildContext context) async{

      CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

      try{
        String? _returnString = await _currentUser.loginUser(email, password);
        if(_returnString == "success"){
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage()));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Invalid login"),
            backgroundColor: Colors.red,));

        }
      }catch(e){
        print(e);
      }
    }

    return  Padding(

        padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
        child: ListView(
          children: <Widget>[

            Container(
                color: Colors.white54,
                padding: const EdgeInsets.all(10),
                child:  Text(
                    'Sign in:', textAlign: TextAlign.left,
                    style: GoogleFonts.raleway(
                        fontSize: 25)
                )),
            Container(
              color: Colors.white54,
              padding: const EdgeInsets.all(10),
              child: TextField(

                controller: _emailController,
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
              color: Colors.white54,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Colors.white70,
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black87)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.black87)),
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
                color: Colors.white54,
                child: Row(
                  children: <Widget>[

                    TextButton(

                      child: const Text(
                        'Forgot password',
                        style: TextStyle(fontSize: 15,color: Colors.deepPurple),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => fpScreen()),
                        );
                      },
                    ),

                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                )),


            Container(

              color: Colors.white54,
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),


              child: ElevatedButton(

                  child:  Text(
                      'Login',
                      style: GoogleFonts.raleway(
                          fontSize: 20,color: Colors.black)),
                  style: ElevatedButton.styleFrom(primary: Colors.grey),
                  onPressed: () async {
                    if (_emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email cannot be empty"),backgroundColor: Colors.red,));
                    }else if(_passwordController.text.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password cannot be empty"),backgroundColor: Colors.red,));

                    } else {
                      _loginUser(_emailController.text, _passwordController.text, context);
                    }
                  }
              ),


            ),
            Container(
                color: Colors.white54,
                padding: const EdgeInsets.fromLTRB(10, 0 , 10, 10),
                child : Center(
                  child: Text("--------or--------"),
                )



            ),

            Container(
                color: Colors.white54,
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0 , 10, 10),
                child: ElevatedButton(
                    child:  Text(
                        'Register',
                        style: GoogleFonts.raleway(
                            fontSize: 20,color: Colors.black)),
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => regScreen()));
                    }
                )

            ),

          ],
        ));
  }
}