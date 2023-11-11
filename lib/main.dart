import 'package:flutter/material.dart';
import 'package:speed_math/game_session/game_model.dart';
import 'package:speed_math/game_session/game_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speed Math',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Difficulty selectedDifficulty = Difficulty.novice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Speed Math - Fun way to learn math",
          style: TextStyle(fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.black26,
            height: 0.75,
          ),
        ),
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
                    builder: (context) =>
                        GameView(difficulty: selectedDifficulty, maxLevel: 10),
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
