import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/label.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/screens/todo_screen.dart';

class AddScreen extends StatefulWidget {
  AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _name = "", _description = "";
  String labelChoosed = "";
  List<Label> labelList = [];

  initState() {
    getLabelByUser();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _startDate)
      setState(() {
        _startDate = picked;
      });
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _endDate)
      setState(() {
        _endDate = picked;
      });
  }

  void addTaskByModel() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference user_id =
        db.collection('users').doc('rkHhSJzDvgmKJ6whbCax');
    DocumentReference label_id = db.collection('labels').doc(labelChoosed);
    String task_id = DateTime.now().millisecondsSinceEpoch.toString();
    final taskData = Task(
        task_id: task_id,
        task_name: _name,
        task_description: _description,
        task_status: "new",
        user_id: user_id,
        label_id: label_id,
        is_visible: true,
        start_date: _startDate,
        due_date: _endDate);
    final docRef = db.collection('tasks').withConverter(
        fromFirestore: Task.fromFirestore,
        toFirestore: (Task task, options) => task.toFirestore());
    await docRef.doc(task_id).set(taskData).then((value) => {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TodoScreen(
                tab: 0,
              ),
            ),
          )
        });
  }

  void getLabelByUser() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // final userData = User(user_email: "fikri@gmail.com", user_name: "Fikri New");
    final docRef = db.collection('labels');
    docRef.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          labelChoosed = docSnapshot.id;
          Label label = new Label(
              label_id: docSnapshot.id,
              label_name: docSnapshot.data()['label_name'],
              label_color: docSnapshot.data()['label_color']);
          labelList.add(label);
          print(label.label_name);
        }
        setState(() {});
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add To Do',
          style: TextStyle(color: Color(0xFF4EA949)),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 32.0,
            height: 32.0,
            margin: EdgeInsets.all(5.0),
            child: Image(
              image: AssetImage('assets/images/back.png'),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Name'),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => {
                setState(
                  () {
                    _name = value;
                  },
                )
              },
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectStartDate(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Start Date'),
                        SizedBox(height: 8),
                        Text('${_startDate.toLocal()}'.split(' ')[0]),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectEndDate(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('End Date'),
                        SizedBox(height: 8),
                        Text('${_endDate.toLocal()}'.split(' ')[0]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Label'),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: labelChoosed,
                dropdownColor: Colors.white,
                style: TextStyle(color: Color(0xFF001A72)),
                icon: Icon(Icons.arrow_drop_down_circle_sharp),
                items: labelList
                    .map((e) => DropdownMenuItem<String>(
                          value: e.label_id,
                          child: Container(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 5.0),
                                    width: 24.0,
                                    height: 24.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: e.label_color == "4EA949"
                                          ? Color(0xFF4EA949)
                                          : Colors.blue,
                                    ),
                                  ),
                                  Text(e.label_name),
                                ],
                              )),
                        ))
                    .toList(),
                onChanged: (String? value) {
                  labelChoosed = value!;
                  setState(() {});
                },
              ),
            ),
            SizedBox(height: 16),
            Text('Description'),
            SizedBox(height: 8),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => {
                setState(
                  () {
                    _description = value;
                  },
                )
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                addTaskByModel();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4EA949),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
                ),
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
