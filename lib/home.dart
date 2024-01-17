import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Hi,"),
                    Text("Kamu"),
                  ],
                ),
                Text("Enjoy yous tasks!!"),
              ],
            ),
            Text("Notif"),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today, \n 12 November 2023"),
                Text("2/10 tasks"),
              ],
            ),
            Text("Image")
          ]),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [Text("Image"), Text("Add To do")],
                ),
                Column(
                  children: [Text("Image"), Text("Add To do")],
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [Text("Image"), Text("Add To do")],
                ),
                Column(
                  children: [Text("Image"), Text("Add To do")],
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [Text("Image"), Text("Add To do")],
                ),
                Column(
                  children: [Text("Image"), Text("Add To do")],
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        )),
      ]),
    );
  }
}
