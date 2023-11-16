import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_haircutters/Services.dart';
import 'package:the_haircutters/aboutUs.dart';
import 'package:the_haircutters/booking.dart';
import 'package:the_haircutters/profileScreen.dart';

import 'package:the_haircutters/bookingCalendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_haircutters/currentUser.dart';


import 'login.dart';
class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF83b6cc),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
            'The Haircutters',
            style: GoogleFonts.aclonica(
                fontSize: 30, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Color(0xFF83b6cc),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.account_circle_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          )
        ],
      ),
      body: Container(
          decoration: BoxDecoration(image: DecorationImage(
            image: AssetImage("Assets/images/THEHOME.jpg"),
            fit: BoxFit.cover,
          )),
        child: Center(child: Column(children: <Widget>[
          Container(

              margin: EdgeInsets.all(40),
              width: 200,
              height: 100,
              child: ElevatedButton.icon(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookingPage())
                    );
                  },
                  label: Text('Booking',style: TextStyle(fontSize: 20.0,color: Colors.black87)),
                  icon: Icon(
                    Icons.draw,
                    color: Colors.black87,
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.grey)
              )
          ),

          Container(
              margin: EdgeInsets.all(40),
              width: 200,
              height: 100,
              child: ElevatedButton.icon(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ServicesPage()),
                    );
                  },
                  label: Text('Services',style: TextStyle(fontSize: 20.0,color: Colors.black87)),
                  icon: Icon(
                    Icons.cut,
                    color: Colors.black87,
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.grey)
              )
          ),
          Container(
              margin: EdgeInsets.all(40),
              width: 200,
              height: 100,
              child: ElevatedButton.icon(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutUsPage()),
                    );
                  },
                  label: Text('About Us',style: TextStyle(fontSize: 20.0,color: Colors.black87)),
                  icon: Icon(
                    Icons.lightbulb,
                    color: Colors.black87,
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.grey)
              )
          ),


        ],
        ),
        ),
      ),
    );
  }
}

