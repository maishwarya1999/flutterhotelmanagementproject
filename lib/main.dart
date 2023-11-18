import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:hotelmgt/pages/Homepage.dart';
import 'package:hotelmgt/pages/Landingpage.dart';
import 'package:hotelmgt/pages/Signinpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:
  DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotel Management',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: HotelMgmt(),
    );
  }
}

class HotelMgmt extends StatelessWidget {
  final Future<FirebaseApp> _initialisation = Firebase.initializeApp();
  HotelMgmt({super.key});

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: _initialisation,
      builder: (context,snapshot) {
      if(snapshot.hasError){
        print('Something Went Wrong');
      }

      if(snapshot.connectionState == ConnectionState.done){
        return const SignInScreen();
      }

      return const Center(child:CircularProgressIndicator());
  }
  );
  } 
}