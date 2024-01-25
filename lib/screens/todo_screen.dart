import 'package:flutter/material.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/screens/edit_screen.dart';

class TodoScreen extends StatefulWidget {
  TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  int _selectedTab = 0;

  List _pages = [
    Center(
      child: Text("Home"),
    ),
    Center(
      child: Text("About"),
    ),
    Center(
      child: Text("Products"),
    ),
    Center(
      child: Text("Contact"),
    ),
    Center(
      child: Text("Settings"),
    ),
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          width: 32.0,
          height: 32.0,
          margin: EdgeInsets.all(5.0),
          child: Image(
            image: AssetImage('assets/images/home_header_icon.png'),
          ),
        ),
        title: Text(
          'To-Do List',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: GREEN_PRIMARY),
        ),
        actions: [
          Container(
            width: 32.0,
            height: 32.0,
            margin: EdgeInsets.all(5.0),
            child: Image(
              image: AssetImage('assets/images/search_icon.png'),
              width: 32.0,
              height: 32.0,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
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
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedTab,
            backgroundColor: GREEN_PRIMARY,
            onTap: (index) => _changeTab(index),
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: _selectedTab == 0
                    ? Card(
                        margin: EdgeInsets.all(0.0),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(children: [
                            Image(
                              image:
                                  AssetImage('assets/images/to_do_green.png'),
                            ),
                          ]),
                        ),
                      )
                    : Column(children: [
                        Image(
                          image: AssetImage('assets/images/to_do_white.png'),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "To do",
                          style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        )
                      ]),
                label: "To do",
              ),
              BottomNavigationBarItem(
                icon: _selectedTab == 1
                    ? Card(
                        margin: EdgeInsets.all(0.0),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(children: [
                            Image(
                              image: AssetImage(
                                  'assets/images/on_progress_green.png'),
                            ),
                          ]),
                        ),
                      )
                    : Column(children: [
                        Image(
                          image:
                              AssetImage('assets/images/on_progress_white.png'),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "On Progress",
                          style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        )
                      ]),
                label: "On Progress",
              ),
              BottomNavigationBarItem(
                icon: _selectedTab == 2
                    ? Card(
                        margin: EdgeInsets.all(0.0),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(children: [
                            Image(
                              image: AssetImage('assets/images/done_green.png'),
                            ),
                          ]),
                        ),
                      )
                    : Column(children: [
                        Image(
                          image: AssetImage('assets/images/done_white.png'),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "Done",
                          style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        )
                      ]),
                label: "Done",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
