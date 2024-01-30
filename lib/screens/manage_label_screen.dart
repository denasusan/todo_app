import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/services/shared_preference_service.dart';
// import 'package:todo_app/widgets/label_card.dart';

class ManageLabelScreen extends StatefulWidget {
  const ManageLabelScreen({Key? key}) : super(key: key);

  @override
  State<ManageLabelScreen> createState() => _ManageLabelScreenState();
}

class _ManageLabelScreenState extends State<ManageLabelScreen> {
  bool _showFab = true;
  final _formKey = GlobalKey<FormState>();
  final _labelNameController = TextEditingController();
  int _selectedColor = -1;
  List<String> _colors = ["e74c3c", "f1c40f", "2ecc71", "3498db"];
  late String _userEmail = "";

  void _showLabelDialog(docId) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 20.0,
                          ),
                        ),
                        child: const Text('Save'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _addOrEditLabel(docId, _labelNameController.text,
                                _colors[_selectedColor]);

                            _labelNameController.text = "";
                            _selectedColor = -1;
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Label Name',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _labelNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter label here",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Label cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Text(
                      'Label Color',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _selectedColor = 0),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xffe74c3c),
                                border: Border.all(
                                  color: _selectedColor == 0
                                      ? Colors.black54
                                      : Colors.transparent,
                                  width: 3.0,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _selectedColor = 1),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xfff1c40f),
                                border: Border.all(
                                  color: _selectedColor == 1
                                      ? Colors.black54
                                      : Colors.transparent,
                                  width: 3.0,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _selectedColor = 2),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xff2ecc71),
                                border: Border.all(
                                  color: _selectedColor == 2
                                      ? Colors.black54
                                      : Colors.transparent,
                                  width: 3.0,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _selectedColor = 3),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xff3498db),
                                border: Border.all(
                                  color: _selectedColor == 3
                                      ? Colors.black54
                                      : Colors.transparent,
                                  width: 3.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _getUserEmail() async {
    SharedPreferencesService pref =
        await SharedPreferencesService.getInstance();

    setState(() {
      _userEmail = pref.getData('email');
    });
  }

  void _addOrEditLabel(
      String docId, String labelName, String labelColor) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    SharedPreferencesService pref =
        await SharedPreferencesService.getInstance();
    var userEmail = pref.getData('email');
    final user_id = db.collection('users').doc(userEmail);
    final docref = db.collection('labels');

    if (docId.isEmpty) {
      await docref.doc().set({
        "label_name": labelName,
        "label_color": labelColor,
        "user_id": user_id,
      });
    } else {
      await docref.doc(docId).update({
        "label_name": labelName,
        "label_color": labelColor,
      });
    }
  }

  void _deleteLabel(String docId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    final docref = db.collection('labels');
    await docref.doc(docId).delete();
  }

  @override
  void initState() {
    super.initState();

    _getUserEmail();
  }

  @override
  void dispose() {
    super.dispose();
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
          'Labels',
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('labels')
            .where('user_id',
                isEqualTo: FirebaseFirestore.instance
                    .collection('users')
                    .doc(_userEmail))
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error saat ambil data');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs
                .map(
                  (DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Container(
                      padding: EdgeInsets.only(
                        left: 5.0,
                      ),
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 5.0, bottom: 5.0),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    data['label_name'],
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
                                  items: <String>['Edit', 'Delete'].map(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (String? value) {
                                    if (value == 'Edit') {
                                      _showLabelDialog(document.id);
                                      _labelNameController.text =
                                          data['label_name'];
                                      _selectedColor =
                                          _colors.indexOf(data['label_color']);
                                    }

                                    if (value == 'Delete') {
                                      _deleteLabel(document.id);
                                    }
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                )
                .toList()
                .cast(),
          );
        },
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _showFab ? Offset.zero : const Offset(0, 2),
        child: FloatingActionButton(
          onPressed: () => _showLabelDialog(""),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade400,
          child: Image(
            image: AssetImage('assets/images/add_label_floating_button.png'),
            width: 24.0,
            height: 24.0,
          ),
        ),
      ),
    );
  }
}
