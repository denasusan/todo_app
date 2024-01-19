import 'package:flutter/material.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/screens/manage_label_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ManageLabelScreen(),
      theme: ThemeData(fontFamily: 'Poppins'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kanbanwa'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Kanbanwa',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            // Image.asset(
            //   'assets/img/hero.png',
            //   width: 200.0,
            //   height: 200.0,
            // ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
