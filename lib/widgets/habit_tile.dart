import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  final bool isCompleted;
  final String text;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;
  final IconData icon;

  const MyHabitTile({
    super.key,
    required this.isCompleted,
    required this.text,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit,
    this.icon = Icons.menu_book,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: editHabit,
              backgroundColor: Colors.blueGrey,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: deleteHabit,
              backgroundColor: Colors.redAccent,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isCompleted
                  ? const Color(0xFFB2F5EC)
                  : const Color(0xFFE8FBFB),
              child: Icon(
                icon,
                color: isCompleted
                    ? const Color(0xFF0E9AA7)
                    : const Color(0xFF79C8C8),
              ),
            ),
            title: Text(
              text,
              style: TextStyle(
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Checkbox(
              value: isCompleted,
              onChanged: onChanged,
              activeColor: const Color(0xFF0E9AA7),
            ),
          ),
        ),
      ),
    );
  }
}
