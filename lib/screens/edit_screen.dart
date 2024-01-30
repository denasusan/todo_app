import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/user.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/services/shared_preference_service.dart';
import 'package:todo_app/model/label.dart';
import 'package:todo_app/screens/login_screen.dart';

class EditScreen extends StatefulWidget {
  final Task task;

  EditScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late DateTime _startDate;
  late DateTime _endDate;
  late String _status;
  late bool _isAssigned;
  List<User> _assignes = [];
  final TextEditingController _assignToController = TextEditingController();
  String _assignedTo = '';
  List<String> _suggestions = [];
  List<dynamic> _assignToList = [];
  String _labelChoosedController = "";
  List<Label> labelList = [];
  bool isTextFieldEnabled = false;
  List<String> _statuses = ["new", "in progress", "done"];

  TextEditingController _nameController = TextEditingController();
  TextEditingController _labelController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startDate = widget.task.start_date;
    _endDate = widget.task.due_date;
    _status = widget.task.task_status;
    _isAssigned = widget.task.is_visible;
    _assignedTo = '';
    _assignToList = widget.task.sharedWith.toList();
    _nameController.text = widget.task.task_name;
    _labelController.text = widget.task.label_id.id;
    _descriptionController.text = widget.task.task_description;
    _assignToController.text = _assignedTo;
    getLabelByUser();
    enableFieldBasedOnUser();
  }

  void getLabelByUser() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final SharedPreferencesService pref =
        await SharedPreferencesService.getInstance();
    String email = "";

    if (pref.getData('is_login')) {
      email = pref.getData('email');
      DocumentReference user_id = db.collection('users').doc(email);

      String taskLabelId = widget.task.label_id.id;

      _labelChoosedController = taskLabelId;

      print(user_id);

      if (user_id == widget.task.user_id) {
        final docRef =
            db.collection('labels').where("user_id", isEqualTo: user_id);

        docRef.get().then(
          (querySnapshot) {
            print(querySnapshot.docs.length);
            if (querySnapshot.docs.isNotEmpty) {
              for (var docSnapshot in querySnapshot.docs) {
                // _labelChoosedController = docSnapshot.id;
                Label label = new Label(
                    label_id: docSnapshot.id,
                    label_name: docSnapshot.data()['label_name'],
                    label_color: docSnapshot.data()['label_color']);
                labelList.add(label);
              }
            } else {
              print("kesini");
              Label label = new Label(
                  label_id: "1", label_name: "", label_color: "02342e");
              labelList.add(label);
            }
            setState(() {});
          },
          onError: (e) => print("Error completing: $e"),
        );
      } else {
        final docRef = db.collection('labels').doc(taskLabelId);
        docRef.get().then(
          (querySnapshot) {
            if (querySnapshot.exists) {
              // _labelChoosedController = docSnapshot.id;
              Label label = new Label(
                  label_id: querySnapshot.id,
                  label_name: querySnapshot.data()!['label_name'],
                  label_color: querySnapshot.data()!['label_color']);
              labelList.add(label);
            } else {
              print("kesini 2");
              Label label = new Label(
                  label_id: "1", label_name: "", label_color: "02342e");
              labelList.add(label);
            }
            setState(() {});
          },
          onError: (e) => print("Error completing: $e"),
        );
      }
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  void updateSuggestions(String text) {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    db
        .collection('users')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      List<String> userSuggestions = snapshot.docs
          .map<String?>((doc) => doc['user_email'] as String?)
          .where((userEmail) =>
              userEmail != null &&
              userEmail.toLowerCase().contains(text.toLowerCase()))
          .cast<String>()
          .toList();

      setState(() {
        _suggestions = userSuggestions;
      });
    });
  }

  Future<void> enableFieldBasedOnUser() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final SharedPreferencesService pref =
        await SharedPreferencesService.getInstance();
    String email = "";

    if (pref.getData('is_login')) {
      email = pref.getData('email');
      DocumentReference userRef = db.collection('users').doc(email);

      final taskDocs = await db
          .collection('tasks')
          .where('user_id', isEqualTo: userRef)
          .get();

      if (taskDocs.docs.isNotEmpty) {
        setState(() {
          isTextFieldEnabled = true;
        });
      } else {
        setState(() {
          isTextFieldEnabled = false;
        });
      }
    } else {}
  }

  Future<List<String>> getStatusValuesFromDatabase() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('tasks').get();

    List<String> statusValues = snapshot.docs
        .map<String?>((doc) => doc['task_status'] as String?)
        .where((taskStatus) => taskStatus != null)
        .cast<String>()
        .toSet()
        .toList();

    return statusValues;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit To Do',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Name'),
            SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              enabled: isTextFieldEnabled,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: isTextFieldEnabled
                        ? () => _selectStartDate(context)
                        : null,
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
                    onTap: isTextFieldEnabled
                        ? () => _selectEndDate(context)
                        : null,
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
                                      color: e.label_color.toLowerCase() ==
                                              "3498db"
                                          ? Color(0xFF3498db)
                                          : e.label_color.toLowerCase() ==
                                                  "2ecc71"
                                              ? Color(0xFF2ecc71)
                                              : e.label_color.toLowerCase() ==
                                                      "f1c40f"
                                                  ? Color(0xFFf1c40f)
                                                  : e.label_color
                                                              .toLowerCase() ==
                                                          "e74c3c"
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
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              enabled: isTextFieldEnabled,
            ),
            SizedBox(height: 8),
            Visibility(
              visible: isTextFieldEnabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Is Assign'),
                  Row(
                    children: [
                      Radio(
                        value: true,
                        groupValue: _isAssigned,
                        onChanged: (value) {
                          setState(() {
                            _isAssigned = value as bool;
                          });
                        },
                      ),
                      Text('True'),
                      SizedBox(width: 16),
                      Radio(
                        value: false,
                        groupValue: _isAssigned,
                        onChanged: (value) {
                          setState(() {
                            _isAssigned = value as bool;
                          });
                        },
                      ),
                      Text('False'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Visibility(
              visible: isTextFieldEnabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Assign To'),
                  TextField(
                    controller: _assignToController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Search user',
                    ),
                    onChanged: (text) {
                      updateSuggestions(text);
                    },
                  ),
                ],
              ),
            ),
            _assignToList.length > 0
                ? Text('Assigned To')
                : SizedBox(
                    height: 2.0,
                  ),
            Wrap(
              children: _assignToList.length > 0
                  ? _assignToList
                      .map(
                        (e) => Container(
                            margin: EdgeInsets.only(right: 10.0, top: 5.0),
                            child: ElevatedButton(
                                onPressed: () => {}, child: Text('${e}'))),
                      )
                      .toList()
                  : [],
            ),
            Column(
              children: _suggestions
                  .map((suggestion) => ListTile(
                        title: Text(suggestion),
                        onTap: () {
                          setState(() {
                            _assignedTo = suggestion;
                            _assignToController.text = "";
                            _assignToList.add(suggestion);
                            _suggestions = [];
                          });
                        },
                      ))
                  .toList(),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status'),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  value: _status,
                  items: _statuses
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                saveChanges();
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

  void saveChanges() async {
    try {
      String selectedLabelId = _labelChoosedController;

      Task updatedTask = Task(
        task_id: widget.task.task_id,
        task_name: _nameController.text,
        start_date: _startDate,
        due_date: _endDate,
        task_description: _descriptionController.text,
        task_status: _status,
        user_id: widget.task.user_id,
        label_id: FirebaseFirestore.instance.doc('labels/$selectedLabelId'),
        is_visible: _isAssigned,
        sharedWith: _assignToList.length > 0 ? _assignToList : [],
      );

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.task.task_id)
          .update(updatedTask.toFirestore());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TodoScreen(tab: 0),
        ),
      );
    } catch (e) {
      print('Error updating task: $e');
    }
  }
}
