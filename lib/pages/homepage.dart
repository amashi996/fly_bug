import 'dart:async';
import 'package:flutter/material.dart';

//import pages
import 'package:fly_bug/pages/bug.dart';
import 'package:fly_bug/pages/wall.dart';
import 'package:fly_bug/pages/coverscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variables related to bug
  static double bugY = 0;
  double initialPos = bugY;
  double height = 0;
  double time = 0;
  double gravity = -4.9; //how strong the gravity is
  double velocity = 3.5; //how strong the jump is
  double bugWidth = 0.1;
  double bugHeight = 0.1;

  //calculate score
  int currentScore = 0;

  //game settings
  bool gameHasStarted = false;

  //variables related to wall
  static List<double> wallX = [2, 2 + 1.5];
  static double wallWidth = 0.5; // out of 2
  List<List<double>> wallHeight = [
    // out of 2, where 2 is the entire height of the screen
    // [topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      // a real physical jump is the same as an upside down parabola
      // so this is a simple quadratic equation
      height = gravity * time * time + velocity * time;

      setState(() {
        bugY = initialPos - height;
        currentScore = currentScore + 10;
      });

      // check if bird is dead
      if (bugIsDead()) {
        timer.cancel();
        setState(() {
          currentScore = 0;
        });
        _showDialog();
      }

      // keep the map moving (move walls)
      moveMap();

      // keep the time going!
      time += 0.01;
    });
  }

  void moveMap() {
    for (int i = 0; i < wallX.length; i++) {
      // keep barriers moving
      setState(() {
        wallX[i] -= 0.005;
      });

      // if barrier exits the left part of the screen, keep it looping
      if (wallX[i] < -1.5) {
        wallX[i] += 3;
      }
    }
  }

  void resetGame() {
    Navigator.pop(context); // dismisses the alert dialog
    setState(() {
      bugY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = bugY;
      wallX = [2, 2 + 1.5];
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: Center(
              child: Text(
                "G A M E  O V E R",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = bugY;
    });
  }

  bool bugIsDead() {
    // check if the bird is hitting the top or the bottom of the screen
    if (bugY < -1 || bugY > 1) {
      return true;
    }

    // hits walls
    // checks if bird is within x coordinates and y coordinates of barriers
    for (int i = 0; i < wallX.length; i++) {
      if (wallX[i] <= bugWidth &&
          wallX[i] + wallWidth >= -bugWidth &&
          (bugY <= -1 + wallHeight[i][0] ||
              bugY + bugHeight >= 1 - wallHeight[i][1])) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      // bug
                      Bug(
                        bugY: bugY,
                        bugWidth: bugWidth,
                        bugHeight: bugHeight,
                      ),

                      // tap to play
                      CoverScreen(gameHasStarted: gameHasStarted),

                      // Top wall 0
                      Wall(
                        wallX: wallX[0],
                        wallWidth: wallWidth,
                        wallHeight: wallHeight[0][0],
                        isThisBottomWall: false,
                      ),

                      // Bottom wall 0
                      Wall(
                        wallX: wallX[0],
                        wallWidth: wallWidth,
                        wallHeight: wallHeight[0][1],
                        isThisBottomWall: true,
                      ),

                      // Top wall 1
                      Wall(
                        wallX: wallX[1],
                        wallWidth: wallWidth,
                        wallHeight: wallHeight[1][0],
                        isThisBottomWall: false,
                      ),

                      // Bottom wall 1
                      Wall(
                        wallX: wallX[1],
                        wallWidth: wallWidth,
                        wallHeight: wallHeight[1][1],
                        isThisBottomWall: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentScore.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 35),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'S C O R E',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
