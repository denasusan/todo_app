import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/widgets/label_card.dart';

class ManageLabelScreen extends StatefulWidget {
  const ManageLabelScreen({Key? key}) : super(key: key);

  @override
  State<ManageLabelScreen> createState() => _ManageLabelScreenState();
}

class _ManageLabelScreenState extends State<ManageLabelScreen> {
  bool _showFab = true;
  final _formKey = GlobalKey<FormState>();
  final _labelNameController = TextEditingController();
  int _selectedColor = 0;

  void showLabelDialog() {
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
                            _formKey.currentState!.save();
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
                            onTap: () => setState(() => _selectedColor = 1),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
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
                                color: Colors.yellow,
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
                                color: Colors.green,
                                border: Border.all(
                                  color: _selectedColor == 3
                                      ? Colors.black54
                                      : Colors.transparent,
                                  width: 3.0,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _selectedColor = 4),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                                border: Border.all(
                                  color: _selectedColor == 4
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green.shade400,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {},
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          )
        ],
        elevation: 0,
        title: const Text(
          'Label List',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              final ScrollDirection direction = notification.direction;
              setState(() {
                if (direction == ScrollDirection.reverse) {
                  _showFab = false;
                } else if (direction == ScrollDirection.forward) {
                  _showFab = true;
                }
              });
              return true;
            },
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 10.0,
                  ),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            splashRadius: 1,
                            icon: const Icon(Icons.delete),
                          ),
                          Text("labelName"),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        splashRadius: 1,
                        icon: const Icon(Icons.edit),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _showFab ? Offset.zero : const Offset(0, 2),
        child: FloatingActionButton(
          onPressed: showLabelDialog,
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade400,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
