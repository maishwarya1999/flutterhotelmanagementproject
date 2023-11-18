import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:hotelmgt/pages/MyBookings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoomsScreen extends StatelessWidget {
  final String location;
  final int guests;
  final DateTime checkInDate;
  final DateTime checkOutDate;

  const RoomsScreen({
    Key? key,
    required this.location,
    required this.guests,
    required this.checkInDate,
    required this.checkOutDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Results'),
        backgroundColor: Color(0xFFA1887F),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xFFFFF8E1),
          Color(0xFFD7CCC8),
          Color(0xFFA1887F)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong.'),
              );
            }

            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final rooms = snapshot.data!.docs
                .map((doc) => Room.fromSnapshot(doc))
                .toList();

            final availableRooms = rooms.where((room) {
              final isAvailable =
                  room.checkAvailability(checkInDate, checkOutDate) &&
                      room.capacity >= guests;
              return isAvailable;
            }).toList();

            if (availableRooms.isEmpty) {
              return Center(
                child: Text(
                    'Sorry, no available rooms match your search criteria.'),
              );
            }

            return ListView.builder(
              itemCount: availableRooms.length,
              itemBuilder: (context, index) {
                final room = availableRooms[index];
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: ListTile(
                  title: Text('${room.name}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${room.price} / night'),
                      Text('${room.description}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      final roomRef = FirebaseFirestore.instance
                          .collection('rooms')
                          .doc(room.id);

                      // Retrieve room details
                      final roomSnapshot = await roomRef.get();
                      final roomData =
                          roomSnapshot.data() as Map<String, dynamic>;

                      // Create bookedRoom data
                      final bookedRoom = {
                        'userId': user?.email,
                        'roomId': room.id,
                        'checkInDate': checkInDate,
                        'checkOutDate': checkOutDate,
                      };

                      // Add bookedRoom data to bookedRooms collection
                      final bookedRoomRef = await FirebaseFirestore.instance
                          .collection('bookedRooms')
                          .add(bookedRoom);

                      // Update room availability
                      final updatedAvailability =
                          Map<String, dynamic>.from(roomData['availability']);
                      // for (var date = checkInDate; date.isBefore(checkOutDate); date = date.add(const Duration(days: 1))) {
                      //   updatedAvailability[date.toString()] = false;
                      // }
                      updatedAvailability['date'] = checkOutDate;
                      await roomRef.update({
                        'availability': updatedAvailability,
                      });

                      // Redirect to MyBookings page
                      final bookingsQuery = FirebaseFirestore.instance
                          .collection('bookedRooms')
                          .where('userId', isEqualTo: user?.email);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyBookings(),
                      ));
                    },
                    child: Text('Book',
                        style: TextStyle(
                            fontSize: 20.0, color: Color(0xFFFFFFFF))),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFFA1887F),
                        )),
                  ),
                ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class Room {
  final String id;
  final String name;
  final String description;
  final int price;
  final int capacity;
  final Map<String, dynamic> availability;

  Room({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.capacity,
    required this.availability,
  });

  factory Room.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Room(
      id: snapshot.id,
      name: data['name'],
      description: data['description'],
      price: data['price'],
      capacity: data['capacity'],
      availability: data['availability'],
    );
  }

  bool checkAvailability(DateTime checkInDate, DateTime checkOutDate) {
    final checkInDateStr = DateFormat('yyyy-MM-dd').format(checkInDate);
    final checkOutDateStr = DateFormat('yyyy-MM-dd').format(checkOutDate);

    String dateStr = "";
    bool isAvailable = false;

    return availability.entries.any((entry) {
      if (entry.key == "date") {
        dateStr = DateFormat('yyyy-MM-dd').format(entry.value.toDate());
      } else if (entry.key == "isAvailable") {
        isAvailable = entry.value;
      }

      if (isAvailable &&
          checkInDateStr.compareTo(dateStr) >= 0 &&
          dateStr.compareTo(checkOutDateStr) < 0) {
        return true;
      }

      return false;
    });
  }
}
