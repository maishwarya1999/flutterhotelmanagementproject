import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:hotelmgt/pages/RoomsScreen.dart';

class Room {
  final String name;
  final String description;
  final String imageUrl;
  final int price;

  Room({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _location = 'Charlotte';
  int _guests = 1;
  DateTime _checkInDate = DateTime.now();
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
        body: Container(
        width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(
    gradient: LinearGradient(colors: [
    Color(0xFFFFF8E1),
    Color(0xFFD7CCC8),
    Color(0xFFA1887F)
    ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
    child: SingleChildScrollView(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    SizedBox(height: 100),
    Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Image.asset('assets/images/Taj.png', height: 100),
    ),
    SizedBox(height: 40),
    Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Location',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 10),
    TextField(
    decoration: InputDecoration(
    hintText: 'Enter your location',
    border: OutlineInputBorder(),
    ),
    onChanged: (value) => _location = value,
    ),
    SizedBox(height: 20),
    Text(
    'Guests',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 10),
    TextField(
    decoration: InputDecoration(
    hintText: 'Enter number of guests',
    border: OutlineInputBorder(),
    ),
    keyboardType: TextInputType.number,
    onChanged: (value) => _guests = int.tryParse(value) ?? 0,
    ),
      SizedBox(height: 20),
      Text(
        'Guest Name:',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      TextField(
        decoration: InputDecoration(
          hintText: 'Enter a name for the booking',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => _location = value,
      ),
    SizedBox(height: 20),
    Text(
    'Check-in Date',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 10),
    GestureDetector(
    onTap: () => _selectCheckInDate(context),
    child: Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(_checkInDate == null
          ? 'Select Date'
          : DateFormat('MM/dd/yyyy').format(_checkInDate)),
      Icon(Icons.calendar_today),
    ],
    ),
    ),
    ),
    SizedBox(height: 20),
    Text(
    'Check-out Date',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 10),
    GestureDetector(
    onTap: () => _selectCheckOutDate(context),
    child: Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(_checkOutDate == null ? 'Select Date'
        : DateFormat('MM/dd/yyyy').format(_checkOutDate)),
    Icon(Icons.calendar_today),
    ],
    ),
    ),
    ),
    SizedBox(height: 20),
    SizedBox(
    width: double.infinity,
    child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomsScreen(
            location: _location,
            guests: _guests,
            checkInDate: _checkInDate,
            checkOutDate: _checkOutDate,
          ),
        ),
      );

    },
    child: Text('Search Rooms',  style: TextStyle(fontSize: 18),
    ),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF323232),
        onPrimary: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10),
      ),
    ),
    ),
    ],
    ),
    ),
    ],
    ),
        ),
        )
    );
  }
  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _checkInDate) {
      setState(() {
        _checkInDate = picked;
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate ?? DateTime.now(),
      firstDate: _checkInDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _checkOutDate) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }
}
