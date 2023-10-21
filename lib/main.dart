import 'package:flutter/material.dart';
import 'package:speed_math/play_session/game_model.dart';
import 'package:speed_math/play_session/play_session_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Speed Math'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Difficulty selectedDifficulty = Difficulty.novice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Game(difficulty: selectedDifficulty),
                  ),
                );
              },
              child: const Text("Play"),
            ),
            SegmentedButton<Difficulty>(
              segments: const <ButtonSegment<Difficulty>>[
                ButtonSegment(value: Difficulty.novice, label: Text("Novice")),
                ButtonSegment(
                    value: Difficulty.advanced, label: Text("Advanced")),
                ButtonSegment(value: Difficulty.master, label: Text("Master")),
              ],
              selected: <Difficulty>{selectedDifficulty},
              onSelectionChanged: (Set<Difficulty> newSelection) {
                setState(
                  () {
                    selectedDifficulty = newSelection.first;
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
