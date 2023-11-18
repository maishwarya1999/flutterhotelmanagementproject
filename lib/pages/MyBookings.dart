import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyBookings extends StatefulWidget {
  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  late Query bookingsQuery;
  late CollectionReference<Map<String, dynamic>> bookedRoomsRef;
  late List<DocumentSnapshot> bookings;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    bookingsQuery = FirebaseFirestore.instance
        .collection('bookedRooms')
        .where('userId', isEqualTo: user?.email)
        .orderBy('checkInDate', descending: true);
    bookedRoomsRef = FirebaseFirestore.instance.collection('bookedRooms');
    bookings = [];
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final querySnapshot = await bookingsQuery.get();
    setState(() {
      bookings = querySnapshot.docs;
    });
  }

  Future<void> _cancelBooking(DocumentSnapshot booking) async {
    final roomRef =
        FirebaseFirestore.instance.collection('rooms').doc(booking['roomId']);

    // Retrieve room details
    final roomSnapshot = await roomRef.get();
    final roomData = roomSnapshot.data() as Map<String, dynamic>;

    // Update room availability
    final updatedAvailability =
        Map<String, dynamic>.from(roomData['availability']);
    updatedAvailability['date'] = booking['checkInDate'].toDate();
    await roomRef.update({
      'availability': updatedAvailability,
    });

    await bookedRoomsRef.doc(booking.id).delete();
    _loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('My Bookings'),
      // ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xFFFFF8E1),
          Color(0xFFD7CCC8),
          Color(0xFFA1887F)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: bookings.isNotEmpty
            ? ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final roomId = booking['roomId'];
                  final checkInDate = booking['checkInDate'].toDate();
                  final checkOutDate = booking['checkOutDate'].toDate();
                  return Card(
                    color: Color(0xFFD7CCC8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Room ID: $roomId'),
                          Text('Check-in Date: $checkInDate',
                          style: TextStyle(
                            fontSize: 16,
                          ),),
                          Text('Check-out Date: $checkOutDate',
                            style: TextStyle(
                              fontSize: 16,
                            ),),
                          QrImage(
                            data:
                                'ROOM_ID=$roomId\nCHECK_IN_DATE=$checkInDate\nCHECK_OUT_DATE=$checkOutDate',
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () => _cancelBooking(booking),
                                child: Text('Cancel Booking',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Color(0xFFFFFFFF))),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                  Color(0xFF323232),
                                )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text('No bookings found.'),
              ),
      ),
    );
  }
}
