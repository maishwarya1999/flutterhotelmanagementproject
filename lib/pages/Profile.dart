import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotelmgt/pages/Signinpage.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
              child: Column(
                children: [
                  // Profile section
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  //profile picture and user information
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/profile_picture.png'),
                        radius: 40,
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12),
                          Text(
                            '${FirebaseAuth.instance.currentUser!.email}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          // Text(
                          //   'New York, NY',
                          //   style: TextStyle(
                          //     color: Colors.grey[700],
                          //     fontSize: 16,
                          //   ),
                          // ),
                          SizedBox(height: 8),
                          Text(
                            'Joined in January 2015',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(25),
                    child: ElevatedButton(
                      child: Text('Logout',
                          style: TextStyle(
                              fontSize: 20.0, color: Color(0xFFFFFFFF))),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFF323232),
                      )),
                      onPressed: () {
                        _signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()));
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 16),
                        ListTile(
                          title: Text('Email'),
                          // subtitle: Text('johndoe@gmail.com'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigate to email change page
                          },
                        ),
                        ListTile(
                          title: Text('Password'),
                          // subtitle: Text('********'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigate to password change page
                          },
                        ),
                        SizedBox(height: 32),
                        Text(
                          'Support',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 16),
                        ListTile(
                          title: Text('Contact Us'),
                          subtitle: Text('1-803-949-8073'),
                          trailing: Icon(Icons.phone),
                          onTap: () {
                            // Call support phone number
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  var currentUser = FirebaseAuth.instance.currentUser;

  _signOut() async {
    await auth.signOut();
  }
}

// child: Center(child: Column(children: <Widget>[
// Container(
// margin: EdgeInsets.all(25),
// child:Text(
// 'User id: ${FirebaseAuth.instance.currentUser!.email}',
// style: TextStyle(fontSize: 24),
// ),
// ),
//
// ]
// ),
// ),
