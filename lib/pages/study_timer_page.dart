import 'dart:async';
import 'package:flutter/material.dart';
import 'package:habit_modification/database/habit_database.dart';
import 'package:provider/provider.dart';

class StudyTimerPage extends StatefulWidget {
  const StudyTimerPage({super.key});
  @override
  State<StudyTimerPage> createState() => _StudyTimerPageState();
}

class _StudyTimerPageState extends State<StudyTimerPage> {
  final Stopwatch _sw = Stopwatch();
  Timer? _ticker;

  void _start() {
    if (!_sw.isRunning) {
      _sw.start();
      _ticker = Timer.periodic(
        const Duration(seconds: 1),
        (_) => setState(() {}),
      );
    }
  }

  void _pause() {
    if (_sw.isRunning) {
      _sw.stop();
      _ticker?.cancel();
      setState(() {});
    }
  }

  void _reset() {
    _sw.reset();
    _ticker?.cancel();
    setState(() {});
  }

  String _format() {
    final d = _sw.elapsed;
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  Future<void> _save() async {
    final minutes = (_sw.elapsed.inSeconds / 60).round();
    if (minutes == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No time recorded to save')));
      return;
    }
    final db = context.read<HabitDatabase>();
    await db.addReadingLog(DateTime.now(), minutes);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Saved $minutes minute(s)')));
    _reset();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _sw.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final running = _sw.isRunning;
    return Scaffold(
      appBar: AppBar(title: const Text('Study Timer')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    _format(),
                    style: const TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    running ? 'Studying...' : 'Stopped',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: running ? _pause : _start,
                  icon: Icon(running ? Icons.pause : Icons.play_arrow),
                  label: Text(running ? 'Pause' : 'Start'),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Save your session. The next day, if you have study time saved in the last two days, a summary popup will appear.',
            ),
          ],
        ),
      ),
    );
  }
}
