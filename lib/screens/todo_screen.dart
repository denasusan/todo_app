import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/components/done_screen.dart';
import 'package:todo_app/components/in_process_screen.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/model/label.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/screens/add_screen.dart';
import 'package:todo_app/screens/edit_screen.dart';

class TodoScreen extends StatefulWidget {
  final int tab;
  TodoScreen({Key? key, required this.tab}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  int _selectedTab = 0;
  List<Task> taskList = [];
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

  initState() {
    getTasksByUser();

    _selectedTab = widget.tab;
    super.initState();
  }

  void getTasksByUser() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // final userData = User(user_email: "fikri@gmail.com", user_name: "Fikri New");
    final docRef =
        db.collection('tasks').where("task_status", isEqualTo: "new");
    docRef.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Task task = new Task(
              task_id: docSnapshot?.id as String,
              task_name: docSnapshot?.data()['task_name'] as String,
              task_description:
                  docSnapshot?.data()['task_description'] as String,
              task_status: docSnapshot?.data()['task_status'] as String,
              user_id: docSnapshot?.data()['user_id'] as DocumentReference,
              label_id: docSnapshot?.data()['label_id'] as DocumentReference,
              is_visible: docSnapshot?.data()['is_visible'] as bool,
              start_date: docSnapshot?.data()['start_date'].toDate(),
              due_date: docSnapshot?.data()['due_date'].toDate());
          taskList.add(task);
        }
        setState(() {});
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  Future<Label> getLabelByReference(String docInput) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final docRef = db.collection('labels').doc(docInput);
    Label dataLabel = await docRef.get().then(
      (querySnapshot) {
        Label label = new Label(label_id: "", label_name: "", label_color: "");
        if (querySnapshot.exists) {
          return Label(
              label_id: docInput,
              label_name: querySnapshot.data()!['label_name'],
              label_color: querySnapshot.data()!['label_color']);
        }
        return label;
      },
      onError: (e) => print("Error completing: $e"),
    );
    return dataLabel;
  }

  void deleteTask(String doc) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final CollectionReference users = db.collection("tasks");
    await users.doc(doc).delete();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => TodoScreen(
                tab: 0,
              )),
    );
  }

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
          child: GestureDetector(
            onTap: () {
              Route route =
                  MaterialPageRoute(builder: (context) => HomeScreen());
              Navigator.pushReplacement(context, route);
            },
            child: Image(
              image: AssetImage('assets/images/home_header_icon.png'),
            ),
          ),
        ),
        title: Text(
          _selectedTab == 0
              ? 'To Do List'
              : _selectedTab == 1
                  ? "In Process List"
                  : "Done List",
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
      body: _selectedTab == 1
          ? InProcessScreen()
          : _selectedTab == 1
              ? DoneScreen()
              : SingleChildScrollView(
                  child: Column(
                    children: taskList.map((e) {
                      DocumentReference labels = e.label_id;
                      final label_id = labels.path.split("/")[1];

                      return Container(
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
                                FutureBuilder<Label>(
                                    future: getLabelByReference(label_id),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Container(
                                          child: Card(
                                            margin: EdgeInsets.only(left: 0.0),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 5.0,
                                                  bottom: 5.0,
                                                  left: 8.0,
                                                  right: 8.0),
                                              child: Text(
                                                snapshot.data!.label_name
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            color: Color(0xFF58C952),
                                            elevation: 2.0,
                                          ),
                                        );
                                      } else {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                      ;
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              e.task_name,
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
                                      e.due_date.toString(),
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
                                      image: AssetImage(
                                          'assets/images/menu_icon.png'),
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
                                              builder: (context) =>
                                                  EditScreen()),
                                        );
                                      } else if (value == 'Delete') {
                                        deleteTask(e.task_id);
                                      }
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
      floatingActionButton: _selectedTab == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddScreen()));
              },
              foregroundColor: Colors.white,
              backgroundColor: YELLOW_CUSTOM,
              shape: RoundedRectangleBorder(
                // <= Change BeveledRectangleBorder to RoundedRectangularBorder
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: Image(
                image:
                    AssetImage('assets/images/add_to_do_floating_button.png'),
                width: 24.0,
                height: 24.0,
              ),
            )
          : null,
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
