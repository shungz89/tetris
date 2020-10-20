import 'dart:async';

import 'package:flutter/material.dart';

import 'model/playfield.dart';
import 'model/tetromino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PlayField _playField;
  Timer _timer;

  void _setup() {
    var I = Tetromino([1, 1, 1, 1], width: 4);
    var O = Tetromino([1, 1, 1, 1], width: 2);
    var T = Tetromino([0, 1, 0, 1, 1, 1], width: 3);
    var S = Tetromino([0, 1, 1, 1, 1, 0], width: 3);
    var Z = Tetromino([1, 1, 0, 0, 1, 1], width: 3);
    var J = Tetromino([1, 0, 0, 1, 1, 1], width: 3);
    var L = Tetromino([0, 0, 1, 1, 1, 1], width: 3);

    var tetrominos = [I, O, T, S, Z, J, L];
    _playField = PlayField(10, 16, tetrominos: tetrominos);
  }

  @override
  void initState() {
    super.initState();
    _setup();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 500), (_) {
      setState(() {
        if (!_playField.proceed()) {
          _timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tetris"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _playField.reset();
                startTimer();
              });
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0,
                    crossAxisCount: _playField.width,
                  ),
                  itemCount: _playField.array.length,
                  itemBuilder: (context, index) {
                    var value = _playField.array[index];
                    if (value == 0) {
                      return Container(color: Colors.red);
                    } else {
                      return Container(color: Colors.blue);
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.rotate_left),
                    onPressed: () {
                      setState(() {
                        _playField.rotateLeft();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () {
                      setState(() {
                        _playField.moveLeft();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () {
                      setState(() {
                        _playField.moveRight();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.rotate_right),
                    onPressed: () {
                      setState(() {
                        _playField.rotateRight();
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
