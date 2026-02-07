import 'package:flutter/material.dart';
import 'package:habit_modification/database/habit_database.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReadingHistoryPage extends StatefulWidget {
  const ReadingHistoryPage({super.key});
  @override
  State<ReadingHistoryPage> createState() => _ReadingHistoryPageState();
}

class _ReadingHistoryPageState extends State<ReadingHistoryPage> {
  bool _loading = true;
  Map<DateTime, double> _daily = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = context.read<HabitDatabase>();
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 365));
    final m = await db.getDailyHoursBetween(start, end);
    final sorted = Map.fromEntries(
      m.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );
    setState(() {
      _daily = sorted;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('EEEE, dd MMM yyyy');
    return Scaffold(
      appBar: AppBar(title: const Text('Reading History')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _daily.isEmpty
          ? const Center(child: Text('No study sessions recorded yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _daily.length,
              itemBuilder: (c, idx) {
                final entry = _daily.entries.toList()[idx];
                final date = entry.key;
                final hrs = entry.value;
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 6,
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFEFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.menu_book,
                        color: Color(0xFF0E9AA7),
                      ),
                    ),
                    title: Text(
                      dateFmt.format(date),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: Text(
                      '${hrs.toStringAsFixed(1)} hrs',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
