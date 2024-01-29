import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/screens/manage_label_screen.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:todo_app/services/shared_preference_service.dart';
import 'package:todo_app/screens/add_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  String allTask = "", waitingTask = "";
  var _usernameController = TextEditingController();
  var _emailController = TextEditingController();

  late String _username = "", _email = "";

  void _showProfileDialog() {
    _emailController.text = _email;
    _usernameController.text = _username;
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
                            _changeUsername(_email, _usernameController.text);
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Username',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter your username",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'username cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(_email),
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

  void _changeUsername(String email, String newUsername) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final docref = db.collection('users');
    await docref.doc(email).update({'user_name': newUsername});

    SharedPreferencesService pref =
        await SharedPreferencesService.getInstance();
    pref.saveData('user_name', newUsername);
    setState(() {
      _username = newUsername;
    });
  }

  void _getUserData() async {
    final SharedPreferencesService pref =
        await SharedPreferencesService.getInstance();

    if (!context.mounted) return;

    if (pref.getData('is_login')) {
      setState(() {
        _username = pref.getData('username') ?? "";
        _email = pref.getData('email');
      });
      getCountTasksByUser();
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  void getCountTasksByUser() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final allTaskCount = db
        .collection('tasks')
        .where("sharedWith", arrayContains: _email)
        .count();
    final waitingTaskCount = db
        .collection('tasks')
        .where("task_status", isEqualTo: "done")
        .where("sharedWith", arrayContains: _email)
        .count();

    final AggregateQuerySnapshot snapshotAll = await allTaskCount.get();
    final AggregateQuerySnapshot snapshotWaiting = await waitingTaskCount.get();

    allTask = snapshotAll.count.toString();
    waitingTask = snapshotWaiting.count.toString();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "KanbanWa",
          style: TextStyle(
              color: GREEN_PRIMARY,
              fontSize: 20.0,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          Container(
            margin:
                EdgeInsets.only(top: 8.0, bottom: 4.0, left: 10.0, right: 10.0),
            child: const Image(
                image: AssetImage('assets/images/notification_icon.png')),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 12.0,
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Hi,",
                          style: TextStyle(
                              color: BLACK_CUSTOM,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          _username.isEmpty ? _email : _username,
                          style: TextStyle(
                              color: GREEN_PRIMARY,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Text(
                      "Enjoy your tasks!!",
                      style: TextStyle(
                          color: BLACK_CUSTOM,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: YELLOW_CUSTOM,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 213, 213, 213),
                    blurRadius: 5.0, // soften the shadow
                    offset: Offset(
                      0.0, // Move to right 10  horizontally
                      4.0, // Move to bottom 10 Vertically
                    ),
                  ),
                ],
              ),
              padding: EdgeInsets.only(
                  left: 20.0, right: 10.0, top: 12.0, bottom: 12.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Today, \n${DateTime.now().day} ${month[DateTime.now().month - 1]} ${DateTime.now().year}",
                          style: TextStyle(
                              color: BLACK_CUSTOM,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600),
                        ),
                        Flexible(
                          child: allTask == ""
                              ? Center(child: CircularProgressIndicator())
                              : Text(
                                  "${waitingTask}/${allTask} tasks",
                                  style: TextStyle(
                                      color: BLACK_CUSTOM,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600),
                                ),
                        ),
                      ],
                    ),
                    Image(
                      image: AssetImage('assets/images/home_banner_icon.png'),
                      // width: MediaQuery.of(context).size.width / 3,
                      // height: MediaQuery.of(context).size.width / 4,
                    ),
                  ]),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddScreen()))
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFFF7D34),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 213, 213, 213),
                              blurRadius: 5.0, // soften the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                4.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(
                                  image: AssetImage(
                                      'assets/images/add_to_do_button.png')),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "Add To do",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TodoScreen(
                                      tab: 0,
                                    )))
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFFF5151),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 213, 213, 213),
                              blurRadius: 5.0, // soften the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                4.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(
                                  image: AssetImage(
                                      'assets/images/to_do_button.png')),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "To do",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TodoScreen(
                                      tab: 1,
                                    )))
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFF1DC9FF),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 213, 213, 213),
                              blurRadius: 5.0, // soften the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                4.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(
                                  image: AssetImage(
                                      'assets/images/in_process_button.png')),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "In Process",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TodoScreen(
                                      tab: 2,
                                    )))
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFF58C952),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 213, 213, 213),
                              blurRadius: 5.0, // soften the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                4.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(
                                  image: AssetImage(
                                      'assets/images/done_button.png')),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "Done",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManageLabelScreen()))
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFA97AF6),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 213, 213, 213),
                              blurRadius: 5.0, // soften the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                4.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(
                                  image: AssetImage(
                                      'assets/images/manage_label_button.png')),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "Manage Label",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showProfileDialog(),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFFF8181),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 213, 213, 213),
                              blurRadius: 5.0, // soften the shadow
                              offset: Offset(
                                0.0, // Move to right 10  horizontally
                                4.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(
                                  image: AssetImage(
                                      'assets/images/profile_button.png')),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            )),
          ]),
        ),
      ),
    );
  }
}
