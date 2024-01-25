import 'package:flutter/material.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/screens/edit_screen.dart';

class InProcessScreen extends StatefulWidget {
  InProcessScreen({Key? key}) : super(key: key);

  @override
  State<InProcessScreen> createState() => _InProcessScreenState();
}

class _InProcessScreenState extends State<InProcessScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9]
              .map(
                (e) => Container(
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10.0, bottom: 0.0),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFFF8F9FA),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 213, 213, 213),
                        blurRadius: 5.0, // soften the shadow
                        offset: Offset(
                          0.0, // Move to right 10  horizontally
                          6.0, // Move to bottom 10 Vertically
                        ),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Card(
                            margin: EdgeInsets.only(left: 0.0),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 5.0, bottom: 5.0, left: 8.0, right: 8.0),
                              child: Text(
                                'Pemograman Mobile',
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                            color: Colors.redAccent,
                            elevation: 2.0,
                          ),
                          Card(
                            margin: EdgeInsets.only(left: 6.0),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 5.0, bottom: 5.0, left: 8.0, right: 8.0),
                              child: Text(
                                'Kuliah',
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                            color: Color(0xFF58C952),
                            elevation: 2.0,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Membuat aplikasi mobile menggunakan flutter Membuat aplikasi mobile menggunakan flutter',
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image(
                                image: AssetImage(
                                  'assets/images/clock_icon.png',
                                ),
                                width: 16.0,
                                height: 16.0,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                '1 Februari 2024',
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              )
                            ],
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: Colors.white,
                              style: TextStyle(color: Color(0xFF001A72)),
                              icon: Image(
                                image:
                                    AssetImage('assets/images/menu_icon.png'),
                                width: 24.0,
                                height: 24.0,
                              ),
                              items: <String>['Edit', 'Delete']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value == 'Edit') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditScreen()),
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      )
    ;
  }
}
