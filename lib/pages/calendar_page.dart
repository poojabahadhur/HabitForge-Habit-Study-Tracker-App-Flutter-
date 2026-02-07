import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habit_modification/database/habit_database.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;
  CalendarFormat _format = CalendarFormat.month;
  Map<DateTime, double> _dailyHours = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = Provider.of<HabitDatabase>(context, listen: false);
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 365));
    final map = await db.getDailyHoursBetween(start, end);
    setState(() {
      _dailyHours = map;
    });
  }

  Color _colorForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    final hours = _dailyHours[key] ?? 0.0;
    if (hours == 0) return Colors.transparent;
    if (hours <= 0.5) return const Color(0xFFB7EBE6);
    if (hours <= 1.5) return const Color(0xFF9AE0DA);
    if (hours <= 3) return const Color(0xFF6ED0C8);
    return const Color(0xFF39B3A8);
  }

  void _onDayTap(DateTime day, DateTime focused) async {
    final db = Provider.of<HabitDatabase>(context, listen: false);
    final hours = await db.getTotalHoursForDate(day);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(DateFormat('EEEE, dd MMM yyyy').format(day)),
        content: Text('Study time: ${hours.toStringAsFixed(2)} hrs'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TableCalendar(
          firstDay: DateTime(DateTime.now().year - 1, 1, 1),
          lastDay: DateTime(DateTime.now().year, 12, 31),
          focusedDay: _focused,
          calendarFormat: _format,
          headerStyle: const HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
          ),
          selectedDayPredicate: (d) => isSameDay(d, _selected),
          onDaySelected: (selected, focused) {
            setState(() {
              _selected = selected;
              _focused = focused;
            });
            _onDayTap(selected, focused);
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focused) {
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _colorForDay(day),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text('${day.day}')),
              );
            },
            todayBuilder: (context, day, focused) {
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E9AA7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
