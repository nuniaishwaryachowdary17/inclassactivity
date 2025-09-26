import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MoodModel(),
      child: MyApp(),
    ),
  );
}

class MoodModel with ChangeNotifier {
  String _currentMood = '😊';
  Color _backgroundColor = Colors.yellow;

  Map<String, int> _moodCounts = {
    'Happy': 0,
    'Sad': 0,
    'Excited': 0,
  };

  String get currentMood => _currentMood;
  Color get backgroundColor => _backgroundColor;
  Map<String, int> get moodCounts => _moodCounts;

  void setHappy() {
    _currentMood = '😊';
    _backgroundColor = Colors.yellow;
    _moodCounts['Happy'] = (_moodCounts['Happy'] ?? 0) + 1;
    notifyListeners();
  }

  void setSad() {
    _currentMood = '😢';
    _backgroundColor = Colors.blue;
    _moodCounts['Sad'] = (_moodCounts['Sad'] ?? 0) + 1;
    notifyListeners();
  }

  void setExcited() {
    _currentMood = '🎉';
    _backgroundColor = Colors.orange;
    _moodCounts['Excited'] = (_moodCounts['Excited'] ?? 0) + 1;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Toggle Challenge',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color bgColor = context.watch<MoodModel>().backgroundColor;

    return Scaffold(
      appBar: AppBar(title: Text('Mood Toggle Challenge')),
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('How are you feeling?', style: TextStyle(fontSize: 24)),
            SizedBox(height: 30),
            MoodDisplay(),
            SizedBox(height: 50),
            MoodButtons(),
            SizedBox(height: 50),
            MoodCounter(),
          ],
        ),
      ),
    );
  }
}

class MoodDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Text(
          moodModel.currentMood,
          style: TextStyle(fontSize: 100),
        );
      },
    );
  }
}

class MoodButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setHappy();
          },
          child: Text('Happy 😊'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setSad();
          },
          child: Text('Sad 😢'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setExcited();
          },
          child: Text('Excited 🎉'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        ),
      ],
    );
  }
}
class MoodCounter extends StatelessWidget {
  final double maxBarHeight = 150;

  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        int happyCount = moodModel.moodCounts['Happy'] ?? 0;
        int sadCount = moodModel.moodCounts['Sad'] ?? 0;
        int excitedCount = moodModel.moodCounts['Excited'] ?? 0;

        int maxCount = [happyCount, sadCount, excitedCount]
            .reduce((a, b) => a > b ? a : b);
        maxCount = maxCount == 0 ? 1 : maxCount;

        return Column(
          children: [
            Text('Mood Counts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar('Happy', happyCount, maxCount, Colors.yellow),
                _buildBar('Sad', sadCount, maxCount, Colors.blue),
                _buildBar('Excited', excitedCount, maxCount, Colors.orange),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBar(String mood, int count, int maxCount, Color color) {
    double barHeight = (count / maxCount) * maxBarHeight;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(count.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: 40,
          height: barHeight,
          decoration: BoxDecoration(
            color: color.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(height: 5),
        Text(mood),
      ],
    );
  }
}
