import 'package:flutter/material.dart';
import 'package:speed_math/game_session/game_model.dart';
import 'package:speed_math/game_session/game_view.dart';
import 'package:speed_math/main.dart';

class GameEnd extends StatelessWidget {
  final int totalScore;
  final Difficulty previousDifficulty;
  final int previousMaxLevel;
  const GameEnd(
      {super.key,
      required this.totalScore,
      required this.previousDifficulty,
      required this.previousMaxLevel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Your total score is $totalScore"),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameView(
                        difficulty: previousDifficulty,
                        maxLevel: previousMaxLevel,
                      ),
                    ),
                    (Route<dynamic> route) => route.isFirst);
              },
              child: const Text("Play again"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                    (Route<dynamic> route) => false);
              },
              child: const Text("Home"),
            ),
          ],
        ),
      ),
    );
  }
}
