import 'package:flutter/material.dart';
import 'package:speed_math/game_end/game_end_view.dart';
import 'package:speed_math/play_session/game_model.dart';

class Game extends StatefulWidget {
  final Difficulty difficulty;
  final int maxLevel;
  const Game({super.key, required this.difficulty, required this.maxLevel});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  late AnimationController controller;
  late GameModel gameModel;

  bool isButtonsDisabled = false;
  int _score = 0;
  int _level = 1;

  @override
  void initState() {
    super.initState();
    initializeGame();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          checkAnswer(-1);
        }
      });
    Future.delayed(const Duration(milliseconds: 500), () {
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void initializeGame() {
    gameModel = GameModel(difficulty: widget.difficulty);
    gameModel.generateMathExpressionAndAnswer();
    gameModel.generateWrongAnswers();
    gameModel.allAnswers.shuffle();
  }

  void checkAnswer(int i) {
    isButtonsDisabled = true;
    controller.stop();

    if (i == -1) {
      setState(() {
        _score -= 50;
      });
    } else if (gameModel.allAnswers[i] == gameModel.rightAnswer) {
      setState(() {
        _score += (100 * (1 - controller.value)).round();
      });
    } else {
      setState(() {
        if (controller.value < 0.1) {
          _score -= 100 + (100 * controller.value).round();
        } else {
          _score -= 50 + (100 * controller.value).round();
        }
      });
    }

    if (_level == widget.maxLevel) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameEnd(
            totalScore: _score,
            previousDifficulty: widget.difficulty,
            previousMaxLevel: widget.maxLevel,
          ),
        ),
      );
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        controller.reset();
        setState(() {
          _level++;
        });
        initializeGame();
        isButtonsDisabled = false;
        controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Total score: $_score"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6.0),
          child: LinearProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black87),
              value: controller.value),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Level ${(_level)}",
              style: const TextStyle(fontSize: 16),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            Text(
              gameModel.formatMathExpression(),
              style: const TextStyle(fontSize: 30),
            ),
            const Padding(
              padding: EdgeInsets.all(80),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Kaksi saraketta rivillä
                ),
                itemCount: gameModel.allAnswers.length,
                itemBuilder: (BuildContext context, int i) {
                  return ElevatedButton(
                    onPressed: () => isButtonsDisabled ? null : checkAnswer(i),
                    child: Text(
                      gameModel.allAnswers[i].toString(),
                      style: const TextStyle(fontSize: 30),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
