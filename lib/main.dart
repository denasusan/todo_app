import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app/home.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:todo_app/model/user.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart';

final Color BLACK_CUSTOM = const Color(0xFF000000);
final Color GREEN_PRIMARY = const Color(0xFF4EA949);
final Color YELLOW_CUSTOM = const Color(0xFFFFC83F);

void addUser() async {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference users = db.collection("users");
  final Map<String, dynamic> userValue = {
    "user_id": 3,
    "user_name": "Dena",
    "user_email": "dena@gmail.com"
  };
  await users.doc("dena@gmail.com").set(userValue);
}

void updateUser() async {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference users = db.collection("users");
  final Map<String, dynamic> userValue = {
    "user_name": "Dena Baru",
  };
  await users.doc("dena@gmail.com").update(userValue);
}

void deleteUser() async {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference users = db.collection("users");
  await users.doc("dena@gmail.com").delete();
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBkluq8V_hzI3SNOUl92ty56WLfmp3wFDg",
          appId: "1:395030047429:android:6f972f8d07833f92ba5eac",
          messagingSenderId: "395030047429",
          projectId: "todo-list-4d4a1"));

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference users = db.collection("users");
  // addUser();
  // updateUser();
  deleteUser();
  users.get().then(
    (querySnapshot) {
      print("Successfully completed");
      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
      }
    },
    onError: (e) => print("Error completing: $e"),
  );

  
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      theme: ThemeData(fontFamily: 'Poppins'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'MANAGE ',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF001A72),
                    ),
                  ),
                  TextSpan(
                    text: 'YOUR TASKS',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE3A60D),
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.0),
            Text(
              'EASILY',
              style: TextStyle(
                fontSize: 80.0,
                fontWeight: FontWeight.bold,
                color: GREEN_PRIMARY,
                height: 1.0,
              ),
            ),
            SizedBox(height: 20.0),
            Image.asset(
              'assets/images/hero.png',
              width: 300.0,
              height: 300.0,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GREEN_PRIMARY,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
                ),
              ),
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
