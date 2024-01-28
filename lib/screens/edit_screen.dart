import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:todo_app/model/task.dart';

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
  late String _assignedTo;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _labelController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _assignToController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startDate = widget.task.start_date;
    _endDate = widget.task.due_date;
    _status = widget.task.task_status;
    _isAssigned = widget.task.is_visible;
    _assignedTo =
        widget.task.sharedWith.isNotEmpty ? widget.task.sharedWith[0] : '';

    _nameController.text = widget.task.task_name;
    _labelController.text = widget.task.label_id.id;
    _descriptionController.text = widget.task.task_description;
    _assignToController.text = _assignedTo;
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
            TextField(
              controller: _labelController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
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
            ),
            SizedBox(height: 8),
            Column(
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
            SizedBox(height: 4),
            Text('Assign To'),
            TypeAheadField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Search user',
                ),
                controller: _assignToController,
              ),
              suggestionsCallback: (pattern) async {
                final FirebaseFirestore db = FirebaseFirestore.instance;
                final QuerySnapshot<Map<String, dynamic>> usersSnapshot =
                    await db.collection('users').get();

                List<String> userSuggestions = usersSnapshot.docs
                    .map<String?>((doc) => doc['user_email'] as String?)
                    .where((userEmail) =>
                        userEmail != null &&
                        userEmail.toLowerCase().contains(pattern.toLowerCase()))
                    .cast<String>()
                    .toList();

                return userSuggestions;
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) {
                print('Selected suggestion: $suggestion');
                setState(() {
                  _assignedTo = suggestion!;
                  _assignToController.text = suggestion;
                });
              },
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status'),
                FutureBuilder<List<String>>(
                  future: getStatusValuesFromDatabase(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        value: _status,
                        items: snapshot.data?.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              );
                            }).toList() ??
                            [],
                        onChanged: (value) {
                          setState(() {
                            _status = value!;
                          });
                        },
                      );
                    }
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
      Task updatedTask = Task(
        task_id: widget.task.task_id,
        task_name: _nameController.text,
        start_date: _startDate,
        due_date: _endDate,
        task_description: _descriptionController.text,
        task_status: _status,
        user_id: widget.task.user_id,
        label_id: widget.task.label_id,
        is_visible: _isAssigned,
        sharedWith: _assignToController.text.isNotEmpty
            ? [_assignToController.text]
            : [],
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
