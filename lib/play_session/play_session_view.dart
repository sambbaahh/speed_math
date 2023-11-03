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
  late AnimationController _controller;
  late GameModel _gameModel;

  bool _isButtonsDisabled = false;
  int _score = 0;
  int _level = 1;
  int _clickedButtonIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeGame();
    _controller = AnimationController(
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
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void initializeGame() {
    _gameModel = GameModel(difficulty: widget.difficulty);
    _gameModel.generateMathExpressionAndAnswer();
    _gameModel.generateWrongAnswers();
    _gameModel.allAnswers.shuffle();
  }

  void checkAnswer(int i) {
    setState(() {
      _isButtonsDisabled = true;
      _controller.stop();
      _clickedButtonIndex = i;
    });

    //time over
    if (_clickedButtonIndex == -1) {
      setState(() {
        _score -= 50;
      });
    }
    //correct answer
    else if (_gameModel.allAnswers[_clickedButtonIndex] ==
        _gameModel.rightAnswer) {
      setState(() {
        _score += (100 * (1 - _controller.value)).round();
      });
    }
    //wrong answer
    else {
      setState(() {
        if (_controller.value < 0.1) {
          _score -= 100 + (100 * _controller.value).round();
        } else {
          _score -= 50 + (100 * _controller.value).round();
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
        initializeGame();
        setState(() {
          _controller.reset();
          _level++;
          _isButtonsDisabled = false;
          _controller.forward();
        });
      });
    }
  }

  ButtonStyle? changeButtonColor(int i) {
    //time over
    if (_clickedButtonIndex == -1) {
      if (i == _gameModel.allAnswers.indexOf(_gameModel.rightAnswer)) {
        return ElevatedButton.styleFrom(backgroundColor: Colors.green);
      } else {
        return null;
      }
    }
    //correct answer
    else if (_clickedButtonIndex == i &&
        _gameModel.allAnswers[_clickedButtonIndex] == _gameModel.rightAnswer) {
      return ElevatedButton.styleFrom(backgroundColor: Colors.green);
    }
    //wrong answer (show the clicked wrong answer and correct answer)
    else if (_gameModel.allAnswers[_clickedButtonIndex] !=
        _gameModel.rightAnswer) {
      if (_clickedButtonIndex == i) {
        return ElevatedButton.styleFrom(backgroundColor: Colors.red);
      } else if (i == _gameModel.allAnswers.indexOf(_gameModel.rightAnswer)) {
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
              value: _controller.value),
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
              _gameModel.formatMathExpression(),
              style: const TextStyle(fontSize: 30),
            ),
            const Padding(
              padding: EdgeInsets.all(80),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: _gameModel.allAnswers.length,
                itemBuilder: (BuildContext context, int i) {
                  return ElevatedButton(
                    onPressed: () => _isButtonsDisabled ? null : checkAnswer(i),
                    style: _isButtonsDisabled ? changeButtonColor(i) : null,
                    child: Text(
                      _gameModel.allAnswers[i].toString(),
                      style: const TextStyle(fontSize: 38),
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
