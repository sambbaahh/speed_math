import 'package:flutter/material.dart';
import 'package:speed_math/game_end/game_end_view.dart';
import 'package:speed_math/game_session/game_logic.dart';
import 'package:speed_math/game_session/game_model.dart';

class GameView extends StatefulWidget {
  final Difficulty difficulty;
  final int maxLevel;
  const GameView({super.key, required this.difficulty, required this.maxLevel});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late GameLogic _currentLevel;

  bool _isButtonsDisabled = false;
  int _score = 0;
  int _level = 1;
  int _clickedButtonIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeGame();
    _animationController = AnimationController(
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
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void initializeGame() {
    _currentLevel = GameLogic(difficulty: widget.difficulty);
    _currentLevel.generateMathExpressionAndAnswer();
    _currentLevel.generateWrongAnswers();
    _currentLevel.shuffleAnswers();
  }

  void checkAnswer(int i) {
    setState(() {
      _isButtonsDisabled = true;
      _animationController.stop();
      _clickedButtonIndex = i;
    });

    //time over
    if (_clickedButtonIndex == -1) {
      setState(() {
        _score -= 50;
      });
    }
    //correct answer
    else if (_currentLevel.getAllAnswers()[_clickedButtonIndex] ==
        _currentLevel.getRightAnswer()) {
      setState(() {
        _score += (100 * (1 - _animationController.value)).round();
      });
    }
    //wrong answer
    else {
      setState(() {
        if (_animationController.value < 0.1) {
          _score -= 100 + (100 * _animationController.value).round();
        } else {
          _score -= 50 + (100 * _animationController.value).round();
        }
      });
    }

    if (_level == widget.maxLevel) {
      Future.delayed(const Duration(milliseconds: 500), () {
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
      });
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        initializeGame();
        setState(() {
          _animationController.reset();
          _level++;
          _isButtonsDisabled = false;
          _animationController.forward();
        });
      });
    }
  }

  ButtonStyle? changeButtonColor(int i) {
    //time over
    if (_clickedButtonIndex == -1) {
      if (i ==
          _currentLevel
              .getAllAnswers()
              .indexOf(_currentLevel.getRightAnswer())) {
        return ElevatedButton.styleFrom(backgroundColor: Colors.green);
      } else {
        return null;
      }
    }
    //correct answer
    else if (_clickedButtonIndex == i &&
        _currentLevel.getAllAnswers()[_clickedButtonIndex] ==
            _currentLevel.getRightAnswer()) {
      return ElevatedButton.styleFrom(backgroundColor: Colors.green);
    }
    //wrong answer (show the clicked wrong answer and correct answer)
    else if (_currentLevel.getAllAnswers()[_clickedButtonIndex] !=
        _currentLevel.getRightAnswer()) {
      if (_clickedButtonIndex == i) {
        return ElevatedButton.styleFrom(backgroundColor: Colors.red);
      } else if (i ==
          _currentLevel
              .getAllAnswers()
              .indexOf(_currentLevel.getRightAnswer())) {
        return ElevatedButton.styleFrom(backgroundColor: Colors.green);
      }
    }

    return null;
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
              value: _animationController.value),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(5),
            ),
            Text(
              "Level ${(_level)}/${(widget.maxLevel)}",
              style: const TextStyle(fontSize: 16),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            Text(
              _currentLevel.formatMathExpression(),
              style: const TextStyle(fontSize: 40),
            ),
            const Padding(
              padding: EdgeInsets.all(75),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: _currentLevel.getAllAnswers().length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (BuildContext context, int i) {
                  return Container(
                    padding: const EdgeInsets.all(6),
                    child: ElevatedButton(
                      onPressed: () =>
                          _isButtonsDisabled ? null : checkAnswer(i),
                      style: _isButtonsDisabled ? changeButtonColor(i) : null,
                      child: Text(
                        _currentLevel.getAllAnswers()[i].toString(),
                        style: const TextStyle(fontSize: 38),
                      ),
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
