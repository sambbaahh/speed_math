import 'dart:math';

import 'package:math_expressions/math_expressions.dart';

enum Difficulty { novice, advanced, master }

class GameModel {
  final Difficulty difficulty;
  late String mathExpression;
  late List<String> operators;
  late int maxNumber;
  late int minNumber;
  late int rightAnswer;
  late List<int> allAnswers;

  GameModel({required this.difficulty}) {
    mathExpression = "";
    operators = _selectOperators(difficulty);
    maxNumber = _selectMaxNumber(difficulty);
    minNumber = _selectMinNumber(difficulty);
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
        return 40;
      default:
        return 10;
    }
  }

  int _selectMinNumber(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.novice || Difficulty.advanced:
        return 1;
      case Difficulty.master:
        return 5;
      default:
        return 1;
    }
  }

  List<String> _selectOperators(Difficulty difficulty) {
    if (difficulty != Difficulty.master) {
      return ["+", "-", "*"];
    } else {
      return ["+", "-", "*", "/"];
    }
  }

  void generateMathExpressionAndAnswer() {
    // Alustetaan alkuarvot
    int tempRightAnswer = 0;
    String tempMathExpression = "";

    while (tempRightAnswer < 1) {
      var startValue = Random().nextInt(maxNumber) + minNumber;
      var endValue = Random().nextInt(maxNumber) + minNumber;
      var operator = operators[Random().nextInt(operators.length)];
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
      if (difficulty == Difficulty.master &&
          operator == "*" &&
          startValue >= 20 &&
          endValue >= 30) {
        startValue = startValue - Random().nextInt(startValue - 2) + 1;
        endValue = endValue - Random().nextInt(endValue - 2) + 1;
        tempMathExpression = "$endValue $operator $startValue";
      }
      if (difficulty == Difficulty.advanced &&
          operator == "*" &&
          startValue >= 10 &&
          endValue >= 10) {
        startValue = startValue - Random().nextInt(startValue - 2) + 1;
        endValue = endValue - Random().nextInt(endValue - 2) + 1;
        tempMathExpression = "$endValue $operator $startValue";
      }

      tempRightAnswer = calculateCorrectAnswer(tempMathExpression);
    }

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
