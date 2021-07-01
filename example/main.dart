import 'package:flutter/material.dart';
import 'package:flutter_advanced_seekbar/flutter_advanced_seekbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String state1 = "";
  int progress1 = 0;

  String state2 = "";
  int progress2 = 30;

  String state3 = "";
  int progress3 = 0;

  String state4 = "";
  int progress4 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Advanced Seek Bar"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            child: Center(
              child: Text("demo1: state: $state1: $progress1"),
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: AdvancedSeekBar(
              Color(0xffeeeff3),
              10,
              Colors.blue,
              fillProgress: true,
              seekBarStarted: () {
                setState(() {
                  state1 = "starting";
                });
              },
              seekBarProgress: (v) {
                setState(() {
                  state1 = " seeking";
                  progress1 = v;
                });
              },
              seekBarFinished: (v) {
                setState(() {
                  state1 = " finished";
                  progress1 = v;
                });
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            child: Center(
              child: Text("demo2: state: $state2: $progress2"),
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: AdvancedSeekBar(
              Color(0xffeeeff3),
              10,
              Colors.blue,
              scaleWhileDrag: false,
              defaultProgress: 30,
              seekBarStarted: () {
                setState(() {
                  state2 = "starting";
                });
              },
              seekBarProgress: (v) {
                setState(() {
                  state2 = " seeking";
                  progress2 = v;
                });
              },
              seekBarFinished: (v) {
                setState(() {
                  state2 = " finished";
                  progress2 = v;
                });
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            child: Center(
              child: Text("demo3: state: $state3: $progress3"),
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: AdvancedSeekBar(
              Color(0xffeeeff3),
              10,
              Colors.blue,
              lineHeight: 5,
              defaultProgress: 50,
              scaleWhileDrag: true,
              percentSplit: 10,
              percentSplitColor: Colors.green,
              percentSplitWidth: 1,
              fillProgress: true,
              autoJump2Split: false,
              seekBarStarted: () {
                setState(() {
                  state3 = "starting";
                });
              },
              seekBarProgress: (v) {
                setState(() {
                  state3 = " seeking";
                  progress3 = v;
                });
              },
              seekBarFinished: (v) {
                setState(() {
                  state3 = " finished";
                  progress3 = v;
                });
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            child: Center(
              child: Text("demo4: state: $state4: $progress4"),
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: AdvancedSeekBar(
              Color(0xffeeeff3),
              10,
              Colors.blue,
              lineHeight: 5,
              defaultProgress: 50,
              scaleWhileDrag: true,
              percentSplit: 10,
              percentSplitColor: Colors.green,
              percentSplitWidth: 1,
              seekBarStarted: () {
                setState(() {
                  state4 = "starting";
                });
              },
              seekBarProgress: (v) {
                setState(() {
                  state4 = " seeking";
                  progress4 = v;
                });
              },
              seekBarFinished: (v) {
                setState(() {
                  state4 = " finished";
                  progress4 = v;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
