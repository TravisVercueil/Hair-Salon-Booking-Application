import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_haircutters/currentUser.dart';
import 'package:the_haircutters/get_fullName.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _fullName = "loading...";
  String? _email = "";
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  List<Map<String, dynamic>> bookings = [];

  Future<void> _getUserName() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(await FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        _fullName = value.data()?['fullName'].toString();
        _email = value.data()?['email'].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserName();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: user.uid)
            .get();
        bookings = bookingSnapshot.docs.map((doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
          String bookingId = doc.id;
          String serviceName = data?['serviceName'] ?? '';
          String date = data?['date'] ?? '';
          String Time = data?['Time']??'';
          int servicePrice = data?['servicePrice'] ?? 0;

          return {
            'bookingId': bookingId,
            'serviceName': serviceName,
            'date': date,
            'Time': Time,
            'servicePrice': servicePrice,
          };
        }).toList();
        setState(() {});
      }
    } catch (e) {
      print('Error fetching bookings: $e');
    }
  }

  void _deleteBooking(String bookingId) async {
    try {
      await FirebaseFirestore.instance.collection('bookings').doc(bookingId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Update the UI or perform any other tasks after successful deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting booking: $e'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error deleting booking: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF83b6cc),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
        title: Text(
          'Account',
          style: GoogleFonts.raleway(fontSize: 30, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF83b6cc),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              width: 400,
              height: 30,
              child: Text("Your details: ",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 5),
              width: 400,
              height: 50,
              child: Text("Name: " +
                _fullName! + "\n" + "Email: "  + _email!,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(fontSize: 18),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'My Bookings:',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Container(
                color: Colors.white70,
                width: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: bookings.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> bookingData = bookings[index];
                    String bookingId = bookingData['bookingId'] as String;
                    String serviceName = bookingData['serviceName'] as String;
                    String date = bookingData['date'] as String;
                    String Time = bookingData['Time'] as String;
                    int servicePrice = bookingData['servicePrice'] as int;

                    return Center(
                      child: ListTile(
                        title: Text(
                          'Date: $date',
                          textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 17.0,)
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Service: $serviceName',style: TextStyle(fontSize: 17.0,)),
                            Text('Time: $Time',style: TextStyle(fontSize: 17.0,)),
                            Text('Price: R$servicePrice',style: TextStyle(fontSize: 17.0,)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteBooking(bookingId); // Pass the bookingId to the delete function
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(30),
              width: 200,
              height: 40,
              child: ElevatedButton.icon(
                onPressed: () async {
                  CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
                  String? _returnString = _currentUser.signOut();
                  if (_returnString == "success") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }
                },
                label: Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 20.0, color: Colors.black87),
                ),
                icon: Icon(
                  Icons.logout,
                  color: Colors.black87,
                ),
                style: ElevatedButton.styleFrom(primary: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
