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
  final double barrierHeight = 200.0;

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

      // Move barriers
      if (barrierX1 < -1.15) {
        barrierX1 += 3.6;
      } else {
        barrierX1 -= 0.05;
      }

      if (barrierX2 < -1.15) {
        barrierX2 += 3.6;
      } else {
        barrierX2 -= 0.05;
      }
    });

    updateScore(); // Update the score when the bird passes an obstacle

    // Check for collision or game over
    if (birdY > 1 || birdY < -1 || checkCollision()) {
      timer.cancel();
      isGameStarted = false;
      scoreBoard();
    }
  });
}


  bool checkCollision() {
    double normalizedBarrierHeight =
        barrierHeight / MediaQuery.of(context).size.height;

    if ((barrierX1 >= -0.2 && barrierX1 <= 0.2) ||
        (barrierX2 >= -0.2 && barrierX2 <= 0.2)) {
      if (birdY <= -1 + normalizedBarrierHeight ||
          birdY >= 1 - normalizedBarrierHeight) {
        return true;
      }
    }
    return false;
  }

  void scoreBoard() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.brown,
        title: Text(
          "Game Over",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Score: " + score.toString(),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (score > highscore) {
                highscore = score;
              }
              resetGame(); // Reset game variables
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              "Play Again",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      );
    },
  );
}

void updateScore() {
  if (barrierX1 < -0.2 && barrierX1 > -0.25) {
    // Increment score when bird passes the first obstacle
    setState(() {
      score++;
    });
  }

  if (barrierX2 < -0.2 && barrierX2 > -0.25) {
    // Increment score when bird passes the second obstacle
    setState(() {
      score++;
    });
  }
}



  void resetGame() {
  setState(() {
    birdY = 0;
    time = 0;
    height = 0;
    initialHeight = 0;
    isGameStarted = false;
    barrierX1 = 1;
    barrierX2 = barrierX1 + 1.5;
    score = 0;
  });
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
                        size: barrierHeight
                      ),
                    ),
                    AnimatedContainer(
                      // barrier2
                      alignment: Alignment(barrierX1, -1.1),
                      duration: Duration(milliseconds: 0),
                      child: Obstacles(
                        size: barrierHeight,
                      ),
                    ),
                    AnimatedContainer(
                      // barrier3
                      alignment: Alignment(barrierX2, 1.1),
                      duration: Duration(milliseconds: 0),
                      child: Obstacles(
                        size: barrierHeight,
                      ),
                    ),
                    AnimatedContainer(
                      // barrier4
                      alignment: Alignment(barrierX2, -1.1),
                      duration: Duration(milliseconds: 0),
                      child: Obstacles(
                        size: barrierHeight
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
                          score.toString(),
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
                          score.toString(),
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
