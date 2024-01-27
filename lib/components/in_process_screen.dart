import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/model/label.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/screens/edit_screen.dart';
import 'package:todo_app/screens/todo_screen.dart';

class InProcessScreen extends StatefulWidget {
  InProcessScreen({Key? key}) : super(key: key);

  @override
  State<InProcessScreen> createState() => _InProcessScreenState();
}

class _InProcessScreenState extends State<InProcessScreen> {
  List<Task> taskList = [];

  initState() {
    getTasksByUser();
  }

  void getTasksByUser() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // final userData = User(user_email: "fikri@gmail.com", user_name: "Fikri New");
    final docRef =
        db.collection('tasks').where("task_status", isEqualTo: "in progress");
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


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                                    snapshot.data!.label_name.toString(),
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
                            return Center(child: CircularProgressIndicator());
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
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
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
                          "${e.due_date.day}, ${month[e.due_date.month-1]} ${e.due_date.year}",
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
                          image: AssetImage('assets/images/menu_icon.png'),
                          width: 24.0,
                          height: 24.0,
                        ),
                        items: <String>['Edit'].map((String value) {
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
          );
        }).toList(),
      ),
    );
  }
}
