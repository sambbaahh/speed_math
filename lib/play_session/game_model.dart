import 'dart:math';

import 'package:math_expressions/math_expressions.dart';

enum Difficulty { novice, advanced, master }

class GameModel {
  final Difficulty difficulty;
  late String mathExpression;
  late List<String> operators;
  late int maxNumber;
  late int rightAnswer;
  late List<int> allAnswers;

  GameModel({required this.difficulty}) {
    mathExpression = "";
    operators = ["+", "-", "*", "/"];
    maxNumber = _selectMaxNumber(difficulty);
    rightAnswer = 0;
    allAnswers = [];
  }

  int _selectMaxNumber(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.novice:
        return 10;
      case Difficulty.advanced:
        return 20;
      case Difficulty.master:
        return 50;
      default:
        return 10;
    }
  }

  void generateMathExpressionAndAnswer() {
    // Alustetaan alkuarvot
    int tempRightAnswer = 0;
    String tempMathExpression = "";

    while (tempRightAnswer < 1) {
      var startValue = Random().nextInt(maxNumber) + 1;
      var endValue = Random().nextInt(maxNumber) + 1;
      var operator = operators[Random().nextInt(operators.length)];

      if (operator == "-" && endValue > startValue) {
        tempMathExpression = "$endValue $operator $startValue";
      } else {
        tempMathExpression = "$startValue $operator $endValue";
      }

      tempRightAnswer = calculateCorrectAnswer(tempMathExpression);
    }
    if (difficulty == Difficulty.advanced) {}

    mathExpression = tempMathExpression;
    rightAnswer = tempRightAnswer;
    allAnswers.add(tempRightAnswer);
  }

  int calculateCorrectAnswer(String expression) {
    Parser p = Parser();
    Expression parsedExpression = p.parse(expression);
    ContextModel cm = ContextModel();

    return parsedExpression.evaluate(EvaluationType.REAL, cm).round();
  }

  void generateWrongAnswers() {
    double rndFactor = 0;
    if (rightAnswer < 2) {
      rndFactor = 4;
    } else if (rightAnswer < 3) {
      rndFactor = 2;
    } else if (rightAnswer < 5) {
      rndFactor = 1;
    } else if (rightAnswer < 10) {
      rndFactor = 0.5;
    } else if (rightAnswer < 20) {
      rndFactor = 0.25;
    } else {
      rndFactor = 0.2;
    }

    while (allAnswers.length < 4) {
      int minValue = (rightAnswer * (1 - rndFactor)).round();
      int maxValue = (rightAnswer * (1 + rndFactor)).round();

      int randomWrongAnswer = Random().nextInt(maxValue - minValue) + minValue;

      if (!allAnswers.contains(randomWrongAnswer) &&
          randomWrongAnswer != rightAnswer &&
          randomWrongAnswer > 0) {
        allAnswers.add(randomWrongAnswer);
      }
    }
  }

  String formatMathExpression() {
    return mathExpression.replaceAll("*", "x").replaceAll("/", "÷");
  }
}
