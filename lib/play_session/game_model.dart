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
}
