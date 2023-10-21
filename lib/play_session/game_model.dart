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
    operators = ["+", "-", "*"];
    maxNumber = 0;
    rightAnswer = 0;
    allAnswers = [];
  }
}
