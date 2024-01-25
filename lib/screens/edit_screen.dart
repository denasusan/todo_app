import 'package:flutter/material.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class EditScreen extends StatefulWidget {
  EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EdiScreenState();
}

class _EdiScreenState extends State<EditScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _status = 'New';
  bool _isAssigned = true;
  String _assignedTo = '';

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
        leading: Container(
          width: 32.0,
          height: 32.0,
          margin: EdgeInsets.all(5.0),
          child: Image(
            image: AssetImage('assets/images/back.png'),
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
              decoration: InputDecoration(
                border: OutlineInputBorder(),
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
              ),
              suggestionsCallback: (pattern) async {
                return [
                  'User 1',
                  'User 2',
                  'User 3',
                ];
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) {
                setState(() {
                  _assignedTo = suggestion!;
                });
              },
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
                  items: [
                    DropdownMenuItem(value: 'New', child: Text('New')),
                    DropdownMenuItem(
                        value: 'In Process', child: Text('In Process')),
                    DropdownMenuItem(value: 'Done', child: Text('Done')),
                  ],
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodoScreen(tab: 0,),
                  ),
                );
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
