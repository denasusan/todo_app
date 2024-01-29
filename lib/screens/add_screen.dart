import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/label.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:todo_app/services/shared_preference_service.dart';

class AddScreen extends StatefulWidget {
  AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _labelChoosedController = "";
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
    final SharedPreferencesService pref =
        await SharedPreferencesService.getInstance();
    String email = "";
    final FirebaseFirestore db = FirebaseFirestore.instance;

    if (pref.getData('is_login')) {
      email = pref.getData('email');
      DocumentReference user_id = db.collection('users').doc(email);
      DocumentReference label_id =
          db.collection('labels').doc(_labelChoosedController);
      String task_id = DateTime.now().millisecondsSinceEpoch.toString();
      final taskData = Task(
          task_id: task_id,
          task_name: _nameController.text,
          task_description: _descriptionController.text,
          task_status: "new",
          user_id: user_id,
          label_id: label_id,
          sharedWith: [email],
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
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  void getLabelByUser() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final SharedPreferencesService pref =
        await SharedPreferencesService.getInstance();
    String email = "";

    if (pref.getData('is_login')) {
      email = pref.getData('email');
      DocumentReference user_id = db.collection('users').doc(email);

      final docRef =
          db.collection('labels').where("user_id", isEqualTo: user_id);
      docRef.get().then(
        (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            _labelChoosedController = docSnapshot.id;
            Label label = new Label(
                label_id: docSnapshot.id,
                label_name: docSnapshot.data()['label_name'],
                label_color: docSnapshot.data()['label_color']);
            labelList.add(label);
          }
          setState(() {});
        },
        onError: (e) => print("Error completing: $e"),
      );
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
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
                    _nameController.text = value;
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
                value: _labelChoosedController,
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
                                      color: e.label_color.toLowerCase() == "3498db"
                                          ? Color(0xFF3498db)
                                          : e.label_color.toLowerCase() == "2ecc71"
                                              ? Color(0xFF2ecc71)
                                              : e.label_color.toLowerCase() == "f1c40f"
                                                  ? Color(0xFFf1c40f)
                                                  : e.label_color.toLowerCase() == "e74c3c"
                                                      ? Color(0xFFe74c3c)
                                                      : Colors.blue,
                                    ),
                                  ),
                                  Text(e.label_name),
                                ],
                              )),
                        ))
                    .toList(),
                onChanged: (String? value) {
                  _labelChoosedController = value!;
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
                    _descriptionController.text = value;
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
