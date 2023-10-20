import 'package:flutter/material.dart';
import 'package:speed_math/game.dart';

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

enum Levels { novice, advanced, master }

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Levels currentLevel = Levels.novice;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
                    builder: (context) => const Game(),
                  ),
                );
              },
              child: const Text("Play"),
            ),
            SegmentedButton<Levels>(
              segments: const <ButtonSegment<Levels>>[
                ButtonSegment(value: Levels.novice, label: Text("Novice")),
                ButtonSegment(value: Levels.advanced, label: Text("Advanced")),
                ButtonSegment(value: Levels.master, label: Text("Master")),
              ],
              selected: <Levels>{currentLevel},
              onSelectionChanged: (Set<Levels> newSelection) {
                setState(
                  () {
                    currentLevel = newSelection.first;
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
