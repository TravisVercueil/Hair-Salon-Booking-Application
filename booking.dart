

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookingSlot {



  final String id;
  late final String label;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  bool isBooked;

  BookingSlot({
    required this.id,
    required this.label,
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
  });
}


List<BookingSlot> bookingSlots = [
  BookingSlot(
    id: "1",
    label: '9am-10am',
    startTime: TimeOfDay(hour: 9, minute: 0),
    endTime: TimeOfDay(hour: 10, minute: 0),
  ),
  BookingSlot(
    id: "2",
    label: '10am-11am',
    startTime: TimeOfDay(hour: 10, minute: 0),
    endTime: TimeOfDay(hour: 11, minute: 0),
  ),
  BookingSlot(
    id: "3",
    label: '11am-12pm',
    startTime: TimeOfDay(hour: 11, minute: 0),
    endTime: TimeOfDay(hour: 12, minute: 0),
  ),
  BookingSlot(
    id: "4",
    label: '12pm-1pm',
    startTime: TimeOfDay(hour: 12, minute: 0),
    endTime: TimeOfDay(hour: 13, minute: 0),
  ),
  BookingSlot(
    id: "5",
    label: '1pm-2pm',
    startTime: TimeOfDay(hour: 13, minute: 0),
    endTime: TimeOfDay(hour: 14, minute: 0),
  ),
  BookingSlot(
    id: "6",
    label: '2pm-3pm',
    startTime: TimeOfDay(hour: 14, minute: 0),
    endTime: TimeOfDay(hour: 15, minute: 0),
  ),
  BookingSlot(
    id: "7",
    label: '3pm-4pm',
    startTime: TimeOfDay(hour: 15, minute: 0),
    endTime: TimeOfDay(hour: 16, minute: 0),
  ),

];

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final CollectionReference collectionRef = FirebaseFirestore.instance.collection('services');
  List<String> dropdownItems = [];
  String selectedOption = '';
  DateTime selectedDate = DateTime.now();
  String selectedFormattedDate = DateFormat('MMMM d, y').format(DateTime.now());

  String selectedTimeSlot = '';
  BookingSlot? selectedBookingSlot;
  int selectedServicePrice = 0;


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await collectionRef.get();
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
        dropdownItems.add(data['serviceName'] as String);
        print(dropdownItems);
      });

      if (dropdownItems.isNotEmpty) {
        selectedOption = dropdownItems[0];
        QuerySnapshot serviceSnapshot = await FirebaseFirestore.instance
            .collection('services')
            .where('serviceName', isEqualTo: selectedOption)
            .limit(1)
            .get();
        if (serviceSnapshot.docs.isNotEmpty) {
          Map<String, dynamic> serviceData = serviceSnapshot.docs[0].data() as Map<String, dynamic>;
          selectedServicePrice = serviceData['servicePrice'] as int;
        }
      }

      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat.Hm(); // Use the "HH:mm" format
    return format.format(dateTime);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().isBefore(selectedDate)
          ? selectedDate
          : DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2024),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedBookingSlot = null; // Reset the selected time slot when the date changes
      });
    }
    String formattedDate = DateFormat('MMMM d, y').format(selectedDate);
    print(formattedDate); // Output: "July 8, 2023"
    setState(() {
      selectedFormattedDate = formattedDate;
    });
  }

  List<DropdownMenuItem<String>> buildDropdownItems() {
    return dropdownItems.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }
  Future<List<DropdownMenuItem<BookingSlot>>?>? buildTimeSlotItems() async {
    List<DropdownMenuItem<BookingSlot>> items = [];

    for (BookingSlot slot in bookingSlots) {
      if (await isTimeSlotAvailable(slot)) {
        items.add(
          DropdownMenuItem<BookingSlot>(
            value: slot,
            child: Text(
              '${formatTimeOfDay(slot.startTime)} - ${formatTimeOfDay(slot.endTime)} ',
           style: TextStyle(fontSize: 18),),
          ),
        );
      }
    }

    return items;
  }

  Future<bool> isTimeSlotAvailable(BookingSlot slot) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Check if the selected time slot is already booked by any user
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('bookings')
            .where('date', isEqualTo: selectedFormattedDate)
            .where('timeSlot.startTime', isEqualTo: formatTimeOfDay(slot.startTime))
            .get();

        // If the time slot is booked by any user, set the 'isBooked' flag to true
        if (snapshot.docs.isNotEmpty) {
          slot.isBooked = true;
          return false;
        }

        // Check if the current user has already booked the same time slot
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: user.uid)
            .where('date', isEqualTo: selectedFormattedDate)
            .where('timeSlot.startTime', isEqualTo: formatTimeOfDay(slot.startTime))
            .get();

        // If the current user has already booked the same time slot, set the 'isBooked' flag to true
        if (userSnapshot.docs.isNotEmpty) {
          slot.isBooked = true;
          return false;
        }

        return true;
      }
      return false;
    } catch (e) {
      print('Error checking time slot availability: $e');
      return false;
    }
  }

  Future<void> _bookService() async {
    DateTime currentDate = DateTime.now();
    DateTime minimumBookingDate = currentDate.add(Duration(days: 1));

    if (selectedOption.isNotEmpty &&
        selectedBookingSlot != null &&
        await isTimeSlotAvailable(selectedBookingSlot!)) {
      try {
        // Get the current user
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          print('User ID: ${user.uid}');
          print('Service Name: $selectedOption');
          print('Service Price: $selectedServicePrice');
          print('Date: $selectedFormattedDate');
          print('Time Slot: ${selectedBookingSlot!.label}');

          // Generate a booking ID
          String bookingId = FirebaseFirestore.instance.collection('bookings').doc().id;

          // Save booking details to Firestore with booking ID as a field
          await FirebaseFirestore.instance.collection('bookings').doc(bookingId).set({
            'bookingId': bookingId,
            'userId': user.uid,
            'serviceName': selectedOption,
            'servicePrice': selectedServicePrice,
            'date': selectedFormattedDate,
            'Time' : selectedBookingSlot!.label,
            'timeSlot': {
              'startTime': formatTimeOfDay(selectedBookingSlot!.startTime),
              'endTime': formatTimeOfDay(selectedBookingSlot!.endTime),
            },
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Booking successfully created!"),
            backgroundColor: Colors.green,
          ));

          print('Booking successfully created');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Booking failed!"),
          backgroundColor: Colors.red,
        ));
        print('Failed to save booking details: $e');
      }
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
          'Create Booking',
          style: GoogleFonts.raleway(fontSize: 30, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF83b6cc),
      ),
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(
            image: AssetImage("Assets/images/calendar.jpg"),
          fit: BoxFit.cover,
        )),
        child: Center(
          child: Container(

            width: 350,
            height: 550,
            decoration: BoxDecoration(color: Colors.white70,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.grey),),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 200),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child : Text("Select a day that suites you:",style: GoogleFonts.rubik(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold))
                  ),

                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },


                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Selected Date:',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(

                    child: Text("Select a Time Slot:", style: GoogleFonts.rubik(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold))
                  ),
                  Container(
                    width: 200,
                    height: 50,
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    decoration: BoxDecoration(color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                       border: Border.all(color: Colors.grey),),
                    child: FutureBuilder<List<DropdownMenuItem<BookingSlot>>?>(
                      future: buildTimeSlotItems(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<DropdownMenuItem<BookingSlot>>? items = snapshot.data;
                          if (items != null) {
                            return Center(

                              child: DropdownButton<BookingSlot>(
                                isExpanded: true,
                                value: selectedBookingSlot,
                                onChanged: (BookingSlot? newValue) {
                                  setState(() {
                                    selectedBookingSlot = newValue;
                                  });
                                },
                                items: items,
                              ),
                            );
                          } else {
                            return Text('No available time slots');
                          }
                        }
                      },
                    ),
                  ),



                  SizedBox(height: 20.0),
                  Container(child: Text("Select a Service:", style: GoogleFonts.rubik(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold)),),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        width: 200,
                        height: 50,
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.grey), // Specify the background color of the container
                           // Apply border radius if desired
                        ),
                        child: Container(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedOption,
                            onChanged: (String? newValue) async {
                              setState(() {
                                selectedOption = newValue!;
                              });

                              // Fetch the service price whenever the selected service changes
                              QuerySnapshot serviceSnapshot = await FirebaseFirestore.instance
                                  .collection('services')
                                  .where('serviceName', isEqualTo: selectedOption)
                                  .limit(1)
                                  .get();
                              if (serviceSnapshot.docs.isNotEmpty) {
                                Map<String, dynamic> serviceData =
                                serviceSnapshot.docs[0].data() as Map<String, dynamic>;
                                setState(() {
                                  selectedServicePrice = serviceData['servicePrice'] as int;
                                });
                              }
                            },
                            style: TextStyle(
                              color: Colors.black, fontSize: 18 // Specify the text color
                            ),
                            dropdownColor: Colors.white, // Specify the background color of the dropdown menu
                            items: buildDropdownItems(),
                          ),
                        ),
                      );
                    },
                  ),


                  SizedBox(height: 20.0),
                  Container(

                    width: 120,
                    height: 40,
                    child: ElevatedButton(

                      onPressed: () async {
                        _bookService();
                      },
                      child: Text(
                        'Book',
                        style: TextStyle(fontSize: 20.0, color: Colors.black87),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.grey),
                    ),
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


