import 'dart:math';

import 'package:math_expressions/math_expressions.dart';

import 'game_model.dart';

class GameLogic {
  late final GameModel _gameModel;

  GameLogic({required Difficulty difficulty}) {
    _gameModel = GameModel(difficulty: difficulty);
  }

  void generateMathExpressionAndAnswer() {
    int tempRightAnswer = 0;
    String tempMathExpression = "";

    while (tempRightAnswer < 1) {
      var startValue =
          Random().nextInt(_gameModel.maxNumber) + _gameModel.minNumber;
      var endValue =
          Random().nextInt(_gameModel.maxNumber) + _gameModel.minNumber;
      var operator =
          _gameModel.operators[Random().nextInt(_gameModel.operators.length)];
      tempMathExpression = "$startValue $operator $endValue";

      if (operator == "-" && endValue > startValue) {
        tempMathExpression = "$endValue $operator $startValue";
      }
      if (operator == "/" && startValue % endValue != 0) {
        int changeValue = 0;
        while (startValue % endValue != 0 && (startValue / endValue) != 1) {
          changeValue++;
          if (changeValue > 4) {
            startValue++;
            changeValue = 0;
          } else {
            endValue = Random().nextInt(startValue) + 1;
          }
        }
        tempMathExpression = "$startValue $operator $endValue";
      }
      if (_gameModel.difficulty == Difficulty.master &&
          operator == "*" &&
          startValue >= 20 &&
          endValue >= 30) {
        startValue = startValue - Random().nextInt(startValue - 2) + 1;
        endValue = endValue - Random().nextInt(endValue - 2) + 1;
        tempMathExpression = "$endValue $operator $startValue";
      }
      if (_gameModel.difficulty == Difficulty.advanced &&
          operator == "*" &&
          startValue >= 10 &&
          endValue >= 10) {
        startValue = startValue - Random().nextInt(startValue - 2) + 1;
        endValue = endValue - Random().nextInt(endValue - 2) + 1;
        tempMathExpression = "$endValue $operator $startValue";
      }

      tempRightAnswer = calculateCorrectAnswer(tempMathExpression);
    }

    _gameModel.mathExpression = tempMathExpression;
    _gameModel.rightAnswer = tempRightAnswer;
    _gameModel.allAnswers.add(tempRightAnswer);
  }

  int calculateCorrectAnswer(String expression) {
    Parser p = Parser();
    Expression parsedExpression = p.parse(expression);
    ContextModel cm = ContextModel();

    return parsedExpression.evaluate(EvaluationType.REAL, cm).round();
  }

  void generateWrongAnswers() {
    double rndFactor = 0;
    if (_gameModel.rightAnswer < 2) {
      rndFactor = 4;
    } else if (_gameModel.rightAnswer < 3) {
      rndFactor = 2;
    } else if (_gameModel.rightAnswer < 5) {
      rndFactor = 1;
    } else if (_gameModel.rightAnswer < 10) {
      rndFactor = 0.5;
    } else if (_gameModel.rightAnswer < 20) {
      rndFactor = 0.25;
    } else {
      rndFactor = 0.2;
    }

    while (_gameModel.allAnswers.length < 4) {
      int minValue = (_gameModel.rightAnswer * (1 - rndFactor)).round();
      int maxValue = (_gameModel.rightAnswer * (1 + rndFactor)).round();

      int randomWrongAnswer = Random().nextInt(maxValue - minValue) + minValue;

      if (!_gameModel.allAnswers.contains(randomWrongAnswer) &&
          randomWrongAnswer != _gameModel.rightAnswer &&
          randomWrongAnswer > 0) {
        _gameModel.allAnswers.add(randomWrongAnswer);
      }
    }
  }

  void shuffleAnswers() {
    _gameModel.allAnswers.shuffle();
  }

  int getRightAnswer() {
    return _gameModel.rightAnswer;
  }

  List<int> getAllAnswers() {
    return _gameModel.allAnswers;
  }

  String formatMathExpression() {
    return _gameModel.mathExpression.replaceAll("*", "x").replaceAll("/", "÷");
  }
}
