enum Difficulty { novice, advanced, master }

class GameModel {
  final Difficulty difficulty;
  int level = 1;

  late String mathExpression;
  late List<String> operators;
  late int maxNumber;
  late int rightAnswer;
  late List<int> wrongAnswers;

  GameModel({required this.difficulty}) {
    mathExpression = "";
    operators = ["+", "-", "*"];
    maxNumber = 0;
    rightAnswer = 0;
    wrongAnswers = [];
  }
}
