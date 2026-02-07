import 'package:flutter/material.dart';
import 'package:habit_modification/pages/reading_history_page.dart';
import 'package:habit_modification/pages/study_timer_page.dart';
import 'package:habit_modification/themes/theme.provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B2A2A), Color(0xFFECFEFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E9AA7).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.water, color: Color(0xFF0E9AA7)),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'River Mode',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.timer),
                title: const Text('Study Timer'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StudyTimerPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Reading History'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReadingHistoryPage(),
                    ),
                  );
                },
              ),
              const Spacer(),
              Consumer<ThemeProvider>(
                builder: (_, t, __) {
                  return SwitchListTile(
                    title: const Text('Dark Mode'),
                    value: t.isDarkMode,
                    onChanged: (_) => t.toggletheme(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
