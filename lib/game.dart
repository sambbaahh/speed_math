import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("jee"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(child: Text("pöö")));
  }
}
