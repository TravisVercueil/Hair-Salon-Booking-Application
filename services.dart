import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ServicesPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF83b6cc),
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
        title: Text('Services', style: GoogleFonts.raleway(
            fontSize: 30, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF83b6cc),
      ),
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(
          image: AssetImage("Assets/images/background.jpg"),
          fit: BoxFit.cover,
        )),
        child: Center(
          child: Container(
            width: 350,
            height: 520,
            decoration: BoxDecoration(color: Colors.white70,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.grey),),
            child: Center(child: Column(children: <Widget>[
              Container(
                  margin: EdgeInsets.all(10),
                  child: Text('CUT:', style: GoogleFonts.raleway(fontSize: 20,fontWeight: FontWeight.bold))
              ),
              Container(
                  margin: EdgeInsets.all(5),
                  width: 220,
                  height: 120,
                  child: Text(
                    'Womens cut - R300 \n'
                        'Mens cut - R150\n',
                    softWrap: true,
                    style: GoogleFonts.rubik(fontSize: 20,fontWeight: FontWeight.bold,),
                  )
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Text('STYLE:', style: GoogleFonts.raleway(fontSize: 20,fontWeight: FontWeight.bold))
              ),
              Container(
                  margin: EdgeInsets.all(5),
                  width: 220,
                  height: 120,
                  child: Text(
                    'Blowouts - R100 \n'
                        'Straighten - R120\n'
                        'Curls - R150',
                    softWrap: true,
                    style: GoogleFonts.rubik(fontSize: 20,fontWeight: FontWeight.bold,),
                  )
              ),
              Container(
                  margin: EdgeInsets.all(10),
                  child: Text('COLOUR:', style: GoogleFonts.raleway(fontSize: 20,fontWeight: FontWeight.bold,))
              ),
              Container(
                  margin: EdgeInsets.all(5),
                  width: 280,
                  height: 120,
                  child: Text(
                    'Full Highlight - R450 \n'
                        'Partial Highlight - R250\n'
                        'Full Dye - R500\n'
                        'Roots Colour - R200',
                    softWrap: true,
                    style: GoogleFonts.rubik(fontSize: 20,fontWeight: FontWeight.bold,),
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

