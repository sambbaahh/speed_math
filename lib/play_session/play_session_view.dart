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
  int _score = 0;
  int _level = 1;

  @override
  void initState() {
    super.initState();
    gameModel = GameModel(difficulty: widget.difficulty);
    gameModel.maxNumber = 10;
    generateMathExpression();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _score += 50;
            _level += 1;
          });
        }
      });
    Future.delayed(const Duration(microseconds: 500), () {
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void generateMathExpression() {
    gameModel.rightAnswer = 0;
    while (gameModel.rightAnswer < 1) {
      var startValue = Random().nextInt(gameModel.maxNumber) + 1;
      var endValue = Random().nextInt(gameModel.maxNumber) + 1;
      var operator =
          gameModel.operators[Random().nextInt(gameModel.operators.length)];

      if (operator == "-" && endValue > startValue) {
        gameModel.mathExpression = "$endValue $operator $startValue";
      } else {
        gameModel.mathExpression = "$startValue $operator $endValue";
      }

      Parser p = Parser();
      Expression expression = p.parse(gameModel.mathExpression);
      ContextModel cm = ContextModel();
      gameModel.rightAnswer =
          expression.evaluate(EvaluationType.REAL, cm).round();
    }

    for (var i = 0; i < 3; i++) {
      int randomWrongAnswer =
          Random().nextInt((gameModel.rightAnswer * 1.2).round()) +
              (gameModel.rightAnswer * 0.8).round();

      gameModel.wrongAnswers.add(randomWrongAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Total score: ${_score}"),
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
              Text("Level ${(_level)}"),
              Text(gameModel.mathExpression),
              Text(gameModel.rightAnswer.toString()),
              Text(gameModel.wrongAnswers.toString()),
              ElevatedButton(
                onPressed: () {
                  controller.stop(canceled: true);
                },
                child: const Text("Stop"),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.forward();
                },
                child: const Text("Start"),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.reset();
                },
                child: const Text("Reset"),
              ),
            ],
          ),
        ));
  }
}
