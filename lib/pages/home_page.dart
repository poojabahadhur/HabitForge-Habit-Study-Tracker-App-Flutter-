import 'package:flutter/material.dart';
import 'package:habit_modification/widgets/my_drawer.dart';
import 'package:intl/intl.dart';

import 'package:habit_modification/database/habit_database.dart';
import 'package:habit_modification/models/habit.dart';
import 'package:habit_modification/pages/calendar_page.dart';
import 'package:habit_modification/utils/habit_util.dart';
import 'package:habit_modification/widgets/habit_tile.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final db = Provider.of<HabitDatabase>(context, listen: false);
    db.readHabits();

    // check popup *after* first frame (will only show if reading logs exist in the previous two days)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeShowPrev2DaysPopup();
    });
  }

  Future<void> _maybeShowPrev2DaysPopup() async {
    final db = context.read<HabitDatabase>();
    final now = DateTime.now();
    final todayNorm = DateTime(now.year, now.month, now.day);
    final lastShown = await db.getLastPopupShownDate();
    if (lastShown != null && _isSameDay(lastShown, todayNorm)) return;

    final yesterday = todayNorm.subtract(const Duration(days: 1));
    final dayBefore = todayNorm.subtract(const Duration(days: 2));

    final yH = await db.getTotalHoursForDate(yesterday);
    final bH = await db.getTotalHoursForDate(dayBefore);

    // If both zero, do NOT show popup (this fixes the wrong info issue)
    if (yH == 0 && bH == 0) return;

    // Show popup (only for days that have > 0)
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Last 2 Days Reading Hours'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (bH > 0)
              Row(
                children: [
                  const Icon(Icons.menu_book, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${DateFormat('dd MMM').format(dayBefore)}: ${bH.toStringAsFixed(2)} hrs',
                  ),
                ],
              ),
            if (yH > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.menu_book, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '${DateFormat('dd MMM').format(yesterday)}: ${yH.toStringAsFixed(2)} hrs',
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // mark popup shown today so it doesn't show repeatedly
    await db.setLastPopupShownDate(todayNorm);
  }

  void _createNewHabit() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: TextField(
          controller: _textController,
          decoration: const InputDecoration(hintText: 'Create a new Habit'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final name = _textController.text.trim();
              if (name.isNotEmpty)
                await context.read<HabitDatabase>().addHabit(name);
              _textController.clear();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _toggleHabit(bool? val, Habit h) {
    if (val != null)
      context.read<HabitDatabase>().updateHabitCompletion(h.id, val);
  }

  void _editHabit(Habit h) {
    _textController.text = h.name;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: TextField(
          controller: _textController,
          decoration: const InputDecoration(hintText: 'Edit Habit'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final nm = _textController.text.trim();
              if (nm.isNotEmpty)
                await context.read<HabitDatabase>().updateHabitName(h.id, nm);
              _textController.clear();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _deleteHabit(Habit h) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete habit?'),
        actions: [
          TextButton(
            onPressed: () async {
              await context.read<HabitDatabase>().deleteHabit(h.id);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final db = context.watch<HabitDatabase>();
    return FutureBuilder<DateTime?>(
      future: db.getFirstLaunchDate(),
      builder: (c, s) {
        if (s.hasData && s.data != null) {
          // Calendar page is a reusable card
          return const CalendarPage();
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHabitList() {
    final db = context.watch<HabitDatabase>();
    final habits = db.currentHabits;
    if (habits.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24.0),
        child: Text(
          'No habits yet. Tap + to add one.',
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: habits.length,
      itemBuilder: (c, i) {
        final h = habits[i];
        final done = isHabitCompletedToday(h.completedDays);
        return MyHabitTile(
          isCompleted: done,
          text: h.name,
          icon: Icons.menu_book,
          onChanged: (v) => _toggleHabit(v, h),
          editHabit: (_) => _editHabit(h),
          deleteHabit: (_) => _deleteHabit(h),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(title: const Text('Habit Tracker')),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewHabit,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          _buildCalendar(),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildHabitList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
