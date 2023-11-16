import 'package:flutter/material.dart';
import 'package:the_haircutters/booking.dart';
import 'package:google_fonts/google_fonts.dart';
class AboutUsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF83b6cc),
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
        title: Text('About Us', style: GoogleFonts.raleway(
            fontSize: 30, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF83b6cc),
      ),
      body: Container(
          decoration: BoxDecoration(image: DecorationImage(
            image: AssetImage("Assets/images/hello.jpg"),
            fit: BoxFit.cover,
          )),
        child: Center(
          child: Container(
            decoration: BoxDecoration(color: Colors.white70),
            width: 350,
            height: 550,

            child: Center(child: Column(children: <Widget>[
              Container(
                  margin: EdgeInsets.all(5),
                  width: 220,
                  height: 40,
                  child: Text(
                    'Location:', textAlign: TextAlign.center,
                       style: GoogleFonts.rubik(fontSize: 22, color: Colors.black,fontWeight: FontWeight.bold),
                  )
              ),
              Container(
                child: Image.asset('Assets/images/map.png'),
                width: 300,
                height: 170,
              ),
              Container(
                  child: Text('Address:', style: GoogleFonts.rubik(fontSize: 22, color: Colors.black,fontWeight: FontWeight.bold))
              ),
              Container(
                  margin: EdgeInsets.all(5),
                  child: Text(
                    ' 7 Urb Street, Durbanville, 7530',
                    softWrap: true,
                    style: GoogleFonts.rubik(fontSize: 17),
                  )
              ),
              Container(
                  child: Text('Contact:', style: GoogleFonts.rubik(fontSize: 22, color: Colors.black,fontWeight: FontWeight.bold))
              ),
              Container(
                  margin: EdgeInsets.all(5),
                  child: Text(
                    ' 082 455 6969',
                    softWrap: true,
                    style: GoogleFonts.rubik(fontSize: 17),
                  )
              ),
              Container(
                  child: Text('Email:', style: GoogleFonts.rubik(fontSize: 22, color: Colors.black,fontWeight: FontWeight.bold))
              ),
              Container(
                  margin: EdgeInsets.all(5),
                  child: Text(
                    'thehaircutters@gmail.com',
                    softWrap: true,
                    style: GoogleFonts.rubik(fontSize: 17),
                  )
              ),
              Container(
                  child: Text('Operating Hours:', style: GoogleFonts.rubik(fontSize: 22, color: Colors.black,fontWeight: FontWeight.bold))
              ),
              Container(
                  margin: EdgeInsets.all(5),
                  child: Text(
                        'Monday-Friday: 9am-5pm\n'
                        'Weekends: closed',

                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: GoogleFonts.rubik(fontSize: 17),
                  )
              ),
            ],
            ),
            ),
          ),
        ),
      ),
    );
  }
}

