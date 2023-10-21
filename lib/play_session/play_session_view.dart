import 'dart:math';

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:speed_math/play_session/game_model.dart';

class Game extends StatefulWidget {
  final Difficulty difficulty;
  const Game({super.key, required this.difficulty});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  late AnimationController controller;
  late GameModel gameModel;

  bool isDisabled = false;
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
    gameModel.maxNumber = 10;
    generateMathExpression();
    generateWrongAnswers();
    gameModel.allAnswers.shuffle();
  }

  void generateMathExpression() {
    // Alustetaan alkuarvot
    int rightAnswer = 0;
    String mathExpression = "";

    while (rightAnswer < 1) {
      var startValue = Random().nextInt(gameModel.maxNumber) + 1;
      var endValue = Random().nextInt(gameModel.maxNumber) + 1;
      var operator =
          gameModel.operators[Random().nextInt(gameModel.operators.length)];

      if (operator == "-" && endValue > startValue) {
        mathExpression = "$endValue $operator $startValue";
      } else {
        mathExpression = "$startValue $operator $endValue";
      }

      rightAnswer = calculateCorrectAnswer(mathExpression);
    }
    gameModel.mathExpression = mathExpression;
    gameModel.rightAnswer = rightAnswer;
    gameModel.allAnswers.add(rightAnswer);
  }

  int calculateCorrectAnswer(String expression) {
    Parser p = Parser();
    Expression parsedExpression = p.parse(expression);
    ContextModel cm = ContextModel();

    return parsedExpression.evaluate(EvaluationType.REAL, cm).round();
  }

  void generateWrongAnswers() {
    double rndFactor = 0;
    if (gameModel.rightAnswer < 2) {
      rndFactor = 4;
    } else if (gameModel.rightAnswer < 3) {
      rndFactor = 2;
    } else if (gameModel.rightAnswer < 5) {
      rndFactor = 1;
    } else if (gameModel.rightAnswer < 10) {
      rndFactor = 0.5;
    } else if (gameModel.rightAnswer < 20) {
      rndFactor = 0.25;
    } else {
      rndFactor = 0.2;
    }

    print(gameModel.rightAnswer);

    while (gameModel.allAnswers.length < 4) {
      int minValue = (gameModel.rightAnswer * (1 - rndFactor)).round();
      int maxValue = (gameModel.rightAnswer * (1 + rndFactor)).round();

      int randomWrongAnswer = Random().nextInt(maxValue - minValue) + minValue;

      if (!gameModel.allAnswers.contains(randomWrongAnswer) &&
          randomWrongAnswer != gameModel.rightAnswer &&
          randomWrongAnswer > 0) {
        gameModel.allAnswers.add(randomWrongAnswer);
      }
    }
  }

  void checkAnswer(int i) {
    isDisabled = true;
    controller.stop();

    if (i == -1) {
      setState(() {
        _score -= 50;
        _level++;
      });
    } else if (gameModel.allAnswers[i] == gameModel.rightAnswer) {
      setState(() {
        _score += (100 * (1 - controller.value)).round();
        _level++;
      });
    } else {
      setState(() {
        _score -= 50 + (100 * controller.value).round();
        _level++;
      });
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      controller.reset();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      initializeGame();
      isDisabled = false;
      controller.forward();
    });
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
                gameModel.mathExpression,
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
                      onPressed: () => isDisabled ? null : checkAnswer(i),
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
        ));
  }
}
