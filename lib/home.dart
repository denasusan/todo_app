import 'package:flutter/material.dart';
import 'package:todo_app/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "KanbanWa",
          style: TextStyle(
              color: GREEN_PRIMARY,
              fontSize: 20.0,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(top: 8.0, bottom: 4.0, left: 10.0, right: 10.0),
            child: 
                const Image(
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
                          "Kamu",
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
                          "Today, \n12 November 2023",
                          style: TextStyle(
                              color: BLACK_CUSTOM,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600),
                        ),
                        Flexible(
                          child: Text(
                            "2/10 tasks",
                            style: TextStyle(
                                color: BLACK_CUSTOM,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    Image(
                      image: AssetImage('assets/images/home_icon.png'),
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
                      onTap: () => {},
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
                      onTap: () => {},
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
                      onTap: () => {},
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
                      onTap: () => {},
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
                      onTap: () => {},
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
                      onTap: () => {},
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
