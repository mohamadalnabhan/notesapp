import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:idkfirbase/auth/signup.dart';
import 'package:idkfirbase/categories/addcategory.dart';

import 'firebase_options.dart';
import 'auth/login.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? newUser) {
      setState(() {
        user = newUser; // Update the user state
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[100],
              titleTextStyle: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              iconTheme: IconThemeData(color: Colors.orangeAccent, size: 25))),
      debugShowCheckedModeBanner: false ,
      title: 'Flutter Firebase Setup',
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? Home()
          : Login(),
      routes: {
        "signup": (context) => Signup(),
        "login": (context) => Login(),
        "home": (context) => Home(),
        "addcategory": (context) => Addcategory(),
      },
    );
  }
}
