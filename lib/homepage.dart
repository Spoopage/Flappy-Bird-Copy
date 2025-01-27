import 'dart:async';

import 'package:flappy_bird/obstacle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'bird.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double birdY = 0;
  double time = 0;
  double height = 0;
  double initialHeight = 0;
  bool isGameStarted = false;
  static double barrierX1 = 1;
  double barrierX2 = barrierX1 + 1.5;
  double score = 0;
  double highscore = 0;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdY;
    });
  }

  void startGame() {
    isGameStarted = true;
    Timer.periodic(Duration(milliseconds: 70), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2.2 * time;
      setState(() {
        birdY = initialHeight - height;
      });

      setState(() {
        if (barrierX1 < -1.15) {
          barrierX1 += 3.6;
        } else {
          barrierX1 -= 0.05;
        }
      });

      setState(() {
        if (barrierX2 < -1.15) {
          barrierX2 += 3.6;
        } else {
          barrierX2 -= 0.05;
        }
      });

      if (birdY > 1) {
        timer.cancel();
        isGameStarted = false;
      }
    });
  }

  void scoreBoard() {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Text("Game Over", style: TextStyle(color: Colors.white),),
          content: Text("Score: " + score.toString(), style: TextStyle(color: Colors.white),),
          actions: [
            TextButton(
              onPressed: () {
                if (score > highscore) {
                  highscore = score;
                }
                initState();
                setState(() {
                  isGameStarted = false;
                });
                Navigator.of(context).pop();
              }, 
              child: Text("Play Again", style: TextStyle(color: Colors.white),)
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isGameStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment(0, birdY),
                      duration: Duration(milliseconds: 0),
                      color: Colors.blue,
                      child: MyBird(),
                    ),
                    Container(
                      alignment: Alignment(0, -0.4),
                      child: isGameStarted
                          ? Text("")
                          : Text(
                              "TAP TO PLAY",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                    ),
                    AnimatedContainer(
                      // barrier1
                      alignment: Alignment(barrierX1, 1.1),
                      duration: Duration(milliseconds: 0),
                      child: Obstacles(
                        size: 200.0,
                      ),
                    ),
                    AnimatedContainer(
                      // barrier2
                      alignment: Alignment(barrierX1, -1.1),
                      duration: Duration(milliseconds: 0),
                      child: Obstacles(
                        size: 200.0,
                      ),
                    ),
                    AnimatedContainer(
                      // barrier3
                      alignment: Alignment(barrierX2, 1.1),
                      duration: Duration(milliseconds: 0),
                      child: Obstacles(
                        size: 200.0,
                      ),
                    ),
                    AnimatedContainer(
                      // barrier4
                      alignment: Alignment(barrierX2, -1.1),
                      duration: Duration(milliseconds: 0),
                      child: Obstacles(
                        size: 200.0,
                      ),
                    ),
                  ],
                )),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Score",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "0",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Highest",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "0",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
